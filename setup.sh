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
  config/user-dirs.dirs
  config/user-dirs.fish
  config/user-dirs.locale
  config/mimeapps.list
  config/alacritty
  config/fish
  config/git
  config/lazygit
  config/fastfetch
  config/hypr
  config/omarchy
  config/uwsm
  config/waybar
  config/walker
  config/mako
  local/bin/*
  local/share/applications/nvim.desktop
  local/share/omarchy/icon.png
  local/share/omarchy/themes
  local/share/omarchy/default
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

    if [ -f "$source" ]; then 
     if head -n1 "$source" | grep -q '^#!'; then
       info "making $target executable (shebang detected)"
       chmod +x "$target"
     fi
    fi
  done
done

info "setup complete!"

