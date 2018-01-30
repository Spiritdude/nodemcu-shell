-- add action done at boot/startup
arch = string.match(node.chipid(),"^0x") and 'esp32' or 'esp8266'
if arch=='esp8266' then
   node.setcpufreq(node.CPU160MHZ)  -- 2x the speed
end
dofile("lib/integer.lua")
dofile("lib/timer.lua")
if arch=='esp32' then
   dofile("lib/http.lua")
end
dofile("lib/console.lua")
dofile("lib/syslog.lua")
--dofile("display/init.lua")

if arch=='esp32' then
   -- has no node.info()
   syslog.print(syslog.INFO,"device "..node.chipid().." starting up")
else
   local ma,mi,de = node.info()
   syslog.print(syslog.INFO,"device #"..node.chipid()..string.format(" / 0x%x",node.chipid()).." (NodeMCU-"..ma.."."..mi.."."..de..(1/2==0 and "-integer" or "-float")..") starting up")
end

dofile(arch=='esp8266' and "wifi/init.lua" or "wifi/init32.lua")

-- a slight delay in case startup/* script resets device, we can overwrite something (interrupt reboot loop)
timer.create():alarm(3000,timer.ALARM_SINGLE,function()
   if true then      -- experimental
      for f in pairs(file.list()) do
         if f.match(f,"^startup/") then
            syslog.print(syslog.INFO,"startup: execute "..f)
            dofile(f)
         end
      end
   end
end)
