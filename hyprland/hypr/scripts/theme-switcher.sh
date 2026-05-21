#!/usr/bin/env bash

# Switches themes for various applications based on user selection from rofi.

# --- Configuration ---
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
HYPR_THEMES_DIR="$XDG_CONFIG_HOME/themes"

declare -A TARGETS=(
  ["kitty.conf"]="$XDG_CONFIG_HOME/kitty/current-theme.conf"
  ["mako.ini"]="$XDG_CONFIG_HOME/mako/config"
  ["waybar.css"]="$XDG_CONFIG_HOME/waybar/colors.css"
  ["neovim.lua"]="$XDG_CONFIG_HOME/nvim/lua/plugins/colorscheme.lua"
  ["rofi.rasi"]="$XDG_CONFIG_HOME/rofi/colors.rasi"
  ["rmpc.ron"]="$XDG_CONFIG_HOME/rmpc/themes/default.ron"
  ["lazygit.yml"]="$XDG_CONFIG_HOME/lazygit/config.yml"
  ["btop.theme"]="$XDG_CONFIG_HOME/btop/themes/current.theme"
)

# --- Functions ---

# Presents a theme selection menu using rofi.
select_theme() {
  options=$(find "$HYPR_THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
  printf "%s" "$options" |
    rofi -dmenu -i -p " " -location 0 \
      -theme-str 'window { width: 200px; }
                  listview { columns: 1; lines: 2; spacing: 10px; }
                  element { orientation: vertical; }
                  element-icon { size: 250px; }
                  element-text { horizontal-align: 0.5; }'
}

# Copies theme files to their respective target directories.
apply_theme_files() {
  theme=$1
  for file in "${!TARGETS[@]}"; do
    source_file="$HYPR_THEMES_DIR/$theme/$file"
    target_file="${TARGETS[$file]}"
    [ -f "$source_file" ] && cp -f "$source_file" "$target_file"
  done
}

# Updates the Starship prompt theme.
update_starship() {
  theme=$1
  config_file="$HOME/dotfiles/.config/starship.toml"
  if command -v starship &>/dev/null && [ -f "$config_file" ]; then
    sed -i "s/palette = '.*'/palette = '${theme//-/_}'/" "$config_file"
  fi
}

# Updates GTK and icon themes.
update_gtk() {
  if command -v gsettings &>/dev/null; then
    # shellcheck disable=SC2154
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
    # shellcheck disable=SC2154
    gsettings set org.gnome.desktop.interface color-scheme "$gtk_color_scheme"
    # shellcheck disable=SC2154
    gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"
  fi

  # Link GTK4 assets
  gtk_theme_dir="$HOME/.themes/$gtk_theme"
  gtk4_config_dir="$XDG_CONFIG_HOME/gtk-4.0"
  if [ -d "$gtk_theme_dir/gtk-4.0" ]; then
    mkdir -p "$gtk4_config_dir"
    ln -sf "$gtk_theme_dir/gtk-4.0/assets" "$gtk4_config_dir/assets"
    ln -sf "$gtk_theme_dir/gtk-4.0/gtk.css" "$gtk4_config_dir/gtk.css"
    ln -sf "$gtk_theme_dir/gtk-4.0/gtk-dark.css" "$gtk4_config_dir/gtk-dark.css"
    if [ -f "$gtk4_config_dir/settings.ini" ]; then
      sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" "$gtk4_config_dir/settings.ini"
      sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon_theme/" "$gtk4_config_dir/settings.ini"
    fi
  fi

  # Update GTK3 settings
  gtk3_config_dir="$XDG_CONFIG_HOME/gtk-3.0"
  if [ -d "$gtk3_config_dir" ] && [ -f "$gtk3_config_dir/settings.ini" ]; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" "$gtk3_config_dir/settings.ini"
    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon_theme/" "$gtk3_config_dir/settings.ini"
  fi
}

# Overrides the Flatpak theme.
update_flatpak() {
  if command -v flatpak &>/dev/null; then
    # shellcheck disable=SC2154
    flatpak override --user --env=GTK_THEME="$gtk_theme" --env=ICON_THEME="$icon_theme" \
      --filesystem=xdg-config/gtk-3.0 --filesystem=xdg-config/gtk-4.0 \
      --filesystem=~/.themes --filesystem=~/.icons
  fi
}

# Updates the Visual Studio Code theme.
update_vscode() {
  # shellcheck disable=SC2154
  if command -v code &>/dev/null && [ -n "$vscode_extension" ]; then
    settings_file="$XDG_CONFIG_HOME/Code/User/settings.json"
    if ! code --list-extensions | grep -q "$vscode_extension"; then
      code --install-extension "$vscode_extension"
    fi
    sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$vscode_theme\"/" "$settings_file"
  fi
}

# Updates QT5 and QT6 themes.
update_qt() {
  qt5_conf="$XDG_CONFIG_HOME/qt5ct/qt5ct.conf"
  # shellcheck disable=SC2154
  if [ -f "$qt5_conf" ]; then
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" "$qt5_conf"
    sed -i "s|color_scheme_path=.*|color_scheme_path=/usr/share/qt5ct/colors/$qt_color.conf|" "$qt5_conf"
  fi

  # shellcheck disable=SC2154
  qt6_conf="$XDG_CONFIG_HOME/qt6ct/qt6ct.conf"
  if [ -f "$qt6_conf" ]; then
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" "$qt6_conf"
    sed -i "s|color_scheme_path=.*|color_scheme_path=/usr/share/qt6ct/colors/$qt_color.conf|" "$qt6_conf"
  fi
}

# Updates the bat (cat clone) theme.
update_bat() {
  # shellcheck disable=SC2154
  if command -v bat &>/dev/null && [ -f "$XDG_CONFIG_HOME/bat/config" ] && [ -n "$bat_theme" ]; then
    sed -i "s/--theme=.*/--theme=\"$bat_theme\"/" "$HOME/dotfiles/.config/bat/config"
    bat cache --build &>/dev/null
  fi
}

# Sets a random wallpaper from the theme's directory.
update_wallpaper() {
  theme=$1
  wallpaper_dir="$HOME/Pictures/wallpapers/$theme/"

  # Export wallpaper directory for other scripts/processes.
  echo "export CURRENT_THEME_BG=\"$wallpaper_dir\"" >~/.cache/current_theme_env
  export CURRENT_THEME_BG="$wallpaper_dir"

  if [ ! -d "$wallpaper_dir" ]; then
    command -v notify-send &>/dev/null && notify-send "Wallpaper Error" "Directory not found: $wallpaper_dir"
    return
  fi

  wallpaper=$(find "$wallpaper_dir" -type f \( -iname \*.png -o -iname \*.jpg -o -iname \*.jpeg -o -iname \*.webp \) | shuf -n1)

  if [ -z "$wallpaper" ]; then
    command -v notify-send &>/dev/null && notify-send "Wallpaper Error" "No wallpaper images found in $wallpaper_dir"
    return
  fi

  # Set wallpaper using hyprctl and hyprpaper
  killall hyprpaper
  printf "%b\n" "splash = false" >~/.config/hypr/hyprpaper.conf
  printf "%b\n" "ipc = true" >>~/.config/hypr/hyprpaper.conf

  # monitors=$(hyprctl monitors -j | jq -r ".[] | .name")
  # for monitor in $monitors; do
  #   printf "%b" "wallpaper {
  #   monitor = $monitor
  #   path = $wallpaper
  #   fit_mode=cover
  # }" >>~/.config/hypr/hyprpaper.conf
  # done

  printf "%b" "wallpaper {
    monitor =
    path = $wallpaper
    fit_mode=cover
}" >>~/.config/hypr/hyprpaper.conf

  # Update hyprlock background
  printf "%b" "# BACKGROUND
background {
    blur_size = 3
    blur_passes = 2
    contrast = 1
    brightness = 0.5
    vibrancy = 0.2
    vibrancy_darkness = 0.2
    path = $wallpaper
}" >"$XDG_CONFIG_HOME/hypr/sections/lock-background.conf"

  hyprctl dispatch 'hl.dsp.exec_cmd("hyprpaper")'
}

