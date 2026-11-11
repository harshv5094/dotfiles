local g = vim.g
local opt = vim.opt

-- Path setup for undodir (For persistence undo file record)
local undodir_path = vim.fn.stdpath("cache") .. "/undodir"
vim.fn.mkdir(undodir_path, "p")

-- Better i,j,k,l,-,+ discipline
my_utils.discipline.cowboy()

-- use PowerShell on Windows
if vim.fn.has("win32") == 1 then
	opt.shell = "pwsh"
end

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})

-- basic
g.mapleader = " " -- use space as the leader key
g.maplocalleader = "\\" -- use backslash as the local leader key
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- respect case when the search contains uppercase
opt.inccommand = "split" -- preview substitutions live in a split window
opt.path:append({ "**" }) -- search recursively through subdirectories
opt.wildignore:append({ "*/node_modules/*", "*/.git/*" }) -- skip node_modules and .git in completion
opt.expandtab = true -- insert spaces instead of tab characters
opt.shiftwidth = 2 -- use 2 spaces for each autoindent step
opt.tabstop = 2 -- display a tab character as 2 spaces
opt.softtabstop = 2 -- treat 2 spaces as a tab while editing
opt.smartindent = true -- indent new lines based on syntax
opt.confirm = true -- ask to save changes instead of failing on quit
opt.formatoptions:append({ "r" }) -- continue comments when pressing enter in insert mode
opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" } -- configure insert-mode completion behavior
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
opt.foldlevel = 99 -- open all folds by default

-- appearance
opt.title = true -- set the terminal window title
opt.relativenumber = true -- show line numbers relative to the cursor
opt.cursorline = true -- highlight the line the cursor is on
opt.signcolumn = "yes" -- always reserve space for the sign column
opt.conceallevel = 2 -- hide concealed text unless it has a custom replacement
opt.concealcursor = "nvc" -- excluding insert mode for conceal text
opt.fillchars = { -- customize the characters used for window fills
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

-- ui
opt.laststatus = 3 -- use one global statusline for all windows
opt.mouse = "" -- disable mouse support
opt.pumheight = 10 -- limit the popup menu to 10 items
opt.pumblend = 10 -- make the popup menu slightly transparent

-- windows
opt.splitbelow = true -- open horizontal splits below the current window
opt.splitright = true -- open vertical splits to the right of the current window
opt.splitkeep = "screen" -- keep text in place when splitting windows
opt.scrolloff = 10 -- keep 10 lines visible above and below the cursor
opt.sidescrolloff = 8 -- keep 8 columns visible left and right of the cursor
opt.smoothscroll = true -- scroll smoothly by screen line with wrapped text
opt.wrap = false -- do not wrap long lines
opt.breakindent = true -- keep indentation on wrapped lines

-- session
opt.undofile = true -- persist undo history across sessions
opt.undodir = undodir_path -- using my custom directory path for undo files
opt.swapfile = false -- Don't need swapfile backup never asked for it
opt.writebackup = false -- Disable writing backup file for config
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } -- choose what a session saves

-- file explorer
g.netrw_liststyle = 3 -- show netrw entries as a tree
g.netrw_banner = 1 -- show the netrw banner
g.netrw_winsize = 25 -- set the netrw window width to 25%
g.netrw_browse_split = 0 -- open netrw files in the current window
g.netrw_altfile = 1 -- use the alternate file when opening from netrw

-- commands
vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.split(vim.lsp.log.get_filename())
end, { desc = "Open the Neovim lsp log file" })
