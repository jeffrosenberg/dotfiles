#!/usr/bin/env sh
mkdir -p ~/.config/sway
mkdir -p ~/.config/rofi
mkdir -p ~/.config/kanshi

[ -d /usr/local/lib/systemd/sleep.conf.d ] || {
  sudo mkdir -p /usr/local/lib/systemd/sleep.conf.d
  sudo ln -sf $DOTFILES/Sway/sleep.conf /usr/local/lib/systemd/sleep.conf.d/sleep.conf
}

ln -sf $DOTFILES/Sway/libinput-gestures.conf ~/.config/libinput-gestures.conf
ln -sf $DOTFILES/Sway/rofi.config ~/.config/rofi/config
ln -sf $DOTFILES/Sway/sway.config ~/.config/sway/config
ln -sf $DOTFILES/Sway/kanshi.config ~/.config/kanshi/config