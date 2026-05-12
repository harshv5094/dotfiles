-- https://wiki.hypr.land/Configuring/Basics/Binds/#submaps

-- Programs submaps
hl.bind(main_mod .. " + O", hl.dsp.submap("programs"))

hl.define_submap("programs", "reset", function()
	-- Gnome Characters
	hl.bind("E", function()
		hl.exec_cmd(emoji)
	end)

	-- Sound Controller
	hl.bind("V", function()
		hl.exec_cmd(terminal_float .. " wiremix")
	end)

	-- Waybar Killswitch
	hl.bind("R", function()
		hl.exec_cmd(waybar)
	end)

	-- Calculator
	hl.bind("C", function()
		hl.exec_cmd(calculator)
	end)

	-- Hyprpicker: a color picker
	hl.bind("P", function()
		hl.exec_cmd(color_picker)
	end)

	-- Impala: A wifi viewer
	hl.bind("N", function()
		hl.exec_cmd(terminal_float .. " impala")
	end)

	-- Btop: A task manager
	hl.bind("T", function()
		hl.exec_cmd(terminal_float .. " btop")
	end)

	-- Bluetooth Manager
	hl.bind("B", function()
		hl.exec_cmd(terminal_float .. " bluetui")
	end)

	-- Use `reset` to go back to the global submap
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

-- Rofi Menu
hl.bind(main_mod .. " + R", hl.dsp.submap("rofi_menu"))

hl.define_submap("rofi_menu", "reset", function()
	-- Waybar Position
	hl.bind("P", function()
		hl.exec_cmd(script_dir .. "/waybar-position.sh")
	end)

	-- Change wallpaper
	hl.bind("W", function()
		hl.exec_cmd(script_dir .. "/wallpaper-switcher.sh")
	end)

	-- Change Theme
	hl.bind("T", function()
		hl.exec_cmd(script_dir .. "/theme-switcher.sh")
	end)

	-- Layout Switcher
	hl.bind("L", function()
		hl.exec_cmd(script_dir .. "/layout-switcher.sh")
	end)

	-- Kitty Sessionizer
	hl.bind("S", function()
		hl.exec_cmd(script_dir .. "/kitty-sessionizer.sh")
	end)

	-- Use `reset` to go back to the global submap
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

-- Switch to a submap called `resize`.
hl.bind("ALT + R", hl.dsp.submap("resize"))

-- Start a submap called "resize".
hl.define_submap("resize", function()
	-- Resize active window (Vim Keys)
	hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

	-- Resize active window (Arrow Keys)
	hl.bind("left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

	-- Use `reset` to go back to the global submap
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

-- Keybinds further down will be global again...
