-- colors/gruvbox.lua
-- Gruvbox Dark palette for WezTerm.
-- Returns a table assignable directly to `config.colors`.

-- Change to "hard", "medium", or "soft" to adjust background contrast
local contrast = "medium"

local bg = {
	hard = "#1d2021",
	medium = "#282828",
	soft = "#32302f",
}

local colors = {
	foreground = "#ebdbb2",
	background = bg[contrast],

	cursor_bg = "#ebdbb2",
	cursor_fg = bg[contrast],
	cursor_border = "#ebdbb2",

	selection_fg = bg[contrast],
	selection_bg = "#665c54",

	scrollbar_thumb = "#504945",
	split = "#665c54",

	ansi = {
		"#282828", -- black
		"#cc241d", -- red
		"#98971a", -- green
		"#d79921", -- yellow
		"#458588", -- blue
		"#b16286", -- purple
		"#689d6a", -- aqua
		"#a89984", -- white
	},
	brights = {
		"#928374", -- bright black
		"#fb4934", -- bright red
		"#b8bb26", -- bright green
		"#fabd2f", -- bright yellow
		"#83a598", -- bright blue
		"#d3869b", -- bright purple
		"#8ec07c", -- bright aqua
		"#ebdbb2", -- bright white
	},

	tab_bar = {
		background = bg[contrast],
		active_tab = {
			bg_color = "#504945",
			fg_color = "#fabd2f",
		},
		inactive_tab = {
			bg_color = bg[contrast],
			fg_color = "#a89984",
		},
		inactive_tab_hover = {
			bg_color = "#3c3836",
			fg_color = "#ebdbb2",
		},
		new_tab = {
			bg_color = bg[contrast],
			fg_color = "#a89984",
		},
		new_tab_hover = {
			bg_color = "#3c3836",
			fg_color = "#ebdbb2",
		},
	},
}

return colors
