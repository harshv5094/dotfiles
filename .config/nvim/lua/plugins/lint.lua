local ok, plugin = pcall(require, "lint")

if ok then
	plugin.linters_by_ft = {
		sh = { "shellcheck" },
		bash = { "shellcheck" },
		lua = { "luacheck" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("Lint", { clear = true }),
		callback = function()
			plugin.try_lint()
		end,
	})
end
