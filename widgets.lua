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
			      if data == nil then return end
			      data["screen"] = mouse.screen
			      if data and data.text then lastnotif = naughty.notify(data) end
			   end)
   mywidget:connect_signal('mouse::leave', function () naughty.destroy(lastnotif) end)
end

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

-------------
-- Widgets --
-------------
-- Separators
lsep = wibox.widget.textbox("[")
msep = wibox.widget.textbox("][")
rsep = wibox.widget.textbox("]")

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

   local ret = "<span weight='bold' color ='" .. theme.fg_focus .. "'>🔋</span> "
   if discharging == nil then ret = ret .. tostring(percent) .. "% <span color='green'>⚡</span>"
   else
      if tonumber(percent) > 33 then ret = ret .. tostring(percent) .. "%"
      else ret = ret .. tostring(percent) .. "% <span color='red'>⚡</span> (" .. tostring(time) .. ")" end
   end

   batterywidget:set_markup(ret)
end
batterywidget:connect_signal('mouse::enter', function () if time then battery_popup = naughty.notify({text = time, timeout = 0}) end end)
batterywidget:connect_signal('mouse::leave', function() if battery_popup then naughty.destroy(battery_popup) end end)


-- Clock
clockwidget = awful.widget.textclock("<span color='" .. theme.fg_focus .. "'>🕓</span> %d/%m/%Y %R")
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
			      month, year = tonumber(os.date('%m')), os.date('%Y')
			      calendar_popup = naughty.notify({title = month .. "/" .. year,
								 screen = mouse.screen,
								 text = displayMonth(month, year, 2),
								 timeout = 0})
			   end)
clockwidget:buttons(awful.util.table.join(
					  awful.button({ }, 1, function()
								  if calendar_popup then naughty.destroy(calendar_popup) end
								  month, year = previous_month(month, year)
								  calendar_popup = naughty.notify({title = month .. "/" .. year,
												     screen = mouse.screen,
												     text = displayMonth(month, year, 2),
												     timeout = 0})
							       end),
					  awful.button({ }, 3, function()
								  if calendar_popup then naughty.destroy(calendar_popup) end
								  month, year = next_month(month, year)
								  calendar_popup = naughty.notify({title = month .. "/" .. year,
												     screen = mouse.screen,
												     text = displayMonth(month, year, 2),
												     timeout = 0})
							       end)

				    ))
clockwidget:connect_signal('mouse::leave', function() if calendar_popup then naughty.destroy(calendar_popup) end end)


-- Load
loadwidget = wibox.widget.textbox()
function loadupdater()
   local file = io.open("/proc/loadavg")
   local csv = split(file:read(), " ")
   local res = "<span weight='bold' color ='" .. theme.fg_focus .. "'>回</span> "

   local min = csv[1]
   local min5 = csv[2]
   local min15 = csv[3]
   if tonumber(min) < 8 then res = res .. min .. " "
   elseif tonumber(min) < 16 then res = res .. "<span color='orange'>" .. min .. "</span> "
   else res = res .. "<span color='red'>" .. min .. "</span> " end

   if tonumber(min5) < 8 then res = res .. min5 .. " "
   elseif tonumber(min5) < 16 then res = res .. "<span color='orange'>" .. min5 .. "</span> "
   else res = res .. "<span color='red'>" .. min5 .. "</span> " end

   if tonumber(min15) < 8 then res = res .. min15
   elseif tonumber(min15) < 16 then res = res .. "<span color='orange'>" .. min15 .. "</span>"
   else res15 = res .. "<span color='red'>" .. min15 .. "</span>" end

   loadwidget:set_markup(res)
