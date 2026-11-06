-- A file formatter which is way better and simple
local ok, plugin = pcall(require, "conform")

if ok then
	plugin.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			markdown = { "markdownlint-cli2" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	})
end
