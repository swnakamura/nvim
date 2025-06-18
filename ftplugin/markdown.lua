vim.cmd([[
  setlocal conceallevel=1
  "command -range=% MDGHCopy call MDGHCopy(<line1>, <line2>)
  command -range=% MDPTCopy lua require('markdown').MDPTCopy(<line1>, <line2>)
]])
