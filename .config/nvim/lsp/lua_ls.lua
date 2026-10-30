-- Enabled automatically via config/autocmds.lua (scans lsp/*.lua and calls vim.lsp.enable).
-- Binary installed by mason (see plugins/mason.lua).

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	single_file_support = true,
	settings = {
		Lua = {
			diagnostics = {
				workspaceEvent = "OnSave",
				disable = { "incomplete-signature-doc", "trailing-space" },
				unusedLocalExclude = { "_*" },
			},
			codeLens = {
				enable = true,
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
			telemetry = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
}
