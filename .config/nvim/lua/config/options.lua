local g = vim.g
local opt = vim.opt

-- Lazyvim Options
g.snacks_animate = false -- Turn off animation for snacks.nvim
g.lazyvim_picker = "telescope"
g.lazyvim_cmp = "blink.cmp"
g.lazyvim_prettier_needs_config = true
g.trouble_lualine = false

if vim.fn.has("win32") == 1 then
	opt.shell = "pwsh"
end

opt.title = true
opt.scrolloff = 10
opt.inccommand = "split"
opt.breakindent = true
opt.path:append({ "**" }) -- Finding files - Search down into subfolders
opt.wildignore:append({ "*/node_modules/*" })

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
