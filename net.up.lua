-- do things when net is up
dofile("rtc/init.lua")
dofile("shell/main.lc")
if arch=='esp32' then
   dofile("httpd/init.lua")
end
--dofile("tftpd/init.lua")()
