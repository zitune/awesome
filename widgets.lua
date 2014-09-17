-----------
-- Tools --
-----------

local string	= string
local tostring	= tostring
local os	= os
local capi	=
   {mouse	= mouse,
   screen	= screen}
local lastnotif	= nil


-- Useful function to link a function returning a string to a widget as a notification on mouse hover
function addNotificationToWidget(mywidget, func)
   mywidget:add_signal('mouse::enter',
		       function ()
			  local data = func()
			  if data.text then lastnotif = naughty.notify(data) end
		       end)
   mywidget:add_signal('mouse::leave',
		       function () naughty.destroy(lastnotif) end)
end


-------------
-- Widgets --
-------------

-- Separator
separator = widget({type="textbox"})
separator.text = " "


-- Task list
taskwidget = {}
for s = 1, screen.count() do
   taskwidget[s] = awful.widget.tasklist(function(c)
					    return awful.widget.tasklist.label.currenttags(c, s)
					 end, {})
end


-- Battery
batterywidget = widget({type = 'textbox'})
batterywidget.text = ""
local percent = nil
local discharging = nil
local time = nil
function batteryupdater()
   local bat = awful.util.pread('acpi')
   percent = string.match(bat, "(%d*)%%")
   discharging = string.match(bat, "Discharging")
   time = string.match(bat, "(%d*:%d*:%d*)")

   local ret ="<span weight='bold' color ='" .. theme.fg_focus .. "'>🔋</span> "
   if time == nil and tonumber(percent) > 98 then ret = ret .. "Full <span color='green'>↯</span>"
   elseif time == nil then ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='green'>▲</span>"
   elseif discharging == nil
   then
      if tonumber(percent) > 98 then ret = ret .. "Full <span color='green'>↯</span>"
      else ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='green'>▲</span>" end
   elseif tonumber(percent) > 66 then ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='yellow'>▼</span>"
   elseif tonumber(percent) > 33 then ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='orange'>▼</span>"
   else ret = ret .. "<span color='" .. theme.fg_focus .. "'>".. percent .. "%</span> <span color='red'>▼</span> (" .. time .. ")" end

   batterywidget.text = ret
end
batterywidget:add_signal('mouse::enter', function ()
					    if time then batterywidget.text = batterywidget.text .. " (".. time .. ")" end
					 end)
batterywidget:add_signal('mouse::leave', batteryupdater)


-- Clock
clockwidget = awful.widget.textclock({}, "<span color='" .. theme.fg_focus .. "'>%d/%m/%Y %R</span>")
calendar2.addCalendarToWidget(clockwidget)


-- Load
loadwidget = widget({ type = "textbox"})
loadwidget.text = "NL"
function loadupdater()
   local file = io.open("/proc/loadavg")
   local csv = split(file:read(), " ")
   local res = "<span weight='bold' color ='" .. theme.fg_focus .. "'>Load:</span> "

   local min = csv[1]
   local min5 = csv[2]
   local min15 = csv[3]
   if tonumber(min) < 8 then res = res .. "<span color='" .. theme.fg_focus .. "'>" .. min .. "</span> "
   elseif tonumber(min) < 16 then res = res .. "<span color='orange'>" .. min .. "</span> "
   else res = res .. "<span color='red'>" .. min .. "</span> " end

   if tonumber(min5) < 8 then res = res .. "<span color='" .. theme.fg_focus .. "'>" .. min5 .. "</span> "
   elseif tonumber(min5) < 16 then res = res .. "<span color='orange'>" .. min5 .. "</span> "
   else res = res .. "<span color='red'>" .. min5 .. "</span> " end

   if tonumber(min15) < 8 then res = res .. "<span color='" .. theme.fg_focus .. "'>" .. min15 .. "</span>"
   elseif tonumber(min15) < 16 then res = res .. "<span color='orange'>" .. min15 .. "</span>"
   else res15 = res .. "<span color='red'>" .. min15 .. "</span>" end


   loadwidget.text = res
