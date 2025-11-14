# append to the history file, don't overwrite it
shopt -s histappend

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

# Changing default editor
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  export VISUAL=nvim
fi

#######################################################
# Eval / Initializations
#######################################################

# Bash Completion Check
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# Initialize zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd bash)"
fi

# Initialize Starship prompt theme
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi

# Set up fzf key bindings and fuzzy completion
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
fi

# Initialize GitHub CLI completion
if command -v gh &>/dev/null; then
  eval "$(gh completion -s bash)"
fi

#######################################################
# Aliases
#######################################################
# Basic Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

function have() {
  command -v "$1" >/dev/null 2>&1
}

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
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi
