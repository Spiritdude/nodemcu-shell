# NodeMCU UNIX-like Shell

** Highly Experimental: API and Skeleton might change at any time **

This provides a UNIX-like Shell for the NodeMCU platform (ESP8266: 32KB RAM, 512K-16MB flash, 80MHz RISC Processor with WIFI, cost ~ USD/EUR 2.00-5.00).

NodeMCU is a LUA runtime environment, so the "shell" is written in LUA.

Example:
```
% ls
/
   161  args/main.lua
    59  args2/main.lua
   540  blink/main.lua
   642  compile_all/main.lua
    81  init.lua
    30  net.down.lua
    53  net.up.lua
...
                         
% df
Filesystem    Total    Used   Avail.   Use%  Mounted On
/flashfs      3322738  26606  3296132  0%    /

% uptime
0d 00h 46m 51s

% cat startup.lua
-- add action done at boot/startup
dofile("wifi/main.lua")

% help
available commands:
   args
   blink
   cat
   compile
   cp
   date
   df
   echo
   help
   hostname
   ls
   mv
   rm
   sysinfo
   time
   touch
   uptime

```

## Layout of Commands

Following filesystem layout has been adopted:
- every command or app has its own directory or namespace, with main entry point of `<appname>/main.lua`
- each `main.lua` must conform to following skeleton:

```
return function(arg) 
   -- arg[1] contains the command name itself (e.g. 'ls')
   -- arg[2] optionally contains the first argument (e.g. `ls a.lua` then it arg[2] = "a.lua")
   -- etc.
end
```

`shell/main.lua` is the NodeMCU shell main entry, it opens a telnet server at port 2323 (default).

At first you need to configure `wifi/wifi.conf`, first copy `wifi/wifi.conf.dist` to `wifi/wifi.conf` and edit it:
```
return {
   mode = "client",     -- "client" or "ap"
   client = {
      ssid = "yourWIFI"
      password = "youWIFIpassword"
   },
   ap = { 
      config = {
         ssid = "ESP-"..node.chipid(),
         pwd = "Pass"..node.chipid()
      },
      net = {
         ip = "192.168.111.1",
         netmask = "255.255.255.255",
         gateway = "192.168.111.1"
      }
   }
}
```

Either have the device join your existing WIFI, edit then part of "client" part, or let the device operate as access point (AP) then change "mode" to "ap", and keep the defaults otherwise.

## Requirements
Install `nodemcu-tool` via
```
sudo npm install nodemcu-tool -g
```

## Installation
Then you do 
```
% make upload_all
```

which uploads the entire setup to your NodeMCU/ESP8266 device.

If your device resides somewhere else than the default (`/dev/ttyUSB0`), set it with `PORT=<device>`, for example:
```
% make PORT=/dev/ttyUSB4 upload_all
```

Once all uploaded fine, you reset the device.

Preferably start a terminal to see the NodeMCU console:
```
% nodemcu-tool --port /dev/ttyUSB0 terminal
```

Once your device becomes available via WIFI (as client or access point), you see the IP in the console, then you can telnet to it, for example:
```
% telnet 192.168.2.119 2323
Trying 192.168.2.119...
Connected to 192.168.2.119.
Escape character is '^]'.
== Welcome to NodeMCU Shell 0.0.2
% help
```

Type in 'help' and hit RETURN and it will list the available commands.

## LS
## CAT
## ECHO
## MV
## RM
## CP
## BLINK
## HEAP
## UPTIME
## HOSTNAME
## TIME
## TOUCH
## SYSINFO
## COMPILE
## REBOOT

