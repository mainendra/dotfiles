-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.disable_default_key_bindings = true -- disable default keys to support ctrl+shift+6 to switch buffers
config.color_scheme = 'GruvboxDarkHard'
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

config.keys = {
    -- paste from the clipboard
    { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
    -- new window
    { key = 'n', mods = 'CMD', action = wezterm.action.SpawnWindow },
}

-- theme
config.color_scheme = 'GruvboxDarkHard'

-- and finally, return the configuration to wezterm
return config
