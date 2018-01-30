-- == WIFI ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: configure wifi
--
-- History:
-- 2018/01/28: 0.0.1: adapted init.lua, this is for esp32 (why keep things simple, when you can change the API altogether: NodeMCU devs thanks!!)

if file.exists("wifi/wifi.conf") then
   local conf = dofile("wifi/wifi.conf")

   wifi.start()
   wifi.mode(conf.mode == 'ap' and wifi.SOFTAP or conf.mode == 'station' and wifi.STATION or wifi.STATIONAP)
   
   if(conf.mode=='ap' or conf.mode=='stationap') then 
      wifi.ap.config(conf.ap.config,true)
      --wifi.ap.setip(conf.ap.net) -- doesn't exist yet
      syslog.print(syslog.INFO,"wifi "..conf.ap.config.ssid.." access point ("..wifi.sta.getmac()..") started")
      if(conf.mode ~= 'stationap') then     -- if 'stationap' then let 'station' below call net.up.lua once
         dofile("net.up.lua")
      end
   end
   if(conf.mode=='station' or conf.mode=='stationap') then
      --wifi.setphymode(conf.signal_mode)
      local sta_fails = 0
      local sta_id = 0
      if(type(conf.station.config)=='table' and conf.station.config.ssid) then
         syslog.print(syslog.INFO,"wifi: connecting to "..conf.station.config.ssid.." ...")
         wifi.sta.config(conf.station.config,true)
      else 
         -- multiple stations defined
         sta_id = sta_id + 1
         wifi.sta.config(conf.station[sta_id].config,true)
         syslog.print(syslog.INFO,"wifi: connecting to "..conf.station[sta_id].config.ssid.." ...")
      end
      wifi.sta.connect()
      --wifi.sta.sethostname("ESP-"..node.chipid())
      if conf.station.net then
         -- wifi.sta.setip(conf.station.net)    -- doesn't exist yet
      end
      wifi.sta.on("got_ip",function(ev,info) 
         syslog.print(syslog.INFO,"wifi: connected to "..(sta_id > 0 and conf.station[sta_id].config.ssid or conf.station.config.ssid).." "..info.ip)
         dofile("net.up.lua")
      end)
      wifi.sta.on("disconnected",function(ev,info) 
         syslog.print(syslog.WARN,"wifi: lost connectivity, reconnecting ...")
         if(info.reason==201) then        -- NO_AP_FOUND
            local ap = sta_id > 0 and conf.station[sta_id].config.ssid or conf.station.config.ssid
            sta_fails = sta_fails + 1
            sta_id = sta_id + 1
            if sta_id <= #conf.station then
               syslog.print(syslog.INFO,"wifi: connecting to "..conf.station[sta_id].config.ssid.." ...")
               wifi.sta.config(conf.station[sta_id].config,true)
            end
         else
            syslog.print(syslog.WARN,"wifi: error, reason "..info.reason)
            dofile("net.down.lua")
         end
      end)
   end
else
   syslog.print(syslog.INFO,"no wifi/wifi.conf")
end
