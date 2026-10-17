-- KitsuneLauncher theme.
-- Reloads on save, in a restricted Lua state that can only restyle the panel.
-- Layout is native, so this token set is the whole appearance surface: if a value
-- is not here, it is not hardcoded somewhere else — file it as a missing token.

return {
  -- Colour scheme. Seeds bg/surface/fg/fg_muted/accent/border/selection_bg from an
  -- external scheme file; anything you set below still overrides it.
  --   "auto"            follow ~/.config/theme (so `set-theme` retints this too)
  --   "kanagawa"        a name, searched in this order:
  --                       ~/.config/kitsune/themes/<name>.{toml,yaml,yml,conf,theme}
  --                       ~/omarchy/themes/<name>/colors.toml
  --                       ~/.config/{kitty,ghostty,btop}/themes/<name>
  --   "~/path/to/scheme.yaml"   an explicit file
  -- Formats: Base16 YAML (base00-base0F), Omarchy colors.toml, kitty .conf,
  -- ghostty, btop .theme. They are all flat key -> hex, so one reader takes them all.
  palette = "auto",
  -- border = "5fcfc9",
  -- Palette overrides. Uncomment to pin a role regardless of the palette; with all
  -- of them commented out the palette above is fully in charge.
  -- bg = "F5C2D1",
  -- border = "7aa2f7",
  -- surface = "fad7e1",
  -- fg = "1a102b",
  -- fg_muted = "6c497d",
  -- accent = "3f539e",
  -- border = "774052",
  -- selection_bg = "5f73d3",
  -- selection_fg = "1a102b",
  --
  -- Alphas, composed onto the palette above
  bg_alpha = 0.97,
  border_alpha = 1,
  selection_alpha = 1,
  detail_alpha = 0.72,
  chevron_alpha = 0.9,
  divider_alpha = 0.10,
  blur = 0,

  -- Geometry
  radius = 10,
  row_radius =5,
  width = 350,
  max_height = 0.6,      -- fraction of the screen the panel may grow to
  border_width = 2,
  offset_y = 44,          -- above screen centre

  -- Spacing. Every value below is multiplied by spacing_scale.
  spacing_scale = 1.15,
  panel_padding = 14,
  padding_top = 14,
  padding_bottom = 14,
  padding_sides = 12,
  row_gap = 0,
  row_padding_x = 9,
  icon_slot = 30,
  icon_gap = 10,
  label_gap = 2,
  row_height = 46,
  row_height_detail = 60,
  divider_height = 12,
  header_gap = 4,
  selection_inset = 0,
  selection_bar = 0,

  -- Typography. One base size drives a proportional scale
  -- (caption .83, small .92, body 1.0, title 1.17, heading 1.33, icon 1.5).
  font = "JetBrainsMono Nerd Font",              -- empty means the system font
  font_size = 18,
  label_weight = "semibold",
  detail_weight = "regular",
  detail_mode = "never", -- "search" | "always" | "never"

  -- Screen tint behind the panel while it is open (tint = false to turn off).
  tint = {
    mode = "color",       -- "color" | "monochrome" (a neutral black dim)
    color = "bg",         -- a role (bg surface fg fg_muted accent border) or a hex value
    alpha = 0.55,         -- default 0.15 for color, 0.35 for monochrome
    blur = 0,           -- 0-1, how much of the blurred screen shows through
    screens = "panel",    -- "panel" | "all"
    fade = 0,
  },
}
