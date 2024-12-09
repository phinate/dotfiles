local wezterm = require("wezterm")

local config = {}

-- Check if config_builder is available and use it if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local fonts = {
	"ComicCodeLigatures Nerd Font",
}
local emoji_fonts = { "Apple Color Emoji", "Joypixels", "Twemoji", "Noto Color Emoji", "Noto Emoji" }

config.font = wezterm.font_with_fallback({ fonts[1], emoji_fonts[1], emoji_fonts[2] })
config.enable_scroll_bar = false
config.scrollback_lines = 10240
config.font_size = 13
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.automatically_reload_config = true
config.default_cursor_style = "BlinkingBar"
config.initial_cols = 132 
config.initial_rows = 43 
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.window_padding = {
	left = 30,
	right = 30,
	top = 30,
	bottom = 30,
}
config.window_frame = {
	font = wezterm.font({ family = "ComicCodeLigatures Nerd Font" }),
	active_titlebar_bg = "#1e1e1e",
	inactive_titlebar_bg = "#1e1e1e",
	font_size = 12.0,
}

-- Leader is CMD+a
config.leader = { key = 'a', mods = 'CMD', timeout_milliseconds = 1000 }

-- Key bindings
config.keys = {
  {
    mods   = "LEADER",
    key    = "-",
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "=",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    mods = "LEADER",
    key = "h",
    action = wezterm.action.ActivatePaneDirection("Left")
  },
  {
    mods = "LEADER",
    key = "j",
    action = wezterm.action.ActivatePaneDirection("Down")
  },
  {
    mods = "LEADER",
    key = "k",
    action = wezterm.action.ActivatePaneDirection("Up")
  },
  {
    mods = "LEADER",
    key = "l",
    action = wezterm.action.ActivatePaneDirection("Right")
  },
  {
    key = 'p',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

config.color_scheme = 'Gruvbox Dark (Gogh)'

config.colors = {
	tab_bar = {
		background = "#808080",
		active_tab = {
			bg_color = "#1e1e1e",
			fg_color = "#c8c8c8",
		},
		inactive_tab = {
			bg_color = "#30363d",
			fg_color = "#8b949e",
		},
		inactive_tab_hover = {
			bg_color = "#484f58",
			fg_color = "#b1bac4",
		},
		new_tab = {
			bg_color = "#30363d",
			fg_color = "#8b949e",
		},
		new_tab_hover = {
			bg_color = "#484f58",
			fg_color = "#b1bac4",
		},
	},
}

local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  pane:split { direction = "Bottom", size = 0.3 }
  window:perform_action(wezterm.action.ActivatePaneDirection("Up"), pane)

end)

config.native_macos_fullscreen_mode = false
config.show_update_window = false

-- Return the config table at the end
return config

