local time1 = os.time()

-- Standard awesome libraries
require("awful")
require("awful.autofocus")
require("awful.remote")
require("awful.rules")
require("awful.util")
require("beautiful")
require("naughty")
require("mousegrabber")
local time2 = os.time()

-- Found libraries
require("libs/calendar2")
require("libs/expose")
require("libs/teardrop")
local time3 = os.time()

-- Tools
require("tools")
local time4 = os.time()

-- Themes define colours, icons, and wallpapers
beautiful.init(confpath .. "theme.lua")
local time5 = os.time()

-- Widgets
require("widgets")
local time6 = os.time()

-- Keys
require("keys")
local time7 = os.time()

-- Display
require("display")
local time8 = os.time()


-- Compute launch time
local stl_time	= time2 - time1
local lib_time	= time3 - time2
local tool_time	= time4 - time3
local them_time = time5 - time4
local widg_time = time6 - time5
local keys_time = time7 - time6
local disp_time = time8 - time7
local tot_time	= time8 - time1
naughty.notify({title = "Time to launch configuration",
 		  text =
		     "STL:\t\t" .. stl_time .. "\n"
 		     .. "Lib:\t\t" .. lib_time .. "\n"
		     .. "Tools:\t\t" .. tool_time .. "\n"
 		     .. "Theme:\t\t" .. them_time .. "\n"
 		     .. "Widgets:\t" .. widg_time .. "\n"
 		     .. "Keys:\t\t" .. keys_time .. "\n"
 		     .. "Display:\t" .. disp_time .. "\n"
 		     .. "\n<span color='red'>Total: " .. tot_time
 		     .. "</span>",
		  preset = naughty.config.presets.normal,
 		  timeout = 15})
