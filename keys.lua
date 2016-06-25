-- Awesome controls
for i = 1, keynumber
do
   globalkeys =
      awful.util.table.join(globalkeys,
			    awful.key({modkey}, "#" .. i + 9,            function() awful.tag.viewonly(tags[mouse.screen][i]) end),
			    awful.key({modkey, "Shift"}, "#" .. i + 9,   function() if client.focus then awful.client.movetotag(tags[client.focus.screen][i]) end end),
			    awful.key({modkey, "Control"}, "#" .. i + 9, function() tags[mouse.screen][i].selected = not tags[mouse.screen][i].selected end))
end

globalkeys =
   awful.util.table.join(globalkeys,
			 awful.key({modkey, "Control"}, "r", awesome.restart),
			 awful.key({modkey, "Control"}, "q", awesome.quit),

			 awful.key({modkey}, "Return",            function() awful.util.spawn(term) end),
			 awful.key({ modkey, "Shift" }, "Return", function () teardrop(term, "bottom", "left", .90, 1, true) end),
			 awful.key({modkey}, "e",                 function () awful.util.spawn_with_shell(editor) end),
			 awful.key({modkey, "Shift" },  "e",      function () teardrop(editor, "bottom", "right", .90, 1, true) end),
--			 awful.key({modkey, "Comtrol"}, "Tab",    expose),
			 awful.key({modkey}, "a",                 function () awful.util.spawn_with_shell(editor .. " " .. confpath .. "rc.lua") end),

			 awful.key({modkey}, "F1",           function()
								local nn = awful.util.pread("echo '' | dmenu -p 'Name' " .. dmenuoptions)
								nn = string.sub(nn, 1, #nn - 1)
								if nn ~= "" then awful.tag.selected().name = nn
								else awful.tag.selected().name = awful.tag.getidx(awful.tag.selected()) end
							     end),
			 awful.key({modkey}, "F2",           function () awful.util.spawn('dmenu_run -p "Run" ' .. dmenuoptions) end),
			 awful.key({modkey}, "F3",           function () awful.util.spawn(confpath .. 'scripts/rssh.sh') end),
			 awful.key({modkey}, "F4",           function () awful.util.spawn(confpath .. 'scripts/ssh.sh') end),
			 awful.key({modkey}, "F5",           function () awful.util.spawn(confpath .. 'scripts/screen.sh') end),
			 awful.key({modkey}, "g",            function()
								local i = awful.util.pread("echo '' | dmenu -p 'Go to tag' " .. dmenuoptions)
								i = tonumber(string.sub(i, 1, #i - 1))
								if i then awful.tag.viewonly(tags[mouse.screen][i]) end
							     end),

			 awful.key({modkey, "Shift"}, "t",     function() bottombox[mouse.screen].visible = not bottombox[mouse.screen].visible end),
			 awful.key({modkey}, "s",              function () awful.screen.focus(screen.count() - mouse.screen + 1) end),

			 awful.key({modkey}, "Left",   awful.tag.viewprev),
			 awful.key({modkey}, "Right",  awful.tag.viewnext),
			 awful.key({modkey}, "Escape", awful.tag.history.restore),

			 awful.key({modkey, "Shift"}, "Left",  function() awful.client.focus.bydirection("left") end),
			 awful.key({modkey, "Shift"}, "Right", function() awful.client.focus.bydirection("right") end),
			 awful.key({modkey, "Shift"}, "Up",    function() awful.client.focus.bydirection("up") end),
			 awful.key({modkey, "Shift"}, "Down",  function() awful.client.focus.bydirection("down") end),
			 awful.key({modkey}, "Tab",            function ()
								  awful.client.focus.byidx(1)
								  if client.focus then client.focus:raise() end
							       end),
			 awful.key({modkey, "Shift"}, "Tab",   function ()
								  awful.client.focus.byidx(-1)
								  if client.focus then client.focus:raise() end
							       end),
			 awful.key({modkey}, "j",              function () awful.client.swap.byidx(1) end),
			 awful.key({modkey}, "k",              function () awful.client.swap.byidx(-1) end),
			 awful.key({modkey}, "l",              function () awful.tag.incmwfact(0.05) end),
			 awful.key({modkey, "Shift"}, "l",     function () awful.tag.incmwfact(-0.05) end),
			 awful.key({modkey}, "space",          function () awful.layout.inc(layouts, 1) end),
			 awful.key({modkey, "Shift"}, "space", function () awful.layout.inc(layouts, -1) end))


clientkeys =
   awful.util.table.join(clientkeys,
			 awful.key({modkey}, "f",          function (c) c.fullscreen = not c.fullscreen end),
			 awful.key({modkey, "Shift"}, "c", function (c) c:kill() end),
			 awful.key({modkey, "Shift"}, "s", function (c) awful.client.movetotag(awful.tag.selected(screen.count() - mouse.screen + 1)) end))


clientbuttons =
   awful.util.table.join(
			 awful.button({modkey}, 1, function(c) awful.mouse.client.move(c) end),
			 awful.button({modkey}, 2, awful.mouse.client.resize),
			 awful.button({}, 12,      function (c) c.fullscreen = not c.fullscreen end))

root.keys(globalkeys)
