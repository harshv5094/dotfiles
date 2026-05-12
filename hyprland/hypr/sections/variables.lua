-- See https://wiki.hypr.land/Configuring/Keywords/

-- Default Settings Variables
terminal = "kitty"
terminal_float = "kitty --title float -e"
file_manager = "thunar"
menu = "killall rofi || rofi -show drun -location 0"
screenshotarea =
	'hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"'
color_picker = "hyprpicker -a -n"

-- Extra variables
script_dir = "~/.config/hypr/scripts"

-- Main Mod Key
main_mod = "SUPER"
shift_mod = "SUPER + SHIFT"
ctrl_mod = "SUPER + CTRL"

-- Theme Variables
cursor_theme = "Adwaita"
cursor_size = 24

-- Custom variables
hyprpaper = "killall hyprpaper && hyprctl dispatch 'hl.dsp.exec_cmd(\"hyprpaper\")'"
calculator = "killall gnome-calculator || hyprctl dispatch 'hl.dsp.exec_cmd(\"gnome-calculator\")'"
waybar = "killall waybar && hyprctl dispatch 'hl.dsp.exec_cmd(\"waybar\")'"
emoji = "killall gnome-characters || hyprctl dispatch 'hl.dsp.exec_cmd(\"gnome-characters\")'"
browser = "gtk-launch $(xdg-settings get default-web-browser)"
