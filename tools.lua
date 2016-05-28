------------
-- Values --
------------
-- Useful aliases
modkey		= "Mod4"
confpath	= "/home/hybris/.config/awesome/"
scriptpath	= confpath .. "scripts/"
term		= "urxvtc"
editor		= "emacsclient -c"
browser		= "firefox"
dmenufont	= "-*-courier-*-*-*-*-10-*-*-*-*-*-*-*"
dmenuoptions	= '-nb "#000000" -sb "#000000" -sf "#ffffff" -nf "#ffffff" -fn "' .. dmenufont .. '"'

-- Global values
notifications	= true
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

---------------
-- Functions --
---------------
-- split a string
function split(str, pat)
   if str == nil then return {} end
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then table.insert(t, cap) end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str
   then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

-- Normalize string for markup language
function normalize(s, full)
   if full then return string.gsub(string.gsub(string.gsub(s, "&", "&amp;"), "<", "&lt;"), ">", "&gt;")
   else return string.gsub(s, "&", "&#amp;") end
end

-- Spawn if not launched
function unique_launch(command, name) awful.util.spawn_with_shell(scriptpath .. "notlaunched.sh " .. name .. "&&".. command) end

-- Get the active default connection
function getDefaultRoute()
   local nst = io.popen("LC_ALL=C netstat -r -n")
   for i in nst:lines()
   do
      local fields = split(i, ' ')
      local dest = fields[1]
      local interface = fields[#fields]
      if dest == '0.0.0.0' then return interface end
   end
   return 'None'
end

-- Range function
function range(to)
   res = {}
   for i=1, to do table.insert(res, i) end
   return res
end

-------------
-- Naughty --
-------------
naughty_fg	= "#ffffff"
naughty_bg	= "#000000"
naughty_bd	= "#ffffff"
-- default
naughty.config.presets.normal.position		= "top_right"
naughty.config.presets.normal.fg		= naughty_fg
naughty.config.presets.normal.bg		= naughty_bg
naughty.config.presets.normal.border_color	= naughty_bd
-- Logs
naughty.config.presets.logs =
   {position	= "bottom_right",
   screen	= mouse.screen,
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 1}
-- Toolbar
naughty.config.presets.toolbar =
   {position	= "bottom_left",
   screen	= mouse.screen,
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 1}
-- Topbar
naughty.config.presets.topbar =
   {position	= "top_left",
   screen	= mouse.screen,
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 1}
-- File copy
naughty.config.presets.copy =
   {position	= "top_right",
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 1}
naughty.config.presets.news =
   {position	= "top_right",
   screen	= mouse.screen,
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 0.7}

-------------
-- Autorun --
-------------
awful.util.spawn_with_shell("urxvtc -e '' || urxvtd")
awful.util.spawn_with_shell("killall xbindkeys ; xbindkeys -f " .. confpath.."etc/xbindkeysrc")
awful.util.spawn_with_shell("xmodmap " .. confpath .. "etc/Xmodmap")
awful.util.spawn_with_shell("emacsclient -e '()' > /dev/null || emacs --daemon -l ~/.emacs.d/editor.el > /tmp/emacs.log")
awful.util.spawn_with_shell("ps aux | grep nm-applet | grep -v grep > /dev/null || nm-applet")
awful.util.spawn_with_shell("ps aux | grep pasystray | grep -v grep > /dev/null || pasystray")
awful.util.spawn_with_shell("ps aux | grep blueman-applet | grep -v grep > /dev/null || blueman-applet")

