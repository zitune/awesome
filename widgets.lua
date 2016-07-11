-- Tools
local string, tostring, os, capi = string, tostring, os, {mouse = mouse, screen = screen}
-- Useful function to link a function returning a string to a widget as a notification on mouse hover
local lastnotif	= nil
function addNotificationToWidget(mywidget, func, preexec)
   mywidget:connect_signal('mouse::enter', function ()
					      if preexec ~= nil then preexec() end
					      local data = func()
					      if data == nil then return end
					      data["screen"] = mouse.screen
					      if data and data.text then lastnotif = naughty.notify(data) end
					   end)
   mywidget:connect_signal('mouse::leave', function () naughty.destroy(lastnotif) end)
end

-- Separator Widgets
sep = wibox.widget.textbox(" <span color='" .. theme.fg_focus .. "'>|</span> ")

-- Battery widget
batterywidget = wibox.widget.textbox("<span weight='bold' color='" .. theme.fg_focus .. "'>🔋</span>")
local bat, percent, discharging, time = nil, nil, nil
function batteryupdater()
   bat = awful.util.pread('acpi')
   percent, discharging, time = string.match(bat, "(%d*)%%"), string.match(bat, "Discharging"), string.match(bat, "(%d*:%d*:%d*)")

   if discharging == nil then batterywidget:set_markup("<span weight='bold' color='green'>🔋</span> " .. percent .. "%")
   elseif tonumber(percent) < 34 then batterywidget:set_markup("<span weight='bold' color='red'>🔋</span> " .. percent .. "%")
   else batterywidget:set_markup("<span weight='bold' color ='" .. theme.fg_focus .. "'>🔋</span> " .. percent .. "%") end
end
function batterypopup() return {title = "Battery", text = bat, timeout = 0} end
addNotificationToWidget(batterywidget, batterypopup, batteryupdater)

-- Clock
clockwidget = awful.widget.textclock("<span color='" .. theme.fg_focus .. "'>%d/%m/%Y %R</span>")
function clockpopup() return {title = "Calendar", text = awful.util.pread('ncal -hMwA 2'), timeout = 0} end
addNotificationToWidget(clockwidget, clockpopup)

-- Temperature
tempwidget = wibox.widget.textbox()
function tempupdater()
   local temp = string.match(awful.util.pread("acpi -t"), ", (%d*).")
   if tonumber(temp) > 80 then tempwidget:set_markup("<span weight='bold' color='red'>⚠</span> ")
   elseif tonumber(temp) > 60 then tempwidget:set_markup("<span weight='bold' color='orange'>⚠</span> ")
   else tempwidget:set_markup("") end
end
function temppopup() return {title = "Temperature", text = string.match(awful.util.pread("acpi -t"), ", (%d*).") .. "°C", timeout = 0} end
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
   local res = awful.util.pread("/home/hybris/.scripts/new_mails.py awesome")
   if res ~= "\n" then return {title = "Unread mails", text = res, timeout = 0} else return end
end
addNotificationToWidget(mailwidget, mailpopup, mailupdater)

-- Timers
function minutefunction()
   batteryupdater()
   mailupdater()
   tempupdater()
end
minutetimer = timer({timeout = 60})
minutetimer:connect_signal("timeout", minutefunction)
minutetimer:start()
