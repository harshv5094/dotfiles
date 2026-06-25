local g = vim.g
local opt = vim.opt

-- Lazyvim Options
g.snacks_animate = false
g.lazyvim_picker = "telescope"
g.lazyvim_cmp = "blink.cmp"
g.lazyvim_prettier_needs_config = true
g.autoformat = true
g.trouble_lualine = false

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

local has = function(x)
	return vim.fn.has(x) == 1
end

if has("win32") then
	opt.shell = "pwsh"
	vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
end

if has("macunix") then
	opt.clipboard:append({ "unnamedplus" })
end

opt.title = true
opt.autoindent = true
opt.autoread = true
opt.smartindent = true
opt.hlsearch = true
opt.backup = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 3
opt.expandtab = true
opt.scrolloff = 10
opt.backupskip = { "/tmp/*", "/private/tmp/*" }
opt.inccommand = "split"
opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.wrap = false -- No Wrap lines
opt.swapfile = true -- Toggle swap files
opt.undofile = true -- Toggle undofile
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" }) -- Finding files - Search down into subfolders
opt.wildignore:append({ "*/node_modules/*" })
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "cursor"
-- opt.mouse = "a"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
opt.formatoptions:append({ "r" })
