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
   mywidget:connect_signal('mouse::enter',
			   function ()
			      local data = func()
			      if data and data.text then lastnotif = naughty.notify(data) end
			   end)
   mywidget:connect_signal('mouse::leave', function () naughty.destroy(lastnotif) end)
end


-------------
-- Widgets --
-------------
-- Task list
taskwidget = {}
for s = 1, screen.count() do taskwidget[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, nil) end

-- Dispkay
lwidget = wibox.widget.textbox("[")
rwidget = wibox.widget.textbox("]")

-- Battery
batterywidget = wibox.widget.textbox()
local percent = nil
local discharging = nil
local time = nil
function batteryupdater()
   local bat = awful.util.pread('acpi')
   percent = string.match(bat, "(%d*)%%")
   discharging = string.match(bat, "Discharging")
   time = string.match(bat, "(%d*:%d*:%d*)")

   local ret ="[<span weight='bold' color ='" .. theme.fg_focus .. "'>🔋</span> "
   if time == nil and tonumber(percent) > 98 then ret = ret .. "Full <span color='green'>↯</span>"
   elseif time == nil then ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='green'>▲</span>]"
   elseif discharging == nil
   then
      if tonumber(percent) > 98 then ret = ret .. "Full <span color='green'>↯</span>]"
      else ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='green'>▲</span>]" end
   elseif tonumber(percent) > 66 then ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='yellow'>▼</span>]"
   elseif tonumber(percent) > 33 then ret = ret .. "<span color='" .. theme.fg_focus .. "'>" .. percent .. "%</span> <span color='orange'>▼</span>]"
   else ret = ret .. "<span color='" .. theme.fg_focus .. "'>".. percent .. "%</span> <span color='red'>▼</span> (" .. time .. ")]" end

   batterywidget:set_markup(ret)
end
batterywidget:connect_signal('mouse::enter', function () if time then battery_popup = naughty.notify({text = time}) end end)
batterywidget:connect_signal('mouse::leave', function() if battery_popup then naughty.destroy(battery_popup) end end)


