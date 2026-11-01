local ok, plugin = pcall(require, "nvim-treesitter")
if ok then
	---@type nvim-ts.parsers
	-- HACK: Setting up gcc for windows
	if vim.fn.has("win32") == 1 then
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

ok, plugin = pcall(require, "treesitter-context")
if ok then
	plugin.setup({
		mode = "cursor",
		max_lines = 3,
	})
end

ok, plugin = pcall(require, "treesitter-autoinstall")
if ok then
	plugin.setup({
		-- A list of *treesitter languages* to ignore.
		ignore = {},
		-- Auto-enable highlighting for installed languages.
		highlight = true,
		-- A list of *treesitter languages* to also enable regex highlighting for
		regex = {},
	})
end
