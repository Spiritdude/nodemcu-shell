-- add action done at boot/startup
if node.info then
   local ma,mi,re,cid,fid,fs,fm,fsp,ar = node.info()
   arch = ar or "esp8266"
else 
   arch = string.match(node.chipid(),"^0x") and 'esp32' or 'esp8266'
end
sysconf = { arch=arch }
if arch=='esp8266' then
   node.setcpufreq(node.CPU160MHZ)  -- 2x the speed
end
dofile("lib/integer.lua")
dofile("lib/console.lua")
dofile("lib/syslog.lua")
dofile("shell/cat.lua")('cat',"shell/bnr."..arch..".bw.txt")
dofile("lib/tmr.lua")
dofile("lib/gpio.lua")
if not http then
   dofile("lib/http.lua")
end
dofile("display/init.lua")

if node.info then
   local ma,mi,de = node.info()
   syslog.print(syslog.INFO,"device #"..node.chipid()..string.format(" / 0x%x",node.chipid()).." ("..arch..", NodeMCU-"..ma.."."..mi.."."..de..(1/2==0 and "-integer" or "-float")..") starting up")
else
   -- has no node.info()
   syslog.print(syslog.INFO,"device "..node.chipid().." ("..arch..") starting up")
end

dofile(arch=='esp8266' and "wifi/init.lua" or "wifi/init32.lua")

-- a slight delay in case startup/* script resets device, we can overwrite something (interrupt reboot loop)
tmr.create():alarm(3000,tmr.ALARM_SINGLE,function()
   if true then      -- experimental
      for fn in pairs(file.list()) do
         if string.match(fn,"^startup/") then
            syslog.print(syslog.INFO,"startup: execute "..fn)
            local f = dofile(fn)
            if f and type(f)=='function' then
               f(fn)
            end
         end
      end
   end
end)
