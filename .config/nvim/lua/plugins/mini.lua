local ok, plugin = pcall(require, "mini.pairs")
if ok then
	plugin.setup()
end

ok, plugin = pcall(require, "mini.indentscope")
if ok then
	plugin.setup()
end

ok, plugin = pcall(require, "mini.diff")
if ok then
	plugin.setup()
end

ok, plugin = pcall(require, "mini.notify")
if ok then
	plugin.setup({
		lsp_progress = {
			enable = false,
		},
	})
end

ok, plugin = pcall(require, "mini.statusline")
if ok then
	-- Format mini.diff counts with your icons
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniDiffUpdated",
		callback = function(args)
			local buf = args.buf
			local s = vim.b[buf].minidiff_summary
			if not s then
				return
			end
			local parts = {}
			if (s.add or 0) > 0 then
				table.insert(parts, my_utils.icons.git.added .. s.add)
			end
			if (s.change or 0) > 0 then
				table.insert(parts, my_utils.icons.git.modified .. s.change)
			end
			if (s.delete or 0) > 0 then
				table.insert(parts, my_utils.icons.git.removed .. s.delete)
			end
			vim.b[buf].minidiff_summary_string = table.concat(parts, " ")
		end,
	})

	-- Actual statusline setup
	plugin.setup({
		content = {
			active = function()
				-- Left side status config
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				mode = my_utils.icons.misc.vim .. mode

				local git = MiniStatusline.section_git({ trunc_width = 40, icon = my_utils.icons.git.branch })
				git = (git:gsub("%s*%b()", "")) -- remove " (MM)" etc.

				local diff = MiniStatusline.is_truncated(75) and "" or (vim.b.minidiff_summary_string or "")

				local diagnostics = MiniStatusline.section_diagnostics({
					trunc_width = 75,
					icon = "",
					signs = {
						ERROR = my_utils.icons.diagnostics.Error,
						WARN = my_utils.icons.diagnostics.Warn,
						INFO = my_utils.icons.diagnostics.Info,
						HINT = my_utils.icons.diagnostics.Hint,
					},
				})

				-- Right end status config
				local filename = MiniStatusline.section_filename({ trunc_width = 140 })
				local progress = "%p%%"
				local clock = my_utils.icons.misc.clock .. os.date("%I:%M %p")

				-- Combining this components into single group
				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					{ hl = "MiniStatuslineFilename", strings = { diff } },
					{ hl = "MiniStatuslineDevinfo", strings = { progress } },
					{ hl = mode_hl, strings = { clock } },
				})
			end,
			inactive = function()
				return "%#MiniStatuslineInactive#%f%="
			end,
		},
		use_icons = true,
	})
end

ok, plugin = pcall(require, "mini.icons")
if ok then
	plugin.setup()
end

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
