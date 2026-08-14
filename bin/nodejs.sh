#!/usr/bin/env bash

# -- Node JS Banner -- #
cat <<'EOF'
 _   _           _          ___ _____   _____          _        _ _       _   _             
| \ | |         | |        |_  /  ___| |_   _|        | |      | | |     | | (_)            
|  \| | ___   __| | ___      | \ `--.    | | _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __  
| . ` |/ _ \ / _` |/ _ \     | |`--. \   | || '_ \/ __| __/ _` | | |/ _` | __| |/ _ \| '_ \ 
| |\  | (_) | (_| |  __/ /\__/ /\__/ /  _| || | | \__ \ || (_| | | | (_| | |_| | (_) | | | |
\_| \_/\___/ \__,_|\___| \____/\____/   \___/_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_|
                                                                                            
                                                                                            
EOF

# -- Running installation script -- #
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# -- Checking bashrc for nvm variables and paths -- #
if ! grep -q -A3 "NVM_DIR" ~/.bashrc; then
  cat <<EOF | tee -a "$HOME/.bashrc"
[[ -d "$HOME/.config/nvm" ]] && export NVM_DIR="$HOME/.config/nvm"
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" # This loads nvm
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
EOF
fi

# -- Checking zshrc for nvm variables and paths -- #
if ! grep -q -A3 "NVM_DIR" ~/.zshrc; then
  cat <<EOF | tee -a "$HOME/.zshrc"
[[ -d "$HOME/.config/nvm" ]] && export NVM_DIR="$HOME/.config/nvm"
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" # This loads nvm
# shellcheck disable=SC1091
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
EOF
fi

## -- Adding default package for nvm -- #
if [[ ! -f "$HOME/.config/nvm/default-packages" ]]; then
  cat <<EOF | tee -a "$HOME/.config/nvm/default-packages"
commitizen
cz-git
EOF
fi
