#! /usr/bin/env bash

[[ ${DEBUG_BASHRC} -eq 1 ]] && echo "rosenberg.git.sh" && echo

########################################
# Git setup
########################################

# echo "Pre Git PS1: $PS1" # DEBUG
# echo "Pre Git PS1_STATUS: $PS1_STATUS" # DEBUG
export PS1_STATUS="${PS1_STATUS}"' [$(__git_ps1 "%s")] '
# export PROMPT_COMMAND="__git_ps1 \"${PS1_START}${PS1_STATUS}\" \"${PS1_END}\""

echo "Git path: $(which git)"

# Source these if Git is installed through Homebrew
if [ -n "${BREW}" ] && [ -f "${BREW}/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  source "${BREW}/etc/bash_completion.d/git-completion.bash"
  # source "${BREW}/opt/bash-git-prompt/share/gitprompt.sh" # bash-git-prompt is too heavy
  source "${BREW}/etc/bash_completion.d/git-prompt.sh"

  # Config for bash-git-prompt
  # see: https://github.com/magicmonty/bash-git-prompt
  ### NOTE:
  ### Replacing bash-git-prompt with git-prompt,
  ### Because bash-git-prompt takes over the PROMPT_COMMAND variable
  # __GIT_PROMPT_DIR="${BREW}/opt/bash-git-prompt/share"
  # GIT_PROMPT_ONLY_IN_REPO=1
  # GIT_PROMPT_IGNORE_SUBMODULES=1
  # GIT_PROMPT_SHOW_UPSTREAM=1
  # GIT_PROMPT_START="^ test ^"
# Source these if Xcode is installed
elif [ -d /Applications/Xcode.app ]; then
  source "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh"
  source "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash"
# Source these if just Command Line Tools are installed
elif [ -d /Library/Developer ]; then
  source "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
  source "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"
fi

# Git-Prompt configuration
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS="yes"
export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_STATESEPARATOR=' '

########################################
# Shell wrappers for Git commands / aliases
######################################## 
# Where possible, prefer to create aliases in
# .gitconfig and just wrap in shell aliases
#
# This way, can update command behaviors,
# formatting, etc. across all providers
# in .gitconfig 
########################################

#git log
alias lg='git lg'
alias gl='git lg'

alias slg='git slg'

alias status='git st'
alias gs='git st'

alias sha='git sha'

alias add='git add'
alias ga='git add'
alias addall='git addall'
alias aa='git addall'

alias diff='git diff'
alias gd='git diff'

alias commit='git commit'
alias gc='git commit'
alias amend='git add --all && commit --amend --no-edit'

alias chk='git chk'
alias checkout='git chk'

alias dev='git dev'
alias devp='git devp'
alias main='git main'
alias mainp='git mainp'
alias master='git master'
alias masterp='git masterp'

alias merge='git merge'

alias fetch='git fetch'

alias pull='git pull'
alias gp='git pull'

alias push='git push'

alias show='git show'