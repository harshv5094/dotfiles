-- The theme itself lives in colors/gruvbox.lua. It reads 'background' on every
-- load, so `:set background=light` / `:set background=dark` switches palettes
-- automatically (Neovim re-sources the active colorscheme).
vim.cmd.colorscheme("gruvbox")

vim.api.nvim_create_user_command("GruvboxToggle", function()
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle gruvbox dark/light", force = true })
