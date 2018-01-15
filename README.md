# NodeMCU Shell (UNIX-like)

**NOTE: Highly experimental, API and Filesystem skeleton might change at any time**

This provides a **UNIX-like Shell for the NodeMCU platform** with **[ESP8266](https://en.wikipedia.org/wiki/ESP8266)**: 64KB/96KB RAM, 512K-16MB Flash, 80/160MHz RISC Processor with WIFI, cost ~ USD/EUR 1.50-5.00.

## Main Features
- simple commands with space separated arguments (including "string with spaces" or 'string with spaces' arguments)
- every command is a .lua (or .lc) script
 - command or app resides in `<appname>/main.lua` or `shell/<cmd>.lua`, so the shell is freely extendable
- shell accessible via telnet session (this might change later)

NodeMCU is a LUA runtime environment, so the shell is written in LUA.

### TODO
- improve stability (commands can take down the shell)
- piping and redirecting stdout with multiple commands
- scripting (writing scripts)
- readline() features (cursor left/right, up/down = history)
- always more commands
  - editor
  - ftpd or another upload/download functionality
  
## Examples
After power up or reboot, on the serial port of your ESP8266 / NodeMCU device:
```
NodeMCU custom build by frightanic.com
        branch: master
        commit: 5073c199c01d4d7bbbcd0ae1f761ecc4687f7217
        SSL: true
        modules: adc,bit,crypto,encoder,file,gpio,http,i2c,mdns,mqtt,net,node,rtctime,sjson,sntp,struct,tmr,u8g,uart,websocket,wifi,tls
 build  built on: 2018-01-05 07:53
 powered by Lua 5.1.4 on SDK 2.1.0(116b762)
INFO [0.339] device 10448928 / 0x9f7020 starting up
INFO [0.421] init display driver: mode i2c, 128x64
INFO [0.741] wifi: connecting to WLAN-XYZ ...
INFO [3.718] wifi: connected to WLAN-XYZ 192.168.2.119
INFO [3.902] nodemcu shell started on 192.168.2.119 port 2323
INFO [4.611] sntp:sync response from 195.50.171.101
INFO [4.629] rtc: 2018/01/14 12:00:08 UTC (1515931208)
```

On your desktop or host use `telnet` to enter the NodeMCU Shell:
```
> telnet 192.168.2.119 2323
Trying 192.168.2.119...
Connected to 192.168.2.119.
Escape character is '^]'.

== Welcome to NodeMCU Shell 0.0.6 on ESP-XYZ (XYZ / 0xffffff)

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
   args            help             ....
   blink           hostname         ...
   cat             ls               ..
   compile         lua              .
   cp              mv
   date            ping
   df              reboot
   dofile          rm
   echo            sysinfo
   exit            time
   grep            touch
   heap            uptime

% exit
Connection closed by foreign host.
```

## System Layout of Commands

Following filesystem layout has been adopted:
- every **command** or app has its own directory or namespace, with main entry point of `<appname>/main.lua`
- every **shell built-in command** resides in `shell/<command>.lua`
- each `main.lua` or `shell/<command>.lua` must conform to following skeleton:

```
return function(...) 
   -- arg[1] contains the command name itself (e.g. 'ls')
   -- arg[2] optionally contains the first argument (e.g. `ls a.lua` then arg[2] = "a.lua")
   -- etc.
end
```

- every **configuration** has `.conf` as extension but is also LUA code like:
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

- every **service** has a `<service>/init.lua` and if possible a `<service>/<service>.conf` along:
  - `wifi/init.lua`: `wifi/wifi.conf` as configuration, triggers `net.up.lua` and `net.down.lua`
  - `rtc/init.lua`: tries to retrieve real time clock from various sources (via sntpd/http)
  - `display/init.lua`: `display/display.conf` as configuration, initializes a display (e.g. an I2C OLED)
  - `httpd/init.lua`: `httpd/httpd.conf` as configuration, simple http/web server
  - more to come ...

- every **library** for common use resides in `lib/*` like:
  - `lib/console.lua`: provides `console.print()` as replacement of `print()`
  - `lib/syslog.lua`: simple syslog functionality to log INFO, WARN, ERROR or FATAL messages
  - `lib/display.lua`: provides higher level display functionality (e.g. `display.print()` with autoscroll)

Finally, `shell/main.lua` is the NodeMCU shell main entry, it opens a telnet server at port 2323 (default).

## Console vs Syslog vs Print

`print()` and `node.output()` interfer with the serial port where the upload is happening. 
To resolve this and have also a cleaner setup:
- `console.print()`: print to the console (whereever this ends up to be), defined in `lib/console.lua`
  - `console.output(function(s) .. end)` allows redirecting
- `syslog.print(type,message)` is for logging system stuff, type: `syslog.INFO`, `syslog.WARN`, `syslog.ERROR` or `syslog.FATAL` and is defined in `lib/syslog.log`

**Note**: do **not** use `print()` in anything anymore within NodeMCU Shell and its realm, but use `console.print()`.

## Everything is a File (No Directories)

Currently NodeMCU uses SPIFFS (SPI Flash File System) which is very simple with little RAM consumption:
- everything is a file
- the '/' is part of the filename, and only helps you (human) to think in terms of quasi directories
- there are no directories, hence no `mkdir`
- and the maximum length of a filename is 32 characters, so keep this in mind as well

## Network Configuration

You need to configure `wifi/wifi.conf`: first copy `wifi/wifi.conf.dist` to `wifi/wifi.conf` and edit it:
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

Either have the device join your existing WIFI, edit then the "station" part, or let the device operate as access point (AP) then change "mode" to "ap", and keep the defaults otherwise.

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

== Welcome to NodeMCU Shell 0.0.6 on ESP-XYZ (XYZ / 0xffffff)

% help
available commands:
   args            ...
   blink           ..
   cat             .
   compile         .
   cp              .
   date            .
   ...             .
   
```

## ls
```
% ls
args/main.lua           ....
blink/main.lua          ...
compile/main.lua        ..
...                     .
..                      .
.                       .

% ls -l
-rwx     258  Jan  1 1970  args/main.lua
-rwx      59  Jan  1 1970  args2/main.lua
-rwx     540  Jan  1 1970  blink/main.lua
-rwx    1108  Jan  1 1970  compile/main.lua
...

% ls -l init.lua
-rwx      81  Jan  1 1970  init.lua
```

## cat & more
Display content of a file:
```
% cat net.up.lua
-- do things when net is up
dofile("rtc/init.lua")
dofile("shell/main.lua")
```
`more` does the same as `cat` for now.

## echo
Echo the arguments:
```
% echo "hello world"
hello world
```

## clear
Clear screen:
```
% clear
```

## mv
Move or rename a file:
```
% mv tst.lua test.lua
```
 
## rm
Remove a file
```
% rm tst.lua
```

## cp
Copy a file
```
% cp tst.lua test.lua
```

## touch
Touch, update mtime (seems currently not working) of a file or create an empty file:
```
% touch x.lua
% ls -l x.lua
-rwx       0  Jan  1 1970  x.lua
```

## grep
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

## df
Disk space usage:
```
% df 
Filesystem  Total    Used  Avail.   Use%  Mounted On
/flashfs    3260490  63252 3197238  1%    /

% df -h
Filesystem  Total   Used  Avail.   Use%  Mounted On
/flashfs    3184K   61K   3122K    1%    /
```

## blink
Blink the on-board LED, with a particular frequency (default 500 = 500ms), 0 or "off" turns blinking off:
```
% blink
% blink 100
% blink 300 3     (blink 3 times then off)
% blink 0
% blink off
```

## heap
Display remaining heap (free RAM):
```
% heap
31064
```
## uptime
```
% uptime
0d 0h 44m 26s
```
## date
```
% date
2018/01/05 10:04:09 UTC
```
Hint: include **sntp** module in the firmware, and when wifi is configured, it will retrieve current time via a ntp server, see `net.up.lua` and `rtc/init.lua`.

## hostname
Display or set hostname:
```
% hostname
ESP-12345678
% hostname esp1
% hostname
esp1
```

## time
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
## sysinfo
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

## cpu
Display LuaKIPS (thousands of instructions per second) or select CPU frequency (80 or 160 MHz):
```
% cpu
645 LuaKIPS

% cpu 80
cpu freq = 80 MHz

% cpu 
322 LuaKIPS

% cpu 160
cpu freq = 160 MHz

% cpu
645 LuaKIPS

% cpu 200
ERROR: only 80 or 160 MHz supported: 200
```

## ping
```
% ping slashdot.org
PING slashdot.org (216.34.181.45) time 517ms
```
## compile
Compile does compile `.lua` into `.lc`, the shell prefers `.lc` over `.lua` when executing commands - in other words, once you start to execute `.lc` and you update the system with `.lua` files, keep your `.lc` in sync.
```
% compile args/main.lua
> compile args/main.lua: args/main.lc
```

## wc
Count lines, words and characters:
```
% wc startup.lua
  19    60    687 startup.lua
```

## args
Display arguments for debug purposes:
```
% args "abc def" 5 14
arg[1] = 'args'
arg[2] = 'abc def'
arg[3] = '5'
arg[4] = '14'
```
## dofile
Execute a .lua file via `dofile()`:
```
% dofile example.lua
```
## lua
Execute actual LUA code:
```
% lua 'print("abc")'
abc

% lua 'print(node.bootreason())'
2     6
```
## reboot
```
% reboot
```
### exit
This is a built-in command (there is no corresponding .lua) and disconnects telnet session:
```
% exit
Connection closed by foreign host.
```

## Related Projects
- [ESuite-LUA](https://github.com/BLavery/esuite-lua): collection of libraries, very useful, uses simple `dofile()` to load individual libraries

