-- Check myrc.lua validity
require("awful")

local ret = awful.util.checkfile("/home/hybris/.config/awesome/rcperso.lua")

-- checkfile return a function if rcperso is valid
local check = type(ret) == "function"

if check
then
   -- Launch my rc.lua
   require("rcperso")
else
   -- Launch default rc.lua and a term with debug
   file = io.open("/tmp/awesome_bug.tmp","w")
   file:write(ret)
   file:close()
   require("rcdefault")
   awful.util.spawn_with_shell("xterm -e 'less /tmp/awesome_bug.tmp'")
end
