#!/usr/bin/env bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

if ! grep -q -A3 "NVM_DIR" ~/.bashrc; then
  cat <<EOF | tee -a "$HOME/.bashrc"
[[ -d "$HOME/.config/nvm" ]] && export NVM_DIR="$HOME/.config/nvm"
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" # This loads nvm
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
EOF
fi

if [[ ! -f "$HOME/.config/nvm/default-packages" ]]; then
  cat <<EOF | tee -a "$HOME/.config/nvm/default-packages"
commitizen
cz-git
EOF
fi
