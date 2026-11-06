-- A lightweight statusline implementation by echanovski
local ok, plugin = pcall(require, "mini.statusline")
if ok then
	local clock_timer

	-- Foreground-only diff highlights on the Filename background
	local diff = {
		add = { sign = "MiniDiffSignAdd", icon = my_utils.icons.git.added },
		change = { sign = "MiniDiffSignChange", icon = my_utils.icons.git.modified },
		delete = { sign = "MiniDiffSignDelete", icon = my_utils.icons.git.removed },
	}

	local function set_diff_hl()
		local bg = vim.api.nvim_get_hl(0, { name = "StatusLineNC", link = false }).bg
		for key, d in pairs(diff) do
			local fg = vim.api.nvim_get_hl(0, { name = d.sign, link = false }).fg
			vim.api.nvim_set_hl(0, "MiniStatuslineDiff" .. key, { fg = fg, bg = bg })
		end
	end

	-- Foreground-only diagnostic highlights on the Devinfo background
	local diag_levels = {
		{ severity = vim.diagnostic.severity.ERROR, name = "Error", icon = my_utils.icons.diagnostics.Error },
		{ severity = vim.diagnostic.severity.WARN, name = "Warn", icon = my_utils.icons.diagnostics.Warn },
		{ severity = vim.diagnostic.severity.INFO, name = "Info", icon = my_utils.icons.diagnostics.Info },
		{ severity = vim.diagnostic.severity.HINT, name = "Hint", icon = my_utils.icons.diagnostics.Hint },
	}

	local function set_diag_hl()
		local bg = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false }).bg
		for _, lvl in ipairs(diag_levels) do
			local fg = vim.api.nvim_get_hl(0, { name = "DiagnosticSign" .. lvl.name, link = false }).fg
			vim.api.nvim_set_hl(0, "MiniStatuslineDiag" .. lvl.name, { fg = fg, bg = bg })
		end
	end

	local function diagnostics_str()
		if MiniStatusline.is_truncated(75) then
			return ""
		end
		local counts = vim.diagnostic.count(0)
		local parts = {}
		for _, lvl in ipairs(diag_levels) do
			local n = counts[lvl.severity] or 0
			if n > 0 then
				table.insert(parts, ("%%#MiniStatuslineDiag%s#%s%d"):format(lvl.name, lvl.icon, n))
			end
		end
		if #parts == 0 then
			return ""
		end
		return table.concat(parts, " ") .. "%#MiniStatuslineDevinfo#"
	end

	-- Statusline setup
	plugin.setup({
		content = {
			active = function()
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local git = MiniStatusline.section_git({ trunc_width = 40, icon = my_utils.icons.git.branch })
					:gsub("%s*%b()", "")
				local diff_str = MiniStatusline.is_truncated(75) and "" or (vim.b.minidiff_summary_string or "")
				local diagnostics = diagnostics_str()
				local filename = MiniStatusline.section_filename({ trunc_width = 140 })

				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { my_utils.icons.misc.vim .. mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					{ hl = "MiniStatuslineFilename", strings = { diff_str } },
					{ hl = "MiniStatuslineDevinfo", strings = { "%p%%" } },
					{ hl = mode_hl, strings = { my_utils.icons.misc.clock .. os.date("%I:%M %p") } },
				})
			end,
			inactive = function()
				return "%#MiniStatuslineInactive#%f%="
			end,
		},
		use_icons = true,
	})

	-- Apply custom highlights after setup and keep them in sync with the colorscheme
	local gr = vim.api.nvim_create_augroup("my_statusline", { clear = true })
	set_diff_hl()
	set_diag_hl()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = gr,
		callback = function()
			set_diff_hl()
			set_diag_hl()
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		group = gr,
		pattern = "MiniDiffUpdated",
		callback = function(args)
			local s = vim.b[args.buf].minidiff_summary or {}
			local parts = {}
			for _, key in ipairs({ "add", "change", "delete" }) do
				local n = s[key] or 0
				if n > 0 then
					table.insert(parts, ("%%#MiniStatuslineDiff%s#%s%d%%#MiniStatuslineFilename#"):format(key, diff[key].icon, n))
				end
			end
			vim.b[args.buf].minidiff_summary_string = table.concat(parts, " ")
		end,
	})

	-- Keep the statusline clock live (it otherwise only updates on redraw)
	clock_timer = vim.uv.new_timer()
	---@diagnostic disable-next-line:need-check-nil
	clock_timer:start(
		30000,
		30000,
		vim.schedule_wrap(function()
			vim.cmd.redrawstatus()
		end)
	)
end