end
-- htop viewer
function showload()
   local f1 = io.popen(confpath .. "scripts/mtop.py")
   local f2 = io.popen(confpath .. "scripts/memory.py")
   local res = ""
   res = res .. "\n"
   for l in f1:lines() do res = res .. l .. "\n" end
   res = res .. "\n"
   for l in f2:lines() do res = res .. l .. "\n" end

   return {title = "CPU & Memory",
      screen = mouse.screen,
      preset = naughty.config.presets.toolbar,
      text = res:sub(1, #res - 1),
      timeout = 0}
end
addNotificationToWidget(loadwidget, showload)


-- Filesystems
fswidget = wibox.widget.textbox()
fswidget:set_markup("<span weight='bold' color='" .. theme.fg_focus .. "'>⛁</span>")
function show_fs()
   local f = io.popen(confpath .. "scripts/fs.py")
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
local lastlog = nil
function parse_log(log_line)
   local date = log_line:sub(1, 15)
   local title = split(log_line:sub(23), ':')[1]
   local message = split(log_line, "] ")[2]
   if not message then message = "" end
   return {date = date, title = title, message = message}
end

function logsupdater()
   local last_log = string.sub(awful.util.pread("tail -n1 /var/log/messages"), 0, 145)
   local parsed = parse_log(last_log)
   logs:set_markup("<span weight='bold' color='" .. theme.fg_focus .. "'>" .. parsed.date .. " " .. parsed.title .. "</span> " .. parsed.message)
end
function logsnotifier()
   local last_logs = split(awful.util.pread("tail -n 20 /var/log/messages"), "\n")
   local res = ''
   for i = 1, #last_logs do
      local parsed = parse_log(last_logs[i])
      res = res .. "<span weight='bold' color='yellow'>" .. parsed.date .. "</span> <span weight='bold' color='blue'>" .. parsed.title .. "</span> " .. parsed.message .. "\n"
   end
   if res ~= ""
   then
      res = res:sub(1, #res - 1)
      return {title = "Logs",
	 preset = naughty.config.presets.logs,
	 text = res,
	 timeout = 0}
   end
end
addNotificationToWidget(logs, logsnotifier)


-- Network bandwidth widget
networkwidget = wibox.widget.textbox()
local lastdown = 0
local lastup = 0
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
function networkupdater()
   local interface = getDefaultRoute()
   local unit = {"B/s", "KB/s", "MB/s"}
   local res = ""

   if interface ~= "None"
   then
      res = "<span weight='bold' color='" .. theme.fg_focus .. "'>⇅</span> "
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

      res = res .. math.ceil(bytesIn) .. unit[unitIn] .. " ↓ "
      res = res .. math.ceil(bytesOut) .. unit[unitOut] .. " ↑"
      networkwidget.text = res
      networkwidget:set_markup(res)
   end
end
local network_last_notif = nil
function show_network()
   local f = io.popen("wget -qO- http://ipecho.net/plain")
   local res = "<span weight='bold' color='" .. theme.fg_focus .. "'>Public IP:</span> "
   for l in f:lines()
   do
      res = res .. l .. "\n"
   end
   f = io.popen(confpath .. "scripts/network.py")
   for l in f:lines()
   do
      res = res .. l .. "\n"
   end

   if network_last_notif then naughty.destroy(network_last_notif) end
   network_last_notif = naughty.notify({title = Network,
					  screen = mouse.screen,
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
   local res = "<span weight='bold' color='" .. theme.fg_focus .. "'>⚠</span> "
   if tonumber(temp) > 80 then res = res .. "<span color='red'>" .. tonumber(temp) .. "°C</span>"
   elseif tonumber(temp) > 60 then res = res .. "<span color='orange'>" .. tonumber(temp) .. "°C</span>"
   else res = res.. tonumber(temp) .. "°C" end
   tempwidget:set_markup(res)
end

-- Mails
mailswidget = wibox.widget.textbox()
mailswidget:set_markup("<span weight='bold' color='" .. theme.fg_focus .. "'>✉</span>")
function mailsupdater()
   io.popen("notmuch new")
   local f = io.popen("notmuch search tag:unread")
   local res = 0
   for l in f:lines() do res = res + 1 end
   if res ~= 0 then mailswidget:set_markup("<span color='green'>✉</span>")
   else mailswidget:set_markup("<span weight='bold' color='" .. theme.fg_focus .. "'>✉</span>") end
   offlineimap = os.execute("screen -list offlineimap")
   if offlineimap ~=0 then mailswidget:set_markup("<span color='red'>✉</span>") end
end
function show_mails()
   -- naughty.notify({text = "notmuch synced", timeout = 1})
   mailsupdater()
   local res = ""
   for l in io.popen("/home/hybris/.scripts/new_mails.py awesome"):lines() do res = res .. l .. "\n" end
   res = res:sub(1, #res - 1)
   if res == "" then return  end

   return {title = "Unread mails",
      preset = naughty.config.presets.topbar,
      text = res,
      timeout = 0}
end
addNotificationToWidget(mailswidget, show_mails)
mailswidget:connect_signal("mouse::leave", function ()  end)


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
   loadupdater()
   networkupdater()
   logsupdater()
end
twosecondstimer = timer({timeout = 2})
twosecondstimer:connect_signal("timeout", twosecondsfunction)
twosecondstimer:start()

-- Launch once at startup
minutefunction()
twosecondsfunction()
