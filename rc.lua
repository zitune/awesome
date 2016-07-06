-- Standard awesome libraries
awful		= require("awful")
awful.rules	= require("awful.rules")
beautiful	= require("beautiful")
gears		= require("gears")
naughty		= require("naughty")
wibox		= require("wibox")
require("awful.autofocus")

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
for s = 1, screen.count() do gears.wallpaper.maximized("/home/hybris/.wallpaper", s, "#000000") end

-- Autorun
awful.util.spawn_with_shell("urxvtc -e '' 2> /dev/null || urxvtd > /tmp/urxvtd.log 2>&1")
awful.util.spawn_with_shell("killall xbindkeys 2> /dev/null ; xbindkeys")
awful.util.spawn_with_shell("xmodmap ~/.xmodmaprc")
awful.util.spawn_with_shell("emacsclient -e '()' > /dev/null 2>&1 || emacs --daemon -l ~/.emacs.d/editor.el > /tmp/emacs.log 2>&1")
awful.util.spawn_with_shell("nm-applet")
awful.util.spawn_with_shell("ps aux | grep pasystray | grep -v grep > /dev/null || pasystray")
awful.util.spawn_with_shell("blueman-applet > /dev/null 2>&1")
