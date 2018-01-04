conf = dofile("wifi/wifi.conf")

if(conf.mode=='client') then
   wifi.setmode(wifi.STATION) 
   --wifi.setphymode(conf.signal_mode)
   wifi.sta.config({ssid=conf.client.ssid, pwd = conf.client.password})
   wifi.sta.connect()
   wifi.sta.sethostname("ESP-"..node.chipid())
   if conf.ip then
      wifi.sta.setip({ip=conf.ip,netmask=conf.netmask,gateway=conf.gateway})
   end
   wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,function(args)
      print("wifi: ",conf.client.ssid,wifi.sta.getip())
      dofile("net.up.lua")
      wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,function(args)
         print("wifi: lost connectivity, reconnecting ...")
         dofile("net.down.lua")
      end)
   end)
else 
   wifi.setmode(wifi.SOFTAP)
   wifi.ap.config(conf.ap.config)
   wifi.ap.setip(conf.ap.net)
   print("wifi: "..conf.ap.config.ssid.." access point ("..wifi.sta.getmac()..")")
   dofile("net.up.lua")
end


