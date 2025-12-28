--[[
  wezterm 是用以配置 wezterm 终端的配置文件,使用 lua 来进行配置.
  该文件需要写入到到对应目录下匹配的文件名称.
    Windows:
      ~/.wezterm.lua
    Linux:
      ${XDG_CONFIG_HOME}/wezterm/wezterm.lua
]]--

local wezterm = require('wezterm')

return {
  -- 主题
  color_scheme = "Catppuccin Mocha",

  -- 显示标题栏按钮（最常用）
  window_decorations = "INTEGRATED_BUTTONS | RESIZE",

  -- 窗口大小
  initial_cols = 100,
  initial_rows = 30,

  -- 字体
  font = wezterm.font("JetBrains Mono"),
  font_size = 12.5,

  -- 透明背景
  window_background_opacity = 1,

  -- 启用漂亮的标签栏
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,

  -- 加速渲染
  front_end = "WebGpu",

  -- 去掉不必要的空白
  adjust_window_size_when_changing_font_size = false,

  -- 快捷键
  keys = {
    -- 分屏（纵向）
    { key = "d", mods = "ALT", action = wezterm.action.SplitHorizontal({}) },

    -- 分屏（横向）
    { key = "d", mods = "ALT|SHIFT", action = wezterm.action.SplitVertical({}) },

    -- 面板切换：Alt + hjkl（Vim风格）
    { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },

    -- 新建 Tab
    { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

    -- 关闭 Tab
    { key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

    -- 命令面板
    { key = "p", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette },
  },

  -- Windows 下自动打开 WSL（如果需要）
  default_domain = "WSL:Ubuntu-24.04",
}
