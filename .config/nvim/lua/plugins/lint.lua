local ok, plugin = pcall(require, "lint")

if ok then
	plugin.linters_by_ft = {
		sh = { "shellcheck" },
		bash = { "shellcheck" },
		lua = { "luacheck" },
	}

	-- Turn on by default
	local lint_status = true

	if lint_status == true then
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("Lint", { clear = true }),
			callback = function()
				plugin.try_lint()
			end,
		})
	end

	vim.keymap.set("n", "<leader>cl", function()
		lint_status = not lint_status
		vim.notify("nvim-lint: " .. (lint_status and "on" or "off"))
	end, { desc = "Toggle Lint" })
end
