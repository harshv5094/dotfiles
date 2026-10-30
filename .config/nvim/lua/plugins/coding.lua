local ok, plugin = pcall(require, "trouble")

if ok then
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

	plugin.setup()
end

ok, plugin = pcall(require, "cloak")

if ok then
	plugin.setup({
		enabled = true,
		cloak_character = "*",
		-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
		highlight_group = "Comment",
		patterns = {
			{
				-- Match any file starting with ".env".
				-- This can be a table to match multiple file patterns.
				file_pattern = {
					".env*",
					"wrangler.toml",
					".dev.vars",
				},
				-- Match an equals sign and any character after it.
				-- This can also be a table of patterns to cloak,
				-- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
				cloak_pattern = "=.+",
			},
		},
	})
end
