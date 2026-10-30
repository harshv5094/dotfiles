local M = {}
-- This function allows user to setup git initialized on the root directory where neovim is open.
function M.init()
	local root = vim.fn.getcwd()
	local output = vim.fn.system({ "git", "init", root })

	if vim.v.shell_error == 0 then
		vim.notify("Git initialized in: " .. root, vim.log.levels.INFO, { title = "Git Init" })
	else
		vim.notify("Git init failed:\n" .. output, vim.log.levels.ERROR, { title = "Git Init Error" })
	end
end

return M
