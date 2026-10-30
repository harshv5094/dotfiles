local state = {
	buf = nil,
	win = nil,
	height_fraction = 0.3,
}

local lazy = {
	buf = nil,
	win = nil,
}

local M = {}

function M.toggle_terminal()
	-- Hide the terminal if it's visible
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
		state.win = nil
		return
	end

	-- Start a shell if there's no live terminal buffer
	local alive = state.buf
		and vim.api.nvim_buf_is_valid(state.buf)
		and vim.bo[state.buf].channel ~= 0
		and vim.fn.jobwait({ vim.bo[state.buf].channel }, 0)[1] == -1

	if not alive then
		if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
			vim.api.nvim_buf_delete(state.buf, { force = true })
		end
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_call(state.buf, function()
			vim.api.nvim_buf_call(state.buf, function()
				vim.fn.jobstart(vim.o.shell, {
					term = true,
					on_exit = function()
						vim.schedule(function()
							if state.win and vim.api.nvim_win_is_valid(state.win) then
								vim.api.nvim_win_close(state.win, true)
							end
							if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
								vim.api.nvim_buf_delete(state.buf, { force = true })
							end
							state.buf, state.win = nil, nil
						end)
					end,
				})
			end)
		end)
	end

	-- Open a full-width window at the bottom of the editor
	state.win = vim.api.nvim_open_win(state.buf, true, {
		win = -1,
		split = "below",
		height = math.floor(vim.o.lines * state.height_fraction),
	})

	local opts = { win = state.win }
	vim.api.nvim_set_option_value("number", false, opts)
	vim.api.nvim_set_option_value("relativenumber", false, opts)
	vim.api.nvim_set_option_value("signcolumn", "no", opts)

	vim.cmd.startinsert()
end

function M.chmod(mode)
	mode = mode or "x"
	local file = vim.fn.expand("%")
	local sign = mode == "x" and "+" or "-"
	local result = os.execute("chmod " .. sign .. "x " .. vim.fn.shellescape(file))

	if result == 0 then
		vim.notify(
			"chmod " .. sign .. "x → " .. vim.fn.fnamemodify(file, ":t"),
			vim.log.levels.INFO,
			{ title = "File Permissions" }
		)
	else
		vim.notify(
			"Failed to chmod " .. sign .. "x → " .. vim.fn.fnamemodify(file, ":t"),
			vim.log.levels.ERROR,
			{ title = "File Permissions" }
		)
	end
end

function M.toggle_lazygit()
	-- Hide the float but keep lazygit running
	if lazy.win and vim.api.nvim_win_is_valid(lazy.win) then
		vim.api.nvim_win_hide(lazy.win)
		lazy.win = nil
		return
	end

	-- Start lazygit in a fresh buffer if there isn't a live one
	if not (lazy.buf and vim.api.nvim_buf_is_valid(lazy.buf)) then
		if vim.fn.executable("lazygit") == 0 then
			vim.notify("lazygit not found in PATH", vim.log.levels.ERROR)
			return
		end

		lazy.buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_call(lazy.buf, function()
			vim.fn.jobstart({ "lazygit" }, {
				term = true,
				cwd = M.project_root(),
				on_exit = function()
					vim.schedule(function()
						if lazy.win and vim.api.nvim_win_is_valid(lazy.win) then
							vim.api.nvim_win_close(lazy.win, true)
						end
						if lazy.buf and vim.api.nvim_buf_is_valid(lazy.buf) then
							vim.api.nvim_buf_delete(lazy.buf, { force = true })
						end
						lazy.buf, lazy.win = nil, nil
					end)
				end,
			})
		end)
	end

	-- Usable area: editor minus cmdline and tabline (if shown)
	local tabline = (vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)) and 1 or 0
	local avail_w = vim.o.columns
	local avail_h = vim.o.lines - vim.o.cmdheight - tabline

	-- Outer size includes the 1-cell border on each side
	local outer_w = math.max(20, math.floor(avail_w * 0.9))
	local outer_h = math.max(5, math.floor(avail_h * 0.9))

	lazy.win = vim.api.nvim_open_win(lazy.buf, true, {
		relative = "editor",
		width = outer_w - 2,
		height = outer_h - 2,
		row = math.floor((avail_h - outer_h) / 2) + tabline,
		col = math.floor((avail_w - outer_w) / 2),
		style = "minimal",
		border = "rounded",
		zindex = 30,
	})

	-- Window-local options, set on this float only
	local opts = { win = lazy.win }
	vim.api.nvim_set_option_value("wrap", false, opts)
	vim.api.nvim_set_option_value("cursorline", false, opts)
	vim.api.nvim_set_option_value("list", false, opts)
	vim.api.nvim_set_option_value("number", false, opts)
	vim.api.nvim_set_option_value("relativenumber", false, opts)
	vim.api.nvim_set_option_value("signcolumn", "no", opts)

	-- Reset any horizontal scroll left over from a previous show
	vim.api.nvim_win_call(lazy.win, function()
		vim.fn.winrestview({ leftcol = 0 })
	end)

	vim.cmd.startinsert()
end

-- A lua function to get project root dir path (whether you are in git path or not)
function M.project_root()
	return vim.fs.root(0, { ".git" }) or vim.fs.root(vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()
end

return M
