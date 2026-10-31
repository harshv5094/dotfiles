-- Custom Utility Function
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	if vim.snippet and vim.snippet.active() then
		vim.snippet.stop()
	end
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Delete a word backwards
map("n", "dw", 'vb"_d', opts)

-- Redo - make U the opposite of u
map("n", "U", "<C-r>", { desc = "Redo" })

-- Save - Save from any mode
map({ "i", "n", "v" }, "<C-s>", "<ESC><CMD>w<CR>", { desc = "Save" })

-- Split screen keymaps
map("n", "ss", "<CMD>split<CR>", opts)
map("n", "sv", "<CMD>vsplit<CR>", opts)

-- better indenting
map("x", "<", "<gv", opts)
map("x", ">", ">gv", opts)

-- Split screen focus navigation
map("n", "sh", "<C-W>h", opts)
map("n", "sj", "<C-W>j", opts)
map("n", "sk", "<C-W>k", opts)
map("n", "sl", "<C-W>l", opts)

-- Split screen resize
map("n", "<C-h>", "<C-w><", opts)
map("n", "<C-j>", "<C-w>+", opts)
map("n", "<C-k>", "<C-w>-", opts)
map("n", "<C-l>", "<C-w>>", opts)

-- Major Navigation
map("n", "<M-j>", "<C-d>zz", opts)
map("n", "<M-k>", "<C-u>zz", opts)

-- My custom git initialization function
map("n", "<leader>gi", my_utils.git.init, { desc = "Git init", noremap = true })

-- String auto replace
map(
	"n",
	"<localleader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and Replace (Buffer)", noremap = true }
)

-- Keymaps for tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Special chmod keymaps for windows and mac only
if vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1 then
	-- chmod +x <current-buffer>
	map("n", "<leader>fx", function()
		my_utils.base.chmod()
	end, { desc = "chmod +x <current-buffer>" })

	-- chmod -x <current-buffer>
	map("n", "<leader>fX", function()
		my_utils.base.chmod("-")
	end, { desc = "chmod -x <current-buffer>" })

	-- A custom command for opening manpage in tab window
	vim.api.nvim_create_user_command("Vhelp", "tab help <args>", {
		nargs = "?",
		complete = "help",
	})
end

-- Quit while asking
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Restart neovim
map("n", "<leader>qr", function()
	vim.cmd("restart")
end, { desc = "Restart neovim", noremap = true })

-- Toggle inlay hints globally (on by default; no-op on servers without support)
map("n", "<leader>uh", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	vim.notify("Inlay hints: " .. (vim.lsp.inlay_hint.is_enabled() and "on" or "off"))
end, { desc = "Toggle inlay hints", noremap = true })

-- Toggle codelens (global)
map("n", "<leader>uc", function()
	vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
	vim.notify("Codelens: " .. (vim.lsp.codelens.is_enabled() and "on" or "off"))
end, { desc = "Toggle Codelens", noremap = true })

-- Toggle terminal
map({ "n", "t" }, "<leader>ft", my_utils.base.toggle_terminal, { desc = "Toggle Terminal" })

-- Toggle Lazygit
map({ "n", "t" }, "<leader>gg", my_utils.base.toggle_lazygit, { desc = "LazyGit" })

-- Escape keymap for terminal
map("t", "<S-Esc>", "<C-\\><C-n>", opts)
