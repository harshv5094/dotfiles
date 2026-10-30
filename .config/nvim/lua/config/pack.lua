-- pack_user_commands.lua
-- User commands for managing plugins with vim.pack (Neovim 0.12+).
-- Load from init.lua with: require('pack_user_command')
--
-- Verify the vim.pack API against `:h vim.pack` in your version.

local function installed_names()
	local names = {}
	for _, p in ipairs(vim.pack.get()) do
		table.insert(names, p.spec.name)
	end
	table.sort(names)
	return names
end

local function complete_names(arglead)
	return vim.tbl_filter(function(name)
		return vim.startswith(name, arglead)
	end, installed_names())
end

local function confirm(msg)
	return vim.fn.confirm(msg, "&Yes\n&No", 2) == 1
end

-- :PackList
vim.api.nvim_create_user_command("PackList", function()
	for _, p in ipairs(vim.pack.get()) do
		print(("%-30s %s"):format(p.spec.name, p.path))
	end
end, { desc = "List vim.pack plugins" })

-- :PackInstall[!] url [name] [version]
-- Bang skips the confirmation prompt.
vim.api.nvim_create_user_command("PackInstall", function(opts)
	local url, name, version = opts.fargs[1], opts.fargs[2], opts.fargs[3]

	local spec = { src = url }
	if name then
		spec.name = name
	end
	if version then
		spec.version = version
	end

	local ok, err = pcall(vim.pack.add, { spec }, { confirm = not opts.bang })
	if ok then
		vim.notify(("Installed %s. Add a vim.pack.add() line to your config so it persists."):format(url))
	else
		vim.notify("PackInstall failed: " .. err, vim.log.levels.ERROR)
	end
end, {
	nargs = "+",
	bang = true,
	desc = "Install a vim.pack plugin from a URL",
})

-- :PackUpdate[!] [name ...]
-- No args updates everything. Bang skips the review window.
vim.api.nvim_create_user_command("PackUpdate", function(opts)
	local names = #opts.fargs > 0 and opts.fargs or nil
	local ok, err = pcall(vim.pack.update, names, { force = opts.bang })
	if not ok then
		vim.notify("PackUpdate failed: " .. err, vim.log.levels.ERROR)
	end
end, {
	nargs = "*",
	bang = true,
	complete = complete_names,
	desc = "Update vim.pack plugins",
})

-- :PackUninstall[!] name ...
vim.api.nvim_create_user_command("PackUninstall", function(opts)
	local known = installed_names()
	for _, name in ipairs(opts.fargs) do
		if not vim.tbl_contains(known, name) then
			vim.notify(('PackUninstall: "%s" is not installed'):format(name), vim.log.levels.WARN)
		elseif confirm(("Uninstall %s?"):format(name)) then
			local ok, err = pcall(vim.pack.del, { name }, { force = opts.bang })
			if ok then
				vim.notify(("Uninstalled %s. Remove its vim.pack.add() call so it stays removed."):format(name))
			else
				vim.notify(("Failed to uninstall %s: %s"):format(name, err), vim.log.levels.ERROR)
			end
		end
	end
end, {
	nargs = "+",
	bang = true,
	complete = complete_names,
	desc = "Uninstall vim.pack plugins",
})
