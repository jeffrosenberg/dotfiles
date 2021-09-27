#!/usr/bin/env bash

if [[ ! -f ~/.dotfilestoload ]]; then
  echo "Before installation, please define all modules to be loaded in ~/.dotfilestoload" >&2
  return 2
fi

# Determine dotfiles modules to load
dotfiles_include() {
  # Expects one argument -- module name    
  matches=$(grep -cix "$1" ~/.dotfilestoload) # Count the number of times module name appears
  [[ $matches -eq 1 ]] # Return success if it appears exactly once, failure otherwise
}

########################################
# Install Homebrew
########################################

if ! which brew; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

########################################
# Install Homebrew packages
########################################

brew install bash lzo gettext readline ripgrep coreutils bash-completion@2 nerdfont || true
brew cask install powershell || true

if dotfiles_include "java"; then
  brew tap AdoptOpenJDK/openjdk || true
  brew cask install adoptopenjdk8 adoptopenjdk11 || true
  brew install jenv && \
    eval "$(jenv init -)" && \
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/ && \
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/ && \
    jenv global 11.0 || true  
fi

if dotfiles_include "git"; then
  brew install git bash-git-prompt || true
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
  cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" && \
  tar zxvf krew.tar.gz && \
  KREW=./krew-"${OS}_${ARCH}" && \
  "$KREW" install krew
fi

if dotfiles_include "web"; then
  brew install httpie jq || true
fi

if dotfiles_include "node"; then
  # Intall NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash || true
  pushd $HOME
  ln -s "$DOTFILES/Node/.npmrc"
  popd
fi

if dotfiles_include "node_olson"; then
  # Intall NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash || true
  pushd $HOME
  ln -s "$DOTFILES/Node_Olson/.npmrc"
  popd
fi

if dotfiles_include "vscode"; then
  pushd ~/'Library/Application Support/Code/User'
  ln -s "$DOTFILES/VSCode/settings.json"
  ln -s "$DOTFILES/VSCode/keybindings.json"
  ln -s "$DOTFILES/VSCode/snippets/"
  popd
fi

if dotfiles_include "olson"; then
  curl https://raw.githubusercontent.com/ahnick/encpass.sh/master/encpass.sh -o /usr/local/bin/encpass.sh && \
  chmod u+x /usr/local/bin/encpass.sh
fi