#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# List dotFILES here without leading dot. Also supports glob.
# e.g. config/hypr/autostart.conf
#      config/hypr/envs.conf
#      config/waybar/*
FILES=(
  bashrc
  inputrc
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
  config/hypr/windows.conf
  config/waybar/config.jsonc
  local/bin/*
)

info() { echo -e "\033[1;34m[info]\033[0m $*"; }
warn() { echo -e "\033[1;33m[warn]\033[0m $*"; }

mkdir -p "$BACKUP_DIR"
info "backing up existing dotfiles to $BACKUP_DIR"


for pattern in "${FILES[@]}"; do
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
      mkdir -p "$(dirname "$BACKUP_DIR/.$rel_path")"
      mv "$target" "$BACKUP_DIR/.$rel_path"
    fi
  
    info "creating symlink $target -> $source"
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"

    if head -n1 "$source" | grep -q '^#!'; then
      info "making $target executable (shebang detected)"
      chmod +x "$target"
    fi
  done
done

info "setup complete!"

