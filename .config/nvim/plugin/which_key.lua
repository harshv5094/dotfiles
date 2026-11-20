if pcall(require, "which-key") then
	require("which-key").setup({
		preset = "helix",
		defaults = {},
		spec = {
			mode = { "n", "x" },
			{ "<leader>/", desc = "Live Grep", icon = { icon = require("icons").misc.search, color = "green" } },
			{
				"<leader>fc",
				desc = "Neovim Config Files",
				icon = { icon = require("icons").misc.nvim, color = "green" },
			},
			{ "<leader>c", group = "code" },
			{ "<leader>d", group = "debug" },
			{ "<leader>g", group = "git" },
			{ "<leader>ga", group = "add" },
			{ "<leader>gh", group = "hunks" },
			{ "<leader>gs", group = "status" },
			{ "<leader>gc", group = "commit" },
			{ "<leader>gl", group = "log" },
			{ "<leader>s", group = "search" },
			{ "<leader>u", group = "ui" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>x", group = "diagnostics/quickfix" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>q", group = "quit/session" },
			{ "<leader><Tab>", group = "tab" },
			{ "<localleader>r", group = "registers" },
			{ "[", group = "prev" },
			{ "]", group = "next" },
			{ "g", group = "goto" },
			{ "gs", group = "surround" },
			{ "z", group = "fold" },
			{ "y", group = "yank" },
			{ "d", group = "delete" },
		},
	})

	-- Adding custom groups for my which-key config
	require("which-key").add({
		{ "<leader>p", group = "vim.pack", icon = { icon = require("icons").misc.box, color = "green" } },
		{ "<leader>b", group = "buffers", icon = { icon = require("icons").misc.buffers, color = "blue" } },
	})
end
