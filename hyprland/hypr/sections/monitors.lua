-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- Laptop lid switch
-- See https://wiki.hypr.land/Configuring/Basics/Binds/#switches
hl.bind("switch:on:Lid Switch", function()
	hl.dsp.exec_cmd(hl.dsp.dpms({ action = "disable" }))
	hl.dsp.exec_cmd("hyprlock")
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	hl.dsp.exec_cmd(hl.dsp.dpms({ action = "enable" }))
end, { locked = true })
