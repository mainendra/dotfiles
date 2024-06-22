-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'GruvboxDarkHard'
-- config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.cell_width = 0.9
config.font = wezterm.font({ family = 'JetBrainsMono Nerd Font', weight = 'Medium' })
config.font_size = 14.0
config.window_decorations = 'RESIZE'
config.enable_tab_bar = false
config.audible_bell = 'Disabled'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
