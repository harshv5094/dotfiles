if pcall(require, "nvim-treesitter") then
	---@type nvim-ts.parsers
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

	require("nvim-treesitter").install(parsers)

	-- A build hook for updating parsers
	local hooks = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			vim.cmd("TSUpdate")
		end
	end
	vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })
end

if pcall(require, "treesitter-context") then
	require("treesitter-context").setup({
		mode = "cursor",
		max_lines = 3,
	})

	vim.keymap.set("n", "<leader>ut", function()
		require("treesitter-context").toggle()
		local string
		if require("treesitter-context").enabled() then
			string = "on"
		else
			string = "off"
		end
		vim.notify("Treesitter Context: " .. string)
	end, { desc = "Toggle Treesitter Context" })
end

-- Author: https://github.com/mks-h
if pcall(require, "treesitter-autoinstall") then
	require("treesitter-autoinstall").setup({
		ignore = {},
		highlight = true,
		regex = {},
	})
end
