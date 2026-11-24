-- Let ripgrep-based pickers search hidden files while still honoring .gitignore
vim.env.RIPGREP_CONFIG_PATH = vim.fn.stdpath("config") .. "/.ripgreprc"

-- Better i,j,k,l,-,+ discipline
require("discipline").cowboy()

-- use PowerShell on Windows
if vim.fn.has("win32") == 1 then
	vim.o.shell = "pwsh"
end

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})

-- basic
vim.g.mapleader = " " -- use space as the leader key
vim.g.maplocalleader = "\\" -- use backslash as the local leader key
vim.o.ignorecase = true -- ignore case when searching
vim.o.smartcase = true -- respect case when the search contains uppercase
vim.o.inccommand = "split" -- preview substitutions live in a split window
vim.opt.path:append({ "**" }) -- search recursively through subdirectories
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*" }) -- skip node_modules and .git in completion
vim.o.expandtab = true -- insert spaces instead of tab characters
vim.o.shiftwidth = 2 -- use 2 spaces for each autoindent step
vim.o.tabstop = 2 -- display a tab character as 2 spaces
vim.o.softtabstop = 2 -- treat 2 spaces as a tab while editing
vim.o.smartindent = true -- indent new lines based on syntax
vim.o.confirm = true -- ask to save changes instead of failing on quit
vim.opt.formatoptions:append("r") -- continue comments when pressing enter in insert mode
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" } -- configure insert-mode completion behavior
vim.o.foldmethod = "expr" -- Use expression for folding
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.o.foldlevel = 99 -- open all folds by default

-- appearance
vim.o.title = true -- set the terminal window title
vim.o.relativenumber = true -- show line numbers relative to the cursor
vim.o.cursorline = true -- highlight the line the cursor is on
vim.o.signcolumn = "yes" -- always reserve space for the sign column
vim.o.conceallevel = 2 -- hide concealed text unless it has a custom replacement
vim.o.concealcursor = "nvc" -- excluding insert mode for conceal text
vim.opt.fillchars = { -- customize the characters used for window fills
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

-- ui
vim.o.laststatus = 3 -- use one global statusline for all windows
-- vim.o.mouse = "" -- disable mouse support
vim.o.pumheight = 10 -- limit the popup menu to 10 items
vim.o.pumblend = 10 -- make the popup menu slightly transparent

-- windows
vim.o.splitbelow = true -- open horizontal splits below the current window
vim.o.splitright = true -- open vertical splits to the right of the current window
vim.o.splitkeep = "screen" -- keep text in place when splitting windows
vim.o.scrolloff = 10 -- keep 10 lines visible above and below the cursor
vim.o.sidescrolloff = 8 -- keep 8 columns visible left and right of the cursor
vim.o.smoothscroll = true -- scroll smoothly by screen line with wrapped text
vim.o.wrap = false -- do not wrap long lines
vim.o.breakindent = true -- keep indentation on wrapped lines

-- session
vim.o.undofile = true -- persist undo history across sessions
vim.o.swapfile = false -- Don't need swapfile backup never asked for it
vim.o.writebackup = false -- Disable writing backup file for config
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } -- choose what a session saves

-- file explorer
vim.g.netrw_liststyle = 3 -- show netrw entries as a tree
vim.g.netrw_banner = 1 -- show the netrw banner
vim.g.netrw_winsize = 25 -- set the netrw window width to 25%
vim.g.netrw_browse_split = 0 -- open netrw files in the current window
vim.g.netrw_altfile = 1 -- use the alternate file when opening from netrw

-- commands
vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.split(vim.lsp.log.get_filename())
end, { desc = "Open the Neovim lsp log file" })
