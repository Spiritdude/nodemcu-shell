-- add action done at boot/startup
node.setcpufreq(node.CPU160MHZ)  -- 2x the speed
dofile("lib/integer.lua")
dofile("lib/console.lua")
dofile("lib/syslog.lua")
syslog.print(syslog.INFO,"device #"..node.chipid()..string.format(" / 0x%x",node.chipid()).." starting up ("..(1/2==0 and "integer" or "float").." firmware)")
--dofile("display/init.lua")
dofile("wifi/init.lua")

-- a slight delay in case startup/* script resets device, we can overwrite something (interrupt reboot loop)
tmr.create():alarm(3000,tmr.ALARM_SINGLE,function()
   if true then      -- experimental
      for f in pairs(file.list()) do
         if f.match(f,"^startup/") then
            syslog.print(syslog.INFO,"startup: execute "..f)
            dofile(f)
         end
      end
   end
end)
