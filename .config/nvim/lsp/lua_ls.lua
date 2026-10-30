-- Enabled automatically via config/autocmds.lua (scans lsp/*.lua and calls vim.lsp.enable).
-- Binary installed by mason (see plugins/mason.lua).

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = {
			codeLens = {
				enable = true,
			},
			completion = {
				callSnippet = "Replace",
			},
			doc = {
				privateName = { "^_" },
			},
			hint = {
				enable = true,
				setType = true,
				paramType = true,
				paramName = "Auto",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
}
