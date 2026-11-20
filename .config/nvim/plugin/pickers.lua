if not pcall(require, "mini.pick") then
	return
end

local map = vim.keymap.set

require("mini.pick").setup({
	window = {
		config = function()
			local height = math.floor(0.4 * vim.o.lines) -- 40% of editor height
			local width = math.floor(0.5 * vim.o.columns) -- 60% of editor width
			return {
				anchor = "NW",
				height = height,
				width = width,
				row = 0, -- On the top edge
				col = math.floor(0.5 * (vim.o.columns - width)), -- still horizontally centered
				border = "rounded",
			}
		end,
	},
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
	require("mini.pick").builtin.files(nil, { source = { name = name, cwd = cwd } })
end

local function todo_picker(keywords)
	if not pcall(require, "todo-comments.search") then
		return
	end

	if type(keywords) == "table" then
		keywords = table.concat(keywords, ",")
	end

	require("todo-comments.search").search(function(results)
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
		require("mini.extra").pickers.list({ scope = "quickfix" })
	end, { keywords = keywords })
end

-- stylua: ignore
local keys = {
	{ "<leader>,", function() require("mini.pick").builtin.buffers() end, "Active Buffers" },
	{ "<leader><space>", function() require("mini.pick").builtin.files() end, "Find Files" },
	{ "<leader>/", function() require("mini.pick").builtin.grep_live() end, "Live Grep" },
	{ "<leader>sb", function() require("mini.extra").pickers.buf_lines({ scope = "current" }) end, "Buffer Lines" },
	{ "<leader>sc", function() require("mini.extra").pickers.history() end, "Command History" },
	{ "<leader>sd", function() require("mini.extra").pickers.diagnostic({ scope = "all" }) end, "Diagnostics" },
	{ "<leader>sh", function() require("mini.pick").builtin.help() end, "Help Tags" },
	{ "<leader>sH", function() require("mini.extra").pickers.hl_groups() end, "Highlight Groups" },
	{ "<leader>sj", function() require("mini.extra").pickers.list({ scope = "jump" }) end, "Jumplist" },
	{ "<leader>sk", function() require("mini.extra").pickers.keymaps() end, "Keymaps" },
	{ "<leader>sl", function() require("mini.extra").pickers.list({ scope = "location" }) end, "Location List" },
	{ "<leader>sm", function() require("mini.extra").pickers.manpages() end, "Man Pages" },
	{ "<leader>so", function() require("mini.extra").pickers.options() end, "Options" },
	{ "<leader>sO", function() require("mini.extra").pickers.oldfiles() end, "Oldfiles" },
	{ "<leader>sq", function() require("mini.extra").pickers.list({ scope = "quickfix" }) end, "Quickfix List" },
	{ "<leader>sR", function() require("mini.pick").builtin.resume() end, "Resume Picker" },
	{ "<leader>st", function() todo_picker() end, "Todo" },
	{ "<leader>sT", function() todo_picker({ "TODO", "FIX", "FIXME" }) end, "Todo/Fix/Fixme" },
	{ "<leader>uC", function() require("mini.extra").pickers.colorschemes() end, "Colorscheme" },
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
