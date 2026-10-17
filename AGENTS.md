# AGENTS.md — dotfiles setup runbook

This repo is Ayaan's macOS dev setup. It is written so a coding agent on a **clean Mac**
can clone it and do most of the setup unattended. Steps that need the human (passwords,
GUI permission prompts, logins) are marked **[human]**. Do those by telling the user
exactly what to click or type, then continue.

Work top to bottom. Each step is safe to re-run.

---

## What's in here

| Path | What it is | Ends up at |
|---|---|---|
| `config/AutoRaise` | AutoRaise (focus-follows-mouse) | `~/.config/AutoRaise` |
| `config/borders` | JankyBorders `bordersrc` | `~/.config/borders` |
| `config/btop` | btop config + custom themes | `~/.config/btop` |
| `config/gh` | GitHub CLI config (`hosts.yml` is **not** tracked) | `~/.config/gh` |
| `config/ghostty` | Ghostty terminal config + custom themes | `~/.config/ghostty` |
| `config/git` | git config (`config`, `personal`, `work`, `ignore`) | `~/.config/git` |
| `config/herdr` | herdr `config.toml` (runtime state is gitignored) | `~/.config/herdr` |
| `config/hyprspace` | Hyprspace (tiling WM) `config.toml` | `~/.config/hyprspace` |
| `config/karabiner` | Karabiner-Elements `karabiner.json` | `~/.config/karabiner` |
| `config/kitsune` | Kitsune launcher config, plugins, colour schemes | `~/.config/kitsune` |
| `config/mise` | mise global tools: claude, codex, opencode (all `latest`) | `~/.config/mise` |
| `config/opencode` | opencode config, plugins, themes | `~/.config/opencode` |
| `config/skhd` | skhd hotkeys (`skhdrc`) | `~/.config/skhd` |
| `config/zsh` | `.zshrc` and `.zprofile` (zsh reads them via `ZDOTDIR`) | `~/.config/zsh` |
| `config/nvim` | **submodule** → [nvim-config](https://github.com/mayaanhafeez/nvim-config) | `~/.config/nvim` |
| `config/sketchybar` | **submodule** → [sketchy-bar-config](https://github.com/mayaanhafeez/sketchy-bar-config) | `~/.config/sketchybar` |
| `config/tmux` | **submodule** → [tmuxconf](https://github.com/mayaanhafeez/tmuxconf) | `~/.config/tmux` |
| `set-theme/` | **submodule** → [set-theme](https://github.com/mayaanhafeez/set-theme), the one-command theme switcher | `~/.local/bin/set-theme`, `~/.local/bin/set-wallpaper` |
| `agent-sudo-mac/` | **submodule** → [agent-sudo-mac](https://github.com/mayaanhafeez/agent-sudo-mac), sudo for agents (Touch ID + GUI fallback) | installs into `~/.local/bin` |
| `wallpapers/` | **submodule** → [wallpapers](https://github.com/mayaanhafeez/wallpapers), one folder per theme (~400 MB) | `~/Pictures/wallpapers` |
| `home/zshenv` | the only zsh file left in `$HOME`; sets `ZDOTDIR=~/.config/zsh` | `~/.zshenv` |
| `bin/tmux-sessionizer` | fzf-pick a dir in `~/personal`, `~/work` or `~/university` → one tmux session per project. Ctrl-F in zsh, `prefix f` in tmux | `~/.local/bin/tmux-sessionizer` |
| `Brewfile` | every Homebrew tap, formula, cask, plus cargo/go/npm globals | — |
| `link.sh` | creates every symlink above; backs up anything in the way | — |
| `macos.sh` | Dock, menu bar, keyboard, trackpad, Finder, window-tiling settings | — |

Everything under `config/` is symlinked as a **whole directory**, not file by file.
set-theme edits configs with `sed -i`, which would replace a symlinked *file* with a plain
copy, but writes straight through a symlinked *directory*. Karabiner also requires the
directory form. Don't "improve" this into per-file links.

---

## Fresh machine setup

### 0. Prerequisites [human]

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Both need a password and/or a GUI click. Wait for them to finish before going on.

### 1. Clone

```sh
git clone --recurse-submodules https://github.com/mayaanhafeez/dotfiles.git ~/dotfiles
```

The wallpapers submodule is ~400 MB. To skip it at first, clone without
`--recurse-submodules` and init the rest by name:

```sh
git clone https://github.com/mayaanhafeez/dotfiles.git ~/dotfiles
cd ~/dotfiles
git submodule update --init config/nvim config/sketchybar config/tmux set-theme agent-sudo-mac
# later: git submodule update --init wallpapers
```

`~/dotfiles` is a convention, not a requirement. `link.sh` and set-theme both find
themselves relative to their own location.

### 2. Homebrew packages

```sh
brew bundle --file=~/dotfiles/Brewfile
```

That installs everything this machine had through Homebrew: the desktop stack
(sketchybar, borders, skhd, autoraise, sketchybar-toggle, Hyprspace from `peachlifeab/tap`,
Karabiner, Kitsune from its own tap, OpenLogi), shell tooling (tmux, neovim, fzf, zoxide,
eza, mise, gh, …), fonts, apps, and global cargo/go/npm packages. A few entries need
input or fail on a first run (macFUSE asks to approve a system extension; the `cargo`
lines need rustup from step 5). Re-run `brew bundle` after step 5 to pick those up.

Things the configs depend on, if you're trimming the Brewfile:
`lua` (`sketchybarrc` is a Lua script), `switchaudio-osx`, `nowplaying-cli` and
`speedtest` (sketchybar items), `fzf` (set-theme, set-wallpaper, sessionizer), and
`eza`, `zoxide`, `go` (`.zshrc` calls them at startup). `jq` ships with macOS.

To refresh it after installing something: `brew bundle dump --file=~/dotfiles/Brewfile --force`,
then re-apply two edits by hand: the `mayaanhafeez/tap` line must not point at a local path,
and drop the `vscode` lines (they fail on a machine without the `code` CLI).

### 3. Link the configs

```sh
cd ~/dotfiles && ./link.sh --dry-run   # read it
./link.sh
```

On a truly clean machine the only backups will be macOS's default `~/.zshenv` (if any).
Anything moved aside lands in `~/.dotfiles-backup/<timestamp>/`.

If you're migrating a machine that's already running these apps, **restart each one
after its config dir becomes a symlink**. Apps that watch their config (Kitsune, Karabiner,
skhd, sketchybar) can keep watching the old, now-empty location and silently stop
picking up edits. Older Kitsune builds also never watch `plugins/`, `menus/` or `lua/`
through a symlinked `~/.config/kitsune`; upgrade Kitsune if plugin edits need a restart.

### 4. Oh My Zsh

Install it **after** `link.sh`, and tell the installer to keep the existing `.zshrc`:

```sh
ZSH="$HOME/.local/share/oh-my-zsh" ZDOTDIR="$HOME/.config/zsh" KEEP_ZSHRC=yes RUNZSH=no CHSH=no \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Without `KEEP_ZSHRC=yes` it renames our `.zshrc` to `.zshrc.pre-oh-my-zsh` and writes its
template, through the symlink, into this repo. If that happens: `git -C ~/dotfiles checkout config/zsh`.

OMZ lives at `~/.local/share/oh-my-zsh` (`$ZSH` in `.zshrc`; the installer's `ZSH=` puts it there), theme `robbyrussell`, plugins `(git)`.
There is no starship. Nothing custom lives in `$ZSH_CUSTOM`.

How the zsh files fit together:
- `~/.zshenv` → `home/zshenv`: sets `ZDOTDIR=~/.config/zsh`, sources `~/.cargo/env` if present.
- `$ZDOTDIR/.zprofile`: brew shellenv, Docker, mise shims (login shells, including the
  non-interactive `zsh -lc` that skhd uses).
- `$ZDOTDIR/.zshrc`: OMZ, aliases, PATH, zoxide (`cd`), fzf, Ctrl-F sessionizer.
- History is at `~/.local/state/zsh/history`, compdump in `~/.cache/zsh/`. Both are set in
  `.zshrc` so zsh never writes into the repo through the `ZDOTDIR` symlink.

### 5. Language runtimes and CLIs

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
curl -fsSL https://bun.sh/install | bash          # .zshrc already has the bun PATH lines
mise install                                       # tools from config/mise/config.toml
```

`--no-modify-path` matters: rustup would otherwise append to `~/.zshenv`, which is a
symlink into this repo. `home/zshenv` already sources `~/.cargo/env`.

### 6. agent-sudo-mac [human]

Needs a real terminal, since `sudo` has to prompt for a password once:

```sh
cd ~/dotfiles/agent-sudo-mac && ./install.sh --shim --hook
```

This machine was set up with `--shim --hook`: `asudo`, `mac-askpass`, a tty-aware `sudo`
shim and the `claude-sudo-rewrite` hook land in `~/.local/bin`, `pam_tid.so` goes into
`/etc/pam.d/sudo_local`, and `SUDO_ASKPASS` + the PreToolUse hook are written into
`~/.claude/settings.json`. From here on, agents should use `asudo` for privileged
commands, and batch them into **one** `asudo sh -c '...'`, never one per item.

### 7. SketchyBar dependencies

The sketchybar config needs two things that aren't in Homebrew core:

```sh
# SbarLua: the Lua binding. helpers/init.lua loads it from ~/.local/share/sketchybar_lua
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && (cd /tmp/SbarLua && make install) && rm -rf /tmp/SbarLua

# App icon font
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf \
  -o ~/Library/Fonts/sketchybar-app-font.ttf
```

`helpers/` also has native helpers that it builds itself on first load (`make` in
`helpers/`), which needs the Xcode command line tools from step 0.

### 8. Personal apps and tools

These live in `~/personal` because skhd bindings and scripts point there:

```sh
mkdir -p ~/personal && cd ~/personal

# Wallpaper picker overlay. skhd: alt+ctrl+space -> ~/personal/wallpaper-overlay/wallpaper-pick
git clone https://github.com/mayaanhafeez/wallpaper-overlay.git && make -C wallpaper-overlay

# Chrome-tab-to-Safari hotkey. skhd: alt+shift+b -> ~/personal/move_to_safari/move_to_safari.sh
git clone https://github.com/mayaanhafeez/move_to_safari.git
```

Kitsune (config is `config/kitsune`) comes from the Brewfile, via its own tap
(`mayaanhafeez/kitsune`, which is the `app_launcher` repo).

herdr (terminal workspace manager; its binary goes in `~/.local/bin`):

```sh
curl -fsSL https://herdr.dev/install.sh | sh
herdr integration install claude
herdr integration install opencode
```

Optional, only if wanted on this machine:
- **Hyprspace from source** instead of the cask: `git clone https://github.com/mayaanhafeez/hyprspace-core ~/personal/hyprspace-core`. It's an AeroSpace fork. Ask before deleting its build tree on any machine.
- **macwifi** (Wi-Fi TUI, used by sketchybar's wifi item): https://github.com/mayaanhafeez/macwifi

### 9. Start services

```sh
brew services start sketchybar
brew services start borders
brew services start autoraise
skhd --install-service && skhd --start-service
open -a Hyprspace       # config has start-at-login = true; it also launches borders
open -a Karabiner-Elements
open -a KitsuneLauncher
```

### 10. macOS settings

```sh
~/dotfiles/macos.sh
```

Dock (auto-hide on the left, no delay), hidden menu bar for SketchyBar, macOS window
tiling and Stage Manager off (they fight Hyprspace), fast key repeat with press-and-hold
off, autocorrect and smart quotes off, tap to click, Finder list view with path bar,
hot corners (top-left, bottom-right → desktop), JPG screenshots. Restarts Dock, Finder and
SystemUIServer. Ask the user to log out and back in afterwards for key repeat.

### 11. Permissions [human]

macOS won't let an agent grant these. Open the panes and tell the user what to toggle on:

```sh
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
```

- **Accessibility**: Hyprspace, skhd (`/opt/homebrew/bin/skhd`), AutoRaise, KitsuneLauncher, Karabiner-Elements
- **Input Monitoring**: Karabiner-Elements (`karabiner_grabber`), skhd
- Karabiner will also ask to allow its **driver extension** in System Settings → General → Login Items & Extensions.

After granting, restart the affected service (`skhd --restart-service`, `brew services restart autoraise`).

### 12. Accounts and SSH [human]

```sh
gh auth login            # GitHub CLI; stores the token in the keychain
gh auth setup-git
```

The submodules clone over HTTPS, but their **push** remotes use the SSH host alias
`github-personal`. To push from a new machine, `~/.ssh/config` needs:

```
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
```

Keys are **not** in this repo. Generate new ones (`ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_personal`)
and add them to GitHub, or copy them over from the old machine by hand.

git identity switches by directory (`config/git/config`): repos under `~/personal/` use
the personal email, `~/work/` uses the work email, everything else uses the personal one.

### 13. Apply a theme

Last, because it writes into almost everything above:

```sh
set-theme                 # list themes
set-theme rose-pine       # or any other; names are fuzzy-matched
```

See the next section for what it touches. On a fresh machine some targets print
`skipped`: kitty (unless installed), macwifi, and OpenLogi until each app has created its config.
That's expected.

### 14. Verify

```sh
zsh -lic 'echo $ZDOTDIR $HISTFILE; alias ls'   # ~/.config/zsh, ~/.local/state/zsh/history, eza
tmux -L check -f ~/.config/tmux/tmux.conf new -d && tmux -L check show -g prefix && tmux -L check kill-server   # prefix C-a
for p in sketchybar borders skhd; do pgrep -x $p >/dev/null && echo "$p ok" || echo "$p NOT running"; done
cat ~/.config/theme                            # the theme you applied
ls ~/Pictures/wallpapers/"$(cat ~/.config/theme)" | head -3
cd ~/dotfiles && git status && git submodule status
```

Then ask the user to press a few hotkeys: `alt+return` (Ghostty), `alt+ctrl+space`
(wallpaper picker), `alt+shift+ctrl+s` (reload sketchybar).

---

## set-theme

`set-theme <name>` re-themes the whole setup in one go. Active theme name is saved to
`~/.config/theme` (and `set-theme/current_theme`, gitignored).

| Target | What it changes |
|---|---|
| Ghostty | `theme =` line in `config/ghostty/config.ghostty`; reloads via SIGUSR2. Custom themes are copied into `config/ghostty/themes/`. |
| tmux | writes `~/.config/tmux/tmux-theme.conf` (ANSI palette, so it's the same for every theme) and re-sources it |
| herdr | `[theme] name` in `config/herdr/config.toml`; `herdr server reload-config` |
| nvim | `local FALLBACK = "..."` in `config/nvim/lua/plugins/theme.lua`; live nvim instances switch via RPC |
| btop | `color_theme` in `config/btop/btop.conf` (absolute path); SIGUSR2 |
| SketchyBar | `theme = "..."` in `config/sketchybar/settings.lua`; `sketchybar --reload` |
| borders | `active_color` in `config/borders/bordersrc`; pushes it to the running instance |
| opencode | sets `theme: system` in `tui.json`; the desktop app's theme is queued via `opencode-desktop-theme` |
| kitty | `~/.config/kitty/current-theme.conf`. Skipped entirely when the kitty CLI isn't installed (it isn't here) |
| Chrome | queues a custom-colour theme, applied when Chrome next quits (`chrome-theme`) |
| OpenLogi | `theme_dark`/`theme_light` in `~/.config/openlogi/config.toml` |
| macwifi | `theme` in `~/Library/Application Support/macwifi/config.toml` |
| macOS | dark/light appearance and accent colour (`accent`) |
| Wallpaper | random image from `~/Pictures/wallpapers/<theme>/` via `set-wallpaper` |

Because several of those files are tracked here, **every theme switch shows up in
`git status`** (ghostty, btop, borders, herdr, plus the sketchybar and nvim submodules).
That's normal. Commit it when you want the new theme to be the default on the next machine.

Adding a theme: add it to `THEMES` and a `case` block in `set-theme/set-theme`, ship any
custom per-app files under `set-theme/themes/<name>/`, and add a `wallpapers/<name>/` folder.

`set-wallpaper [file]` sets the wallpaper on every display and space (and for displays
not currently attached). With no argument it fzf-picks from the current theme's folder.
`wallpaper-pick` (from wallpaper-overlay, bound to `alt+ctrl+space`) is the visual picker
in front of it.

---

## Day to day

- Edit configs where the apps expect them (`~/.config/...`). They are symlinks, so you're
  editing this repo.
- **Submodules** (nvim, sketchybar, tmux, set-theme, agent-sudo-mac, wallpapers): commit
  and push *inside* the submodule first, then `git add <path>` in `~/dotfiles` and commit
  the new pointer. Pushing the dotfiles repo alone doesn't publish submodule changes.
- Pull everything: `git -C ~/dotfiles pull --recurse-submodules && git -C ~/dotfiles submodule update --init --recursive`
- New config dir: move it into `config/`, run `./link.sh`, add junk paths to `.gitignore`.
- New wallpaper: drop it in `~/Pictures/wallpapers/<theme>/`, then commit in the wallpapers repo.

---

## Gotchas

- **tmux reads `~/.tmux.conf` before `~/.config/tmux/tmux.conf`.** If a stray
  `~/.tmux.conf` appears, the repo config is silently ignored. Delete it.
- **skhd** reads `~/.config/skhd/skhdrc`, which wins over `~/.skhdrc` (any `~/.skhdrc` is
  ignored). If an edit doesn't take effect, `skhd --restart-service`.
- **Don't track `config/opencode/service.json`.** It holds a local server password.
  `config/gh/hosts.yml` lists accounts (tokens are in the keychain). Both are gitignored.
- `config/btop/btop.conf` and `config/opencode/opencode.json` contain absolute
  `/Users/ayaanhafeez/...` paths. btop's is rewritten by the first `set-theme`. opencode's
  points at a locally built `pixel-mcp` binary; drop that MCP entry if it isn't installed.
- Installers that "helpfully" append to shell rc files (rustup, conda, Docker, bun) will
  write through the symlinks into this repo. Check `git diff config/zsh home` after
  installing anything.
- `.zshrc` runs `go env GOPATH`, `zoxide init` and `fzf --zsh` at startup, so new shells
  print errors until step 2's packages are installed.
- The tmux help popup (`prefix ?`) calls `~/omarchy/bin/omarchy-menu-tmux-keybindings`.
  Clone https://github.com/mayaanhafeez/omarchy to `~/omarchy` if you want it.
