----------
-- Tags --
----------
tags, layouts = {}, {awful.layout.suit.fair, awful.layout.suit.max}
for s = 1, screen.count() do tags[s] = awful.tag({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42}, s, layouts[1]) end

-----------
-- Rules --
-----------
awful.rules.rules = {{rule = {},
      properties =
	 {border_width = beautiful.border_width,
	 focus = awful.client.focus.filter,
	 size_hints_honor = false,
	 keys = clientkeys,
	 buttons = clientbuttons}}}

----------
-- Bars --
----------
topbox = {}
for s = 1, screen.count() do
   -- Top left
   local left = wibox.layout.fixed.horizontal()
   left:add(awful.widget.taglist(s, awful.widget.taglist.filter.noempty))
   left:add(sep)
   -- Top right
   local right = wibox.layout.fixed.horizontal()
   if s == 1 then
      right:add(sep)
      right:add(mailwidget)
      right:add(wibox.widget.systray())
      right:add(sep)
      right:add(tempwidget)
      right:add(batterywidget)
   end
   right:add(sep)
   right:add(clockwidget)

   -- Topbox
   topbox[s] = awful.wibox({position = "top", screen = s, height = 14})
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left)
   layout:set_middle(awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, nil))
   layout:set_right(right)
   topbox[s]:set_widget(layout)
end

-------------
-- Signals --
-------------
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
