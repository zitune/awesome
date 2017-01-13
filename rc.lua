-- Standard awesome libraries
awful		= require("awful")
awful.rules	= require("awful.rules")
beautiful	= require("beautiful")
gears		= require("gears")
naughty		= require("naughty")
wibox		= require("wibox")
require("awful.autofocus")
-- Expose like, remember to add "t.activated = false" in restore function
require("revelation")

-- Old expose function
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


-- Error handling
if awesome.startup_errors then naughty.notify({preset = naughty.config.presets.critical, title = "errors during startup", text = awesome.startup_errors}) end
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
					     if in_error then return end
					     in_error = true
					     naughty.notify({preset = naughty.config.presets.critical, title = "error", text = err})
					     in_error = false
					  end)
end

-- My conf
confpath = "/home/hybris/.config/awesome/"
naughty.config.presets.normal = {position = "top_right", bg = "#000000", fg = "#ffffff", border_color = "#ffffff"}
beautiful.init(confpath .. "theme.lua")
require("widgets")
require("keys")
require("display")
for s = 1, screen.count() do gears.wallpaper.fit("/home/hybris/.wallpaper", s, "#000000") end

-- Autorun
awful.util.spawn_with_shell("urxvtc -e '' 2> /dev/null || urxvtd > /tmp/urxvtd.log 2>&1")
awful.util.spawn_with_shell("xmodmap ~/.xmodmaprc")
awful.util.spawn_with_shell("emacsclient -e '()' > /dev/null 2>&1 || emacs --daemon > /tmp/emacs.log 2>&1")
awful.util.spawn_with_shell("killall xbindkeys 2> /dev/null      ; xbindkeys")
awful.util.spawn_with_shell("killall nm-applet 2> /dev/null      ; nm-applet")
awful.util.spawn_with_shell("killall pasystray 2> /dev/null      ; pasystray")
awful.util.spawn_with_shell("killall blueman-applet 2> /dev/null ; blueman-applet > /dev/null 2>&1")
awful.util.spawn_with_shell("killall conky 2> /dev/null          ; conky -q")
