if pcall(require, "trouble") then
	-- stylua: ignore
	local keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)", },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)", },
		{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
		{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
	}
	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end

	require("trouble").setup()
end

if pcall(require, "cloak") then
	require("cloak").setup({
		enabled = true,
		cloak_character = "*",
		highlight_group = "Comment",
		patterns = {
			{
				-- Match any file starting with ".env".
				file_pattern = {
					".env*",
					"wrangler.toml",
					".dev.vars",
				},
				-- Match an equals sign and any character after it.
				cloak_pattern = "=.+",
			},
		},
	})
end

-- A git wrapper by tpope
if require("tools").vim_plugin_path_checker("vim-fugitive") then
	-- stylua: ignore
	local keys = {
		{ "<leader>gss", "<CMD>G status<CR>", desc = "status" },
		{ "<leader>gsq", "<CMD>G status --short<CR>", desc = "status (short)" },
		{ "<leader>gab", "<CMD>G add %<CR>", desc = "Current Buffer" },
		{ "<leader>gaa", "<CMD>G add *<CR>", desc = "All" },
		{ "<leader>gaf", ":G add ", desc = "Manual" },
		{ "<leader>gbb", "<CMD>G blame %<CR>", desc = "Current Buffer" },
		{ "<leader>gla", "<CMD>G log<CR>", desc = "All" },
		{ "<leader>glb", "<CMD>G log %<CR>", desc = "Current Buffer" },
		{ "<leader>gce", "<CMD>G commit --edit<CR>", desc = "Edit" },
		{ "<leader>gca", "<CMD>G commit --amend<CR>", desc = "Amend" },
		{ "<leader>gp", "<CMD>G pull --no-edit<CR>", desc = "pull (no-edit)" },
		{ "<leader>gr", "<CMD>G reset --hard HEAD<CR>", desc = "reset (--hard) HEAD" },
		{ "<leader>gP", "<CMD>G push --force-with-lease<CR>", desc = "push (force-with-lease)" },
	}

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end
end
