-- do things when net is up
dofile("rtc/init.lua")
dofile(arch=='linux' and "shell/main.lua" or "shell/main.lc")
if arch=='esp32' then
   dofile("httpd/init.lua")
end
--dofile("tftpd/init.lua")()
