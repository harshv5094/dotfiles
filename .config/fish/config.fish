########################################
# Exports
########################################
set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.bun/bin $PATH
set -gx PATH ~/.config/emacs/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# XDG PATHS
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0

########################################
# Eval / Initlaization
########################################

# Starship prompt
if type -q starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience
end

# Check for nvm to exist
if type -q nvm
    # if nvm exist then check for nvmrc
    if test -e ~/.nvmrc
        nvm --silent use
    else
        nvm install lts
        echo lts >>~/.nvmrc
    end
    set --universal nvm_default_packages commitizen cz-git yarn bun
end

# Changing zoxide 'z' alias to cd
if type -q zoxide
    zoxide init --cmd cd fish | source
end

########################################
# Aliases
########################################

alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"

if type -q eza
    alias ll="eza -l -g --icons --header"
    alias lla="eza -l -g -a --icons --header"
end

if type -q lazygit
    alias lg="lazygit"
end

if type -q bat
    alias os-info="bat /etc/os-release"
end