-- Clock
clockwidget = awful.widget.textclock("[<span color='" .. theme.fg_focus .. "'>%d/%m/%Y %R</span>]")
function displayMonth(month, year, weekStart)
   local current_day_format = "<u>%s</u>"
   local t, wkSt = os.time{year = year, month = month + 1, day = 0}, weekStart or 1
   local d = os.date("*t", t)
   local mthDays, stDay = d.day, (d.wday - d.day-wkSt + 1) % 7
   local lines = "    "
   for x = 0, 6 do
      lines = lines .. os.date("%a ", os.time{year = 2006, month = 1, day = x + wkSt})
   end
   lines = lines .. "\n" .. os.date(" %V", os.time{year = year, month = month, day = 1})
   local writeLine = 1
   while writeLine < (stDay + 1) do
      lines = lines .. "    "
      writeLine = writeLine + 1
   end
   for d = 1, mthDays do
      local x = d
      local t = os.time{year = year, month = month, day = d}
      if writeLine == 8 then
	 writeLine = 1
	 lines = lines .. "\n" .. os.date(" %V", t)
      end
      if os.date("%Y-%m-%d") == os.date("%Y-%m-%d", t) then
	 x = string.format(current_day_format, d)
      end
      if (#(tostring(d)) == 1) then
	 x = " " .. x
      end
      lines = lines .. "  " .. x
      writeLine = writeLine + 1
   end
   local header = os.date("%B %Y\n",os.time{year=year,month=month,day=1})
   return lines
end
function next_month(month, year)
   if month ~= 12 then return month + 1, year
   else return 1, year + 1 end
end
function previous_month(month, year)
   if month ~= 1 then return month - 1, year
   else return 12, year - 1 end
end
clockwidget:connect_signal('mouse::enter',
			   function ()
			      month, year = os.date('%m'), os.date('%Y')
			      calendar_popup = naughty.notify({title = month .. "/" .. year,
								 text = displayMonth(month, year, 2)})
			   end)
clockwidget:buttons(awful.util.table.join(
					  awful.button({ }, 1, function()
								  if calendar_popup then naughty.destroy(calendar_popup) end
								  month, year = previous_month(month, year)
								  calendar_popup = naughty.notify({title = month .. "/" .. year,
												     text = displayMonth(month, year, 2)})
							       end),
					  awful.button({ }, 3, function()
								  if calendar_popup then naughty.destroy(calendar_popup) end
								  month, year = next_month(month, year)
								  calendar_popup = naughty.notify({title = month .. "/" .. year,
												     text = displayMonth(month, year, 2)})
							       end)

				    ))
clockwidget:connect_signal('mouse::leave', function() if calendar_popup then naughty.destroy(calendar_popup) end end)


-- Load
loadwidget = wibox.widget.textbox()
function loadupdater()
   local file = io.open("/proc/loadavg")
   local csv = split(file:read(), " ")
   local res = "[<span weight='bold' color ='" .. theme.fg_focus .. "'>Load:</span> "

   local min = csv[1]
   local min5 = csv[2]
   local min15 = csv[3]
   if tonumber(min) < 8 then res = res .. "<span color='" .. theme.fg_focus .. "'>" .. min .. "</span> "
   elseif tonumber(min) < 16 then res = res .. "<span color='orange'>" .. min .. "</span> "
   else res = res .. "<span color='red'>" .. min .. "</span> " end

   if tonumber(min5) < 8 then res = res .. "<span color='" .. theme.fg_focus .. "'>" .. min5 .. "</span> "
   elseif tonumber(min5) < 16 then res = res .. "<span color='orange'>" .. min5 .. "</span> "
   else res = res .. "<span color='red'>" .. min5 .. "</span> " end

   if tonumber(min15) < 8 then res = res .. "<span color='" .. theme.fg_focus .. "'>" .. min15 .. "</span>]"
   elseif tonumber(min15) < 16 then res = res .. "<span color='orange'>" .. min15 .. "</span>]"
   else res15 = res .. "<span color='red'>" .. min15 .. "</span>]" end

   loadwidget:set_markup(res)
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
   cpu_last_notif = naughty.notify({title = "CPU usage",
				      preset = naughty.config.presets.toolbar,
				      text = res:sub(1, #res - 1),
				      timeout = 0})
end
local cpu_notif_timer = timer({timeout = 5})
cpu_notif_timer:connect_signal("timeout", cpu_popup)
loadwidget:connect_signal('mouse::enter', function()
					     cpu_popup()
					     cpu_notif_timer:start()
					  end)
loadwidget:connect_signal('mouse::leave', function()
					     cpu_notif_timer:stop()
					     if cpu_last_notif then naughty.destroy(cpu_last_notif) end
					  end)


-- Filesystems
fswidget = wibox.widget.textbox()
fswidget:set_markup("[<span weight='bold' color='" .. theme.fg_focus .. "'>FS</span>]")
function show_fs()
   local f = io.popen(scriptpath .. "fs.py")
   local res = ""
   for l in f:lines() do res = res .. l .. "\n" end
   return {title = FS,
      preset = naughty.config.presets.toolbar,
      text = res:sub(1, #res - 1),
      timeout = 0}
end
addNotificationToWidget(fswidget, show_fs)


-- Kernel log
logs = wibox.widget.textbox()
local lastline = -1
local lastlog = nil
function logsupdater()
   local res = string.sub(awful.util.pread("tail -n1 /var/log/kern.log"), 0, 145)
   local date = res:sub(1, 15)
   local message = normalize(res:sub(48, #res - 1), true)
   logs:set_markup("[<span weight='bold' color='" .. theme.fg_focus .. "'>" .. date .. "</span>: <span color='" .. theme.fg_focus .. "'>" .. message .. "</span>]")
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
logsnotifiertimer:connect_signal("timeout", logsnotifier)
logs:connect_signal('mouse::enter',
		    function () logsnotifiertimer:start() end)
logs:connect_signal('mouse::leave',
		    function ()
		       logsnotifiertimer:stop()
		       if lastlog then naughty.destroy(lastlog) end
		    end)


-- Memory
memorywidget = wibox.widget.textbox()
memorywidget:set_markup("[<span weight='bold' color='" .. theme.fg_focus .. "'>MEM</span>]")
function show_memory()
   local f = io.popen(scriptpath .. "memory.py")
   local res = ""
   for l in f:lines() do res = res .. l .. "\n" end
   return {title = Memory,
      preset = naughty.config.presets.toolbar,
      text = res:sub(1, #res - 1),
      timeout = 0}
end
addNotificationToWidget(memorywidget, show_memory)


-- Network bandwidth widget
networkwidget = wibox.widget.textbox()
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

      -- networkwidget:set_markup(res)
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
network_notif_timer:connect_signal("timeout", show_network)
networkwidget:connect_signal('mouse::enter', function() network_notif_timer:start() end)
networkwidget:connect_signal('mouse::leave', function()
						network_notif_timer:stop()
						if network_last_notif then naughty.destroy(network_last_notif) end
					     end)


-- Temperature
tempwidget = wibox.widget.textbox()
function temperatureupdater()
   local temp = string.match(awful.util.pread("acpi -t"), ", (%d*).")
   local res = "[<span weight='bold' color='" .. theme.fg_focus .. "'>Temp:</span> "
   if tonumber(temp) > 80 then res = res .. "<span color='red'>" .. tonumber(temp) .. "°C</span>]"
   elseif tonumber(temp) > 60 then res = res .. "<span color='orange'>" .. tonumber(temp) .. "°C</span>]"
   else res = res.. "<span color='" .. theme.fg_focus .. "'>" .. tonumber(temp) .. "°C</span>]" end
   tempwidget:set_markup(res)
end

-- Mails
mailswidget = wibox.widget.textbox()
mailswidget:set_markup("[<span color='" .. theme.fg_normal .. "'>✉</span>]")
function mailsupdater()
   io.popen("notmuch new")
   local f = io.popen("notmuch search tag:unread")
   local res = 0
   for l in f:lines() do res = res + 1 end
   if res ~= 0 then mailswidget:set_markup("[<span color='red'>✉</span>]")
   else mailswidget:set_markup("[<span color='" .. theme.fg_normal .. "'>✉</span>]") end
end
function show_mails()
   -- naughty.notify({text = "notmuch synced", timeout = 1})
   mailsupdater()
   local res = ""
   for l in io.popen("/home/hybris/scripts/new_mails.py awesome"):lines() do res = res .. l .. "\n" end
   res = res:sub(1, #res - 1)
   if res == "" then return  end

   return {title = "Unread mails",
      preset = naughty.config.presets.topbar,
      text = res,
      timeout = 0}
end
addNotificationToWidget(mailswidget, show_mails)
mailswidget:connect_signal("mouse::leave", function ()  end)

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
   temperatureupdater()
end
minutetimer = timer({timeout = 60})
minutetimer:connect_signal("timeout", minutefunction)
minutetimer:start()

-- Every two seconds
function twosecondsfunction()
   -- copywatcher()
   loadupdater()
   -- networkupdater()
   logsupdater()
end
twosecondstimer = timer({timeout = 2})
twosecondstimer:connect_signal("timeout", twosecondsfunction)
twosecondstimer:start()

-- Launch once at startup
minutefunction()
twosecondsfunction()
