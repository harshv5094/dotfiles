-- A safety guard: if mason_registry not present, then skip loading this file.
if not pcall(require, "mason-registry") then
	return
end

-- NOTE: sign definitions (DapBreakpoint etc.) for dap debugging
vim.fn.sign_define("DapBreakpoint", {
	text = require("icons").dap.breakpoint,
	texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DapBreakpointCondition", {
	text = require("icons").dap.conditional_breakpoint,
	texthl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = require("icons").dap.rejected_breakpoint,
	texthl = "Comment",
})
vim.fn.sign_define("DapLogPoint", {
	text = require("icons").dap.log_point,
	texthl = "DiagnosticSignInfo",
})
vim.fn.sign_define("DapStopped", {
	text = require("icons").dap.stopped,
	texthl = "String",
	linehl = "CursorLine",
	numhl = "String",
})

if pcall(require, "dap-view") then
	require("dap-view").setup({
		auto_toggle = true,
		virtual_text = {
			enabled = true,
		},
	})

	local map = vim.keymap.set
	map("n", "<leader>du", require("dap-view").toggle, { desc = "Toggle UI" })

	map("n", "<leader>dr", function()
		local state = require("dap-view.state")
		if not (state.winnr and vim.api.nvim_win_is_valid(state.winnr)) then
			require("dap-view").open()
			require("dap-view").jump_to_view("repl")
		elseif state.current_section == "repl" then
			require("dap-view").close()
		else
			require("dap-view").jump_to_view("repl")
		end
	end, { desc = "Toggle REPL" })

	map({ "n", "x" }, "<leader>dh", require("dap-view").hover, { desc = "Hover Variable" })
	map({ "n", "x" }, "<leader>dw", require("dap-view").add_expr, { desc = "Watch Expression" })
	map("n", "<leader>de", require("dap-view").virtual_text_toggle, { desc = "Toggle Virtual Text" })
end
