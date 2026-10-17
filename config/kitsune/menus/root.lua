-- The top of the menu, and the app list.
--
-- `root` is the one node that must exist, and the only place a provider runs on every
-- keystroke at the top level -- that is what puts plugins/smart.lua's calculator and
-- conversions next to the app results.
local item = require("item").item

return {
  items = {
    item("root", "Go", { provider = "smart" }),
    item("apps", "Apps", { symbol = "square.grid.2x2", aliases = { "app", "applications" } }),
  },
}
