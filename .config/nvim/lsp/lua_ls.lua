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
				workspaceDelay = 3000,
				disable = { "incomplete-signature-doc", "trailing-space" },
				unusedLocalExclude = { "_*" },
			},
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
			telemetry = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				preloadFileSize = 1000,
				maxPreload = 2000,
				checkThirdParty = false,
				ignoreDir = { ".git", ".node_modules", "build", "dist", "generated" },
			},
		},
	},
}
