------------
-- Values --
------------

-- Useful aliases
modkey		= "Mod4"
modkey2		= "Mod1"
confpath	= "/home/hybris/.config/awesome/"
cachepath	= "/home/hybris/.cache/"
scriptpath	= confpath .. "scripts/"
term		= "urxvtc"
editor		= "emacsclient -c"
browser		= "firefox"
locker		= "slock"
menufont	= "-*-courier-*-*-*-*-8-*-*-*-*-*-*-*"

-- Global values
notifications	= true
layouts		=
   {awful.layout.suit.fair,
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
function split2(str, delim)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find(str, delim, from)
  while delim_from do
     table.insert(result, string.sub(str, from , delim_from-1))
    from  = delim_to + 1
    delim_from, delim_to = string.find(str, delim, from)
  end
  table.insert(result, string.sub(str, from))
  return result
end


-- Normalize string for markup language
function normalize(s, full)
   if full then return string.gsub(string.gsub(string.gsub(s, "&", "&amp;"), "<", "&lt;"), ">", "&gt;")

   else
      return string.gsub(s, "&", "&#amp;") end
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



-------------
-- Naughty --
-------------

naughty_fg	= "#000000"
naughty_bg	= "#ffffff"
naughty_bd	= "#000000"

-- default
naughty.config.presets.normal.position		= "top_right"
naughty.config.presets.normal.fg		= naughty_fg
naughty.config.presets.normal.bg		= naughty_bg
naughty.config.presets.normal.border_color	= naughty_bd

-- Logs
naughty.config.presets.logs =
   {position	= "bottom_right",
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 1}
-- Toolbar
naughty.config.presets.toolbar =
   {position	= "bottom_left",
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 1}
-- Topbar
naughty.config.presets.topbar =
   {position	= "top_left",
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
   screen	= screen.count(),
   bg		= naughty_bg,
   fg		= naughty_fg,
   border_color	= naughty_bd,
   opacity	= 0.7}



-------------
-- Signals --
-------------
client.add_signal("manage",
		  function (c, startup)
		     c:add_signal("mouse::enter",
				  function(c)
				     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then client.focus = c end
				  end)
		     if not startup then
			if not c.size_hints.user_position and not c.size_hints.program_position
			then
			   awful.placement.no_overlap(c)
			   awful.placement.no_offscreen(c)
			end
		     end
		  end)


client.add_signal("focus", function(c)
			      c.border_color = theme.border_focus
			      local clients = {}
			      local i = 0
			      for n,t in ipairs(awful.tag.selectedlist(c.screen))
			      do
				 for m,c in ipairs(t:clients())
				 do
				    clients[i] = c
				    i = i + 1
				 end
			      end

			      if awful.layout.get(c.screen).name == "fullscreen" or awful.layout.get(c.screen).name == "max" or #clients < 1
			      then c.border_width = 0
			      else c.border_width = theme.border_width end
			   end)
client.add_signal("unfocus", function(c)
				c.border_color = theme.border_normal
			     end)


-------------
-- Autorun --
-------------
awful.util.spawn_with_shell("urxvtc -e '' || urxvtd")
awful.util.spawn_with_shell("killall xbindkeys ; xbindkeys -f " .. confpath.."etc/xbindkeysrc")
awful.util.spawn_with_shell("xmodmap " .. confpath .. "etc/Xmodmap")
awful.util.spawn_with_shell("emacsclient -e '()' || emacs --daemon -l ~/.emacs.d/editor.el > /tmp/emacs.log")
awful.util.spawn_with_shell("seaf-cli start")
awful.util.spawn_with_shell("killall xcompmgr ; xcompmgr")
awful.util.spawn_with_shell("killall vlc ; cvlc --one-instance -I http > /tmp/vlc.log 2>&1")
