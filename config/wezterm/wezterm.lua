local wezterm = require 'wezterm'
local c = {}

if wezterm.config_builder then
  c = wezterm.config_builder()
end

-- 初始大小
c.initial_cols = 96
c.initial_rows = 24

-- theme
c.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte

-- 关闭时不进行确认
c.window_close_confirmation = 'NeverPrompt'

-- 字体
c.font = wezterm.font 'JetBrainsMono Nerd Font'

c.disable_default_key_bindings = true

return c
