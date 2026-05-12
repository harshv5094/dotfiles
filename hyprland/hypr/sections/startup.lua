-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	-- Import environment and dbus-update-activation-environment
	-- hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	-- hl.exec_cmd("dbus-update-activation-environment --systemd --all")

	-- Enable mate-polkit
	hl.exec_cmd("/usr/lib/mate-polkit/polkit-mate-authentication-agent-1")

	-- Starting necessary desktop programs at startup
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("mako")
	hl.exec_cmd("copyq --start-server")

	-- Start Gnome Keyring Daemon
	hl.exec_cmd("gnome-keyring-daemon --start")
end)
