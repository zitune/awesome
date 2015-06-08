----------
-- Tags --
----------
-- for s = 1, screen.count() do tags[s] = awful.tag({1, 2, 3, 4, 5, 6, 7, 8, 9}, s, layouts[1]) end
for s = 1, screen.count() do tags[s] = awful.tag(range(20), s, layouts[1]) end

-----------
-- Rules --
-----------
awful.rules.rules = {
   {rule = {},
      properties =
	 {border_width = beautiful.border_width,
	 focus = awful.client.focus.filter,
	 size_hints_honor = false,
	 keys = clientkeys,
	 buttons = clientbuttons}},
}

----------
-- Bars --
----------
for s = 1, screen.count() do
   -- Top left
   local tleft = wibox.layout.fixed.horizontal()
   tleft:add(lwidget)
   tleft:add(awful.widget.taglist(s, awful.widget.taglist.filter.noempty))
   tleft:add(rwidget)
   tleft:add(lwidget)
   -- Top right
   local tright = wibox.layout.fixed.horizontal()
   tright:add(rwidget)
   tright:add(mailswidget)
   tright:add(batterywidget)
   tright:add(clockwidget)
   tright:add(lwidget)
   tright:add(wibox.widget.systray())
   tright:add(rwidget)
   -- Topbox
   topbox[s] = awful.wibox({position = "top", screen = s, height = 14})
   local tlayout = wibox.layout.align.horizontal()
   tlayout:set_left(tleft)
   tlayout:set_middle(taskwidget[s])
   tlayout:set_right(tright)
   topbox[s]:set_widget(tlayout)

   -- Bottom left
   local bleft = wibox.layout.fixed.horizontal()
   bleft:add(tempwidget)
   bleft:add(fswidget)
   bleft:add(memorywidget)
   bleft:add(loadwidget)
   -- Bottom right
   local bright = wibox.layout.fixed.horizontal()
   bright:add(logs)
   -- Bottombox
   bottombox[s] = awful.wibox({position = "bottom", screen = s, height = 14})
   local blayout = wibox.layout.align.horizontal()
   blayout:set_left(bleft)
   blayout:set_right(bright)
   bottombox[s]:set_widget(blayout)
end

-------------
-- Signals --
-------------
client.connect_signal("manage",
		      function (c, startup)
			 -- Focus
			 c:connect_signal("mouse::enter",
					  function(c)
					     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
						and awful.client.focus.filter(c) then
						client.focus = c
					     end
					  end)
			 -- Smart positon
			 if not startup then
			    if not c.size_hints.user_position and not c.size_hints.program_position then
			       awful.placement.no_overlap(c)
			       awful.placement.no_offscreen(c)
			    end
			 -- Prevent clients from being unreachable after screen count change
			 elseif not c.size_hints.user_position and not c.size_hints.program_position then
			    awful.placement.no_offscreen(c)
			 end
		      end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
