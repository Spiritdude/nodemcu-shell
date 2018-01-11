# NodeMCU Shell (UNIX-like)

**NOTE: Highly experimental: API and Filesystem skeleton might change at any time**

This provides a **UNIX-like Shell for the NodeMCU platform** with **[ESP8266](https://en.wikipedia.org/wiki/ESP8266)**: 64KB/96KB RAM, 512K-16MB Flash, 80MHz RISC Processor with WIFI, cost ~ USD/EUR 1.50-5.00.
- simple commands with space separated arguments (including "string with spaces" or 'string with spaces' arguments)
- every command is a .lua (or .lc) script
 - command or app resides in `<appname>/main.lua` or `shell/<cmd>.lua`, so the shell is freely extendable
- shell accessible via telnet session (this might change later)

NodeMCU is a LUA runtime environment, so the shell is written in LUA.

**TODO**
- improve stability (commands can take down the shell)
- piping and redirecting stdout with multiple commands
- scripting (writing scripts)
- readline() features (cursor left/right, up/down = history)
- always more commands
  - editor
  - ftpd or another upload/download functionality
  
## Examples
```
> telnet 192.168.2.119 2323
Trying 192.168.2.119...
Connected to 192.168.2.119.
Escape character is '^]'.
== Welcome to NodeMCU Shell 0.0.4
% ls -l
-rwx     258  Jan  1 1970  args/main.lua
-rwx      59  Jan  1 1970  args2/main.lua
-rwx     540  Jan  1 1970  blink/main.lua
-rwx    1108  Jan  1 1970  compile/main.lua
-rwx      81  Jan  1 1970  init.lua
-rwx      30  Jan  1 1970  net.down.lua
-rwx      76  Jan  1 1970  net.up.lua
-rwx    1359  Jan  1 1970  rtc/init.lua
-rwx     327  Jan  1 1970  shell/cat.lua
-rwx     771  Jan  1 1970  shell/cp.lua
-rwx     476  Jan  1 1970  shell/date.lua
-rwx     537  Jan  1 1970  shell/df.lua
-rwx     246  Jan  1 1970  shell/dofile.lua
...
                         
% df
Filesystem    Total    Used   Avail.   Use%  Mounted On
/flashfs      3322738  26606  3296132  0%    /

% uptime
0d 0h 46m 51s

% cat startup.lua
-- add action done at boot/startup
dofile("wifi/wifi.lua")

% help
available commands:
   args
   blink
   cat
   compile
   cp
   date
   df
   dofile
   echo
   exit
   grep
   heap
   help
   hostname
   ls
   lua
   mv
   ping
   reboot
   rm
   sysinfo
   time
   touch
   uptime

% exit
Connection closed by foreign host.
```

## Layout of Commands

Following filesystem layout has been adopted:
- every command or app has its own directory or namespace, with main entry point of `<appname>/main.lua`
- every shell built-in command resides in `shell/<command>.lua`
- each `main.lua` or `shell/<command>.lua` must conform to following skeleton:

```
return function(...) 
   -- arg[1] contains the command name itself (e.g. 'ls')
   -- arg[2] optionally contains the first argument (e.g. `ls a.lua` then arg[2] = "a.lua")
   -- etc.
end
```

- every configuration has `.conf` as extension but is also LUA code like:
```
return {
   key1 = "value 1",
   key2 = "value 2",
   deeper = {
      key11 = "value 1.1"
   }
}
```
- `.conf.dist` are suggested configuration, and user must copy it to `.conf` - this way you can edit `.conf` and won't be overwritten when you update and upload the NodeMCU Shell.

Finally, `shell/main.lua` is the NodeMCU shell main entry, it opens a telnet server at port 2323 (default).

## Console vs Syslog vs Print

`print()` and `node.output()` interfer with the serial port where the upload is happening. 
To resolve this and have also a cleaner setup:
- `console.print()`: print to the console (whereever this ends up to be), defined in `lib/console.lua`
  - `console.output(function(s) .. end)` allows redirecting
- `syslogs.print(type,message)` is for logging system stuff, type: `syslog.INFO`, `syslog.WARN`, `syslog.ERROR` or `syslog.FATAL` and is defined in `lib/syslog.log`

Note: do **not** use `print()` in anything anymore, but use `console.print()`.

## Everything is a File (No Directories)

Hint: currently NodeMCU uses SPIFFS (SPI Flash File System) which is very simple with little RAM consumption:
- everything is a file
- the '/' is part of the filename, and only helps you (human) to think in terms of quasi directories
- there are no directories, hence no `mkdir`
- and the maximum length of a filename is 32 characters, so keep this in mind as well

## Network Configuration

At first you need to configure `wifi/wifi.conf`, first copy `wifi/wifi.conf.dist` to `wifi/wifi.conf` and edit it:
```
return {
   mode = "station",     -- "station" or "ap"
   station = {
      config = {
         ssid = "yourWIFI",
         password = "youWIFIpassword"
      }
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

## Firmware
The recommended modules for your firmware from [nodemcu-build.com](https://nodemcu-build.com):
- **adc** (recommended)
- **bit**
- **crypto**
- **encoder**
- **file**
- **gpio**
- **http**
- **i2c** (recommended)
- **mdns**
- **mqtt** (recommended)
- **net**
- **node**
- **rtctime**
- **sjson**
- **sntp** (recommended)
- **struct**
- **tmr**
- **u8g** (monochrome) or **ucg** (color): if you have a display attached, then add module **spi** as well
- **uart**
- **websocket** (recommended)
- **wifi**
- **tls** (enable it after the list of the modules)

Install proper firmware with `esptool.py` or other flashing tool.

## Installation
To install the shell with its own `init.lua` and `startup.lua` chain:
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
== Welcome to NodeMCU Shell 0.0.4
% help
available commands:
   args
   blink
   cat
   compile
   cp
   date
   ...
   
```

## LS
```
% ls
args/main.lua
blink/main.lua
compile/main.lua
...

% ls -l
-rwx     258  Jan  1 1970  args/main.lua
-rwx      59  Jan  1 1970  args2/main.lua
-rwx     540  Jan  1 1970  blink/main.lua
-rwx    1108  Jan  1 1970  compile/main.lua
...

% ls -l init.lua
-rwx      81  Jan  1 1970  init.lua
```

## CAT
Display content of a file:
```
% cat net.up.lua
-- do things when net is up
dofile("rtc/init.lua")
dofile("shell/main.lua")

```

## ECHO
Echo the arguments:
```
% echo "hello world"
hello world
```

## CLEAR
Clear screen:
```
% clear
```

## MV
Move or rename a file:
```
% mv tst.lua test.lua
```
 
## RM
Remove a file
```
% rm tst.lua
```

## CP
Copy a file
```
% cp tst.lua test.lua
```

## TOUCH
Touch, update mtime (seems currently not working) of a file or create an empty file:
```
% touch x.lua
% ls -l x.lua
-rwx       0  Jan  1 1970  x.lua
```

## GREP
Simple `grep`:
```
% grep lua startup.lua
dofile("wifi/wifi.lua")

% grep dofile shell/main.lua
-- 2018/01/04: 0.0.3: unpacking args at dofile()
              dofile("shell/"..cmd..".lc")(unpack(a))
              dofile("shell/"..cmd..".lua")(unpack(a))
              dofile(cmd.."/main.lc")(unpack(a))
              dofile(cmd.."/main.lua")(unpack(a))
              dofile(cmd..".lua")(unpack(a))
```

## DF
Disk usage:
```
% df 
Filesystem  Total    Used  Avail.   Use%  Mounted On
/flashfs    3260490  63252 3197238  1%    /

% df -h
Filesystem  Total   Used  Avail.   Use%  Mounted On
/flashfs    3184K   61K   3122K    1%    /
```

## BLINK
Blink the on-board LED, with a particular frequency (default 500 = 500ms), 0 or "off" turns blinking off:
```
% blink
% blink 100
% blink 0
% blink off
```

## HEAP
Display remaining heap (free RAM):
```
% heap
31064
```
## UPTIME
```
% uptime
0d 0h 44m 26s
```
## DATE
```
% date
2018/01/05 10:04:09 UTC
```
Hint: include **sntp** module in the firmware, and when wifi is configured, it will retrieve current time via a ntp server, see `net.up.lua` and `rtc/init.lua`.

## HOSTNAME
Display or set hostname:
```
% hostname
ESP-12345678
% hostname esp1
% hostname
esp1
```

## TIME
Measure execution time of commands:
```
% time
0ms
% time ls
....
520ms
% time cat init.lua
-- DO NOT CHANGE
if file.exists("startup.lua") then
   dofile("startup.lua")
   end
   
298 ms
```   
## SYSINFO
Display system info:
```
% sysinfo
Chip ID: 12345678
Flash ID: 7654321
Heap: 23888
Info: 2 1
Uptime: 0d 0h 47m 1s
Vdd: 2956 mV
File System Address: 720896
File System Size: 3448832 bytes
RTC Time: 2018/01/05 10:06:30
File System Usage: 63252 / 3260490 bytes
Wifi STA MAC Address: xx:xx:xx:xx:xx:xx
Wifi AP MAC Address: xx:xx:xx:xx:xx:xx
WiFi Channel: 6
WiFi Mode: STATION
WiFi Physical Mode: N
wifi.sta.status: STA_GOTIP
Hostname: esp1
STA IP: 192.168.2.119
STA netmask: 255.255.255.0
STA gateway: 192.168.2.1
SSID: WLAN-XYZ
BSSID set: 0
BSSID: xx:xx:xx:xx:xx:xx
STA Broadcast IP: 192.168.2.255
RSSI: -80 dB
```

## PING
```
% ping slashdot.org
PING slashdot.org (216.34.181.45) time 517ms
```
## COMPILE
Compile does compile `.lua` into `.lc`, the shell prefers `.lc` over `.lua` when executing commands - in other words, once you start to execute `.lc` and you update the system with `.lua` files, keep your `.lc` in sync.
```
% compile args/main.lua
> compile args/main.lua: args/main.lc
```

## ARGS
Display arguments for debug purposes:
```
% args "abc def" 5 14
arg[1] = 'args'
arg[2] = 'abc def'
arg[3] = '5'
arg[4] = '14'
```
## DOFILE
Execute a .lua file via `dofile()`:
```
% dofile example.lua
```
## LUA
Execute actual LUA code:
```
% lua 'print("abc")'
abc

% lua 'print(node.bootreason())'
2     6
```
## REBOOT
```
% reboot
```
### EXIT
This is a built-in command (there is no corresponding .lua) and disconnects telnet session:
```
% exit
Connection closed by foreign host.
```
