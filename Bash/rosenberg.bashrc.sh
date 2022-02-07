#!/usr/bin/env bash

# Determine dotfiles modules to load
dotfiles_include() { # Expects one argument -- module name
  if [[ ! -f $DOTFILESTOLOAD ]]; then
    return 2 # Return failure immediately if we can't find $DOTFILESTOLOAD
  else
    matches=$(grep -cix "$1" $DOTFILESTOLOAD) # Count the number of times module name appears
    [[ $matches -eq 1 ]] # Return success if it appears at least once, failure otherwise
  fi
}

# Optionally enable debugging/profiling bashrc
export PROFILE_BASHRC=${PROFILE_BASHRC:-0}
export DEBUG_BASHRC=${DEBUG_BASHRC:-0}

########################################
# Profile .bashrc
# per https://www.rosipov.com/blog/profiling-slow-bashrc/
# Set PROFILE_BASHRC to 1 to enable
# 
# To profile the latest Bash run:
# python3 bashprofile.py "/tmp/$(ls -lt1 /tmp/ | head -n 1)" -n 50 | code -
########################################
if [[ ${PROFILE_BASHRC} -eq 1 ]]; then
  # On macOS, need to use GNU CoreUtils date, which is aliased to gdate
  PS4='+ $(gdate "+%s.%N")\011 '
  exec 3>&2 2>/tmp/bashstart.$$.log
  set -x
fi

########################################
# Source aliases, variables, extensions, etc. for other tools
########################################
sources=("$DOTFILES/Bash/env.sh") # Bash env
dotfiles_include "docker"     && sources+=("$DOTFILES/Docker/rosenberg.docker.sh")
dotfiles_include "dotnet"     && sources+=("$DOTFILES/Dotnet/rosenberg.dotnet.sh")
dotfiles_include "maven"      && sources+=("$DOTFILES/Maven/rosenberg.maven.sh")
dotfiles_include "java"       && sources+=("$DOTFILES/Java/rosenberg.java.sh")
(dotfiles_include "kubernetes" || dotfiles_include "openshift") && \
                                 sources+=("$DOTFILES/kubernetes/rosenberg.kubernetes.sh")
dotfiles_include "olson"      && sources+=("$DOTFILES/Olson/rosenberg.olson.sh")
dotfiles_include "aws"        && sources+=("$DOTFILES/AWS/rosenberg.aws.sh")
dotfiles_include "golang"     && sources+=("$DOTFILES/Golang/rosenberg.golang.sh")
dotfiles_include "git"        && sources+=("$DOTFILES/Git/rosenberg.git.sh")
dotfiles_include "sql"        && sources+=("$DOTFILES/SQL/rosenberg.sql.sh")
dotfiles_include "node"       && sources+=("$DOTFILES/Node/rosenberg.node.sh")
dotfiles_include "spotify"    && sources+=("$DOTFILES/Spotify/rosenberg.spotify.sh")
dotfiles_include "kitty"      && sources+=("$DOTFILES/Kitty/rosenberg.kitty.sh")
# dotfiles_include "kde"        && sources+=("$DOTFILES/KDE/rosenberg.kde.sh")
# dotfiles_include "bitwarden"  && sources+=("$DOTFILES/Bitwarden/rosenberg.bitwarden.sh")

for source in ${sources[@]}; do
	if [[ ${PROFILE_BASHRC} -eq 1 ]]; then
		echo "$source"
		TIMEFORMAT="$source: %R"
		time . "$source"
		unset TIMEFORMAT
	else
		[[ ${DEBUG_BASHRC} -eq 1 ]] && echo "$source"
    . "$source"
	fi
done; unset i

[[ ${DEBUG_BASHRC} -eq 1 ]] && echo "Done with sourcing"

# After sourcing the above, reset PS1
export PS1="${PS1_START}${PS1_STATUS}${PS1_END}"
[[ ${DEBUG_BASHRC} -eq 1 ]] && echo "PS1: ${PS1}"
# [[ ${DEBUG_BASHRC} -eq 1 ]] && echo "PROMPT_COMMAND: $PROMPT_COMMAND"

########################################
# End profile .bashrc
# per https://www.rosipov.com/blog/profiling-slow-bashrc/
########################################
if [[ $PROFILE_BASHRC -eq 1 ]]; then
  set +x
  exec 2>&3 3>&-
fi

# Always use pushd instead of cd
# There are scripts above that use `cd`, so delaying this until the end
alias cd='pushd' 
