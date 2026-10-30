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

	-- Define a local function to install parsers
	local function install_parsers()
		if vim.fn.executable("tree-sitter") == 1 then
			plugin.install(parsers)
		else
			vim.notify(
				"tree-sitter CLI not found; skipping parser install",
				vim.log.levels.WARN,
				{ title = "nvim-treesitter" }
			)
		end
	end

	-- Calling this function based on treesitter installation
	if vim.fn.executable("tree-sitter") == 1 then
		install_parsers()
	else
		-- FIX: Don't know why but this autocmd is not running properly after `vim.pack` migration
		-- I'll see this in the future
		vim.api.nvim_create_autocmd("User", {
			pattern = "MasonToolsUpdateCompleted",
			once = true,
			callback = install_parsers,
		})
	end
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
