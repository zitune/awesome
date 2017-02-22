--------------------------------
-- Standard awesome libraries --
--------------------------------
local awful, beautiful, gears, naughty, wibox = require("awful"), require("beautiful"), require("gears"), require("naughty"), require("wibox")
local string, tostring, os, capi              = string, tostring, os, {mouse = mouse, screen = screen}
require("awful.autofocus")


-- common function


function square_id_on_line(pos, move, lsize, csize)
   if not lsize then lsize = 3 end
   if not csize then csize = 3 end
   local line_index = math.floor(pos/lsize)
   if (pos%lsize == 0) then line_index = line_index - 1 end
   local res = (pos+move)%lsize
   local res_i = res
   if (res == 0) then
      res = (line_index*lsize)+lsize
   else
      res = (line_index*lsize)+res
   end
   
   --naughty.notify({text = " " .. pos .. move .. res_i .. res})
   return res
      
end
function square_id_on_col(pos, move, csize, lsize)
   if not lsize then lsize = 3 end
   if not csize then csize = 3 end
   local res = (pos+move*lsize)%(lsize*csize)
   if (res == 0) then res = lsize*csize end
   return res
end



function left(pos, l, c)
   return square_id_on_line(pos, -1, l)
end
function right(pos, l, c)
   return square_id_on_line(pos, 1, l)
end

function up(pos, l, c)
   return square_id_on_col(pos, -1, c, l)
end
function down(pos)
   return square_id_on_col(pos, 1, c, l)
end

function rleft(pos, l, c)
   return square_id_on_line(pos, -1, l) - pos
end
function rright(pos, l, c)
   return square_id_on_line(pos, 1, l) - pos
end

function rup(pos, l, c)
   return square_id_on_col(pos, -1, c, l) - pos
end
function rdown(pos)
   return square_id_on_col(pos, 1, c, l) - pos
end



modkey = "Mod4"
globalkeys = awful.util.table.join({},
   awful.key({modkey, "Control"}, "r",     awesome.restart),
   awful.key({modkey, "Control"}, "q",     awesome.quit),
   awful.key({modkey, "Shift"}, "Return",           function() awful.util.spawn("urxvtc", awful.screen.focused()) end),
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
   awful.key({modkey},
      "p",
      function ()
	 awful.util.spawn('/home/zitune/bin/dmenu_aliases.py')
   end),
   awful.key({modkey}, "F2",               function() awful.util.spawn('rofi -show run') end),
   awful.key({modkey}, "F3",               function() awful.util.spawn('rofi -show ssh') end),
   awful.key({modkey}, "j",                function() awful.util.spawn('rofi -show window') end),
   awful.key({modkey}, "Escape",           awful.tag.history.restore),
   awful.key({modkey}, "Left",    function() awful.client.focus.bydirection("left") end),
   awful.key({modkey}, "Right",   function() awful.client.focus.bydirection("right") end),
   awful.key({modkey}, "Up",      function() awful.client.focus.bydirection("up") end),
   awful.key({modkey}, "Down",    function() awful.client.focus.bydirection("down") end),
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
-- Move client through tags 
globalkeys = awful.util.table.join(globalkeys,
				   awful.key({ modkey, "Shift", "Control"}, "Left",
				      function ()
					 if client.focus then
					    local curidx = awful.tag.getidx()
					    client.focus:move_to_tag(awful.screen.focused().tags[left(curidx)])
					    awful.tag.viewidx(rleft(curidx))
					 end
				   end),
				   
				   awful.key({ modkey, "Shift", "Control" }, "Right",
				      function (c)
					 if client.focus then
					    local curidx = awful.tag.getidx()
					    client.focus:move_to_tag(awful.screen.focused().tags[right(curidx)])
					    awful.tag.viewidx(rright(curidx))
					 end
				   end),
				   awful.key({ modkey, "Shift", "Control" }, "Up",
				      function (c)
					 local curidx = awful.tag.getidx()
					 client.focus:move_to_tag(client.focus.screen.tags[up(curidx)])
					 awful.tag.viewidx(rup(curidx))
					 
				   end),
				   awful.key({ modkey, "Shift", "Control" }, "Down",
				      function (c)
					 local curidx = awful.tag.getidx()
					 client.focus:move_to_tag(client.focus.screen.tags[down(curidx)])
					 awful.tag.viewidx(rdown(curidx))
					 
				   end),
				   awful.key({ modkey, "Shift"}, "space",
				      function (c)
					 
					 awful.client.movetoscreen()
end))
-- move thru tags
globalkeys = awful.util.table.join(globalkeys,
				   
				   awful.key({ modkey, "Shift"   }, "Left", function ()
					 local screen = mouse.screen
					 curidx = awful.tag.getidx(awful.tag.selected(screen))
					 awful.tag.viewidx(rleft(curidx))
				   end),
				   awful.key({ modkey, "Shift"   }, "Right", function ()
					 local screen = mouse.screen
					 curidx = awful.tag.getidx(awful.tag.selected(screen))
					 awful.tag.viewidx(rright(curidx))
				   end),
				   awful.key({ modkey, "Shift"   }, "Up", function () awful.tag.viewidx(-3) end),
				   awful.key({ modkey, "Shift"   }, "Down", function () awful.tag.viewidx(3) end),
				   awful.key({ modkey, "Shift"   }, "Escape", awful.tag.history.restore))

for i = 1, 9
do
   globalkeys = awful.util.table.join(globalkeys,
				      
				      awful.key({modkey, "Shift"}, "#" .. i + 9,            function() awful.screen.focused().tags[i]:view_only() end),
				      awful.key({modkey, "Control"}, "#" .. i + 9,   function() if client.focus then client.focus:move_to_tag(client.focus.screen.tags[i]) end end))
end
root.keys(globalkeys)

clientkeys = awful.util.table.join({},
   awful.key({modkey}, "f",           function(c) c.fullscreen = not c.fullscreen end),
   awful.key({modkey}, "x",  function(c) c:kill() end))




-- move thru screen


clientkeys = awful.util.table.join(clientkeys,
				   awful.key({"Mod1", "Control"}, "Down",  function(c)
					 if (client.focus.screen.index > 1)
					 then
					    awful.client.movetotag(awful.tag.selected(client.focus.screen.index - 1))
					 end
				   end),
				   awful.key({"Mod1", "Control"}, "Up",  function(c)
					 if (client.focus.screen.index < screen.count())
					 then
					    awful.client.movetotag(awful.tag.selected(client.focus.screen.index + 1))
					 end
				   end),
				   awful.key({"Mod1", "Shift"}, "Down",  function(c)
					 if (client.focus.screen.index > 1)
					 then
					    awful.screen.focus(client.focus.screen.index - 1)
					 end
				   end),
				   awful.key({"Mod1", "Shift"}, "Up",  function(c)
					 if (client.focus.screen.index < screen.count())
					 then
					    awful.screen.focus(client.focus.screen.index + 1)
					 end
				   end)
)
   


clientbuttons = awful.button({modkey}, 1,     function(c) awful.mouse.client.move(c) end)
