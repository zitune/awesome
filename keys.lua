-- Desktop handling
addTags = {}
addTags[1] = 5
addTags[2] = 5

function addDesktop(sc, nb)
   tags[sc][nb] = tag({name = nb - 1 + screen.count() - mouse.screen})
   awful.layout.set(awful.layout.suit.fair, tags[sc][nb])
   tags[sc][nb].screen = sc
   tags_names[tags[sc][nb]] = ""
end

for i = 1, keynumber
do
   globalkeys =
      awful.util.table.join(globalkeys,
			    -- Show tag i (mod4 + #i)
			    awful.key({modkey}, "#" .. i + 9,
				      function()
					 if tags[mouse.screen][i + 1 - screen.count() + mouse.screen] then awful.tag.viewonly(tags[mouse.screen][i + 1 - screen.count() + mouse.screen]) end
				      end),
			    -- Show tag "fullscreen" (mod4 + `)
			    awful.key({modkey}, "`", function() awful.tag.viewonly(tags[screen.count()][1]) end),


			    -- Move client to tag i and show tag i (mod4 + shift + #i)
			    awful.key({modkey, "Shift"}, "#" .. i + 9,
				      function()
					 if client.focus and tags[client.focus.screen][i + 1 - screen.count() + client.focus.screen]
					 then awful.client.movetotag(tags[client.focus.screen][i + 1 - screen.count() + client.focus.screen]) end
				      end),
			    -- Move client to tag "fullscreen" and show tag "fullscreen" (mod4 + shift + `)
			    awful.key({modkey, "Shift"}, "`",
				      function()
					 if client.focus then awful.client.movetotag(tags[screen.count()][1]) end
				      end),

			    -- Move client to tag i (mod4 + control + #i)
			    awful.key({modkey, "Control"}, "#" .. i + 9,
				      function()
					 tags[mouse.screen][i + 1 - screen.count() + mouse.screen].selected = not tags[mouse.screen][i + 1 - screen.count() + mouse.screen].selected
				      end))
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
			 awful.key({modkey}, "Return",
				   function() awful.util.spawn(term) end),
			 -- Teardrop term (mod4 + shift + Enter)
			 awful.key({ modkey, "Shift" }, "Return",
				   function () teardrop(term, "bottom", "left", .90, 1, true) end),

			 -- Emacs (mod4 + e)
			 awful.key({modkey}, "e",
				   function () awful.util.spawn_with_shell(editor) end),
			 -- Teardrop emacs (mod4 + shift + e)
			 awful.key({ modkey, "Shift" }, "e",
				   function () teardrop(editor, "bottom", "right", .90, 1, true) end),

			 -- zlock (mod4 + z)
			 awful.key({modkey}, "z",
				   function () awful.util.spawn_with_shell(locker) end),

			 -- Better switch using revelation (mod4 + control + e).
			 awful.key({modkey, "Control"}, "e", expose),


			 -- Emacs awesome config (mod4 + a)
			 awful.key({modkey}, "a",
				   function () awful.util.spawn_with_shell(editor .. " " .. confpath .. "rcperso.lua") end),

			 -- Open URL from clipboard
			 awful.key({modkey}, "u", function ()
						     for url in string.gmatch(selection(), "https?://[%w-_%.%?%.:/%+=&]+") do awful.util.spawn_with_shell(scriptpath .. "url_sort.py '" .. url .. "'") end
						  end),


			 -- Test command
			 awful.key({modkey}, "b", function ()
						     local res = ""
						     for l in io.popen("cal"):lines() do res = string.gsub(res, '_^H', '') .. l .. "\n" end
						     print(res)
						     res = res:sub(1, #res - 1)
						     naughty.notify({text = res})
						  end),



			 --------------------
			 -- dmenu laucners --
			 --------------------

			 -- Application launcher (mod4 + f2)
			 awful.key({modkey}, "F2",
				   function () awful.util.spawn('dmenu_run -p "Run" -nb "#000" -nf "#fff" -sb "#fff" -sf "#000" -fn "' .. menufont .. '"') end),

			 -- ssh launcher(mod4 + shift + r)
			 awful.key({modkey, "Shift"}, "r",
				   function () awful.util.spawn(scriptpath .. 'ssh.sh') end),

			 -- rssh launcher launcher (mod4 + r)
			 awful.key({modkey}, "r",
				   function () awful.util.spawn(scriptpath .. 'rssh.sh') end),

			 -- screen launcher (mod4 + s)
			 awful.key({modkey, "Control"}, "s",
				   function () awful.util.spawn(scriptpath .. 'screen.sh') end),

			 -- Rename tag (mod4 + F1)
			 awful.key({modkey}, "F1",
				   function()
				      local i = awful.tag.getidx(awful.tag.selected())
				      if mouse.screen == screen.count() and i == 1 then return end
				      local nn = awful.util.pread("echo '' | dmenu -p 'Name' -nb '#000' -nf '#fff' -sb '#fff' -sf '#000' -fn '" .. menufont .. "'")
				      nn = string.sub(nn, 1, #nn - 1)
				      if nn == "\n" then nn = "" end
				      tags_names[tags[mouse.screen][i]] = nn
				   end),



			 -------------
			 -- Display --
			 -------------

			 -- show mails (mod4 + m)
			 awful.key({modkey}, "m",
				   function ()
				      local ret = show_mails()
				      if not ret then return end
				      ret.timeout = 5
				      naughty.notify(ret)
				   end),

			 -- Bar force shown (mod4 + shift + t)
			 awful.key({modkey, "Shift"}, "t",
				   function()
				      force[mouse.screen] = not force[mouse.screen]
				      if force[mouse.screen] then bottombox[mouse.screen].visible = true
				      else bottombox[mouse.screen].visible = false end
				   end),

			 -- Move to first screen (mod4 + shift + left)
			 awful.key({modkey}, "s",
				   function ()
				      awful.screen.focus(screen.count() - mouse.screen + 1)
				   end),

			 -- Switch notification on and off (mod4 + n)
			 awful.key({ modkey, "Control" }, "n",
				   function() notifications = not notifications end),



			 ----------
			 -- Tags --
			 ----------

			 -- Next tag (mod4 + left)
			 awful.key({modkey}, "Left", awful.tag.viewprev),
			 -- Previous tag (mod4 + right)
			 awful.key({modkey}, "Right", awful.tag.viewnext),
			 -- Last tag (mod4 + escape)
			 awful.key({modkey}, "Escape", awful.tag.history.restore),

 			 -- Add tag, go to it (mod4 + t)
			 awful.key({modkey}, "t",
				   function()
				      local j = 1
				      while tags[mouse.screen][j] ~= nil do j = j + 1 end
				      addDesktop(mouse.screen, j)
				      awful.tag.viewonly(tags[mouse.screen][j])
				   end),

 			 -- Add tag, stay on current (mod4 + ctrl + t)
			 awful.key({modkey, "Control"}, "t",
				   function()
				      local j = 1
				      local sc = mouse.screen
				      while tags[sc][j] ~= nil do j = j + 1 end
				      addDesktop(sc, j)
				   end),

			 -- Remove extra tags (mod4 + w)
			 awful.key({modkey}, "w",
				   function()
				      local sc = mouse.screen
				      local j = 1
				      while tags[sc][j] ~= nil do j = j + 1 end
				      j = j - 1
				      local deleted = true
				      while deleted and j > 2
				      do
					 deleted = awful.tag.delete(tags[sc][j])
					 if deleted then tags[sc][j] = nil end
					 j = j - 1
				      end
				   end),


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
			 -- Rotate windows counter-clockwise in current tag (mod4 + shift + j)
			 awful.key({modkey, "Shift"}, "j", function () awful.client.swap.byidx(-1) end),

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
			 awful.key({modkey}, "f",
				   function (c) c.fullscreen = not c.fullscreen end),

			 -- Kill the current window (mod4 + shift + k)
			 awful.key({modkey, "Shift"}, "c",
				   function (c) c:kill() end),

			 -- Move current window on the other screen (mod4 + control + shift + tab)
			 awful.key({modkey, "Shift"}, "s",
				   function (c)
				      local s = screen.count() - mouse.screen + 1
				      local t = awful.tag.selected(s)
				      awful.client.movetotag(t)
				   end))


clientbuttons =
   awful.util.table.join(
			 -- Move client (mod4 + left click)
			 awful.button({modkey}, 1,
				      function(c)
					 if awful.tag.selected(mouse.screen).name ~= "ALL" then awful.mouse.client.move(c)
					 else awful.tag.viewonly(c:tags()[2]) end
				      end),

			 -- Resize client (mod4 + middle click)
			 awful.button({modkey}, 2, awful.mouse.client.resize),

			 -- Switch threw tags (mod4 + wheel)
			 awful.button({modkey}, 4, awful.tag.viewprev),
			 awful.button({modkey}, 5, awful.tag.viewnext)
		      )



-- Set keys
root.keys(globalkeys)
