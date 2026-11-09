-- Just declaring local variable openly
local ok, plugin

-- List of mini plugins that I want to load with default settings
local mini_plugins = {
	"mini.starter",
	"mini.pairs",
	"mini.indentscope",
	"mini.diff",
	"mini.icons",
}

-- HACK: A loop for just loading mini plugins with their default settings.
-- It just saves me some repetitive writing.
for _, mini_plugin in ipairs(mini_plugins) do
	ok, plugin = pcall(require, mini_plugin)
	if ok then
		plugin.setup()
	end
end

-- A lightweight vim.notify implementation by echanovski
ok, plugin = pcall(require, "mini.notify")
if ok then
	plugin.setup({
		lsp_progress = {
			enable = false,
		},
	})
	vim.keymap.set("n", "<leader>n", function()
		MiniNotify.show_history()
	end, { desc = "Notification History" })
end
