------------
-- Values --
------------
-- Useful aliases
modkey		= "Mod4"
confpath	= "/home/hybris/.config/awesome/"
scriptpath	= "/home/hybris/.scripts/"
term		= "urxvtc"
editor		= "emacsclient -c"
dmenufont	= "-*-courier-*-*-*-*-10-*-*-*-*-*-*-*"
dmenuoptions	= '-nb "#000000" -nf "#ffffff" -sb "#000000" -sf "#ffffff" -fn "' .. dmenufont .. '"'

-- Global values
layouts		= {awful.layout.suit.fair,
   awful.layout.suit.floating,
   awful.layout.suit.magnifier,
   awful.layout.suit.max,
   awful.layout.suit.spiral,
   awful.layout.suit.tile}
globalkeys	= {}
clientkeys	= {}
capi		= {
   awesome	= awesome,
   client	= client,
   dbus		= dbus,
   keygrabber	= keygrabber,
   image	= image,
   mouse	= mouse,
   tag		= tag,
   timer	= timer,
   screen	= screen,
   wibox	= wibox,
   widget	= widget}
keynumber	= 9

-- Needed values
topbox		= {}
bottombox	= {}
tags		= {}

-------------
-- Naughty --
-------------
naughty_fg	= "#ffffff"
naughty_bg	= "#000000"
naughty_bd	= "#ffffff"
-- default
naughty.config.presets.normal =
   {position	= "top_right",
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd}
-- Logs
naughty.config.presets.logs =
   {position	= "bottom_right",
   screen	= mouse.screen,
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd}
-- Toolbar
naughty.config.presets.toolbar =
   {position	= "bottom_left",
   screen	= mouse.screen,
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd}
-- Topbar
naughty.config.presets.topbar =
   {position	= "top_left",
   screen	= mouse.screen,
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd}

-------------
-- Autorun --
-------------
awful.util.spawn_with_shell("urxvtc -e '' || urxvtd")
awful.util.spawn_with_shell("killall xbindkeys ; xbindkeys -f " .. confpath.."etc/xbindkeysrc")
awful.util.spawn_with_shell("xmodmap " .. confpath .. "etc/Xmodmap")
awful.util.spawn_with_shell("emacsclient -e '()' > /dev/null || emacs --daemon -l ~/.emacs.d/editor.el > /tmp/emacs.log")
awful.util.spawn_with_shell("nm-applet")
awful.util.spawn_with_shell("ps aux | grep pasystray | grep -v grep > /dev/null || pasystray")
awful.util.spawn_with_shell("blueman-applet")
