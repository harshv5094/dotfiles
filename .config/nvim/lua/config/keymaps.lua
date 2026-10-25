-- Custom Utility function
local git = require("utils.git")
local base = require("utils.base")
local discipline = require("utils.discipline")

-- Cowboy mode
discipline.cowboy()

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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

-- Escape from terminal
map({ "n", "t" }, "<ESC><ESC>", "<C-\\><C-n>", opts)

-- Automatic find and replace
map("n", "<localleader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Special chmod keymaps for windows and mac only
if vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1 then
	-- chmod +x <current-buffer>
	map("n", "<leader>fx", function()
		base.chmod()
	end, { desc = "chmod +x <current-buffer>" })

	-- chmod -x <current-buffer>
	map("n", "<leader>fX", function()
		base.chmod("-")
	end, { desc = "chmod -x <current-buffer>" })

	-- A custom command for tab
	vim.api.nvim_create_user_command("Vhelp", "tab help <args>", {
		nargs = "?",
		complete = "help",
	})
end

-- Adding LazyExtras Quick Access Keybind
map("n", "<localleader>l", "<cmd>LazyExtras<CR>", { desc = "LazyExtras", silent = true })
