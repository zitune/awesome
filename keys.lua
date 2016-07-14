-- Controls
modkey = "Mod4"
dmenuoptions = '-nb "#000000" -sb "#000000" -sf "#ffffff" -nf "#444444" -fn "-8-courier-*-*-*-*-10-*-*-*-*-*-*-*"'

function expose()
   local t = awful.tag.new({""}, mouse.screen, awful.layout.suit.fair)[1]
   awful.tag.viewonly(t, mouse.screen)
   for _, c in pairs(client.get(scr)) do awful.client.toggletag(t, c) end

   local function restore()
      keygrabber.stop()
      mousegrabber.stop()
      t.activated = false
   end

   keygrabber.run(function(mod, key, event)
		     if event ~= "press" then return true end
		     if key == "Escape" then
			awful.tag.history.restore()
			restore()
			return false
		     end
		     if key == "Return" then
			awful.tag.viewonly(awful.client.focus.history.get(mouse.screen, 0):tags()[1])
			restore()
			return false
		     end
		     if key == "Left" or key == "Right" or key == "Up" or key == "Down" then awful.client.focus.bydirection(key:lower()) end
		     if key == "k" == true then client.focus:kill()  end
		     return true
		  end)
   mousegrabber.run(function(mouse)
		       if mouse.buttons[1] == true then
			  awful.tag.viewonly(awful.mouse.client_under_pointer():tags()[1])
			  restore()
			  return false
		       end
		       return true
		    end, "fleur")
end

globalkeys = awful.util.table.join({},
				   awful.key({modkey, "Control"}, "r",		awesome.restart),
				   awful.key({modkey, "Control"}, "q",		awesome.quit),
				   awful.key({modkey}, "Return",		function() awful.util.spawn("urxvtc") end),
				   awful.key({modkey}, "e",			function () awful.util.spawn_with_shell("emacsclient -c > /dev/null") end),
				   awful.key({modkey}, "F1",			function()
										   local nn = awful.util.pread("echo '' | dmenu -p 'Name' " .. dmenuoptions)
										   nn = string.sub(nn, 1, #nn - 1)
										   if nn ~= "" then awful.tag.selected().name = awful.tag.getidx(awful.tag.selected()) .. ":" .. nn
										   else awful.tag.selected().name = awful.tag.getidx(awful.tag.selected()) end
										end),
				   awful.key({modkey}, "F2",			function () awful.util.spawn('dmenu_run -p "Run" ' .. dmenuoptions) end),
				   awful.key({modkey}, "F3",			function () awful.util.spawn(confpath .. 'rssh.sh') end),
				   awful.key({modkey}, "F4",			function () awful.util.spawn(confpath .. 'ssh.sh') end),
				   awful.key({modkey}, "F5",			function () awful.util.spawn(confpath .. 'screen.sh') end),
				   awful.key({modkey}, "j",			function()
										   local i = awful.util.pread("echo '' | dmenu -p 'Go to tag' " .. dmenuoptions)
										   i = tonumber(string.sub(i, 1, #i - 1))
										   if i then awful.tag.viewonly(tags[mouse.screen][i]) end
										end),
				   awful.key({modkey}, "s",			function () awful.screen.focus(screen.count() - mouse.screen + 1) end),
				   awful.key({modkey}, "Left",			awful.tag.viewprev),
				   awful.key({modkey}, "Right",			awful.tag.viewnext),
				   awful.key({modkey}, "Escape",			awful.tag.history.restore),
				   awful.key({modkey, "Shift"}, "e",		expose),
				   awful.key({modkey, "Shift"}, "Left",		function() awful.client.focus.bydirection("left") end),
				   awful.key({modkey, "Shift"}, "Right",	function() awful.client.focus.bydirection("right") end),
				   awful.key({modkey, "Shift"}, "Up",		function() awful.client.focus.bydirection("up") end),
				   awful.key({modkey, "Shift"}, "Down",		function() awful.client.focus.bydirection("down") end),
				   awful.key({modkey}, "Tab",			function ()
										   awful.client.focus.byidx(1)
										   if client.focus then client.focus:raise() end
										end),
				   awful.key({modkey, "Shift"}, "Tab",		function ()
										   awful.client.focus.byidx(-1)
										   if client.focus then client.focus:raise() end
										end),
				   awful.key({modkey, "Control"}, "Left",	function () awful.client.swap.bydirection("left") end),
				   awful.key({modkey, "Control"}, "Right",	function () awful.client.swap.bydirection("right") end),
				   awful.key({modkey, "Control"}, "Up",		function () awful.client.swap.bydirection("up") end),
				   awful.key({modkey, "Control"}, "Down",	function () awful.client.swap.bydirection("down") end),
				   awful.key({modkey}, "space",			function () awful.layout.inc(layouts, 1) end))

for i = 1, 9
do
   globalkeys = awful.util.table.join(globalkeys,
				      awful.key({modkey}, "#" .. i + 9,			function() awful.tag.viewonly(tags[mouse.screen][i]) end),
				      awful.key({modkey, "Shift"}, "#" .. i + 9,	function() if client.focus then awful.client.movetotag(tags[client.focus.screen][i]) end end),
				      awful.key({modkey, "Control"}, "#" .. i + 9,	function() tags[mouse.screen][i].selected = not tags[mouse.screen][i].selected end))
end
root.keys(globalkeys)

clientkeys = awful.util.table.join({},
				   awful.key({modkey}, "f",		function (c) c.fullscreen = not c.fullscreen end),
				   awful.key({modkey, "Shift"}, "c",	function (c) c:kill() end),
				   awful.key({modkey, "Shift"}, "s",	function (c) awful.client.movetotag(awful.tag.selected(screen.count() - mouse.screen + 1)) end))
clientbuttons = awful.button({modkey}, 1, function(c) awful.mouse.client.move(c) end)
