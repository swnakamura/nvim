vim.cmd([[
  setlocal conceallevel=1
  setlocal linebreak
  command -range=% MDPTCopy lua require('markdown').obsidian_to_plain_text_copy(<line1>, <line2>)
  command -range=% MDGHCopy lua require('markdown').obsidian_to_github_copy(<line1>, <line2>)
]])
