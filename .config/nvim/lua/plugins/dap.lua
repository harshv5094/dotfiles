-- The bridge between nvim-dap and mason
local ok, plugin = pcall(require, "mason-nvim-dap")

if ok then
	plugin.setup({
		automatic_installation = false,
		ensure_installed = { "debugpy" },
		handlers = {
			-- Use the default handler, which registers dap.adapters.* for you
			function(config)
				require("mason-nvim-dap").default_setup(config)
			end,
		},
	})
end

-- The Debug adapter protocol
ok, plugin = pcall(require, "dap")

if ok then
	-- Setting up adapter for python, using the Mason-managed debugpy
	local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

	plugin.adapters.python = function(cb, config)
		if config.request == "attach" then
			---@diagnostic disable-next-line: undefined-field
			local port = (config.connect or config).port
			---@diagnostic disable-next-line: undefined-field
			local host = (config.connect or config).host or "127.0.0.1"
			cb({
				type = "server",
				port = assert(port, "`connect.port` is required for a python `attach` configuration"),
				host = host,
				options = {
					source_filetype = "python",
				},
			})
		else
			cb({
				type = "executable",
				command = debugpy_python,
				args = { "-m", "debugpy.adapter" },
				options = {
					source_filetype = "python",
				},
			})
		end
	end

	-- Setting up configuration for python
	plugin.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- The interpreter that runs your code (not the debugger).
				-- Uses the venv selected with :VenvSelect when venv-selector is available.
				local ok_vs, selector = pcall(require, "venv-selector")
				if ok_vs then
					local python = selector.python()
					if python and vim.fn.executable(python) == 1 then
						return python
					end
				end

				-- Fallback: look for a venv or .venv in the current directory
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	}

	-- Debug keymaps, all under <leader>d
	local map = vim.keymap.set

	-- Session control
	map("n", "<leader>dc", plugin.continue, { desc = "Start/Continue" })
	map("n", "<leader>da", plugin.run_last, { desc = "Run Last" })
	map("n", "<leader>dp", plugin.pause, { desc = "Pause" })
	map("n", "<leader>dt", plugin.terminate, { desc = "Terminate" })

	-- Breakpoints
	map("n", "<leader>db", plugin.toggle_breakpoint, { desc = "Toggle Breakpoint" })
	map("n", "<leader>dB", function()
		vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
			if condition and condition ~= "" then
				-- (Re)required here because the `plugin` variable is reused below
				require("dap").set_breakpoint(condition)
			end
		end)
	end, { desc = "Conditional Breakpoint" })
	map("n", "<leader>dC", plugin.clear_breakpoints, { desc = "Clear All Breakpoints" })

	-- Stepping
	map("n", "<leader>di", plugin.step_into, { desc = "Step Into" })
	map("n", "<leader>do", plugin.step_over, { desc = "Step Over" })
	map("n", "<leader>dO", plugin.step_out, { desc = "Step Out" })

	-- Stack frame navigation
	map("n", "<leader>dj", plugin.down, { desc = "Down Frame" })
	map("n", "<leader>dk", plugin.up, { desc = "Up Frame" })
end

-- The Lightweight view of nvim-dap
ok, plugin = pcall(require, "dap-view")

if ok then
	plugin.setup({
		auto_toggle = true,
		virtual_text = {
			enabled = true,
		},
	})

	local map = vim.keymap.set

	map("n", "<leader>du", plugin.toggle, { desc = "Toggle UI" })
	local state = require("dap-view.state")
	map("n", "<leader>dr", function()
		if not (state.winnr and vim.api.nvim_win_is_valid(state.winnr)) then
			plugin.open()
			plugin.jump_to_view("repl")
		elseif state.current_section == "repl" then
			plugin.close()
		else
			plugin.jump_to_view("repl")
		end
	end, { desc = "Toggle REPL" })
	map({ "n", "x" }, "<leader>dh", plugin.hover, { desc = "Hover Variable" })
	map({ "n", "x" }, "<leader>dw", plugin.add_expr, { desc = "Watch Expression" })
	map("n", "<leader>de", plugin.virtual_text_toggle, { desc = "Toggle Virtual Text" })
end
