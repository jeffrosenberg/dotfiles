#!/usr/bin/env bash

########################################
# Set up configuration files and folders
########################################

export DOTFILES="$HOME/dotfiles" # environment variable for my personal dotfiles
export LOCALCONFIG="$HOME/local-config"
export DOTFILESTOLOAD="$LOCALCONFIG/.dotfilestoload" # list of dotfiles modules to load

# Local config files
mkdir -p "$LOCALCONFIG"
if [[ ! -f $LOCALCONFIG/.dotfilestoload ]]; then
  echo "Copying default .dotfilestoload file"
  cp "$DOTFILES/local.dotfilestoload" "$LOCALCONFIG/.dotfilestoload"
fi
if [[ ! -f $LOCALCONFIG/local.profile ]]; then
  echo "Copying default local.profile file"
  cp "$DOTFILES/Bash/local.profile" "$LOCALCONFIG/local.profile"
fi
if [[ ! -f $LOCALCONFIG/local.bashrc ]]; then
  echo "Copying default local.bashrc file"
  cp "$DOTFILES/Bash/local.bashrc" "$LOCALCONFIG/local.bashrc"
fi

# Main config files
if [[ ! -f $HOME/.profile.bak ]]; then
  echo "Copying .profile file"
  mv "$HOME/.profile" "$HOME/.profile.bak"
  cp "$DOTFILES/Bash/main.profile" "$HOME/.profile"
fi
if [[ ! -f $HOME/.bash_profile.bak ]]; then
  echo "Copying .bash_profile file"
  mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
  cp "$DOTFILES/Bash/main.bash_profile" "$HOME/.bash_profile"
fi
if [[ ! -f $HOME/.bashrc.bak ]]; then
  echo "Copying .bashrc file"
  mv "$HOME/.bashrc" "$HOME/.bashrc.bak"
  cp "$DOTFILES/Bash/main.bashrc" "$HOME/.bashrc"
fi

# Determine dotfiles modules to load
dotfiles_include() {
  # Expects one argument -- module name    
  matches=$(grep -cix "$1" "$DOTFILESTOLOAD") # Count the number of times module name appears
  [[ $matches -ge 1 ]] # Return success if it appears at least once
}

########################################
# Set macOS preferences
# https://macos-defaults.com
########################################

# Dock
defaults write com.apple.dock autohide -boolean true
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.25
defaults write com.apple.dock expose-animation-duration -float 0.05
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false
killall Dock

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
killall Finder

########################################
# Install Homebrew
########################################

if ! which brew; then
  # NOTE: This may throw a warning saying it's deprecated, but as of Jan 2022,
  # the updated version throws Bash syntax errors when running on macOS's version of Bash.
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

########################################
# Install Homebrew packages
########################################

brew bundle || true

# Update python with the latest python 3 version:
# https://opensource.com/article/19/5/python-3-default-mac
# https://github.com/pyenv/pyenv/pull/1831
pyenv install 3:latest

if dotfiles_include "java"; then
  brew tap AdoptOpenJDK/openjdk || true
  brew cask install adoptopenjdk8 adoptopenjdk11 || true
  brew install jenv && \
    eval "$(jenv init -)" && \
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/ && \
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/ && \
    jenv global 11.0 || true  
fi

if dotfiles_include "maven"; then
  brew install maven || true
fi

if dotfiles_include "bash"; then # Bash development... Bash itself it always needed
  brew install bats-core gnu-getopt || true
fi

if dotfiles_include "kubernetes"; then
  brew install kubectl hyperkit docker-machine-driver-hyperkit helm kube-ps1 || true
  sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
  sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

  # Install krew
  pushd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" && \
  tar zxvf krew.tar.gz && \
  KREW=./krew-"${OS}_${ARCH}" && \
  "$KREW" install krew && \
  popd
fi

if dotfiles_include "web"; then
  brew install httpie jq || true
  brew install --cask "insomnia" || true
fi

if dotfiles_include "node"; then
  # Install NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash || true
  pushd $HOME
  ln -sf "$DOTFILES/Node/.npmrc"
  popd
fi

if dotfiles_include "node_olson"; then
  # Install NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash || true
  pushd $HOME
  ln -sf "$DOTFILES/Node_Olson/.npmrc"
  popd
fi

if dotfiles_include "vscode"; then
  pushd "$HOME/Library/Application Support/Code/User"
  ln -sf "$DOTFILES/VSCode/settings.json"
  ln -sf "$DOTFILES/VSCode/keybindings.json"
  ln -sfn "$DOTFILES/VSCode/snippets/"
  popd
fi

if dotfiles_include "olson"; then
  curl https://raw.githubusercontent.com/ahnick/encpass.sh/master/encpass.sh -o /usr/local/bin/encpass.sh && \
  chmod u+x /usr/local/bin/encpass.sh
fi

if dotfiles_include "spotify"; then
  brew install shpotify
  pushd $HOME
  ln -sf "$DOTFILES/Spotify/.shpotify.cfg"
  [ -z "$SHPOTIFY_CLIENT_SECRET" ] && echo "To enable shpotify, add a SHPOTIFY_CLIENT_SECRET environment variable to your profile scripts"
  popd
fi

if dotfiles_include "sql"; then
  pip install mssql-cli
  pushd "$XDG_CONFIG_HOME/mssqlcli"
  ln -sf "$DOTFILES/SQL/mssqlcli-light.config" "config"
  ln -sf "$DOTFILES/SQL/mssqlcli-light.config"
  ln -sf "$DOTFILES/SQL/mssqlcli-dark.config"
  popd
fi

if dotfiles_include "amethyst"; then
  brew install --cask amethyst
  echo "To enable Amethyst, manually launch it and provide the required accessibility permissions"
fi