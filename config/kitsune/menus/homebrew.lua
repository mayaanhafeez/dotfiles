-- Installing and removing. Both menus are Homebrew end to end, which is why they share
-- a file; `update` is separate because it is not only Homebrew.
--
-- `read -r '?Prompt: '` works because a `shell` item is `eval`ed inside a Terminal
-- window's own interactive shell, which leaves stdin on the tty. Piping the script into
-- a shell would put it on stdin -- exactly where `read` reads from -- and the prompt
-- would swallow the script's own next line.
--
-- Typing inside Install offers to install what you typed (see plugins/brew.lua).
local item, group = require("item").item, require("item").group

return {
  items = {
    item("install", "Install", { symbol = "square.and.arrow.down", provider = "brew" }),
    item("install.formula", "Homebrew Formula", { shell = "read -r '?Formula: ' name; [[ -n $name ]] && brew install --formula $name" }),
    item("install.cask", "Homebrew App", { shell = "read -r '?Cask: ' name; [[ -n $name ]] && brew install --cask $name" }),

    group("remove", "Remove", "trash"),
    item("remove.formula", "Homebrew Formula", { shell = "brew list --formula; read -r '?Remove formula: ' name; [[ -n $name ]] && brew uninstall --formula $name" }),
    item("remove.cask", "Homebrew App", { shell = "brew list --cask; read -r '?Remove cask: ' name; [[ -n $name ]] && brew uninstall --cask $name" }),
    item("remove.cleanup", "Homebrew Cleanup", { shell = "brew cleanup --prune=all" }),
  },
}
