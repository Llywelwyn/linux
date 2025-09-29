#!/bin/bash

set -euo pipefail

info() { echo -e "\033[1;34m[info]\033[0m $*"; }
warn() { echo -e "\033[1;33m[warn]\033[0m $*"; }

# List dotfiles here without leading dot. Also supports glob.
# e.g. config/hypr/autostart.conf
#      config/hypr/envs.conf
#      config/waybar/*
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

info "backing up existing dotfiles to $backup_dir"

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

for pattern in "${files[@]}"; do
  for source in $REPO_DIR/$pattern; do
    [ -e "$source" ] || continue

    rel_path="${source#$REPO_DIR/}"
    target="$HOME/.$rel_path"

  
    if [ ! -e "$source" ]; then
      warn "missing expected file $source"
      continue
     fi 
  
     if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      info "already symlinked $target"
      continue
    fi
   
    if [ -e "$target" ] || [ -L "$target" ]; then
      info "backing up $target"
      mkdir -p "$(dirname "$backup_dir/.$file")"
      mv "$target" "$backup_dir/.$file"
    fi
  
    info "creating symlink $target -> $source"
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
  done
done

info "setup complete!"

