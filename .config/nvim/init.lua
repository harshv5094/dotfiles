-- Loading vim.loader: this'll cache the require modules
if vim.loader then
	vim.loader.enable()
end

-- Bootstrap my config in one file
require("config.base")
