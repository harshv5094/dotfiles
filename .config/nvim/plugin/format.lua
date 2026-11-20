if pcall(require, "conform") then
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			python = {
				-- To fix auto-fixable lint errors.
				"ruff_fix",
				-- To run the Ruff formatter.
				"ruff_format",
				-- To organize the imports.
				"ruff_organize_imports",
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	})
end
