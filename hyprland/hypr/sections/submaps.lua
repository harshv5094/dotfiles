-- https://wiki.hypr.land/Configuring/Basics/Binds/#submaps

-- Programs submaps
hl.bind(main_mod .. " + O", hl.dsp.submap("programs"))

hl.define_submap("programs", function()
	-- Gnome Characters
	hl.bind("E", function()
		hl.dsp.exec_cmd(emoji)
		hl.dsp.submap("reset")
	end)

	-- Sound Controller
	hl.bind("V", function()
		hl.dsp.exec_cmd(terminal_float .. " wiremix")
		hl.dsp.submap("reset")
	end)

	-- Waybar Killswitch
	hl.bind("R", function()
		hl.dsp.exec_cmd(waybar)
		hl.dsp.submap("reset")
	end)

	-- Calculator
	hl.bind("C", function()
		hl.dsp.submap("reset")
		hl.dsp.exec_cmd(calculator)
	end)

	-- Hyprpicker: a color picker
	hl.bind("P", function()
		hl.dsp.exec_cmd(color_picker)
		hl.dsp.submap("reset")
	end)

	-- Impala: A wifi viewer
	hl.bind("N", function()
		hl.dsp.exec_cmd(terminal_float .. "impala")
		hl.dsp.submap("reset")
	end)

	-- Btop: A task manager
	hl.bind("T", function()
		hl.dsp.exec_cmd(terminal_float .. "btop")
		hl.dsp.submap("reset")
	end)

	-- Bluetooth Manager
	hl.bind("B", function()
		hl.dsp.exec_cmd(terminal_float .. "bluetui")
		hl.dsp.submap("reset")
	end)

	-- Use `reset` to go back to the global submap
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Rofi Menu
hl.bind(main_mod .. " + R", hl.dsp.submap("rofi_menu"))

hl.define_submap("rofi_menu", function()
	-- Waybar Position
	hl.bind("P", function()
		hl.dsp.exec_cmd(script_dir .. "/waybar-position.sh")
		hl.dsp.submap("reset")
	end)

	-- Change wallpaper
	hl.bind("W", function()
		hl.dsp.exec_cmd(script_dir .. "/wallpaper-switcher.sh")
		hl.dsp.submap("reset")
	end)

	-- Change Theme
	hl.bind("T", function()
		hl.dsp.exec_cmd(script_dir .. "/theme-switcher.sh")
		hl.dsp.submap("reset")
	end)

	-- Layout Switcher
	hl.bind("L", function()
		hl.dsp.exec_cmd(script_dir .. "/layout-switcher.sh")
		hl.dsp.submap("reset")
	end)

	-- Kitty Sessionizer
	hl.bind("S", function()
		hl.dsp.exec_cmd(script_dir .. "/kitty-sessionizer.sh")
		hl.dsp.submap("reset")
	end)

	-- Use `reset` to go back to the global submap
	hl.bind("escape", hl.dsp.submap("reset"))
end)