end
-- htop viewer
cpu_last_notif = nil
function cpu_popup()
   local f = io.popen(scriptpath .. "top.py")
   local res = ""
   for l in f:lines()
   do
      res = res .. l .. "\n"
   end

   if cpu_last_notif then naughty.destroy(cpu_last_notif) end
   cpu_last_notif = naughty.notify({title = "<span color='" .. naughty_fg .. "'>CPU usage</span>",
				      preset = naughty.config.presets.toolbar,
				      text = res:sub(1, #res - 1),
				      timeout = 0})
end
local cpu_notif_timer = timer({timeout = 5})
cpu_notif_timer:add_signal("timeout", cpu_popup)
loadwidget:add_signal('mouse::enter', function()
					 cpu_popup()
					 cpu_notif_timer:start()
				      end)
loadwidget:add_signal('mouse::leave', function()
					 cpu_notif_timer:stop()
					 if cpu_last_notif then naughty.destroy(cpu_last_notif) end
				      end)


-- Filesystems
fswidget = widget({type = "textbox"})
fswidget.text = "<span weight='bold' color='" .. theme.fg_focus .. "'>FS</span>"
function show_fs()
   local f = io.popen(scriptpath .. "fs.py")
   local res = ""
   for l in f:lines()
   do
      res = res .. l .. "\n"
   end
   return {title = "<span color='" .. naughty_fg .. "'>FS</span>",
      preset = naughty.config.presets.toolbar,
      text = res:sub(1, #res - 1),
      timeout = 0}
end
addNotificationToWidget(fswidget, show_fs)


-- Kernel log
logs = widget({type = "textbox"})
logs.text = ""
local lastline = -1
local lastlog = nil
function logsupdater()
   local res = string.sub(awful.util.pread("tail -n1 /var/log/kern.log"), 0, 145)
   local date = res:sub(1, 15)
   local message = normalize(res:sub(48, #res), true)
   logs.text = "<span weight='bold' color='" .. theme.fg_focus .. "'>" .. date .. "</span>: <span color='" .. theme.fg_focus .. "'>" .. message .. "</span>"
end
function logsnotifier()
   local tl = tonumber(awful.util.pread("cat /var/log/kern.log | wc -l"))
   if lastline == -1
   then
      lastline = tl
      return
   end
   res = awful.util.pread("cat /var/log/kern.log | tail -n " .. tl - lastline .. " | source-highlight --failsafe --src-lang=log --style-file=default.style --outlang-def=" .. confpath .. "etc/awesome.outlang")
   if res ~= "" and notifications
   then
      if lastlog then naughty.destroy(lastlog) end
      res = res:sub(1, #res - 1)
      lastlog = naughty.notify{preset = naughty.config.presets.logs, text = res, timeout = 0}
   end
   lastline = tl
end
logsnotifiertimer = timer({timeout = 2})
logsnotifiertimer:add_signal("timeout", logsnotifier)
logs:add_signal('mouse::enter',
		function () logsnotifiertimer:start() end)
logs:add_signal('mouse::leave',
		function ()
		   logsnotifiertimer:stop()
		   if lastlog then naughty.destroy(lastlog) end
		end)


-- Memory
memorywidget = widget({type = "textbox"})
memorywidget.text = "<span weight='bold' color='" .. theme.fg_focus .. "'>MEM</span>"
function show_memory()
   local f = io.popen(scriptpath .. "memory.py")
   local res = ""
   for l in f:lines()
   do
      res = res .. l .. "\n"
   end
   return {title = "<span color='" .. naughty_fg .. "'>Memory</span>",
      preset = naughty.config.presets.toolbar,
      text = res:sub(1, #res - 1),
      timeout = 0}
end
addNotificationToWidget(memorywidget, show_memory)


-- Monitor indicator
monitor	= widget({type="textbox"})
monitor.text	= "☢"


-- Network bandwidth widget
networkwidget = widget({type = "textbox"})
networkwidget.text = "NL"
local lastdown = 0
local lastup = 0
function networkupdater()
   local interface = getDefaultRoute()
   local unit = {"B/s", "KB/s", "MB/s"}
   local res = ""

   if interface ~= "None"
   then
      res = "<span weight='bold' color='" .. theme.fg_focus .. "'>" .. interface .. ":</span> <span color='" .. theme.fg_focus .. "'>"
      awful.util.spawn_with_shell("bwm-ng -o csv -c 1 -I " .. interface .. " | head -n1 > /tmp/network.csv")
      local file = io.open("/tmp/network.csv")
      if not file then return nil end
      local csv = split(file:read(), ";")

      local bytesOut = csv[3]
      local bytesIn = csv[4]
      local unitOut = 1
      local unitIn = 1

      if not bytesOut or not bytesIn then return end
      while tonumber(bytesOut) > 1024 and unitOut < 3
      do
	 bytesOut = bytesOut / 1024
	 unitOut = unitOut + 1
      end
      while tonumber(bytesIn) > 1024 and unitIn < 3
      do
	 bytesIn = bytesIn / 1024
	 unitIn = unitIn + 1
      end

      res = res .. math.ceil(bytesIn) .. " " .. unit[unitIn] .. " ↓ "
      res = res .. math.ceil(bytesOut) .. " " .. unit[unitOut] .. " ↑</span>"
      networkwidget.text = res


      if unitIn == 1 then res = res .. math.ceil(bytesIn) .. " " .. unit[unitIn] .. "</span> <span color='green'>↓</span> "
      elseif unitIn == 2 then res = res .. math.ceil(bytesIn) .. " " .. unit[unitIn] .. "</span> <span color='orange'>↓</span> "
      elseif unitIn == 3 then res = res .. math.ceil(bytesIn) .. " " .. unit[unitIn] .. "</span> <span color='red'>↓</span> "
      end
      res = res .. "<span color='" .. theme.fg_focus .. "'>"
      if unitOut == 1 then res = res .. math.ceil(bytesOut) .. " " .. unit[unitOut] .. "</span> <span color='green'>↑</span>"
      elseif unitOut == 2 then res = res .. math.ceil(bytesOut) .. " " .. unit[unitOut] .. "</span> <span color='orange'>↑</span>"
      elseif unitOut == 3 then res = res .. math.ceil(bytesOut) .. " " .. unit[unitOut] .. "</span> <span color='red'>↑</span>"
      end

      -- networkwidget.text = res
   end
end
local network_last_notif = nil
function show_network()
   local f = io.popen(scriptpath .. "network.py")
   local res = ""
   for l in f:lines()
   do
      res = res .. l .. "\n"
   end

   if network_last_notif then naughty.destroy(network_last_notif) end
   network_last_notif = naughty.notify({title = "<span color='" .. naughty_fg .. "'>Network</span>",
					  preset = naughty.config.presets.toolbar,
					  text = res:sub(1, #res - 1),
					  timeout = 0})
end
local network_notif_timer = timer({timeout = 1})
network_notif_timer:add_signal("timeout", show_network)
networkwidget:add_signal('mouse::enter', function() network_notif_timer:start() end)
networkwidget:add_signal('mouse::leave', function()
					    network_notif_timer:stop()
					    if network_last_notif then naughty.destroy(network_last_notif) end
					 end)


-- Sound
soundwidget = widget({type = "textbox"})
soundwidget.text = "<span weight='bold' color='" .. theme.fg_focus .. "'>VOL</span>"
function show_volume()
   return {title = "<span color='" .. naughty_fg .. "'>Volume</span>",
      preset = naughty.config.presets.toolbar,
      text = string.match(awful.util.pread("amixer get Master | tail -n1"), "%[(.*)%%%]") .. "%",
      timeout = 0}
end
addNotificationToWidget(soundwidget, show_volume)


-- Tags
tags_names = {}
tagwidget = {}
function tag_filter(t)
   if t.name == "0" then return "" end

   local urgent = false
   for i = 1, #t.clients(t) do if t.clients(t)[i].urgent then urgent = true end end

   local full_name = t.name
   if tags_names[t] and tags_names[t] ~= "" then full_name = tags_names[t] end
   -- if urgent then full_name = full_name .. "!" end

   local color = "<span color='"
   if t.selected then color = color .. theme.fg_focus .. "' weight='bold' underline='single'>"
   elseif urgent then color = color .. "red'>"
   else color = color .. theme.fg_focus .. "'>" end

   res = "<span font_desc='" .. theme.font .. "'>" .. color .. full_name .. "</span></span> "
   return res
end
for i = 1, screen.count() do tagwidget[i] = awful.widget.taglist(i, tag_filter, nil) end


-- Temperature
tempwidget = widget({type = 'textbox'})
tempwidget.text = "Temp: NL"
function temperatureupdater()
   local temp = string.match(awful.util.pread("acpi -t"), ", (%d*).")
   local res = "<span weight='bold' color='" .. theme.fg_focus .. "'>Temp:</span> "
   if tonumber(temp) > 80 then res = res .. "<span color='red'>" .. tonumber(temp) .. "°C</span>"
   elseif tonumber(temp) > 60 then res = res .. "<span color='orange'>" .. tonumber(temp) .. "°C</span>"
   else res = res.. "<span color='" .. theme.fg_focus .. "'>" .. tonumber(temp) .. "°C</span>" end
   tempwidget.text = res
end

-- Mails
mailswidget = widget({ type = 'textbox'})
mailswidget.text = "<span color='" .. theme.fg_normal .. "'>✉</span>"
function mailsupdater()
   io.popen("notmuch new")
   local f = io.popen("notmuch search tag:unread")
   local res = 0
   for l in f:lines() do res = res + 1 end
   if res ~= 0 then mailswidget.text = "<span color='red'>✉</span>" else mailswidget.text = "<span color='" .. theme.fg_normal .. "'>✉</span>" end
end
function show_mails()
   -- naughty.notify({text = "notmuch synced", timeout = 1})
   mailsupdater()
   local res = ""
   for l in io.popen("/home/hybris/scripts/new_mails.py awesome"):lines() do res = res .. l .. "\n" end
   res = res:sub(1, #res - 1)
   if res == "" then return  end

   return {title = "<span color='" .. naughty_fg .. "'>Unread mails</span>",
      preset = naughty.config.presets.topbar,
      text = res,
      timeout = 0}
end
addNotificationToWidget(mailswidget, show_mails)
mailswidget:add_signal("mouse::leave", function ()  end)

-- Watch file copy
function copywatcher()
   local f = io.popen("notmuch search tag:unread")
   local res = ""
   for l in f:lines() do res = res .. l .. "\n" end
   if notifications and res ~= "" then
      naughty.notify({title = "File copying",
			text = res,
			timeout = 2})
   end
end


------------
-- Timers --
------------
-- Every minutes
function minutefunction()
   batteryupdater()
   mailsupdater()
   if bottombox[1] and bottombox[1].visible then temperatureupdater() end
end
minutetimer = timer({timeout = 60})
minutetimer:add_signal("timeout", minutefunction)
minutetimer:start()

-- Every two seconds
function twosecondsfunction()
   messageupdater()
   -- copywatcher()
   if bottombox[1] and bottombox[1].visible
   then
      loadupdater()
      networkupdater()
      logsupdater()
   end
end
twosecondstimer = timer({timeout = 2})
twosecondstimer:add_signal("timeout", twosecondsfunction)
twosecondstimer:start()

-- Launch once at startup
batteryupdater()
temperatureupdater()
logsupdater()
messageupdater()
loadupdater()
networkupdater()
logsupdater()
mailsupdater()
