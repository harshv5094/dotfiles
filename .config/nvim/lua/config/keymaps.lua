-- Custom Utility function
local git = require("utils.git")
local base = require("utils.base")
local discipline = require("utils.discipline")

-- Cowboy mode
discipline.cowboy()

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Tab navigation Keymaps
map("n", "<tab>", "<CMD>tabnext<CR>", opts)
map("n", "<s-tab>", "<CMD>tabprev<CR>", opts)

-- Delete a word backwards
map("n", "dw", 'vb"_d', opts)

-- Split window
map("n", "ss", "<CMD>split<CR>", opts)
map("n", "sv", "<CMD>vsplit<CR>", opts)

-- Move window
map("n", "sh", "<C-w>h", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sj", "<C-w>j", opts)
map("n", "sl", "<C-w>l", opts)

-- Resize window
map("n", "<C-h>", "<C-w><", opts)
map("n", "<C-l>", "<C-w>>", opts)
map("n", "<C-k>", "<C-w>+", opts)
map("n", "<C-j>", "<C-w>-", opts)

-- Major Navigation
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)

-- Git init current open file root dir
map("n", "<leader>gi", git.init, { desc = "Git init (root)" })

-- Automatic find and replace
map("n", "<localleader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Setup executable permission
map("n", "<localleader>x", function()
	base.chmod()
end, { desc = "chmod +x <current-buffer>" })
map("n", "<localleader>X", function()
	base.chmod("-")
end, { desc = "chmod -x <current-buffer>" })

-- Adding LazyExtras Quick Access Keybind
map("n", "<localleader>l", "<cmd>LazyExtras<CR>", { desc = "LazyExtras", silent = true })

-- Rename whole variables in the buffer
map("n", "rn", function()
	vim.lsp.buf.rename()
end, { desc = "rename buffer", silent = true })
