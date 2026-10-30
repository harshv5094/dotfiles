-- A small function to quickly create a augroup
local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("HighlightOnYank"),
	pattern = "*",
	callback = function()
		if vim.fn.has("nvim-0.13") == 1 then
			vim.hl.hl_op()
		else
			(vim.hl or vim.highlight).on_yank()
		end
	end,
})

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		-- Extend neovim's client capabilities with the completion ones.
		vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })

		local servers = vim
			.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
			:map(function(file)
				return vim.fn.fnamemodify(file, ":t:r")
			end)
			:totable()
		vim.lsp.enable(servers)
	end,
})

-- Some changes when lsp is attached here
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("UserLspAttach"),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		---@diagnostic disable-next-line: need-check-nil
		if client.server_capabilities.codeLensProvider then
			vim.lsp.codelens.enable(true)
		end

		-- Delete default keymaps (buffer-local, so only where LSP attached)
		local default_keymaps = {
			{ "n", "grn" },
			{ "n", "gra" },
			{ "n", "grr" },
			{ "n", "gri" },
			{ "n", "grt" },
			{ "x", "gra" },
			{ { "n", "x" }, "grx" },
		}

		for _, map in ipairs(default_keymaps) do
			pcall(vim.keymap.del, map[1], map[2])
		end

		-- Set custom LSP keymaps
		local lsp_keymaps = {
			{ "n", "gd", vim.lsp.buf.definition, "Goto Definition" },
			{ "n", "gr", vim.lsp.buf.references, "References", nowait = true },
			{ "n", "gI", vim.lsp.buf.implementation, "Goto Implementation" },
			{ "n", "gy", vim.lsp.buf.type_definition, "Goto T[y]pe Definition" },
			{ "n", "gD", vim.lsp.buf.declaration, "Goto Declaration" },
			{ "n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions" },
			{ "n", "<leader>cr", vim.lsp.buf.rename, "Code Rename" },
			{ { "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens" },
		}

		for _, map in ipairs(lsp_keymaps) do
			vim.keymap.set(map[1], map[2], map[3], {
				buffer = ev.buf,
				desc = map[4],
				nowait = map.nowait,
			})
		end
	end,
})

-- Auto clear prompt message after moving the cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = augroup("ClearPrompt"),
	callback = function()
		vim.cmd("echo ''")
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Turn on wrap for specific files only
vim.api.nvim_create_autocmd({ "BufNew", "BufReadPre", "BufNewFile" }, {
	pattern = { "*.md", "*.markdown" },
	command = "set wrap",
})
