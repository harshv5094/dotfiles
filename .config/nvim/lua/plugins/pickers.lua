-- Pickers powered by mini.pick + mini.extra (replaces telescope.nvim)
local ok = pcall(require, "mini.pick")
if not ok then
	return
end

local pick = require("mini.pick")
local extra = require("mini.extra")
local map = vim.keymap.set

pick.setup({
	mappings = {
		move_down = "<M-n>",
		move_up = "<M-p>",
		move_start = "<M-g>",
		mark = "<M-x>",
		mark_all = "<M-a>",
		paste = "<M-r>",
		scroll_down = "<M-f>",
		scroll_up = "<M-b>",
		scroll_left = "<M-h>",
		scroll_right = "<M-l>",
		delete_left = "<M-u>",
		delete_word = "<M-w>",
		choose_in_split = "<M-s>",
		choose_in_vsplit = "<M-v>",
		choose_in_tabpage = "<M-t>",
		stop = "<M-c>",
	},
})

local function files_in(cwd, name)
	pick.builtin.files(nil, { source = { name = name, cwd = cwd } })
end

local function todo_picker(keywords)
	local ok_search, search = pcall(require, "todo-comments.search")
	if not ok_search then
		return
	end

	search.search(function(results)
		local items = {}
		for _, r in ipairs(results) do
			items[#items + 1] = {
				filename = r.filename,
				lnum = r.lnum,
				col = r.col,
				text = (r.tag and (r.tag .. " ") or "") .. (r.message or r.text or ""),
			}
		end
		vim.fn.setqflist({}, " ", { title = "Todo", items = items })
		extra.pickers.list({ scope = "quickfix" })
	end, { keywords = keywords })
end

-- stylua: ignore
local keys = {
	{ "<leader>,", function() pick.builtin.buffers() end, "Buffers" },
	{ "<leader><space>", function() pick.builtin.files() end, "Find Files" },
	{ "<leader>/", function() pick.builtin.grep_live() end, "Live Grep" },
	{ "<leader>sb", function() extra.pickers.buf_lines({ scope = "current" }) end, "Buffer Lines" },
	{ "<leader>sd", function() extra.pickers.diagnostic({ scope = "all" }) end, "Diagnostics" },
	{ "<leader>sh", function() pick.builtin.help() end, "Help Tags" },
	{ "<leader>sH", function() extra.pickers.hl_groups() end, "Highlight Groups" },
	{ "<leader>sj", function() extra.pickers.list({ scope = "jump" }) end, "Jumplist" },
	{ "<leader>sk", function() extra.pickers.keymaps() end, "Keymaps" },
	{ "<leader>sl", function() extra.pickers.list({ scope = "location" }) end, "Location List" },
	{ "<leader>sm", function() extra.pickers.manpages() end, "Man Pages" },
	{ "<leader>so", function() extra.pickers.options() end, "Options" },
	{ "<leader>sO", function() extra.pickers.oldfiles() end, "Oldfiles" },
	{ "<leader>sq", function() extra.pickers.list({ scope = "quickfix" }) end, "Quickfix List" },
	{ "<leader>sR", function() pick.builtin.resume() end, "Resume Picker" },
	{ "<leader>:", function() extra.pickers.history() end, "Command History" },
	{ "<leader>st", function() todo_picker() end, "Todo" },
	{ "<leader>sT", function() todo_picker({ "TODO", "FIX", "FIXME" }) end, "Todo/Fix/Fixme" },
	{ "<leader>uC", function() extra.pickers.colorschemes() end, "Colorscheme" },
	{ "<leader>fc", function() files_in(vim.fn.stdpath("config"), "Config Files") end, "Config Files" },
	{
		"<leader>fP",
		function() files_in(vim.fn.stdpath("data") .. "/site/pack/core/opt", "vim.pack plugins") end,
		"vim.pack plugins",
	},
}

for _, k in ipairs(keys) do
	map("n", k[1], k[2], { desc = k[3] })
end
