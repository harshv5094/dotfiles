-- The bridge between nvim-dap and mason
local ok, plugin = pcall(require, "mason-nvim-dap")

if ok then
	plugin.setup({
		automatic_installation = false,
		ensure_installed = {},
		handlers = {},
	})
end

-- The Debug adapter protocol
ok, plugin = pcall(require, "dap")

if ok then
end

-- The Lightweight view of nvim-dap
ok, plugin = pcall(require, "dap-view")

if ok then
end
