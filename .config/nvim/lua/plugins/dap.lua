-- Mason install locations, resolved once at startup
local registry = require("mason-registry")

local mason_paths = {
	debugpy = registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python",
	bashdb_adapter = registry.get_package("bash-debug-adapter"):get_install_path() .. "/bash-debug-adapter",
	bashdb_dir = registry.get_package("bash-debug-adapter"):get_install_path() .. "/extension/bashdb_dir",
}

-- Icon sign definition
vim.fn.sign_define("DapBreakpoint", {
	text = my_utils.icons.dap.breakpoint,
	texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DapBreakpointCondition", {
	text = my_utils.icons.dap.conditional_breakpoint,
	texthl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = my_utils.icons.dap.rejected_breakpoint,
	texthl = "Comment",
})
vim.fn.sign_define("DapLogPoint", {
	text = my_utils.icons.dap.log_point,
	texthl = "DiagnosticSignInfo",
})
vim.fn.sign_define("DapStopped", {
	text = my_utils.icons.dap.stopped,
	texthl = "String",
	linehl = "CursorLine",
	numhl = "String",
})

-- The Debug adapter protocol
local ok, plugin = pcall(require, "dap")
if ok then
	-- Python Debug Adapters
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
				command = mason_paths.debugpy,
				args = { "-m", "debugpy.adapter" },
				options = {
					source_filetype = "python",
				},
			})
		end
	end

	-- Python configuration
	plugin.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",

			program = "${file}",
			pythonPath = function()
				-- Use the active venv if one is set, otherwise fall back to base
				local venv = vim.env.VIRTUAL_ENV
				if venv and venv ~= "" then
					return venv .. "/bin/python"
				end
				return vim.fn.expand("~/.virtualenvs/base/bin/python")
			end,
		},
	}

	-- Bash Debugger adapter
	plugin.adapters.bashdb = {
		type = "executable",
		command = mason_paths.bashdb_adapter,
		name = "bashdb",
	}

	-- Bash configuration
	plugin.configurations.sh = {
		{
			type = "bashdb",
			request = "launch",
			name = "Launch file",
			showDebugOutput = true,
			pathBashdb = mason_paths.bashdb_dir .. "/bashdb",
			pathBashdbLib = mason_paths.bashdb_dir,
			trace = true,
			file = "${file}",
			program = "${file}",
			cwd = "${workspaceFolder}",
			pathCat = "cat",
			pathBash = "/bin/bash",
			pathMkfifo = "mkfifo",
			pathPkill = "pkill",
			args = {},
			argsString = "",
			env = {},
			terminalKind = "integrated",
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
				plugin.set_breakpoint(condition)
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
