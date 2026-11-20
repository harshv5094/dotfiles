if pcall(require, "fidget") then
	require("fidget").setup({
		progress = {
			poll_rate = 0, -- How and when to poll for progress messages
			display = {
				render_limit = 16, -- How many LSP messages to show at once
				done_ttl = 3, -- How long a message should persist after completion
				done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
				done_style = "Statement", -- Highlight group for completed LSP tasks
			},
			lsp = {
				progress_ringbuf_size = 0,
				log_handler = false,
			},
		},
	})
end

if pcall(require, "incline") then
	require("incline").setup({
		debounce_threshold = {
			falling = 50,
			rising = 10,
		},
		hide = {
			cursorline = "smart",
			focused_win = false,
			only_win = false,
		},
		window = { padding = 0, margin = { vertical = 0, horizontal = 0 } },
		render = function(props)
			local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
			local modified = vim.bo[props.buf].modified

			-- No Name for unsaved file
			if filename == "" then
				filename = "[No Name]"
			end

			-- Adding plus sign for unsaved file
			if modified then
				filename = "[+] " .. filename
			end

			-- Determine styling: Bold only if focused
			-- Keeps italic if modified, regardless of focus
			local style = ""
			if props.focused then
				style = modified and "bold,italic" or "bold"
			else
				style = modified and "italic" or "none"
			end

			local design = {
				{ " " },
				{ filename, gui = style },
				{ " " },
			}
			return design
		end,
	})
end

if pcall(require, "todo-comments") then
  -- stylua: ignore
  local keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
  }

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end

	require("todo-comments").setup()
end

if pcall(require, "render-markdown") then
	require("render-markdown").setup({
		code = {
			sign = false,
			width = "block",
			right_pad = 1,
		},
		heading = {
			sign = false,
			icons = {},
		},
		checkbox = {
			enabled = false,
		},
	})

	vim.keymap.set("n", "<leader>um", require("render-markdown").toggle, { desc = "Toggle Markdown Rendering" })
end

if pcall(require, "bufferline") then
	require("bufferline").setup({
		options = {
			mode = "tabs", -- set to "tabs" to only show tabpages instead
			always_show_bufferline = false,
		},
	})

	local keys = {
		{ "<M-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<M-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	}

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end
end
