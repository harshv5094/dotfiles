if pcall(require, "lazydev") then
	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	})
end

if pcall(require, "mason") then
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	vim.keymap.set("n", "<leader>cm", "<CMD>Mason<CR>", { desc = "Mason" })

	-- HACK: A custom hook to update mason server registries based on plugin install/update status
	vim.api.nvim_create_autocmd("PackChanged", {
		desc = "Mason Update command after updating",
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == "mason.nvim" and (kind == "install" or kind == "update") then
				vim.cmd("MasonUpdate")
			end
		end,
	})
end

if pcall(require, "mason-tool-installer") then
	require("mason-tool-installer").setup({
		ensure_installed = {
			-- LSP servers
			"lua-language-server",
			"bash-language-server",
			"yaml-language-server",
			"json-lsp",
			"taplo",
			"marksman",
			"pyright",

			-- Formatters / linters
			"stylua",
			"shellcheck",
			"shfmt",
			"luacheck",
			"prettier",
			"markdownlint-cli2",
			"ruff",

			-- Debuggers
			"debugpy",
			"bash-debug-adapter",
			"local-lua-debugger-vscode",
		},
		run_on_start = true,
	})
end
