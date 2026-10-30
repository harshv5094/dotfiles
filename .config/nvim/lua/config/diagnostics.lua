-- NOTE: Setting up diagnostics config

---@type vim.diagnostic.Opts.VirtualText
local virtual_text_opts = {
	spacing = 4,
	prefix = my_utils.icons.diagnostics.Prefix,
}
local virtual_text_on = true

---@type vim.diagnostic.Opts
local opts = {
	underline = true,
	update_in_insert = false,
	virtual_text = virtual_text_on and virtual_text_opts or false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = my_utils.icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = my_utils.icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = my_utils.icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = my_utils.icons.diagnostics.Info,
		},
	},
}

-- Importing opts
vim.diagnostic.config(opts)

-- Toggle virtual text (keeps the custom spacing/source/prefix settings intact)
vim.keymap.set("n", "<leader>ut", function()
	virtual_text_on = not virtual_text_on
	vim.diagnostic.config({ virtual_text = virtual_text_on and virtual_text_opts or false })
end, { desc = "Toggle Virtual Text", noremap = true })

-- Previous Diagnostics
vim.keymap.set("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })

-- Next Diagnostics
vim.keymap.set("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
