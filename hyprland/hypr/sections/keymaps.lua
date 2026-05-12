-- unbinding default keymaps
-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more
-- # Basic Navigation Keymaps #
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(main_mod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(shift_mod .. " + SPACE", hl.dsp.layout("togglesplit"))
hl.bind(ctrl_mod .. " + SPACE", hl.dsp.layout("swapsplit")) -- dwindle

-- Move focus (Vim Keys)
hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move focus (Arrow Keys)
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Swap windows (Vim keys)
hl.bind(shift_mod .. " + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(shift_mod .. " + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(shift_mod .. " + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(shift_mod .. " + j", hl.dsp.window.move({ direction = "down" }))

-- Swap windows (Arrow keys)
hl.bind(shift_mod .. " + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(shift_mod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(shift_mod .. " + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(shift_mod .. " + down", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- special workspace (scratchpad)
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Scroll through existing workspaces with main_mod + page_up/page_down
hl.bind(main_mod .. " + page_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + page_up", hl.dsp.focus({ workspace = "e-1" }))

-- Scroll through existing workspaces with main_mod + alt/alt_shift + tab
hl.bind(main_mod .. " + page_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + page_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("ALT" .. " + tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("ALT + SHIFT" .. " + tab", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- # Multimedia Controls #
-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Multimedia Keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Multimedia keys (using fn)
hl.bind(main_mod .. " + f10", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(main_mod .. " + f11", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(main_mod .. " + f12", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- # Misc Kyes #

-- Terminal
hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))

-- Kill active window
hl.bind(shift_mod .. " + Q", hl.dsp.window.close())

-- Power menu keybindings
hl.bind(shift_mod .. " + E", hl.dsp.exec_cmd(script_dir .. "/power-menu.sh"))

-- File Manager
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd(file_manager))

-- Default web browser
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(browser))

-- Hyprlock keybindings
hl.bind(main_mod .. " + x", hl.dsp.exec_cmd("hyprlock"))

-- Toggle smart gaps
hl.bind(main_mod .. " + G", hl.dsp.exec_cmd(script_dir .. "/toggle-smart-gaps.sh"))

-- Hyprpaper killswitch
hl.bind(shift_mod .. " + W", hl.dsp.exec_cmd(hyprpaper))

-- Toggle clipboard
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd("copyq toggle"))

-- Screenshot
hl.bind(shift_mod .. " + T", hl.dsp.exec_cmd(screenshotarea))
hl.bind("Print", hl.dsp.exec_cmd("grimblast --notify --cursor copysave output"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("grimblast --notify --cursor copysave screen"))
