-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Float center for small applications
hl.window_rule({
	name = "float_menu",
	match = {
		class = "^(nwg-look|timeshift-gtk|xdg-desktop-portal-gtk|com.github.hluk.copyq|org.pulseaudio.pavucontrol|net.davidotek.pupgui2|xarchiver)$",
	},

	float = true,
	center = true,
	animation = "popin",
})

-- Kitty terminal float
hl.window_rule({
	name = "kitty_float",
	match = {
		class = "^(kitty)$",
		title = "^(float)$",
	},

	float = true,
	center = true,
	size = { 900, 700 },
	animation = "popin",
})

-- Float center for all gnome apps
hl.window_rule({
	name = "float_popup_for_gnome",
	match = {
		class = "^(.*org.gnome.*)$",
	},

	float = true,
	center = true,
	animation = "popin",
})

-- Float exception for gnome
hl.window_rule({
	name = "float_exception_for_gnome",
	match = {
		class = "^(org.gnome.Evince)$",
	},
	tile = true,
})

-- Thunar popup dialogues
hl.window_rule({
	name = "thunar_popup_dialogues",
	match = {
		class = "^(thunar|Thunar)$",
		title = "^(.*(File|Rename).*)$",
	},
	float = true,
	center = true,
	animation = "popin",
})

-- VlC file popups
hl.window_rule({
	name = "vlc_file_popups",
	match = {
		class = "^(vlc|VLC|Vlc)$",
		title = "^(.*(Open|open).*)$",
	},
	float = true,
	center = true,
	animation = "popin",
})

-- Chromium popup dialogues
hl.window_rule({
	name = "chromium_popup_dialogues",
	match = {
		class = "^(chromium)$",
		title = "^(Open|Save) File",
	},

	float = true,
	center = true,
	animation = "popin",
})
