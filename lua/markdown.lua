-- This module provides functions to convert Obsidian markdown to plain text or GitHub markdown format.
local M = {}

M.obsidian_to_plain_text_copy = function(line1, line2)
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)

  -- Remove lines with internal links to image files: [[*.png]] or [[*.jpg]]
  local lines_filtered = {}
  for _, line in ipairs(lines) do
    if not line:match("%[%[[^%]]*%.(png|jpg|jpeg)%]%]") then
      table.insert(lines_filtered, line)
    end
  end

  for i, line in ipairs(lines_filtered) do
    -- Fancy bullet points
    line = vim.fn.substitute(line, [[^\s*\zs- \[ \]\ze\s\+]], [[☐]], 'ge')
    line = vim.fn.substitute(line, [[^\s*\zs- \[x\]\ze\s\+]], [[☑]], 'ge')
    line = vim.fn.substitute(line, [[^\s*\zs- \[p\]\ze\s\+]], [[👍️]], 'ge')
    line = vim.fn.substitute(line, [[^\s*\zs- \[c\]\ze\s\+]], [[👎️]], 'ge')
    line = vim.fn.substitute(line, [[^\s*\zs-\ze\s\+]], [[• ]], 'ge')
    line = vim.fn.substitute(line, [[^\s*\\<\([^>]\+\)>]], [[\n<\1>]], 'ge') -- Remove preceding backslashes for html tags in the beginning of the line
    line = vim.fn.substitute(line, [=[^\v\\(!\[[^]]+\]\([^)]+\))]=], [[\n\1]], 'ge') -- Remove preceding backslashes for image formats `![alias](path)` in the beginning of the line

    line = vim.fn.substitute(line, [[%%.\{-1,}%%]], [[]], 'ge') -- Remove contents of obsidian comments

    line = vim.fn.substitute(line, [[\$\([^$]\{-1,}\)\$]], [[\1]], 'ge') -- Surround inline math with backticks: $inline math$ -> inline math
    line = vim.fn.substitute(line, [[ --- ]], [[:]], 'ge') -- Replace ' --- ' with ':'

    line = vim.fn.substitute(line, [==[#[^# \]]\+]==], [[]], 'ge') -- remove tags e.g. #tags
    line = vim.fn.substitute(line, [[[📅➕⏳✅] \d\d\d\d-\d\d-\d\d]], [[]], 'ge') -- remove emoji dates from obsidian-tasks
    line = vim.fn.substitute(line, [[	]], [[    ]], 'ge') -- Replace tabs with 4 spaces

    -- move any line decorations
    line = vim.fn.substitute(line, [[\*\([^*]\+\)\*]], [[\1]], 'ge')     -- Remove bold text: *bold text* -> bold text
    line = vim.fn.substitute(line, [[\*\*\([^*]\+\)\*\*]], [[\1]], 'ge') -- Remove bold text: **bold text** -> bold text
    lines_filtered[i] = line
  end

  local text = table.concat(lines_filtered, "\n")

  text = vim.fn.substitute(text, [=[[^!]\[\[\zs[^]]\+|\([^]]\+\)\ze\]\]]=], [[\1]], 'ge')                 -- Remove original link from aliased file name: [[original name|aliased name]] -> [[aliased name]]
  -- double bracket link is followed by an http link, change the double bracket link to a markdown link
  text = vim.fn.substitute(text, [=[[^!]\zs\[\[\([^]]\+\)\]\]\s\?(\(http[^)]\+\))]=], [[[\1](\2)]], 'ge') -- Change double bracket link to markdown link: [[file.md]] <link> -> [file.md](<link>)
  text = vim.fn.substitute(text, [=[[^!]\zs\[\[\([^]]\+\)\]\]\ze]=], [[\1]], 'ge')                        -- Remove double square bracket from non-image link : [[file.md]] -> file.md

  vim.fn.setreg("+", text, "V")
end

M.obsidian_to_github_copy = function(line1, line2)
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)

  -- Remove lines with internal links to image files: [[*.png]] or [[*.jpg]]
  local lines_filtered = {}
  for _, line in ipairs(lines) do
    if not line:match("%[%[[^%]]*%.(png|jpg|jpeg)%]%]") then
      table.insert(lines_filtered, line)
    end
  end

  for i, line in ipairs(lines_filtered) do
    line = vim.fn.substitute(line, [[%%.\{-1,}%%]], [[]], 'ge') -- Remove contents of obsidian comments

    line = vim.fn.substitute(line, [[\$\([^$]\{-1,}\)\$]], [[$`\1`$]], 'ge') -- Surround inline math with backticks: $inline math$ -> inline math
    line = vim.fn.substitute(line, [[ --- ]], [[:]], 'ge') -- Replace ' --- ' with ':'

    line = vim.fn.substitute(line, [==[\s*#[^# \]]\+\s\+]==], [[ ]], 'ge') -- remove tags e.g. #tags
    line = vim.fn.substitute(line, [[[📅➕⏳✅] \d\d\d\d-\d\d-\d\d]], [[]], 'ge') -- remove emoji dates from obsidian-tasks
    line = vim.fn.substitute(line, [[	]], [[    ]], 'ge') -- Replace tabs with 4 spaces

    line = vim.fn.substitute(line, [[^\s*\\<\([^>]\+\)>]], [[\n<\1>]], 'ge') -- Remove preceding backslashes for html tags in the beginning of the line
    line = vim.fn.substitute(line, [=[^\v\\(!\[[^]]+\]\([^)]+\))]=], [[\n\1]], 'ge') -- Remove preceding backslashes for image formats `![alias](path)` in the beginning of the line

    lines_filtered[i] = line
  end

  local text = table.concat(lines_filtered, "\n")

  text = vim.fn.substitute(text, [=[[^!]\[\[\zs[^]]\+|\([^]]\+\)\ze\]\]]=], [[\1]], 'ge')                 -- Remove original link from aliased file name: [[original name|aliased name]] -> [[aliased name]]
  -- If double bracket link is followed by an http link, change the double bracket link to a markdown link
  text = vim.fn.substitute(text, [=[[^!]\zs\[\[\([^]]\+\)\]\]\s\?(\(http[^)]\+\))]=], [[[\1](\2)]], 'ge') -- Change double bracket link to markdown link: [[file.md]] <link> -> [file.md](<link>)
  text = vim.fn.substitute(text, [=[[^!]\zs\[\[\([^]]\+\)\]\]\ze]=], [[<strong>\1</strong>]], 'ge')       -- Remove double square bracket from non-image link and surround it with double star instead: [[file.md]] -> <strong>file.md</strong>

  -- Make a newline after bullet lists
  text = vim.fn.substitute(text, [[\n- [^\n]*\n\zs\ze[^\(\( 	\)*-\)\n]], '\n', 'ge')
  -- Here, [^\(\( 	\)*-\)\n] means:
  -- From this line new text starts, and it's not
  -- 1. there's already newline
  -- 2. There's another bullet list in this line end

  vim.fn.setreg("+", text, "V")
end
return M
