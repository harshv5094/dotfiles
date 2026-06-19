local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- Keybinds
config.keys = require("sections.keybinds")

-- Colors
config.colors = require("sections.gruvbox")

-- Fonts
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0

-- Windows
config.window_background_opacity = 1.0
config.enable_tab_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

return config
