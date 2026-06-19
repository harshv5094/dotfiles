local wezterm = require("wezterm")
local config = wezterm.config_builder()
local padding_size = 2

if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- Keybinds
config.disable_default_key_bindings = true
config.keys = require("sections.keybinds")

-- Colors
config.colors = require("sections.colors")

-- Fonts
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0

-- Windows
config.window_background_opacity = 1.0
config.enable_tab_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
	left = padding_size,
	right = padding_size,
	top = padding_size,
	bottom = padding_size,
}

return config
