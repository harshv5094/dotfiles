-- ~/.config/wezterm/keybinds.lua
local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
	{ key = "Enter", mods = "ALT|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "ALT|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "T", mods = "ALT|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "W", mods = "ALT|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "=", mods = "ALT|SHIFT", action = act.IncreaseFontSize },
	{ key = "-", mods = "ALT|SHIFT", action = act.DecreaseFontSize },
}

return keys
