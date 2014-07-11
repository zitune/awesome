----------
-- Tags --
----------
tags		= {}
tags_names	= {}

local settings	= {}
settings[1]	=
   {{name	= "0",	layout = awful.layout.suit.max.fullscreen},
   {name	= "1",	layout = awful.layout.suit.max},
   {name	= "2",	layout = awful.layout.suit.fair},
   {name	= "3",	layout = awful.layout.suit.fair},
   {name	= "4",	layout = awful.layout.suit.fair},
   {name	= "5",	layout = awful.layout.suit.fair}}
settings[2]	=
   {{name	= "1",	layout = awful.layout.suit.max},
   {name	= "2",	layout = awful.layout.suit.fair},
   {name	= "3",	layout = awful.layout.suit.fair},
   {name	= "4",	layout = awful.layout.suit.fair},
   {name	= "5",	layout = awful.layout.suit.fair}}
settings[3]	=
   {{name	= "0",	layout = awful.layout.suit.max.fullscreen},
   {name	= "1",	layout = awful.layout.suit.fair}}


if screen.count() == 1
then
   -- One screen
   tags[1]	= {}
   for i, v in ipairs(settings[1])
   do
      tags[1][i] = tag({ name = v.name})
      awful.layout.set(v.layout, tags[1][i])
      tags[1][i].screen = 1
      tags_names[tags[1][i]] = ""
   end
   tags[1][1].selected = true
   tags_names[tags[1][2]] = "http"
   tags_names[tags[1][3]] = "mutt"
   tags_names[tags[1][4]] = "irc"
   tags_names[tags[1][5]] = "im"
else
   -- Dual screen
   for j = 1, screen.count()
   do
      tags[j] = {}
      for i, v in ipairs(settings[j + 1])
      do
	 tags[j][i] = tag({ name = v.name})
	 awful.layout.set(v.layout, tags[j][i])
	 tags[j][i].screen = j
	 tags[j][1].selected = true
	 tags_names[tags[j][i]] = ""
      end
   tags_names[tags[1][1]] = "http"
   tags_names[tags[1][2]] = "mutt"
   tags_names[tags[1][3]] = "irc"
   tags_names[tags[1][4]] = "im"
   end
end


-----------
-- Rules --
-----------
function max_tag(c)
   awful.tag.viewonly(tags[screen.count()][1])
   mouse.screen = screen.count()
end
awful.rules.rules = {
   {rule = {},
      properties =
	 {border_width = beautiful.border_width,
	 focus = true,
	 size_hints_honor = false,
	 keys = clientkeys,
	 buttons = clientbuttons}},
   {rule = {class = "URxvt"},		properties = {opacity = 1}},
   {rule = {class = "Emacs"},		properties = {opacity = 1}},
   {rule = {class = "Iceweasel"},	properties = {border_width = 0, tag = tags[1][3 - screen.count()], switchtotag = true}},
   {rule = {icon_name = "screen mutt"}, properties = {tag = tags[1][4 - screen.count()], switchtotag = true}},
   {rule = {icon_name = "screen im"},	properties = {tag = tags[1][6 - screen.count()], switchtotag = true}},
   {rule = {class = "Vlc"},		properties = {border_width = 0, tag = tags[screen.count()][1], switchtotag = true}},
   {rule = {class = "Xpdf"},		properties = {border_width = 0, tag = tags[screen.count()][1], switchtotag = true}},
   {rule = {class = "feh"},		properties = {border_width = 0, tag = tags[screen.count()][1], switchtotag = true}},
   {rule = {class = "Animate.im6"},	properties = {border_width = 0, tag = tags[screen.count()][1], switchtotag = true}},
   {rule = {name = "LibreOffice"},	properties = {border_width = 0, tag = tags[screen.count()][1], switchtotag = true}},
   {rule = {name = "Don't Starve"},	properties = {border_width = 0, tag = tags[screen.count()][1], switchtotag = true}},
}


----------
-- Bars --
----------
topbox[1] = awful.wibox({position = "top", screen = 1, height = 14})
topbox[1].visible = true
bottombox[1] = awful.wibox({position = "bottom", screen = 1, height = 14})
bottombox[1].visible = false
force = {}
force[1] = false

function dockshow(m)
   local i = mouse.screen
   if force[i] then return true end
   if m.y <= topbox[i].height then topbox[i].visible = true
   else topbox[i].visible = false end
   return true
end


-- Screen 1
topbox[1].widgets =
   {{
      -- Left hand widgets
      tagwidget[1],
      separator,
      mailswidget,
      separator,
      layout = awful.widget.layout.horizontal.leftright
   },
   -- Right hand widgets
   monitor,
   separator,
   clockwidget,
   separator,
   batterywidget,
   separator,
   taskwidget[1],
   widget({ type = "systray" }),
   layout = awful.widget.layout.horizontal.rightleft
}

bottombox[1].widgets =
   {{
      soundwidget,
      separator,
      memorywidget,
      separator,
      fswidget,
      separator,
      separator,
      tempwidget,
      separator,
      separator,
      networkwidget,
      separator,
      separator,
      loadwidget,
      layout = awful.widget.layout.horizontal.leftright
   },
   logs,
   layout = awful.widget.layout.horizontal.rightleft
}

monitorforce = false
monitor:buttons(awful.util.table.join(awful.button({ }, 1,
						   function ()
						      monitorforce = not monitorforce
						      if monitorforce
						      then
							 monitor.text = "<span color='" .. theme.fg_focus .. "'>☢</span>"
							 bottombox[1].visible = true
						      else
							 monitor.text = "<span color='" .. theme.fg_normal .. "'>☢</span>"
							 bottombox[1].visible = false
						      end
						   end)))

-- Screen 2
if screen.count() > 1
then
   topbox[2] = awful.wibox({position = "top", screen = 2, height = 14})
   topbox[2].widgets =
      {{
	 -- Left hand widgets
	 tagwidget[2],
	 layout = awful.widget.layout.horizontal.leftright
      },
      taskwidget[2],
      -- Right hand widgets
      clockwidget,
      layout = awful.widget.layout.horizontal.rightleft
   }
end
