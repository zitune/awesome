-- ### Awesome control ###
-- | Key                | Action             |
-- | ------------------ | ------------------ |
-- | Mod4 + h           | Display this help  |
-- | Mod4 + Control + r | Restart awesome    |
-- | Mod4 + Control + q | Quit awesome       |
--
-- ### Tag Control ###
-- (#i between 1 and 9)
-- | Key                 | Action                        |
-- | ------------------- | ----------------------------- |
-- | Mod4 + #i           | Only show tag #i              |
-- | Mod4 + Shift + #i   | Move focused client to tag #i |
-- | Mod4 + Control + #i | Add tag #i to selected tags   |
--
-- ### Direct calls ###
-- | Key                  | Action                        |
-- | -------------------- | ----------------------------- |
-- | Mod4 + Enter         | Open terminal                 |
-- | Mod4 + Shift + Enter | Open teardropped terminal     |
-- | Mod4 + e             | Open emacs                    |
-- | Mod4 + Shift + e     | Open teardropped emacs        |
-- | Mod4 + Control + e   | Revelation (MacOS X's Expose) |
-- | Mod4 + a             | Open awesome configuration    |
--
-- ### Launchers dmenu ###
-- | Key                | Action                        |
-- | ------------------ | ----------------------------- |
-- | Mod4 + F2          | Application launcher          |
-- | Mod4 + Shift + r   | SSH launcher (user@host)      |
-- | Mod4 + r           | SSH launcher, as root (host)  |
-- | Mod4 + Control + s | Screen launcher (screen_name) |
-- | Mod4 + F1          | Rename tag (tag_name)         |
-- | Mod4 + g           | Go to tag (tag_number)        |
--
-- ### Display ###
-- | Key              | Action                |
-- | ---------------- | --------------------- |
-- | Mod4 + Shift + t | Display bottom box    |
-- | Mod4 + s         | Switch screen         |
-- | Mod4 + n         | Display notifications |
--
-- ### Tags ###
-- | Key          | Action                            |
-- | ------------ | --------------------------------- |
-- | Mod4 + Left  | Switch to previous tag            |
-- | Mod4 + Right | Switch to next tag                |
-- | Mod4 + Esc   | Switch to previously selected tag |
--
-- ### Clients ###
-- | Key                  | Action                                      |
-- | -------------------- | ------------------------------------------- |
-- | Mod4 + Shift + Left  | Switch to left client                       |
-- | Mod4 + Shift + Right | Switch to right client                      |
-- | Mod4 + Shift + Up    | Switch to top client                        |
-- | Mod4 + Shift + Down  | Switch to bottom client                     |
-- | Mod4 + Tab)          | Switch to next client                       |
-- | Mod4 + Shift + Tab   | Switch to previous client                   |
-- | Mod4 + j             | Switch current and next client position     |
-- | Mod4 + k             | Switch current and previous client position |
-- | Mod4 + l             | Increasing size of the current window       |
-- | Mod4 + Shift + l     | Decreasing size of the current window       |
-- | Mod4 + Space         | Use next layout                             |
-- | Mod4 + Shift + Space | Use previous layout                         |
-- | Mod4 + f             | Full screen                                 |
-- | Mod4 + Shift + c     | Kill the current client                     |
-- | Mod4 + Shift + s     | Move current client on the other screen     |
-- | Mod4 + Left Click    | Move client (drag and drop)                 |
-- | Mod4 + Middle Click  | Resize client (mod4 + middle click)         |
-- | Mod4 + Wheel         | Switch threw tags                           |
-- | Zoom Click           | Fullscreen client (on RAT5)                 |

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
			 awful.key({modkey}, "h",            function() awful.util.spawn(term .. " -e " .. scriptpath .. "help.sh") end),
			 awful.key({modkey, "Control"}, "r", awesome.restart),
			 awful.key({modkey, "Control"}, "q", awesome.quit),

			 awful.key({modkey}, "Return",            function() awful.util.spawn(term) end),
			 awful.key({ modkey, "Shift" }, "Return", function () teardrop(term, "bottom", "left", .90, 1, true) end),
			 awful.key({modkey}, "e",                 function () awful.util.spawn_with_shell(editor) end),
			 awful.key({ modkey, "Shift" }, "e",      function () teardrop(editor, "bottom", "right", .90, 1, true) end),
			 awful.key({modkey, "Control"}, "e",      expose),
			 awful.key({modkey}, "a",                 function () awful.util.spawn_with_shell(editor .. " " .. confpath .. "rc.lua") end),

			 awful.key({modkey}, "F2",           function () awful.util.spawn('dmenu_run -p "Run" ' .. dmenuoptions) end),
			 awful.key({modkey, "Shift"}, "r",   function () awful.util.spawn(scriptpath .. 'ssh.sh') end),
			 awful.key({modkey}, "r",            function () awful.util.spawn(scriptpath .. 'rssh.sh') end),
			 awful.key({modkey, "Control"}, "s", function () awful.util.spawn(scriptpath .. 'screen.sh') end),
			 awful.key({modkey}, "F1",           function()
								local nn = awful.util.pread("echo '' | dmenu -p 'Name' " .. dmenuoptions)
								nn = string.sub(nn, 1, #nn - 1)
								if nn ~= "" then awful.tag.selected().name = nn
								else awful.tag.selected().name = awful.tag.getidx(awful.tag.selected()) end
							     end),
			 awful.key({modkey}, "g",            function()
								local i = awful.util.pread("echo '' | dmenu -p 'Go to tag' " .. dmenuoptions)
								i = tonumber(string.sub(i, 1, #i - 1))
								if i then awful.tag.viewonly(tags[mouse.screen][i]) end
							     end),

			 awful.key({modkey, "Shift"}, "t",     function() bottombox[mouse.screen].visible = not bottombox[mouse.screen].visible end),
			 awful.key({modkey}, "s",              function () awful.screen.focus(screen.count() - mouse.screen + 1) end),
			 awful.key({ modkey, "Control" }, "n", function() notifications = not notifications end),

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
			 awful.button({}, 12,      function (c) c.fullscreen = not c.fullscreen end),
			 awful.button({modkey}, 4, function(c) awful.tag.viewprev() end),
			 awful.button({modkey}, 5, function(c) awful.tag.viewnext() end))

root.keys(globalkeys)
