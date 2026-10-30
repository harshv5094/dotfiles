---@type vim.lsp.Config
return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	settings = {
		yaml = {
			format = { enabled = true },
			-- Using the schemastore plugin for schemas.
			schemastore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
