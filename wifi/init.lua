-- == WIFI ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: configure wifi
--
-- History:
-- 2018/01/07: 0.0.3: renamed it to init.lua and conditional wifi/wifi.conf checking
-- 2018/01/03: 0.0.1: first version

if file.exists("wifi/wifi.conf") then
   local conf = dofile("wifi/wifi.conf")
   
   wifi.setmode(conf.mode == 'ap' and wifi.SOFTAP or conf.mode == 'station' and wifi.STATION or wifi.STATIONAP)
   
   if(conf.mode=='ap' or conf.mode=='stationap') then 
      wifi.ap.config(conf.ap.config)
      wifi.ap.setip(conf.ap.net)
      syslog.print(syslog.INFO,"wifi "..conf.ap.config.ssid.." access point ("..wifi.sta.getmac()..") started")
      if(conf.mode ~= 'stationap') then     -- if 'stationap' then let 'station' below call net.up.lua once
         dofile("net.up.lua")
      end
   end
   if(conf.mode=='station' or conf.mode=='stationap') then
      syslog.print(syslog.INFO,"wifi: connecting to "..conf.station.config.ssid.." ...")
      --wifi.setphymode(conf.signal_mode)
      wifi.sta.config(conf.station.config)
      wifi.sta.connect()
      wifi.sta.sethostname("ESP-"..node.chipid())
      if conf.station.net then
         wifi.sta.setip(conf.station.net)
      end
      wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,function(args)
         syslog.print(syslog.INFO,"wifi: connected to "..conf.station.config.ssid.." "..wifi.sta.getip())
         dofile("net.up.lua")
         wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,function(args)
            syslog.print(syslog.WARN,"wifi: lost connectivity, reconnecting ...")
            dofile("net.down.lua")
         end)
      end)
      tmr.alarm(1,5000,1,function() 
         local s = wifi.sta.status()
         if(s ~= wifi.STA_GOTIP) then
            syslog.print(syslog.INFO,"wifi: " .. (
               s == wifi.STA_IDLE and "idle ..." or
               s == wifi.STA_CONNECTING and "connecting ..." or
               s == wifi.STA_WRONGPWD and "wrong password" or
               s == wifi.STA_APNOTFOUND and "ap not found" or
               s == wifi.STA_FAIL and "fail" or
               s == wifi.STA_GOTIP and "got ip" or "" )
            )
         end
         if((s==wifi.STA_WRONGPWD) or (s==wifi.STA_APNOTFOUND) or (s==wifi.STA_FAIL) or (s==wifi.STA_GOTIP)) then
            tmr.unregister(1)
         end
      end)
   end
else
   syslog.print(syslog.info,"no wifi/wifi.conf")
end
