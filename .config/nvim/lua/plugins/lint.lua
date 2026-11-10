-- Linter, just checking if what I'm writing is correct or not
local ok, plugin = pcall(require, "lint")

if ok then
	plugin.linters_by_ft = {
		lua = { "luacheck" },
		sh = { "shellcheck" },
		bash = { "shellcheck" },
		markdown = { "markdownlint-cli2" },
		python = { "ruff" },
	}

	-- Turn on by default
	vim.g.lint_enabled = true

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		callback = function()
			if vim.g.lint_enabled then
				plugin.try_lint()
			end
		end,
	})

	vim.keymap.set("n", "<leader>ul", function()
		vim.g.lint_enabled = not vim.g.lint_enabled
		if vim.g.lint_enabled then
			plugin.try_lint()
		else
			vim.diagnostic.reset(nil, 0) -- clear current buffer's lint diagnostics
		end
		vim.notify("nvim-lint: " .. (vim.g.lint_enabled and "on" or "off"))
	end, { desc = "Toggle nvim-lint" })
end
