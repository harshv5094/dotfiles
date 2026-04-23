# History settings
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%F %T " # add timestamp to history

# Zsh specific history options
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_find_no_dups

# Setting fzf default options
export FZF_DEFAULT_OPTS="--reverse --border --bind 'alt-j:down,alt-k:up' --ansi"

# Adding home binary path
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.config/emacs/bin:$HOME/.cargo/bin:$PATH"

# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# If user is mac
if [[ "$OSTYPE" == "darwin"* && -x "/opt/homebrew/bin/brew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
[[ "$OSTYPE" == "darwin"* ]] && zinit snippet OMZP::macos

autoload -Uz compinit && compinit
zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Open buffer line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Bind Magic space command
bindkey " " magic-space

# Basic Aliases
alias ls="ls -F --color=auto"
alias la='ls -AF --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias check-gpu-id='lspci | grep -E "VGA|3D" && echo -e "\nPath: /dev/dri/by-path/" && ls -l /dev/dri/by-path '

# QOL Aliases
AUR_HELPER="$(command -v paru || command -v yay)"
if [[ -n "$AUR_HELPER" ]]; then
  # Install packages interactively
  pri() {
    pkgs=$($AUR_HELPER -Slq | fzf --border-label "** Install Packages ($AUR_HELPER) **" \
      --multi \
      --preview "${AUR_HELPER} -Sii {1}" \
      --preview-window=right:60%)

    # Only run if the string is not empty
    if [[ -n "$pkgs" ]]; then
      echo "$pkgs" | xargs -ro "$AUR_HELPER" -S
    else
      echo "No packages selected. Exiting..."
    fi
  }

  # Remove packages interactively
  pru() {
    pkgs=$($AUR_HELPER -Qq | fzf --border-label "** Remove Packages ($AUR_HELPER) **" \
      --multi \
      --preview "${AUR_HELPER} -Qii {1}" \
      --preview-window=right:60%)

    # Only run if the string is not empty
    if [[ -n "$pkgs" ]]; then
      echo "$pkgs" | xargs -ro "$AUR_HELPER" -Rns
    else
      echo "No packages selected. Exiting...."
    fi
  }
fi

# Alias for quickly listening a single song
listen() {
  local file
  if command -v kitten &>/dev/null; then
    file=$(kitten choose-files ~/Music)
  else
    file=$(find ~/Music -iname "*.mp3" | fzf --border-label "** Select Song **")
  fi

  if [[ -n "$file" ]]; then
    play "$file"
  else
    echo "No file selected. Exiting...."
  fi
}

if command -v pacman &>/dev/null; then
  alias unlock='sudo rm /var/lib/pacman/db.lck'
  alias orphan='sudo pacman -Rns $(pacman -Qtdq)'
fi

command -v trash &>/dev/null && alias del="trash -v"
command -v fastfetch &>/dev/null && alias neofetch="fastfetch -c examples/13"
command -v eza &>/dev/null && alias ll="eza -l -g --icons" && alias lla="eza -l -g -a --icons"
command -v lazygit &>/dev/null && alias lg="lazygit"

# Changing default editor also setting up default man pager
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  export VISUAL=nvim
  export MANPAGER="nvim +Man!"

  # My custom nvim config
  [[ -d $HOME/.config/mnvim/ ]] && alias mnvim="NVIM_APPNAME=mnvim nvim"
fi

command -v fzf &>/dev/null && eval "$(fzf --zsh)"
command -v gh &>/dev/null && eval "$(gh completion -s zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd=cd zsh)"

# Initialize Starship prompt theme
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else
  # A simple fallback prompt
  PROMPT='%F{blue}%n@%m%f:%F{green}%~%f$ '
fi

# My dotfiles directory set as env variable
[[ -d "$HOME/dotfiles/" ]] && export DOTFILES="$HOME/dotfiles"

# NVM Directory
[[ -d "$HOME/.config/nvm" ]] && export NVM_DIR="$HOME/.config/nvm"
[[ ! -f "$NVM_DIR/default-packages" ]] && printf "%b" "commitizen\ncz-git" | tee "$NVM_DIR/default-packages" &>/dev/null
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" # This loads nvm
