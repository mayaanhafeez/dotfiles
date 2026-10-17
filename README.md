# dotfiles

My macOS dev setup: Hyprspace (tiling WM), SketchyBar, JankyBorders, skhd, Karabiner,
Ghostty, tmux, Neovim, zsh, and `set-theme`, which re-themes all of it in one command.

```sh
git clone --recurse-submodules https://github.com/mayaanhafeez/dotfiles.git ~/dotfiles
```

Then point a coding agent at [AGENTS.md](AGENTS.md) and ask it to set up the machine.
It covers packages, symlinks (`./link.sh`), services, permissions and theming, and marks
the steps that need a human.

Configs live in `config/` and are symlinked into `~/.config/`. nvim, sketchybar, tmux,
set-theme, agent-sudo-mac and wallpapers are their own repos, included as submodules.
