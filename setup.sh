#!/bin/bash

# List your dotfiles here (without leading dot)
files=(
  bashrc
  config/lazygit/config.yml
)

backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

echo "backing up existing dotfiles to $backup_dir"

for file in "${files[@]}"; do
  target="$HOME/.$file"
  source="$HOME/.dotfiles/$file"

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

