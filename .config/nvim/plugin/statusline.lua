if pcall(require, "mini.statusline") then
	local icons = require("icons")
	local uv = vim.uv or vim.loop

	---------------------------------------------------------------------------
	-- Highlight helpers
	---------------------------------------------------------------------------

	local function get_hl(name)
		return vim.api.nvim_get_hl(0, { name = name, link = false })
	end

	-- Effective background of a group. gruvbox.nvim uses `reverse` on several
	-- groups (StatusLine, signs), so a reversed group's visible bg is its fg.
	local function bg_of(name)
		local h = get_hl(name)
		if h.reverse then
			return h.fg or get_hl("Normal").fg
		end
		return h.bg
	end

	-- Effective foreground of the first group in the list that has one.
	local function fg_of(...)
		for _, name in ipairs({ ... }) do
			local h = get_hl(name)
			local fg = h.reverse and h.bg or h.fg
			if fg then
				return fg
			end
		end
	end

	---------------------------------------------------------------------------
	-- Diff (drawn on the Filename section background)
	---------------------------------------------------------------------------

	local diff = {
		{
			key = "add",
			hl = "MiniStatuslineDiffAdd",
			src = { "MiniDiffSignAdd", "Added", "GruvboxGreen" },
			icon = icons.git.added,
		},
		{
			key = "change",
			hl = "MiniStatuslineDiffChange",
			src = { "MiniDiffSignChange", "Changed", "GruvboxAqua" },
			icon = icons.git.modified,
		},
		{
			key = "delete",
			hl = "MiniStatuslineDiffDelete",
			src = { "MiniDiffSignDelete", "Removed", "GruvboxRed" },
			icon = icons.git.removed,
		},
	}

	local function set_diff_hl()
		local bg = bg_of("MiniStatuslineFilename")
		for _, d in ipairs(diff) do
			vim.api.nvim_set_hl(0, d.hl, { fg = fg_of(unpack(d.src)), bg = bg })
		end
	end

	-- Built at render time from the current buffer, so it never goes stale
	-- and always follows whichever buffer is displayed.
	local function diff_str()
		if MiniStatusline.is_truncated(75) then
			return ""
		end
		local summary = vim.b.minidiff_summary
		if not summary then
			return ""
		end
		local parts = {}
		for _, d in ipairs(diff) do
			local n = summary[d.key] or 0
			if n > 0 then
				parts[#parts + 1] = ("%%#%s#%s%d"):format(d.hl, d.icon, n)
			end
		end
		if #parts == 0 then
			return ""
		end
		return table.concat(parts, " ") .. "%#MiniStatuslineFilename#"
	end

	---------------------------------------------------------------------------
	-- Diagnostics (drawn on the Devinfo section background)
	---------------------------------------------------------------------------

	local diag_levels = {
		{ severity = vim.diagnostic.severity.ERROR, name = "Error", icon = icons.diagnostics.Error },
		{ severity = vim.diagnostic.severity.WARN, name = "Warn", icon = icons.diagnostics.Warn },
		{ severity = vim.diagnostic.severity.INFO, name = "Info", icon = icons.diagnostics.Info },
		{ severity = vim.diagnostic.severity.HINT, name = "Hint", icon = icons.diagnostics.Hint },
	}

	local function set_diag_hl()
		local bg = bg_of("MiniStatuslineDevinfo")
		for _, lvl in ipairs(diag_levels) do
			-- Prefer plain Diagnostic<Level> over DiagnosticSign<Level>: in
			-- gruvbox the sign groups can be reversed / sign-column colored.
			local fg = fg_of("Diagnostic" .. lvl.name, "DiagnosticSign" .. lvl.name)
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
				parts[#parts + 1] = ("%%#MiniStatuslineDiag%s#%s%d"):format(lvl.name, lvl.icon, n)
			end
		end
		if #parts == 0 then
			return ""
		end
		return table.concat(parts, " ") .. "%#MiniStatuslineDevinfo#"
	end

	---------------------------------------------------------------------------
	-- Git branch (no post-processing of a formatted string)
	---------------------------------------------------------------------------

	local function git_str()
		if MiniStatusline.is_truncated(40) then
			return ""
		end
		local head = (vim.b.minigit_summary or {}).head_name or vim.b.gitsigns_head
		if not head or head == "" then
			return ""
		end
		return icons.git.branch .. " " .. head
	end

	---------------------------------------------------------------------------
	-- Clock: cached string, redraws only when the displayed minute changes
	---------------------------------------------------------------------------

	local function clock_text()
		return icons.misc.clock .. os.date("%I:%M %p")
	end

	local clock_str = clock_text()

	local function stop_clock()
		local t = _G._mini_statusline_clock_timer
		if t and not t:is_closing() then
			t:stop()
			t:close()
		end
		_G._mini_statusline_clock_timer = nil
	end

	---------------------------------------------------------------------------
	-- Statusline setup
	---------------------------------------------------------------------------

	require("mini.statusline").setup({
		content = {
			active = function()
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local filename = MiniStatusline.section_filename({ trunc_width = 140 })

				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { icons.misc.nvim .. mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git_str(), diagnostics_str() } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					{ hl = "MiniStatuslineFilename", strings = { diff_str() } },
					{ hl = "MiniStatuslineDevinfo", strings = { "%p%%" } },
					{ hl = mode_hl, strings = { clock_str } },
				})
			end,
			inactive = function()
				return "%#MiniStatuslineInactive#%<%f%="
			end,
		},
	})

	---------------------------------------------------------------------------
	-- Autocmds and timer
	---------------------------------------------------------------------------

	local gr = vim.api.nvim_create_augroup("my_statusline", { clear = true })

	local function apply_hl()
		set_diff_hl()
		set_diag_hl()
	end

	apply_hl()

	-- Scheduled so the colorscheme (and mini.statusline's own ColorScheme
	-- handler) have finished before we read their groups.
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = gr,
		callback = function()
			vim.schedule(apply_hl)
		end,
	})

	-- gruvbox reloads its palette when 'background' flips (dark <-> light)
	vim.api.nvim_create_autocmd("OptionSet", {
		group = gr,
		pattern = "background",
		callback = function()
			vim.schedule(apply_hl)
		end,
	})

	-- Statusline content is computed on render, so just request a redraw
	-- when the data it depends on changes.
	vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
		group = gr,
		callback = function()
			vim.cmd.redrawstatus()
		end,
	})
	vim.api.nvim_create_autocmd("User", {
		group = gr,
		pattern = "MiniDiffUpdated",
		callback = function()
			vim.cmd.redrawstatus()
		end,
	})

	-- (Re)start the clock timer; close any timer left over from a re-source
	stop_clock()
	local timer = uv.new_timer()
	_G._mini_statusline_clock_timer = timer
	---@diagnostic disable-next-line:need-check-nil
	timer:start(
		15000,
		15000,
		vim.schedule_wrap(function()
			local new = clock_text()
			if new ~= clock_str then
				clock_str = new
				vim.cmd.redrawstatus()
			end
		end)
	)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = gr,
		callback = stop_clock,
	})
end
