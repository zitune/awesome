-----------
-- Tools --
-----------

local string, tostring, os, capi = string, tostring, os, {mouse = mouse, screen = screen}

-- Useful function to link a function returning a string to a widget as a notification on mouse hover
local lastnotif	= nil
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
sep = wibox.widget.textbox(" <span color='" .. theme.fg_focus .. "'>|</span> ")

-- Battery
batterywidget = wibox.widget.textbox("<span weight='bold' color='" .. theme.fg_focus .. "'>🔋</span>")
local percent, discharging, time = nil, nil, nil
function batteryupdater()
   local bat = awful.util.pread('acpi')
   percent, discharging, time = string.match(bat, "(%d*)%%"), string.match(bat, "Discharging"), string.match(bat, "(%d*:%d*:%d*)")

   if discharging == nil then batterywidget:set_markup("<span weight='bold' color='green'>🔋</span>")
   elseif tonumber(percent) < 34 then batterywidget:set_markup("<span weight='bold' color='red'>🔋</span>" .. percent .. "%")
   else batterywidget:set_markup("<span weight='bold' color ='" .. theme.fg_focus .. "'>🔋</span>") end
end
function batterypopup()
   batteryupdater()
   local res = percent .. "%"
   if time ~= nil then res = res .. " - " .. time end
   return {title = "Battery", text = res, timeout = 0}
end
addNotificationToWidget(batterywidget, batterypopup)


-- Clock
clockwidget = awful.widget.textclock("<span color='" .. theme.fg_focus .. "'>%R</span>")
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


-- Temperature
tempwidget = wibox.widget.textbox("<span weight='bold' color='" .. theme.fg_focus .. "'>⚠</span> ")
local temp = string.match(awful.util.pread("acpi -t"), ", (%d*).")
function tempupdater()
   local res = "<span weight='bold'>⚠</span> "
   if tonumber(temp) > 80 then res = "<span weight='bold' color='red'>⚠</span> " elseif tonumber(temp) > 60 then res = "<span weight='bold' color='orange'>⚠</span> " end
   tempwidget:set_markup(res)
end
function temppopup()
   return {title = "Temperature", text = string.match(awful.util.pread("acpi -t"), ", (%d*).") .. "°C", timeout = 0}
end
addNotificationToWidget(tempwidget, temppopup)

-- Mails
mailwidget = wibox.widget.textbox("<span weight='bold' color='" .. theme.fg_focus .. "'>✉</span> ")
function mailupdater()
   io.popen("notmuch new")
   local f, res = io.popen("notmuch search tag:unread"), 0
   for l in f:lines() do res = res + 1 end
   if res ~= 0 then mailwidget:set_markup("<span weight='bold' color='green'>✉</span> ") else mailwidget:set_markup("<span weight='bold' color='" .. theme.fg_focus .. "'>✉</span> ") end
   if os.execute("screen -list offlineimap > /dev/null") ~=0 then mailwidget:set_markup("<span weight='bold' color='red'>✉</span> ") end
end
function mailpopup()
   mailupdater()
   local res = ""
   for l in io.popen("/home/hybris/.scripts/new_mails.py awesome"):lines() do res = res .. l .. "\n" end
   res = res:sub(1, #res - 1)
   if res == "" then return  end

   return {title = "Unread mails", text = res, timeout = 0}
end
addNotificationToWidget(mailwidget, mailpopup)


------------
-- Timers --
------------
-- Every minutes
function minutefunction()
   batteryupdater()
   mailupdater()
   tempupdater()
end
minutetimer = timer({timeout = 60})
minutetimer:connect_signal("timeout", minutefunction)
minutetimer:start()
