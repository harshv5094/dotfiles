-- A safety guard: if mason_registry not present, then skip loading this file.
if not pcall(require, "mason-registry") then
	return
end

-- Don't configure until every package is on disk
local packages_list = {
	"debugpy",
	"bash-debug-adapter",
	"local-lua-debugger-vscode",
}
for _, name in ipairs(packages_list) do
	if not require("mason-registry").is_installed(name) then
		return
	end
end

local mason_paths = {
	debugpy = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python",
	bashdb_adapter = require("mason-registry").get_package("bash-debug-adapter"):get_install_path()
		.. "/bash-debug-adapter",
	bashdb_dir = require("mason-registry").get_package("bash-debug-adapter"):get_install_path()
		.. "/extension/bashdb_dir",
	lua_debugger = require("mason-registry").get_package("local-lua-debugger-vscode"):get_install_path(),
}

if pcall(require, "dap") then
	require("dap").adapters.python = function(cb, config)
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

	require("dap").configurations.python = {
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

	require("dap").adapters.bashdb = {
		type = "executable",
		command = mason_paths.bashdb_adapter,
		name = "bashdb",
	}

	require("dap").configurations.sh = {
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

	require("dap").adapters["local-lua"] = {
		type = "executable",
		command = "node",
		args = { mason_paths.lua_debugger .. "/extension/extension/debugAdapter.js" },
		-- The adapter needs `extensionPath` to locate `lldebugger.lua`
		enrich_config = function(config, on_config)
			if not config.extensionPath then
				local c = vim.deepcopy(config)
				c.extensionPath = mason_paths.lua_debugger .. "/extension"
				on_config(c)
			else
				on_config(config)
			end
		end,
	}

	require("dap").configurations.lua = {
		{
			type = "local-lua",
			request = "launch",
			name = "Launch file (luajit)",
			program = {
				lua = "luajit",
				file = "${file}",
			},
			cwd = "${workspaceFolder}",
		},
	}

	-- Debug keymaps, all under <leader>d
	local map = vim.keymap.set

	map("n", "<leader>dc", require("dap").continue, { desc = "Start/Continue" })
	map("n", "<leader>da", require("dap").run_last, { desc = "Run Last" })
	map("n", "<leader>dp", require("dap").pause, { desc = "Pause" })
	map("n", "<leader>dt", require("dap").terminate, { desc = "Terminate" })

	map("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
	map("n", "<leader>dB", function()
		vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
			if condition and condition ~= "" then
				require("dap").set_breakpoint(condition)
			end
		end)
	end, { desc = "Conditional Breakpoint" })
	map("n", "<leader>dC", require("dap").clear_breakpoints, { desc = "Clear All Breakpoints" })

	map("n", "<leader>di", require("dap").step_into, { desc = "Step Into" })
	map("n", "<leader>do", require("dap").step_over, { desc = "Step Over" })
	map("n", "<leader>dO", require("dap").step_out, { desc = "Step Out" })

	map("n", "<leader>dj", require("dap").down, { desc = "Down Frame" })
	map("n", "<leader>dk", require("dap").up, { desc = "Up Frame" })
end
