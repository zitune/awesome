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
modkey = "Mod4"
globalkeys = awful.util.table.join({},
           awful.key({modkey, "Control"}, "r",     awesome.restart),
           awful.key({modkey, "Control"}, "q",     awesome.quit),
           awful.key({modkey}, "Return",           function() awful.util.spawn("urxvtc") end),
           awful.key({modkey}, "e",                function() awful.util.spawn_with_shell("emacsclient -c > /dev/null") end),
           awful.key({modkey}, "F1",               function() awful.prompt.run({prompt = "Name: ",
                                                                                textbox = mouse.screen.prompt.widget,
                                                                                exe_callback = function(input)
                                                                                   if input ~= "" then
                                                                                      awful.tag.selected().name = awful.tag.getidx(awful.tag.selected())..":"..input
                                                                                   else
                                                                                      awful.tag.selected().name = awful.tag.getidx(awful.tag.selected())
                                                                                   end
                                                                                end}) end),
           awful.key({modkey}, "F2",               function() awful.util.spawn('rofi -show run') end),
           awful.key({modkey}, "F3",               function() awful.util.spawn('rofi -show ssh') end),
           awful.key({modkey}, "j",                function() awful.util.spawn('rofi -show window') end),
           awful.key({modkey}, "s",                function() awful.screen.focus(screen.count() - mouse.screen.index + 1) end),
           awful.key({modkey}, "Left",             awful.tag.viewprev),
           awful.key({modkey}, "Right",            awful.tag.viewnext),
           awful.key({modkey}, "Escape",           awful.tag.history.restore),
           awful.key({modkey, "Shift"}, "Left",    function() awful.client.focus.bydirection("left") end),
           awful.key({modkey, "Shift"}, "Right",   function() awful.client.focus.bydirection("right") end),
           awful.key({modkey, "Shift"}, "Up",      function() awful.client.focus.bydirection("up") end),
           awful.key({modkey, "Shift"}, "Down",    function() awful.client.focus.bydirection("down") end),
           awful.key({modkey}, "Tab",              function()
                                                      awful.client.focus.byidx(1)
                                                      if client.focus then client.focus:raise() end
                                                   end),
           awful.key({modkey, "Shift"}, "Tab",     function()
                                                      awful.client.focus.byidx(-1)
                                                      if client.focus then client.focus:raise() end
                                                   end),
           awful.key({modkey, "Control"}, "Left",  function() awful.client.swap.bydirection("left") end),
           awful.key({modkey, "Control"}, "Right", function() awful.client.swap.bydirection("right") end),
           awful.key({modkey, "Control"}, "Up",    function() awful.client.swap.bydirection("up") end),
           awful.key({modkey, "Control"}, "Down",  function() awful.client.swap.bydirection("down") end),
           awful.key({modkey}, "space",            function() awful.layout.inc({awful.layout.suit.fair, awful.layout.suit.max}, 1) end))

for i = 1, 9
do
   globalkeys = awful.util.table.join(globalkeys,
              awful.key({modkey}, "#" .. i + 9,            function() awful.screen.focused().tags[i]:view_only() end),
              awful.key({modkey, "Shift"}, "#" .. i + 9,   function() if client.focus then client.focus:move_to_tag(client.focus.screen.tags[i]) end end),
              awful.key({modkey, "Control"}, "#" .. i + 9, function() awful.tag.viewtoggle(awful.screen.focused().tags[i]) end))
end
root.keys(globalkeys)

clientkeys = awful.util.table.join({},
           awful.key({modkey}, "f",           function(c) c.fullscreen = not c.fullscreen end),
           awful.key({modkey, "Shift"}, "c",  function(c) c:kill() end),
           awful.key({modkey, "Shift"}, "s",  function(c) awful.client.movetotag(awful.tag.selected(screen.count() - mouse.screen.index + 1)) end))
clientbuttons = awful.button({modkey}, 1,     function(c) awful.mouse.client.move(c) end)

-------------
-- Display --
-------------
awful.screen.connect_for_each_screen(function(s)
   awful.tag({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42}, s, awful.layout.suit.fair)
   gears.wallpaper.fit("/home/hybris/.wallpaper", s, "#000000")
   s.prompt = awful.widget.prompt()
   s.topbox = awful.wibar({position = "top", screen = s, height = 14})
   s.topbox:setup({layout = wibox.layout.align.horizontal,
                   {layout = wibox.layout.fixed.horizontal,
                    s.prompt,
                    awful.widget.taglist(s, awful.widget.taglist.filter.noempty),
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
awful.util.spawn_with_shell("ps aux | grep batterymon | grep -v grep || python /home/hybris/dev/misc/batterymon-clone/batterymon -t 24x24_wide")
