local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
	-- Tabs
	{ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "q", mods = "ALT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "[", mods = "ALT|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "ALT|SHIFT", action = act.ActivateTabRelative(1) },

	-- Tab navigation: alt+1..9 -> tabs 1-9, alt+0 -> tab 10
	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = act.ActivateTab(8) },
	{ key = "0", mods = "ALT", action = act.ActivateTab(9) },

	-- Panes
	{ key = "-", mods = "ALT|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "ALT|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Down") },
	{ key = "z", mods = "ALT|SHIFT", action = act.TogglePaneZoomState },
	{ key = "x", mods = "ALT|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },

	-- Clipboard
	{ key = "c", mods = "ALT|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "ALT|SHIFT", action = act.PasteFrom("Clipboard") },

	-- Font size
	{ key = "=", mods = "ALT", action = act.IncreaseFontSize },
	{ key = "-", mods = "ALT", action = act.DecreaseFontSize },
	{ key = "0", mods = "ALT", action = act.ResetFontSize },

	-- Search
	{ key = "f", mods = "ALT|SHIFT", action = act.Search({ CaseSensitiveString = "" }) },

	-- Debugging
	{ key = "d", mods = "ALT|SHIFT", action = act.ShowDebugOverlay },
}

return keys
