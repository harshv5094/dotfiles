local g = vim.g
local opt = vim.opt

-- Block spammy hjkl / +/- navigation to build better habits
my_utils.discipline.cowboy()

-- NOTE: Leader keys
g.mapleader = " "
g.maplocalleader = "\\"

-- NOTE: Netrw (built-in file explorer)
-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
g.netrw_liststyle = 3 -- Tree view
g.netrw_banner = 1 -- Show the top banner (set 0 to hide)
g.netrw_winsize = 25 -- Width of the netrw window
g.netrw_browse_split = 0 -- Open files in the previous window
g.netrw_altfile = 1 -- Keep the alternate file correct

-- NOTE: Shell
if vim.fn.has("win32") == 1 then
	opt.shell = "pwsh"
end

-- NOTE: Encoding
vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- NOTE: Clipboard
opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- NOTE: UI / Appearance
opt.title = true -- Show file name in the window title
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.cursorline = true -- Highlight the current line
opt.relativenumber = true -- Relative line numbers
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.shiftround = true -- Round indent
opt.laststatus = 3 -- Single global statusline
opt.cmdheight = 1 -- Height of the command line
opt.showcmd = true -- Show partial commands in the last line
opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor
opt.smoothscroll = true -- Setting up smooth scrolling
opt.conceallevel = 2 -- Hide markup (e.g. bold/italic markers) unless it has substitutions
-- opt.mouse = "a" -- Enable mouse support (disabled)

-- NOTE: Search
opt.hlsearch = true -- Highlight all search matches
opt.ignorecase = true -- Case-insensitive search UNLESS /C or capitals are used
opt.smartcase = true -- Override 'ignorecase' when the search has capitals
opt.inccommand = "split" -- Live preview of :substitute in a split
opt.grepprg = "rg --vimgrep" -- Setting up ripgrep as default
opt.path:append({ "**" }) -- Search recursively into subfolders (gf, :find)
opt.wildignore:append({ "*/node_modules/*", "*/.git/*" }) -- Ignore node_modules and .git in searches

-- NOTE: Indentation & Tabs
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Indent size (>>, <<, autoindent)
opt.tabstop = 2 -- Width of a tab character
opt.smarttab = true -- Use shiftwidth at line start, tabstop elsewhere
opt.autoindent = true -- Copy indent from current line on new line
opt.smartindent = true -- Smart auto-indenting for C-like code
opt.breakindent = true -- Wrapped lines keep the same indent level

-- Add asterisks in block comments when pressing Enter
opt.formatoptions:append({ "r" })

-- NOTE: Text display
opt.wrap = false -- Do not wrap long lines

-- NOTE: Completion
opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" } -- Completion menu behavior
opt.pumheight = 12 -- max items shown
opt.pumwidth = 20 -- min width
opt.pumblend = 10 -- transparency (0-100)
opt.pumborder = "rounded" -- border for the menu (newer versions; check :h 'pumborder')

-- NOTE: Files / Persistence
opt.autowrite = true -- Auto-save when switching buffers / running commands
opt.autoread = true -- Reload files changed outside of Neovim
opt.backup = false -- Do not create backup files
opt.writebackup = false -- Do not write a backup file before overwriting
opt.backupskip = { "/tmp/*", "/private/tmp/*" } -- Skip backups for temp files
opt.swapfile = true -- Use swap files for crash recovery
opt.undofile = true -- Persist undo history across sessions

-- NOTE: Windows & Splits
opt.splitbelow = true -- New horizontal splits open below
opt.splitright = true -- New vertical splits open to the right
opt.splitkeep = "screen" -- Keep text on screen when splitting

-- NOTE: Editing behavior
opt.confirm = true -- Ask to save before discarding modified buffers
opt.backspace = { "start", "eol", "indent" } -- Allow backspace over everything
opt.foldlevel = 99 -- Start with folds close with
opt.foldmethod = "indent" -- Fold based on indentation
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
} -- Setting up fold characters symbols
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Create Lsp Log function
vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.split(vim.lsp.log.get_filename())
end, { desc = "Open the Neovim lsp log file" })

-- Undercurl support in supporting terminals
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
