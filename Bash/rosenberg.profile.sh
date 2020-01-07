#!/usr/bin/env bash

if [[ ! -f $DOTFILESTOLOAD ]]; then
  echo "MISSING CONFIGURATION FILE:" >&2
  echo "Please define all modules to be loaded in ~/.dotfilestoload" >&2
fi

########################################
# Environment variables
#########################################

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config

#########################################
# Aliases
#########################################

alias cd='pushd' # Always use pushd instead of cd
alias clrd='dirs -c' # Reset pushd/popd stack
alias resetd='dirs -c' # Reset pushd/popd stack
alias returnd='pushd -0 && dirs -c' # Go back to the beginning of the pushd/popd stack
eval $(thefuck --alias)

# Mac OS
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias flushcache='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder;'

########################################
# Functions
########################################

# Determine dotfiles modules to load
dotfiles_include() { # Expects one argument -- module name
  if [[ ! -f $DOTFILESTOLOAD ]]; then
    return 2 # Return failure immediately if we can't find $DOTFILESTOLOAD
  else
    matches=$(grep -ci "$1" $DOTFILESTOLOAD) # Count the number of times module name appears
    [[ $matches -gt 0 ]] # Return success if it appears at least once, failure otherwise
  fi
}