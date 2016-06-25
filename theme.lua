-- Should only change this part
font			= "SourceCodePro 9"

bg_normal		= "#000000"
bg_focus		= "#000000"
bg_urgent		= "#ff0000"
bg_minimize		= "#444444"

fg_normal		= "#999999"
fg_focus		= "#ffffff"
fg_urgent		= "#ffffff"
fg_minimize		= "#000000"

border_width		= "1"
border_normal		= "#444444"
border_focus		= "#ffffff"
border_marked		= "#990000"

wallpaper		= "/home/hybris/.wallpaper"
for s = 1, screen.count() do gears.wallpaper.maximized(wallpaper, s, "#000000") end


-- Should not be changed from here
-- Theme
theme = {}

-- Font and color
theme.font          = font
theme.bg_normal     = bg_normal
theme.bg_focus      = bg_focus
theme.bg_urgent     = bg_urgent
theme.bg_minimize   = bg_minimize
theme.fg_normal     = fg_normal
theme.fg_focus      = fg_focus
theme.fg_urgent     = fg_urgent
theme.fg_minimize   = fg_minimize
theme.border_width  = border_width
theme.border_normal = border_normal
theme.border_focus  = border_focus
theme.border_marked = border_marked

return theme
