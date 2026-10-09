-- NOTE:
-- Based on https://github.com/craftzdog/dotfiles-public/blob/master/.config/nvim/lua/craftzdog/discipline.lua

local uv = vim.uv or vim.loop -- vim.uv is only available on Neovim >= 0.10

local M = {}

---@class CowboyOpts
---@field keys string[]           keys to throttle in normal mode
---@field limit integer           max consecutive presses allowed
---@field timeout integer         ms after the last allowed press before the counter resets
---@field message string
---@field icon string
---@field exempt_buftypes table<string, boolean>

---@type CowboyOpts
M.defaults = {
	keys = { "h", "j", "k", "l", "+", "-" },
	limit = 10,
	timeout = 2000,
	message = "Hold it Cowboy!",
	icon = "🤠",
	exempt_buftypes = { nofile = true },
}

---@type string[]
local mapped = {}

local function now_ms()
	return uv.hrtime() / 1e6
end

--- Remove all mappings created by `setup()`.
function M.disable()
	for _, key in ipairs(mapped) do
		pcall(vim.keymap.del, "n", key)
	end
	mapped = {}
end

---@param opts? CowboyOpts
function M.setup(opts)
	local o = vim.tbl_deep_extend("force", M.defaults, opts or {})

	M.disable() -- makes setup() idempotent

	for _, key in ipairs(o.keys) do
		local count, last = 0, 0

		local function is_blocked()
			return count >= o.limit and (now_ms() - last) < o.timeout
		end

		vim.keymap.set("n", key, function()
			-- Explicit counts (e.g. `5j`) are fine; so are exempt buffers.
			if vim.v.count > 0 then
				count = 0
				return key
			end
			if o.exempt_buftypes[vim.bo.buftype] then
				return key
			end

			-- Counter expires on its own; no timer handle needed.
			if (now_ms() - last) >= o.timeout then
				count = 0
			end

			if count >= o.limit then
				local ok = pcall(vim.notify, o.message, vim.log.levels.WARN, {
					icon = o.icon,
					id = "cowboy",
					keep = is_blocked,
				})
				-- If notifying fails, don't trap the user: let the key through.
				return ok and "" or key
			end

			count = count + 1
			last = now_ms()
			return key
		end, { expr = true, silent = true, desc = "Cowboy: throttle repeated " .. key })

		mapped[#mapped + 1] = key
	end
end

-- Backwards-compatible alias for the original API
M.cowboy = M.setup

return M
