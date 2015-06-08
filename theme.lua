-- Should only change this part
font			= "SourceCodePro 9"

bg_normal		= "#ffffff"
bg_focus		= "#ffffff"
bg_urgent		= "#ff0000"
bg_minimize		= "#444444"

fg_normal		= "#999999"
fg_focus		= "#000000"
fg_urgent		= "#000000"
fg_minimize		= "#000000"

border_width		= "1"
border_normal		= "#333333"
border_focus		= "#ffffff"
border_marked		= "#990000"

wallpaper		= "/home/hybris/Downloads/wallpaper"
icon_path		= "/usr/share/awesome/themes/default/"
for s = 1, screen.count() do gears.wallpaper.maximized(wallpaper, s, true) end


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

-- icons
theme.taglist_squares_sel	= icon_path .. "taglist/squarefw.png"
theme.taglist_squares_unsel	= icon_path .. "taglist/squarew.png"
theme.tasklist_floating_icon	= icon_path .. "tasklist/floatingw.png"
theme.menu_submenu_icon		= ""

theme.titlebar_close_button_normal
   = icon_path .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus
   = icon_path .. "titlebar/close_focus.png"
theme.titlebar_ontop_button_normal_inactive
   = icon_path .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive
   = icon_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active
   = icon_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active
   = icon_path .. "titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive
   = icon_path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive
   = icon_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active
   = icon_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active
   = icon_path .. "titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive
   = icon_path .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive
   = icon_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active
   = icon_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active
   = icon_path .. "titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive
   = icon_path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive
   = icon_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active
   = icon_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active
   = icon_path .. "titlebar/maximized_focus_active.png"

theme.layout_fairh	= icon_path .. "layouts/fairhw.png"
theme.layout_fairv	= icon_path .. "layouts/fairvw.png"
theme.layout_floating	= icon_path .. "layouts/floatingw.png"
theme.layout_magnifier	= icon_path .. "layouts/magnifierw.png"
theme.layout_max	= icon_path .. "layouts/maxw.png"
theme.layout_fullscreen	= icon_path .. "layouts/fullscreenw.png"
theme.layout_tilebottom	= icon_path .. "layouts/tilebottomw.png"
theme.layout_tileleft	= icon_path .. "layouts/tileleftw.png"
theme.layout_tile	= icon_path .. "layouts/tilew.png"
theme.layout_tiletop	= icon_path .. "layouts/tiletopw.png"
theme.layout_spiral	= icon_path .. "layouts/spiralw.png"
theme.layout_dwindle	= icon_path .. "layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

return theme
