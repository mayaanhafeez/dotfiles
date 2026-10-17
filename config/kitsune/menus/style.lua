-- How the Mac looks. plugins/settings.lua addresses the same panes as part of the full
-- System Settings tree; these are the handful worth a top-level row.
local item, group = require("item").item, require("item").group

return {
  items = {
    group("style", "Style", "paintpalette"),
    -- No URL reaches the Wallpaper pane, so this runs the overlay picker instead.
    -- AppleScript has no single-quoted strings, so the shell command has to arrive in
    -- double quotes -- hence the Lua long string rather than another layer of escapes.
    item("style.wallpaper", "Wallpaper", { applescript = [[do shell script "~/personal/wallpaper-overlay/wallpaper-pick"]] }),
    item("style.appearance", "Appearance", { url = "x-apple.systempreferences:com.apple.Appearance-Settings.extension" }),
    item("style.fonts", "Fonts", { open = "/System/Applications/Font Book.app" }),
    item("style.desktop", "Desktop & Dock", { url = "x-apple.systempreferences:com.apple.Desktop-Settings.extension" }),
    item("style.displays", "Displays", { url = "x-apple.systempreferences:com.apple.Displays-Settings.extension" }),
  },
}
