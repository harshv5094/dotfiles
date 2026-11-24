local term = {
	buf = nil, -- persistent terminal buffer
	height_fraction = 0.38,
}

local lazygit = {
	buf = nil,
	win = nil,
	root = nil,
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
	local root = M.project_root()

	-- Drop the instance if it died or belongs to another project
	if lazygit.buf and (not term_alive(lazygit.buf) or lazygit.root ~= root) then
		if lazygit.win and vim.api.nvim_win_is_valid(lazygit.win) then
			vim.api.nvim_win_hide(lazygit.win)
		end
		if vim.api.nvim_buf_is_valid(lazygit.buf) then
			vim.api.nvim_buf_delete(lazygit.buf, { force = true })
		end
		lazygit.buf, lazygit.win, lazygit.root = nil, nil, nil
	end

	-- Hide the float but keep lazygit running
	if lazygit.win and vim.api.nvim_win_is_valid(lazygit.win) then
		vim.api.nvim_win_hide(lazygit.win)
		lazygit.win = nil
		return
	end

	-- Start lazygit in a fresh buffer if there isn't a live one
	if not lazygit.buf then
		if vim.fn.executable("lazygit") == 0 then
			vim.notify("lazygit not found in PATH", vim.log.levels.ERROR)
			return
		end

		local buf = vim.api.nvim_create_buf(false, true)
		local job = vim.api.nvim_buf_call(buf, function()
			return vim.fn.jobstart({ "lazygit" }, {
				term = true,
				cwd = root,
				on_exit = function()
					vim.schedule(function()
						-- Ignore exits from an instance we already replaced
						if lazygit.buf ~= buf then
							return
						end
						if lazygit.win and vim.api.nvim_win_is_valid(lazygit.win) then
							vim.api.nvim_win_close(lazygit.win, true)
						end
						if vim.api.nvim_buf_is_valid(buf) then
							vim.api.nvim_buf_delete(buf, { force = true })
						end
						lazygit.buf, lazygit.win, lazygit.root = nil, nil, nil
					end)
				end,
			})
		end)

		if job <= 0 then
			vim.api.nvim_buf_delete(buf, { force = true })
			vim.notify("Failed to start lazygit", vim.log.levels.ERROR)
			return
		end

		lazygit.buf, lazygit.root = buf, root
	end

	-- Usable area: editor minus cmdline and tabline (if shown)
	local tabline = (vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)) and 1 or 0
	local avail_w = vim.o.columns
	local avail_h = vim.o.lines - vim.o.cmdheight - tabline

	-- Outer size includes the 1-cell border on each side
	local outer_w = math.max(20, math.floor(avail_w * 0.9))
	local outer_h = math.max(5, math.floor(avail_h * 0.9))

	lazygit.win = vim.api.nvim_open_win(lazygit.buf, true, {
		relative = "editor",
		width = outer_w - 2,
		height = outer_h - 2,
		row = math.floor((avail_h - outer_h) / 2) + tabline,
		col = math.floor((avail_w - outer_w) / 2),
		style = "minimal",
		border = "rounded",
		zindex = 30,
		noautocmd = true,
	})

	-- Window-local options worth setting on top of style="minimal".
	-- Keep wrap on: lazygit parks the cursor at the right edge, and with 'wrap'
	-- off 'sidescrolloff' scrolls the view (leftcol > 0), clipping the TUI.
	local opts = { win = lazygit.win }
	vim.api.nvim_set_option_value("wrap", true, opts)
	vim.api.nvim_set_option_value("signcolumn", "no", opts)

	vim.cmd.startinsert()
end

-- A lua function to get project root dir path (whether you are in git path or not)
function M.project_root()
	return vim.fs.root(0, { ".git" }) or vim.fs.root(vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()
end

-- This function allows user to setup git initialized on the root directory where neovim is open.
function M.git_init()
	local root = vim.fn.getcwd()
	local output = vim.fn.system({ "git", "init", root })

	if vim.v.shell_error == 0 then
		vim.notify("Git initialized in: " .. root, vim.log.levels.INFO, { title = "Git Init" })
	else
		vim.notify("Git init failed:\n" .. output, vim.log.levels.ERROR, { title = "Git Init Error" })
	end
end

---@param plugin_name string
---@return 0|1
--- A function to check vimscript plugin path exist or not.
function M.vim_plugin_path_checker(plugin_name)
	return vim.fn.isdirectory(vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. plugin_name .. "/")
end

return M
