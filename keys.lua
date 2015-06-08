-- Desktop handling
for i = 1, keynumber
do
   globalkeys =
      awful.util.table.join(globalkeys,
			    -- Show tag i (mod4 + #i)
			    awful.key({modkey}, "#" .. i + 9, function() awful.tag.viewonly(tags[mouse.screen][i]) end),
			    -- Move client to tag i(mod4 + shift + #i)
			    awful.key({modkey, "Shift"}, "#" .. i + 9, function() if client.focus then awful.client.movetotag(tags[client.focus.screen][i]) end end),
			    -- Select tag i (mod4 + control + #i)
			    awful.key({modkey, "Control"}, "#" .. i + 9, function() tags[mouse.screen][i].selected = not tags[mouse.screen][i].selected end))
end

-- keys
globalkeys =
   awful.util.table.join(globalkeys,
			 ---------------------
			 -- Awesome control --
			 ---------------------
			 -- Restart awesome (mod4 + control + r)
			 awful.key({modkey, "Control"}, "r", awesome.restart),
			 -- Quit awesome (mod4 + control + q)
			 awful.key({modkey, "Control"}, "q", awesome.quit),

			 ------------------
			 -- Direct calls --
			 -------------------
			 -- Term (mod4 + Enter)
			 awful.key({modkey}, "Return", function() awful.util.spawn(term) end),
			 -- Teardrop term (mod4 + shift + Enter)
			 awful.key({ modkey, "Shift" }, "Return", function () teardrop(term, "bottom", "left", .90, 1, true) end),
			 -- Emacs (mod4 + e)
			 awful.key({modkey}, "e", function () awful.util.spawn_with_shell(editor) end),
			 -- Teardrop emacs (mod4 + shift + e)
			 awful.key({ modkey, "Shift" }, "e", function () teardrop(editor, "bottom", "right", .90, 1, true) end),
			 -- zlock (mod4 + z)
			 awful.key({modkey}, "z", function () awful.util.spawn_with_shell(locker) end),
			 -- Better switch using revelation (mod4 + control + e).
			 awful.key({modkey, "Control"}, "e", expose),
			 -- Emacs awesome config (mod4 + a)
			 awful.key({modkey}, "a", function () awful.util.spawn_with_shell(editor .. " " .. confpath .. "rc.lua") end),

			 --------------------
			 -- dmenu laucners --
			 --------------------
			 -- Application launcher (mod4 + f2)
			 awful.key({modkey}, "F2", function () awful.util.spawn('dmenu_run -p "Run" ' .. dmenuoptions) end),
			 -- ssh launcher(mod4 + shift + r)
			 awful.key({modkey, "Shift"}, "r", function () awful.util.spawn(scriptpath .. 'ssh.sh') end),
			 -- rssh launcher launcher (mod4 + r)
			 awful.key({modkey}, "r", function () awful.util.spawn(scriptpath .. 'rssh.sh') end),
			 -- screen launcher (mod4 + s)
			 awful.key({modkey, "Control"}, "s", function () awful.util.spawn(scriptpath .. 'screen.sh') end),
			 -- Rename tag (mod4 + F1)
			 awful.key({modkey}, "F1",
				   function()
				      local nn = awful.util.pread("echo '' | dmenu -p 'Name' " .. dmenuoptions)
				      nn = string.sub(nn, 1, #nn - 1)
				      if nn ~= "" then awful.tag.selected().name = nn
				      else awful.tag.selected().name = awful.tag.getidx(awful.tag.selected()) end
				   end),
			 -- Rename tag (mod4 + F1)
			 awful.key({modkey}, "g",
				   function()
				      local i = awful.util.pread("echo '' | dmenu -p 'Go to tag' " .. dmenuoptions)
				      i = tonumber(string.sub(i, 1, #i - 1))
				      if i then awful.tag.viewonly(tags[mouse.screen][i]) end
				   end),

			 -------------
			 -- Display --
			 -------------
			 -- Bottombox force shown (mod4 + shift + t)
			 awful.key({modkey, "Shift"}, "t", function() bottombox[mouse.screen].visible = not bottombox[mouse.screen].visible end),
			 -- Move to first screen (mod4 + shift + left)
			 awful.key({modkey}, "s", function () awful.screen.focus(screen.count() - mouse.screen + 1) end),
			 -- Switch notification on and off (mod4 + n)
			 awful.key({ modkey, "Control" }, "n", function() notifications = not notifications end),

			 ----------
			 -- Tags --
			 ----------
			 -- Previous tag (mod4 + left)
			 awful.key({modkey}, "Left", awful.tag.viewprev),
			 -- Next tag (mod4 + right)
			 awful.key({modkey}, "Right", awful.tag.viewnext),
			 -- Last tag (mod4 + escape)
			 awful.key({modkey}, "Escape", awful.tag.history.restore),

			 -------------
			 -- Clients --
			 -------------
			 -- Switch to left task (mod4 + shift + left)
			 awful.key({modkey, "Shift"}, "Left", function() awful.client.focus.bydirection("left") end),
			 -- Switch to right task (mod4 + shift + right)
			 awful.key({modkey, "Shift"}, "Right", function() awful.client.focus.bydirection("right") end),
			 -- Switch to top task (mod4 + shift + up)
			 awful.key({modkey, "Shift"}, "Up", function() awful.client.focus.bydirection("up") end),
			 -- Switch to bottom task (mod4 + shift + down)
			 awful.key({modkey, "Shift"}, "Down", function() awful.client.focus.bydirection("down") end),
			 -- Switch to next task (mod2 + tab)
			 awful.key({modkey}, "Tab",
				   function ()
				      awful.client.focus.byidx(1)
				      if client.focus then client.focus:raise() end
				   end),
			 -- Switch to previous task (mod2 + shift + tab)
			 awful.key({modkey, "Shift"}, "Tab",
				   function ()
				      awful.client.focus.byidx(-1)
				      if client.focus then client.focus:raise() end
				   end),
			 -- Rotate windows clockwise in current tag (mod4 + j)
			 awful.key({modkey}, "j", function () awful.client.swap.byidx(1) end),
			 -- Rotate windows counter-clockwise in current tag (mod4 + k)
			 awful.key({modkey}, "k", function () awful.client.swap.byidx(-1) end),
			 -- Increasing size of the current window (mod4 + l)
			 awful.key({modkey}, "l", function () awful.tag.incmwfact(0.05) end),
			 -- Decreasing size of the current window (mod4 + shift + l)
			 awful.key({modkey, "Shift"}, "l", function () awful.tag.incmwfact(-0.05) end),
			 -- Rotate layout clockwise (mod4 + space)
			 awful.key({modkey}, "space", function () awful.layout.inc(layouts, 1) end),
			 -- Rotate layout counter-clockwise (mod4 + shift + space)
			 awful.key({modkey, "Shift"}, "space", function () awful.layout.inc(layouts, -1) end))


clientkeys =
   awful.util.table.join(clientkeys,
			 -- Toggle/untoggle full screen (mod4 + f)
			 awful.key({modkey}, "f", function (c) c.fullscreen = not c.fullscreen end),
			 -- Kill the current window (mod4 + shift + k)
			 awful.key({modkey, "Shift"}, "c", function (c) c:kill() end),
			 -- Move current window on the other screen (mod4 + shift + s)
			 awful.key({modkey, "Shift"}, "s", function (c) awful.client.movetotag(awful.tag.selected(screen.count() - mouse.screen + 1)) end))


clientbuttons =
   awful.util.table.join(
			 -- Move client (mod4 + left click)
			 awful.button({modkey}, 1, function(c) awful.mouse.client.move(c) end),
			 -- Resize client (mod4 + middle click)
			 awful.button({modkey}, 2, awful.mouse.client.resize),
			 -- Fullscreen client (zoom button click on RAT5)
			 awful.button({}, 12, function (c) c.fullscreen = not c.fullscreen end),
			 -- Switch threw tags (mod4 + wheel)
			 awful.button({modkey}, 4, awful.tag.viewprev),
			 awful.button({modkey}, 5, awful.tag.viewnext))

-- Set keys
root.keys(globalkeys)
