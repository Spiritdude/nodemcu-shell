-- add action done at boot/startup
dofile("lib/syslog.lua")
syslog.print(0,"device "..node.chipid()..string.format("/0x%x",node.chipid()).." starting up")
dofile("wifi/wifi.lua")
