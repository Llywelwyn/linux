#!/bin/bash

# List your dotfiles here (without leading dot)
files=(
  bashrc
  XCompose
  config/starship.toml
  config/lazygit/config.yml
  config/hypr/autostart.conf
  config/hypr/envs.conf
  config/hypr/hyprland.conf
  config/hypr/hyprsunset.conf
  config/hypr/looknfeel.conf
  config/hypr/bindings.conf
  config/hypr/hypridle.conf
  config/hypr/hyprlock.conf
  config/hypr/input.conf
  config/hypr/monitors.conf
  config/waybar/config.jsonc
  local/share/omarchy/default/hypr/autostart.conf
  local/share/omarchy/default/bash/aliases
)

backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

echo "backing up existing dotfiles to $backup_dir"

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

for file in "${files[@]}"; do
  target="$HOME/.$file"
  source="$REPO_DIR/$file"

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "backing up $target"
    mkdir -p "$(dirname "$backup_dir/.$file")"
    mv "$target" "$backup_dir/.$file"
  fi

  echo "creating symlink $target -> $source"
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
done

echo "setup complete!"

