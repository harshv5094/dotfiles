-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
	decoration = {
		rounding = 8,
		rounding_power = 2,

		active_opacity = 1,
		inactive_opacity = 1,

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#shadow
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			new_optimizations = true,
			vibrancy = 0,
			vibrancy_darkness = 0.38,
		},
	},
})

hl.config({
	-- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true,
		-- Wake up with key/mouse activity:
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},

	-- https://wiki.hypr.land/Configuring/Basics/Variables/#xwayland
	xwayland = {
		enabled = true,
		force_zero_scaling = true,
	},
})
