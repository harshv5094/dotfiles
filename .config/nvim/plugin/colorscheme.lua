if pcall(require, "gruvbox") then
	require("gruvbox").setup({
		terminal_colors = true,
		transparent_mode = true,
		undercurl = true,
		bold = true,
		italic = {
			strings = false,
			emphasis = false,
			comments = true,
			operators = false,
			folds = true,
		},
	})
	vim.cmd.colorscheme("gruvbox")
end
