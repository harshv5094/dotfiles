local term = {
	buf = nil, -- persistent terminal buffer
	height_fraction = 0.4,
}

local lazy = {
	buf = nil,
	win = nil,
}

local M = {}

local function term_alive(buf)
	if not (buf and vim.api.nvim_buf_is_valid(buf)) then
		return false
	end
	if vim.bo[buf].buftype ~= "terminal" then
		return false
	end
	local chan = vim.bo[buf].channel
	-- 'channel' stays set after the job exits, so ask jobwait whether it's running
	return chan ~= 0 and vim.fn.jobwait({ chan }, 0)[1] == -1
end

-- Non-floating window showing the terminal buffer (any tabpage)
local function term_win(buf)
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return nil
	end
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == "" then
			return win
		end
	end
end

function M.toggle_terminal()
	local root = M.project_root()

	local win = term_win(term.buf)
	if win then
		-- Closing the last window isn't allowed; hide the terminal in place instead
		if not pcall(vim.api.nvim_win_close, win, true) then
			---@diagnostic disable-next-line "param-type-mismatch"
			pcall(vim.cmd, "enew")
			return
		end
	end

	local alive = term_alive(term.buf)
	if not alive then
		-- Drop a dead terminal (abnormal exit) so a fresh shell is started next time
		if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
			vim.api.nvim_buf_delete(term.buf, { force = true })
		end
		term.buf = nil
		-- The terminal was showing: that was the toggle-off
		if win then
			return
		end
	elseif win then
		-- Closing the window was the toggle-off
		return
	end

	local size = math.max(math.floor(vim.o.lines * term.height_fraction), 5)
	vim.cmd(("botright %dsplit"):format(size))

	if alive then
		-- Resume the existing shell
		vim.api.nvim_win_set_buf(0, term.buf)
	else
		vim.cmd("lcd " .. vim.fn.fnameescape(root))
		vim.cmd("terminal")
		term.buf = vim.api.nvim_get_current_buf()
	end

	-- Keep the terminal from being squashed by later splits
	vim.wo.winfixheight = true

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
