#!/usr/bin/env bash

if [[ ! -f $DOTFILESTOLOAD ]]; then
  echo "MISSING CONFIGURATION FILE:" >&2
  echo "Please define all modules to be loaded in ~/.dotfilestoload" >&2
fi

#########################################
# Environment variables
#########################################

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config

#########################################
# Make the OS available as an env var
#########################################

case "$(uname -s)" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    CYGWIN*)    OS=Cygwin;;
    MINGW*)     OS=MinGw;;
    *)          OS=Unknown
esac
echo "OS: ${OS}"

#########################################
# Aliases
#########################################

# alias cd='pushd' # Always use pushd instead of cd # moving this to the bottom of rosenberg.bashrc.sh
alias clrd='dirs -c' # Reset pushd/popd stack
alias cleard='dirs -c' # Reset pushd/popd stack
alias resetd='dirs -c' # Reset pushd/popd stack
alias returnd='pushd -0 && dirs -c' # Go back to the beginning of the pushd/popd stack
alias showd='dirs -v' # Show the pushd/popd stack

# Mac OS
alias showFiles='defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder'
alias flushcache='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder;'
