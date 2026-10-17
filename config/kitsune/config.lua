-- KitsuneLauncher config.
--
-- This file holds settings and nothing else. Rows live in two places, both using the
-- same contract -- a module returning `{ items = ..., providers = ... }`:
--
--   menus/     my own content, one file per top-level menu
--   plugins/   self-contained pieces, to share or delete whole
--   lua/       item.lua (the row constructors, and what fields a row may carry)
--              loader.lua (merges the two lists below)
--
-- Everything reloads on save, anywhere in the tree.
--
-- Every option Kitsune reads is listed below. Anything switched off is spelled `false`
-- rather than left out: an absent key and a disabled one look identical from here, and
-- only one of them is a decision someone made.

local load = require("loader")

return load {
  -- Which files supply the rows, and in what order. A node's position in the merged
  -- list is its sort key, so this list *is* the order of the top-level rows.
  menus   = { "root", "trigger", "style", "setup", "homebrew", "update", "system" },
  plugins = { "smart", "themes", "brew", "settings" },

  hotkeys = { { key = "space", mods = { "command" } } },

  -- Clipboard history: the `clipboard` menu (aliases: clip, history), newest first.
  -- Return re-copies an entry. Copies marked concealed or transient (password managers
  -- set this) are always skipped. `persist` writes it to disk and is opt-in on its own;
  -- turning it back off deletes the file.
  clipboard = { enabled = true, limit = 100, poll_interval = 1, persist = false },

  -- Path completion: a query starting `/` or `~` at the top level lists that directory.
  files = { enabled = true, show_hidden = false, limit = 40 },

  -- Positional shortcuts: the nth key activates the nth row, back row skipped.
  shortcuts = {
    enabled = true,
    hints = false,         -- no chord drawn on the right of each row
    mods = { "command" },
    keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
  },

  -- An empty `symbol` keeps the built-in glyph; `title` draws text beside it.
  menu_bar = { enabled = true, symbol = "", title = "" },

  -- Extra roots to scan for .app bundles, on top of /Applications,
  -- /System/Applications and ~/Applications. `depth` is components below a root.
  apps = { paths = {}, depth = 3 },

  -- Frecency: rows activated often, and recently, rank higher in *search* results. The
  -- order written in menus/ is never rearranged.
  ranking = { enabled = true, half_life = 14 * 24 * 3600, weight = 12 },

  -- `row_limit = 0` is no cap; `depth` is how far a drilldown search walks.
  search = { app_limit = 40, row_limit = 0, depth = 32, match_detail = true },

  -- Budget for Lua providers. `debounce = 0` fires on every keystroke.
  provider_limits = { timeout = 0.15, instructions = 1000000, debounce = 0 },

  -- Budget for `command = "..."` rows -- stricter, because it spawns a real process
  -- while you type. `login = true` picks up your own PATH; slower.
  commands = {
    timeout = 2,
    debounce = 0.15,
    max_rows = 200,
    max_bytes = 1048576,
    cache_size = 32,
    shell = "/bin/sh",
    login = false,
  },

  -- Quiet period after a config-file change before reloading.
  watch = { debounce = 0.08 },

  terminal = "ghostty",

  -- Off ------------------------------------------------------------------------
  -- The row that leaves a submenu. Off: Escape and Left already go back.
  back = false,

  -- Open as a bare search field, the way Spotlight does: root with nothing typed
  -- draws no list, and the first keystroke expands the card. Submenus unaffected.
  show_search_only = false,

  -- Modal navigation. When on, the panel opens in NORMAL mode: j/k move, i or a
  -- resumes typing, Escape goes insert -> normal.
  vim = false,

  -- Start at login. Can also be toggled from the menu bar, and this value wins the next
  -- time the config is saved.
  login_item = true,
}
