-- https://blog.atusy.net/2025/07/16/prefer-luadoc-to-luals-semantictokens/
if vim.o.buftype == "help" then
	vim.cmd("wincmd L | vertical resize 105") -- 幅は少し余裕を持たせている
end
