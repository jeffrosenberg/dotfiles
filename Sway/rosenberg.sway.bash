#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="sway"
export XDG_SESSION_TYPE="wayland"
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export MOZ_WEBRENDER=1
export MOZ_ACCELERATED=1
export MOZ_DBUS_REMOTE=1

########################################
# Aliases
########################################
alias sleep='systemctl suspend'
alias lock='swaylock -f -c 2b0d63'