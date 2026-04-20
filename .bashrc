# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash Completion Check
# shellcheck disable=SC1091
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
# shellcheck disable=SC1091
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Adding home binary path
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.config/emacs/bin:$PATH"

# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Setting up history export
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%F %T " # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Save each command history for different terminals
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# Default fzf options
export FZF_DEFAULT_OPTS="--reverse --border --bind 'alt-j:down,alt-k:up' --ansi"

# Bash shell options
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s histappend     # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control

# Basic Aliases
alias ls="ls -F --color=auto"
alias la='ls -AF --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
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

if command -v kitten &>/dev/null; then
  listen() {
    file=$(kitten choose-files ~/Music)
    if [[ -n "$file" ]]; then
      play "$file"
    else
      echo "No file selected. Exiting...."
    fi
  }

  view() {
    file=$(kitten choose-files)
    if [[ -n "$file" ]]; then
      kitten icat "$file"
    else
      echo "No file selected. Exiting...."
    fi
  }
fi

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
  [[ -d "$HOME/.config/mnvim/" ]] && alias mnvim="NVIM_APPNAME=mnvim nvim"
fi

# My tools initialization
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
else
  PS1='[\u@\h \W]\$ '
fi

command -v fzf &>/dev/null && eval "$(fzf --bash)"
command -v gh &>/dev/null && eval "$(gh completion -s bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd=cd bash)"

[[ -d "$HOME/.config/nvm" ]] && export NVM_DIR="$HOME/.config/nvm"
[[ ! -f "$NVM_DIR/default-packages" ]] && printf "%b" "commitizen\ncz-git" | tee "$NVM_DIR/default-packages" &>/dev/null
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" # This loads nvm
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
