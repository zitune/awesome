--------------------------------
-- Standard awesome libraries --
--------------------------------
local awful, beautiful, gears, naughty, wibox = require("awful"), require("beautiful"), require("gears"), require("naughty"), require("wibox")
local string, tostring, os, capi              = string, tostring, os, {mouse = mouse, screen = screen}
require("awful.autofocus")

--------------------
-- Error handling --
--------------------
if awesome.startup_errors then naughty.notify({preset = naughty.config.presets.critical, title = "errors during startup", text = awesome.startup_errors}) end
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
                                             if in_error then return end
                                             in_error = true
                                             naughty.notify({preset = naughty.config.presets.critical, title = "error", text = err})
                                             in_error = false
                                          end)
end

-------------------
-- Basic theming --
-------------------
theme                                                                            = {}
theme.font                                                                       = "Ubuntu Mono 10"
theme.bg_normal, theme.bg_focus, theme.bg_urgent, theme.bg_minimize              = "#000000", "#000000", "#ff0000", "#444444"
theme.fg_normal, theme.fg_focus, theme.fg_urgent, theme.fg_minimize              = "#999999", "#ffffff", "#ffffff", "#000000"
theme.border_width, theme.border_normal, theme.border_focus, theme.border_marked = "1", "#444444", "#ffffff", "#990000"
naughty.config.presets.normal                                                    = {position = "top_right", bg = "#000000", fg = "#ffffff", border_color = "#ffffff"}
beautiful.init(theme)

----------
-- Keys --
----------
require("keys")

-------------
-- Display --
-------------
awful.screen.connect_for_each_screen(function(s)
      awful.tag({1,2,3,4,5,6,7,8,9}, s, awful.layout.suit.fair)
   gears.wallpaper.fit("/home/zitune/.wallpaper", s, "#000000")
   s.prompt = awful.widget.prompt()
   s.topbox = awful.wibar({position = "top", screen = s, height = 14})
   s.topbox:setup({layout = wibox.layout.align.horizontal,
                   {layout = wibox.layout.fixed.horizontal,
                    s.prompt,
                    awful.widget.taglist(s, awful.widget.taglist.filter.all),
                    wibox.widget.textbox(" | ")},
                   awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, nil),
                   {layout = wibox.layout.fixed.horizontal,
                    wibox.widget.textbox(" | "),
                    wibox.widget.systray(),
                    wibox.widget.textbox(" | "),
                    awful.widget.textclock("<span color='" .. theme.fg_focus .. "'>%d/%m/%Y %R</span>")}})
end)

awful.rules.rules = {{rule = {}, properties = {border_width = beautiful.border_width, focus = awful.client.focus.filter, size_hints_honor = false, keys = clientkeys, buttons = clientbuttons}}}

client.connect_signal("manage",
          function (c, startup)
       -- Focus
       c:connect_signal("mouse::enter", function(c) if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then client.focus = c end end)
       -- No border if only one client
       local clients= {}
       for n,t in ipairs(awful.tag.selectedlist(c.screen)) do
          for m,c in ipairs(t:clients()) do table.insert(clients, c) end
       end
       -- if awful.layout.get(c.screen).name == "fullscreen" or awful.layout.get(c.screen).name == "max" or #clients < 1 then c.border_width = 0 end

       -- Smart positon
       if not startup then
          if not c.size_hints.user_position and not c.size_hints.program_position then
             awful.placement.no_overlap(c)
             awful.placement.no_offscreen(c)
          end
       -- Prevent clients from being unreachable after screen count change
       elseif not c.size_hints.user_position and not c.size_hints.program_position then awful.placement.no_offscreen(c) end
          end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-------------
-- Autorun --
-------------
awful.util.spawn_with_shell("urxvtc -e '' 2> /dev/null || urxvtd > /tmp/urxvtd.log 2>&1")
awful.util.spawn_with_shell("xmodmap ~/.xmodmaprc")
awful.util.spawn_with_shell("emacsclient -e '()' > /dev/null 2>&1 || emacs --daemon > /tmp/emacs.log 2>&1")
awful.util.spawn_with_shell("killall xbindkeys 2> /dev/null      ; xbindkeys")
awful.util.spawn_with_shell("killall nm-applet 2> /dev/null      ; nm-applet")
awful.util.spawn_with_shell("killall pasystray 2> /dev/null      ; pasystray")
awful.util.spawn_with_shell("killall blueman-applet 2> /dev/null ; blueman-applet > /dev/null 2>&1")
awful.util.spawn_with_shell("killall conky 2> /dev/null          ; conky -q")

