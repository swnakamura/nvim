local M = {}

M.MDPTCopy = function(line1, line2)
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
    line = vim.fn.substitute(line, [[^\s*\\<\([^>]\+\)>]],[[\n<\1>]],'ge') -- Remove preceding backslashes for html tags in the beginning of the line
    line = vim.fn.substitute(line, [=[^\v\\(!\[[^]]+\]\([^)]+\))]=],[[\n\1]],'ge') -- Remove preceding backslashes for image formats `![alias](path)` in the beginning of the line
    lines_filtered[i] = line
  end

  local text = table.concat(lines_filtered, "\n")

  text = vim.fn.substitute(text, [[%%.\{-1,}%%]], [[]] ,'ge') -- Remove contents of obsidian comments

  text = vim.fn.substitute(text, [[\$\([^$]\{-1,}\)\$]],[[\1]],'ge') -- Surround inline math with backticks: $inline math$ -> inline math
  text = vim.fn.substitute(text, [[ --- ]],[[:]],'ge') -- Replace ' --- ' with ':'

  text = vim.fn.substitute(text, [[#\([^# ]\+\)]], [[]], 'ge') -- remove tags e.g. #tags
  text = vim.fn.substitute(text, [[[📅➕⏳✅] \d\d\d\d-\d\d-\d\d]], [[]], 'ge') -- remove emoji dates from obsidian-tasks
  text = vim.fn.substitute(text, [[	]],[[    ]],'ge') -- Replace tabs with 4 spaces
  text = vim.fn.substitute(text, [=[[^!]\[\[\zs[^]]\+|\([^]]\+\)\ze\]\]]=], [[\1]] ,'ge') -- Remove original link from aliased file name: [[original name|aliased name]] -> [[aliased name]]

  -- double bracket link is followed by an http link, change the double bracket link to a markdown link
  text = vim.fn.substitute(text, [=[[^!]\zs\[\[\([^]]\+\)\]\]\s\?(\(http[^)]\+\))]=], [[[\1](\2)]] ,'ge') -- Change double bracket link to markdown link: [[file.md]] <link> -> [file.md](<link>)
  text = vim.fn.substitute(text, [=[[^!]\zs\[\[\([^]]\+\)\]\]\ze]=], [[\1]] ,'ge') -- Remove double square bracket from non-image link : [[file.md]] -> file.md

  -- move any text decorations
  text = vim.fn.substitute(text, [[\*\([^*]\+\)\*]],[[\1]],'ge') -- Remove bold text: *bold text* -> bold text
  text = vim.fn.substitute(text, [[\*\*\([^*]\+\)\*\*]],[[\1]],'ge') -- Remove bold text: **bold text** -> bold text


  vim.fn.setreg("+", text, "V")
end

return M
