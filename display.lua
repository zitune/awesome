----------
-- Tags --
----------
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
   tleft:add(mwidget)
   -- Top right
   local tright = wibox.layout.fixed.horizontal()
   tright:add(mwidget)
   tright:add(mailswidget)
   tright:add(mwidget)
   tright:add(batterywidget)
   tright:add(mwidget)
   tright:add(clockwidget)
   if s == 1 then
      tright:add(mwidget)
      tright:add(wibox.widget.systray())
      tright:add(rwidget)
   else
      tright:add(rwidget)
   end
   -- Topbox
   topbox[s] = awful.wibox({position = "top", screen = s, height = 14})
   local tlayout = wibox.layout.align.horizontal()
   tlayout:set_left(tleft)
   tlayout:set_middle(taskwidget[s])
   tlayout:set_right(tright)
   topbox[s]:set_widget(tlayout)

   -- Bottom left
   local bleft = wibox.layout.fixed.horizontal()
   bleft:add(lwidget)
   bleft:add(tempwidget)
   bleft:add(mwidget)
   bleft:add(fswidget)
   bleft:add(mwidget)
   bleft:add(memorywidget)
   bleft:add(mwidget)
   bleft:add(loadwidget)
   bleft:add(mwidget)
   bleft:add(networkwidget)
   bleft:add(rwidget)
   -- Bottom right
   local bright = wibox.layout.fixed.horizontal()
   bright:add(lwidget)
   bright:add(logs)
   bright:add(rwidget)
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
			 elseif not c.size_hints.user_position and not c.size_hints.program_position then
			    awful.placement.no_offscreen(c)
			 end
		      end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
