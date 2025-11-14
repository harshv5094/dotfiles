local M = {}

local Path = require("plenary.path")
local scan = require("plenary.scandir")
local builtin = require("telescope.builtin")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local notes_dir = vim.fn.expand("~/notebook")
local templates_dir = vim.fn.expand("~/notebook/.templates")

-- Get today's date
local function get_current_date()
	return os.date("%d/%m/%Y %I:%M %p")
end

-- Async safety check & clone if needed, then run callback
local function ensure_notebook_dir(cb)
	local notes_path = Path:new(notes_dir)
	if notes_path:exists() then
		if cb then
			cb()
		end
		return true
	end

	vim.ui.input({ prompt = "SSH key name (without .pub):", default = "id_ed25519" }, function(keyname)
		if not keyname or keyname == "" then
			vim.notify("Clone canceled. SSH key name not provided.", vim.log.levels.WARN)
			return
		end

		local ssh_dir = vim.fn.expand("~/.ssh/")
		local ssh_key = Path:new(ssh_dir .. keyname)
		local ssh_key_pub = Path:new(ssh_dir .. keyname .. ".pub")

		if not ssh_key:exists() or not ssh_key_pub:exists() then
			vim.notify(
				string.format("SSH key pair not found: %s and %s", ssh_key.filename, ssh_key_pub.filename),
				vim.log.levels.ERROR
			)
			return
		end

		vim.ui.input({ prompt = "Git host (e.g., github.com):", default = "github.com" }, function(hostname)
			if not hostname or hostname == "" then
				vim.notify("Clone canceled. Hostname not provided.", vim.log.levels.WARN)
				return
			end

			vim.ui.input({ prompt = "Git username/org:" }, function(username)
				if not username or username == "" then
					vim.notify("Clone canceled. Username not provided.", vim.log.levels.WARN)
					return
				end

				local repo_url = string.format("git@%s:%s/notebook.git", hostname, username)
				vim.notify(string.format("Cloning notebook repo from %s...", repo_url), vim.log.levels.INFO)

				vim.system({ "git", "clone", repo_url, notes_dir }, { text = true }, function(result)
					if result.code == 0 then
						vim.schedule(function()
							vim.notify("Notebook repo cloned successfully!", vim.log.levels.INFO)
							if cb then
								cb()
							end -- run original command after clone
						end)
					else
						vim.schedule(function()
							vim.notify("Failed to clone notebook:\n" .. result.stderr, vim.log.levels.ERROR)
						end)
					end
				end)
			end)
		end)
	end)

	return false
end

-- 1. Create a new Markdown note using selected template
M.create_note = function()
	ensure_notebook_dir(function()
		vim.ui.input({ prompt = "Note Title: " }, function(title)
			if not title or title == "" then
				return
			end

			local function format_title(str)
				return str:gsub("[-_]", " "):gsub("(%a)([%w_']*)", function(a, b)
					return a:upper() .. b:lower()
				end)
			end

			local formatted_title = format_title(title)

			local template_files = scan.scan_dir(templates_dir, { depth = 1, search_pattern = "%.md$" })
			local entries = {}
			for _, file in ipairs(template_files) do
				table.insert(entries, vim.fn.fnamemodify(file, ":t"))
			end

			pickers
				.new({}, {
					prompt_title = "Select Template",
					finder = finders.new_table({ results = entries }),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_bufnr, map)
						map("i", "<CR>", function()
							actions.close(prompt_bufnr)
							local selection = action_state.get_selected_entry()
							if not selection then
								vim.notify("No template selected", vim.log.levels.WARN)
								return
							end

							local template_path = Path:new(templates_dir, selection[1])
							local new_note_path = Path:new(notes_dir, title:gsub("%s+", "_") .. ".md")

							local content = template_path:read()
							content = content:gsub("{{title}}", formatted_title):gsub("{{date}}", get_current_date())

							if not new_note_path:exists() then
								new_note_path:write(content, "w")
							end

							vim.cmd("edit " .. new_note_path.filename)
						end)
						return true
					end,
				})
				:find()
		end)
	end)
end

-- 2. Search notes by tag
M.search_by_tag = function()
	ensure_notebook_dir(function()
		vim.ui.input({ prompt = "Search tag:" }, function(tag)
			if not tag or tag == "" then
				return
			end
			builtin.grep_string({
				search = "tags:.*" .. tag,
				cwd = notes_dir,
				use_regex = true,
			})
		end)
	end)
end

-- 3. Find notes
M.find_notes = function()
	ensure_notebook_dir(function()
		builtin.find_files({
			prompt_title = "Find Notes",
			cwd = notes_dir,
		})
	end)
end

-- 4. Sync notes to all remotes
M.sync_to_remote = function()
	ensure_notebook_dir(function()
		local timestamp = os.date("%d/%m/%Y %I:%M %p")
		local commit_msg = "backup: " .. timestamp
		local cmd = {
			"sh",
			"-c",
			table.concat({
				"cd " .. notes_dir,
				"git stash push -u -m 'auto-backup-stash'",
				"git pull",
				"git stash pop",
				"git add .",
				"git commit -m '" .. commit_msg .. "'",
				"git remote | xargs -L1 git push --all",
			}, " && "),
		}

		vim.system(cmd, { text = true }, function(result)
			if result.code == 0 then
				vim.schedule(function()
					vim.notify("Notes synced to Remote: " .. commit_msg, vim.log.levels.INFO)
				end)
			else
				vim.schedule(function()
					vim.notify("Git sync failed:\n" .. result.stderr, vim.log.levels.ERROR)
				end)
			end
		end)
	end)
end

return M
