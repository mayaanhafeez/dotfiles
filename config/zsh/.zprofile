# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:$HOME/.docker/bin"
# End of Docker Desktop section.

eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------- mise shims ----------
# Lives here, not .zshrc, so NON-interactive login shells get it too
# (e.g. `zsh -lc "opencode"` from skhd hotkeys). zsh skips .zshrc when
# the shell isn't interactive.
export PATH="$HOME/.local/share/mise/shims:$PATH"
