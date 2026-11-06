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

-- A light weight git wrapper/vim-fugitive alternative by echanovski
ok, plugin = pcall(require, "mini.git")
if ok then
	local keys = {
		{ "<leader>gss", "<CMD>Git status<CR>", desc = "Git status" },
		{ "<leader>gsq", "<CMD>Git status --short<CR>", desc = "Git status (short)" },
		{ "<leader>gab", "<CMD>Git add %<CR>", desc = "Git add (Current Buffer)" },
		{ "<leader>gaa", "<CMD>Git add *<CR>", desc = "Git add (All)" },
		{ "<leader>gaf", ":Git add ", desc = "Git add (Manual)" },
		{ "<leader>gce", "<CMD>Git commit --edit<CR>", desc = "Git commit (edit)" },
		{ "<leader>gca", "<CMD>Git commit --amend<CR>", desc = "Git commit (amend)" },
		{ "<leader>gp", "<CMD>Git pull --no-edit<CR>", desc = "Git pull (no-edit)" },
		{ "<leader>gr", "<CMD>Git reset --hard HEAD<CR>", desc = "Git reset (--hard) HEAD" },
		{ "<leader>gP", "<CMD>Git push --force-with-lease<CR>", desc = "Git push (force-with-lease)" },
		{ "<leader>gll", "<CMD>Git log<CR>", desc = "Git log" },
	}

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end
	plugin.setup()
end
