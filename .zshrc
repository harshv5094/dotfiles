#######################################################
# Z shell Setup
#######################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # If you're using macOS, you'll want this enabled
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
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
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::nvm
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Install Macos Plugin if macos is present
if [[ "$OSTYPE" == "darwin"* ]]; then
  zinit snippet OMZP::macos
fi

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


function have() {
  command -v "$1" >/dev/null 2>&1
}

#######################################################
# EXPORTS
#######################################################
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%F %T " # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=ignoredups:erasedups:ignorespaces:ignoreboth

# Adding doom emacs export path
export PATH="$PATH:$HOME/.config/emacs/bin"

# Adding home binary path
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.bun/bin:$PATH"


# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Setting editor variables to nvim
if have nvim; then
  export EDITOR=nvim
  export VISUAL=nvim
fi

# Set up fzf key bindings and fuzzy completion
if have fzf; then
  eval "$(fzf --zsh)"
fi

# Initialize zoxide
if have zoxide; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# Initialize Starship prompt theme
if have starship; then
  eval "$(starship init zsh)"
fi

#######################################################
# Aliases
#######################################################
# Basic Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if have eza; then
    alias ll="eza -l -g --icons --header"
    alias lla="eza -l -g -a --icons --header"
fi

if have lazygit; then
  alias lg="lazygit"
fi

if have bat; then
  alias os-info="bat /etc/os-release"
fi

#######################################################
# NVM_DIR
#######################################################
if have nvm; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
