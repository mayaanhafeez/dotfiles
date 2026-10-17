#!/usr/bin/env bash
# link.sh — symlink everything in this repo into place. Safe to re-run.
#
# Usage:
#   ./link.sh            create/repair links
#   ./link.sh --dry-run  print what would change, touch nothing
#
# Anything already sitting at a target that is not the right symlink is moved
# to ~/.dotfiles-backup/<timestamp>/ first, never deleted.
#
# Links:
#   config/<name>            -> ~/.config/<name>      (whole directories)
#   home/zshenv              -> ~/.zshenv             (sets ZDOTDIR=~/.config/zsh)
#   bin/<script>             -> ~/.local/bin/<script>
#   set-theme/set-theme      -> ~/.local/bin/set-theme
#   set-theme/set-wallpaper.sh -> ~/.local/bin/set-wallpaper
#   wallpapers               -> ~/Pictures/wallpapers
#
# Directories are linked whole rather than file by file because set-theme
# edits configs with `sed -i`, which replaces a symlinked file with a regular
# one but writes straight through a symlinked directory.

set -euo pipefail

DOTFILES=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

run() {
  if [[ "$DRY_RUN" == true ]]; then
    echo "  would: $*"
  else
    "$@"
  fi
}

# link <source> <target>
link() {
  local src=$1 dst=$2
  if [[ ! -e "$src" ]]; then
    echo "skip   $dst (missing $src — run: git submodule update --init)"
    return
  fi
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok     $dst"
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "backup $dst -> $BACKUP_DIR/"
    run mkdir -p "$BACKUP_DIR"
    run mv "$dst" "$BACKUP_DIR/"
  fi
  echo "link   $dst -> $src"
  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
}

for src in "$DOTFILES"/config/*; do
  link "$src" "$HOME/.config/$(basename "$src")"
done

link "$DOTFILES/home/zshenv" "$HOME/.zshenv"

for src in "$DOTFILES"/bin/*; do
  link "$src" "$HOME/.local/bin/$(basename "$src")"
done

link "$DOTFILES/set-theme/set-theme" "$HOME/.local/bin/set-theme"
link "$DOTFILES/set-theme/set-wallpaper.sh" "$HOME/.local/bin/set-wallpaper"

link "$DOTFILES/wallpapers" "$HOME/Pictures/wallpapers"
