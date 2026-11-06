-- See https://wiki.hypr.land/Configuring/Keywords/

-- Default Settings Variables
_G.terminal = "kitty"
_G.terminal_float = "kitty --title float -e"
_G.file_manager = "thunar"
_G.menu = "killall rofi || rofi -show drun -location 0"
_G.screenshotarea =
	'hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"'
_G.color_picker = "hyprpicker -a -n"

-- Extra variables
_G.script_dir = "~/.config/hypr/scripts"
_G.polkit = "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"

-- Mod Keys
_G.main_mod = "SUPER"
_G.shift_mod = "SUPER + SHIFT"
_G.ctrl_mod = "SUPER + CTRL"

-- Theme Variables
_G.cursor_theme = "Adwaita"
_G.cursor_size = 24

-- Custom variables
_G.hyprpaper = "killall hyprpaper && hyprctl dispatch 'hl.dsp.exec_cmd(\"hyprpaper\")'"
_G.calculator = "killall gnome-calculator || hyprctl dispatch 'hl.dsp.exec_cmd(\"gnome-calculator\")'"
_G.waybar = "killall waybar && hyprctl dispatch 'hl.dsp.exec_cmd(\"waybar\")'"
_G.emoji = "killall gnome-characters || hyprctl dispatch 'hl.dsp.exec_cmd(\"gnome-characters\")'"
_G.browser = "gtk-launch $(xdg-settings get default-web-browser)"
