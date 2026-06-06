hl.config({
	-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

	-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
	general = {
		gaps_in = 5,
		gaps_out = 6,
		border_size = 2,
		locale = "en_IN",

		-- https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for moreS
	scrolling = {
		column_width = 0.8,
		fullscreen_on_one_column = true,
		focus_fit_method = 1,
		direction = "right",
	},

	-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
	dwindle = {
		preserve_split = true, -- You probably want this
		smart_split = false, -- I don't know when I'll need this but keeping it
	},

	-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
	master = {
		new_status = "inherit",
		orientation = "right",
		drop_at_cursor = true,
	},
})
