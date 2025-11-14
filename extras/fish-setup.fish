#!/usr/bin/fish

set CONFIG_PATH ~/.config/fish
set BASE_DIR $HOME/dotfiles/.config/fish

if test -d "$CONFIG_PATH"
    echo "Removing Existing Config Files for fish"
    rm -rf "$CONFIG_PATH"
    echo "Making Necessary Directories for fish"
    mkdir "$CONFIG_PATH/"
    mkdir "$CONFIG_PATH/functions/"
    mkdir "$CONFIG_PATH/completions/"
    mkdir "$CONFIG_PATH/themes/"
end

echo "Copying files to config path"
ln -s "$BASE_DIR/config.fish" "$CONFIG_PATH"
ln -s "$BASE_DIR/fish_variables" "$CONFIG_PATH"
ln -s "$BASE_DIR/functions/fish_prompt.fish" "$CONFIG_PATH/functions/"
ln -s "$BASE_DIR/completions/gh.fish" "$CONFIG_PATH/completions/"
ln -s "$BASE_DIR/themes/gruvbox_dark.theme" "$CONFIG_PATH/themes/"

echo "Installing fisher..."
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
echo "fisher installed successfully."
cp -rf $BASE_DIR/fish_plugins "$CONFIG_PATH"
fish -c "fisher update"