# Updates the Emacs theme.
update_emacs() {
  # shellcheck disable=SC2154
  if command -v emacs &>/dev/null; then
    if [ -n "$emacs_theme" ]; then
      config_org_file="$XDG_CONFIG_HOME/doom/config.org"
      config_lisp_file="$XDG_CONFIG_HOME/doom/config.el"
      [ -f "$config_org_file" ] && sed -i "s/(setq doom-theme '.*)/(setq doom-theme '$emacs_theme)/" "$config_org_file"
      [ -f "$config_lisp_file" ] && sed -i "s/(setq doom-theme '.*)/(setq doom-theme '$emacs_theme)/" "$config_lisp_file"

      if command -v emacsclient &>/dev/null && pgrep -x "emacs" &>/dev/null; then
        emacsclient -e "(progn (mapc #'disable-theme custom-enabled-themes) (load-theme '$emacs_theme t) (doom/reload-theme))" &>/dev/null
      fi
    fi
  fi
}

# Reloads services to apply theme changes.
reload_services() {
  command -v makoctl &>/dev/null && makoctl reload
  pgrep -x kitty &>/dev/null && kill -SIGUSR1 "$(pgrep -x kitty)"
}

# --- Main ---
main() {
  choice=$(select_theme)

  if [[ -z "$choice" ]]; then
    exit 0
  fi

  # shellcheck source=/dev/null
  source "$HYPR_THEMES_DIR/$choice/variable.sh"

  apply_theme_files "$choice"
  update_starship "$choice"
  update_gtk
  update_flatpak
  update_qt
  update_vscode
  update_bat
  update_wallpaper "$choice"
  update_emacs

  reload_services
  command -v notify-send >/dev/null && notify-send "Theme Applied" "Switched to $choice"
}

main "$@"
