-- A plugin to install and load treessitter
local ok, plugin = pcall(require, "nvim-treesitter")
if ok then
	---@type nvim-ts.parsers
	-- HACK: Setting up gcc for windows
	if vim.fn.has("win32") == 1 and vim.fn.executable("cl.exe") == 0 then
		vim.env.CC = "gcc"
	end

	local parsers = {
		"bash",
		"gitcommit",
		"gitignore",
		"git_config",
		"json",
		"yaml",
		"toml",
		"vim",
		"diff",
		"vimdoc",
		"lua",
		"luadoc",
		"python",
		"requirements",
	}

	plugin.install(parsers)

	-- A build hook for updating parsers
	local hooks = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			vim.cmd("TSUpdate")
		end
	end
	vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })
end

-- A context view of current file open in neovim
ok, plugin = pcall(require, "treesitter-context")
if ok then
	plugin.setup({
		mode = "cursor",
		max_lines = 3,
	})

	vim.keymap.set("n", "<leader>ut", function()
		vim.cmd("TSContext toggle")
		vim.notify("treesitter context: " .. (plugin.enabled and "on" or "off"))
	end, { desc = "Toggle Treesitter Context" })
end

-- A very useful plugin to autoinstall treesitter parsers based on current file in buffer
-- Author: https://github.com/mks-h
ok, plugin = pcall(require, "treesitter-autoinstall")
if ok then
	plugin.setup({
		ignore = {},
		highlight = true,
		regex = {},
	})
end
