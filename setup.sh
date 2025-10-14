#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DONE_FILE="$REPO_DIR/.last_run.list"

FILES=(
  bashrc
  inputrc
  XCompose
  config/starship.toml
  config/user-dirs.dirs
  config/user-dirs.fish
  config/user-dirs.locale
  config/mimeapps.list
  config/chromium-flags.conf
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
  local/share/applications
  local/share/omarchy/bin
  local/share/omarchy/icon.svg
  local/share/omarchy/icon.png
  local/share/omarchy/themes
  local/share/omarchy/default
)

info() { echo -e "\033[1;34m[info]\033[0m $*"; }
warn() { echo -e "\033[1;33m[warn]\033[0m $*"; }

mkdir -p "$BACKUP_DIR"
info "backing up existing dotfiles to $BACKUP_DIR"

if [ -f "$DONE_FILE" ]; then
  info "checking for stale symlinks"
  mapfile -t OLD_FILES < "$DONE_FILE"

  declare -A CURRENT
  for pattern in "${FILES[@]}"; do
    for source in $REPO_DIR/$pattern; do
      rel_path="${source#$REPO_DIR/}"
      CURRENT["$rel_path"]=1
    done
  done

  for rel_path in "${OLD_FILES[@]}"; do
    if [ -z "${CURRENT["$rel_path"]+x}" ]; then
      target="$HOME/.$rel_path"
      if [ -L "$target" ]; then
        info "removing stale symlink $target"
        rm "$target"
      fi
    fi
  done
fi

> "$DONE_FILE"

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
      echo "$rel_path" >> "$DONE_FILE"
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

    if [ -f "$source" ] && head -n1 "$source" | grep -q '^#!'; then
      info "making $target executable (shebang detected)"
      chmod +x "$target"
    fi

    echo "$rel_path" >> "$DONE_FILE"
  done
done

info "setup complete!"

