# NodeMCU Shell (UNIX-like)

This provides a **UNIX-like Shell for the NodeMCU/Lua platform** for
- **[NodeMCU/ESP8266](https://en.wikipedia.org/wiki/ESP8266)**: 64KB/96KB RAM, 512KB-16MB Flash, 80/160MHz RISC Processor with WIFI, cost ~EUR 1.50-5.00 (2018/01)
- **[NodeMCU/ESP32](https://en.wikipedia.org/wiki/ESP32)**: 512KB RAM, 4MB-16MB Flash, 160/240MHz RISC Processor with WIFI, Bluetooth, cost ~EUR 4.00-7.00 (2018/01)
- **[NodeMCU/Linux](https://github.com/Spiritdude/nodemcu-linux)** (experimental): any device which runs Debian-based Linux with GPIO, I2C, SPI and alike interfaces, like Raspberry Pi, Orange Pi, NanoPi series, cost ~EUR 7.00-40.00 (2018/02)

## Main Features
- **commands with space separated arguments** (including "string with spaces" or 'string with spaces' arguments)
- **arguments with `*` or `?` are expanded**, e.g. `ls -l *.txt` or `grep dofile *.lua`
- **every command is a .lua (or .lc) script**
 - command or app resides in `<appname>/main.lua` or `shell/<cmd>.lua`, so the shell is freely extendable
- **shell accessible via telnet session** (this might change later)

NodeMCU is a Lua runtime environment, so the shell is written in Lua.

## Updates
- **0.1.0**: 
  - `exec`, `repeat` command added
  - `lib/exec.lua` to execute a program with arguments (additionally look in `apps/*` for executables)
  - `cp` works on esp32 as well
- **0.0.9**: `ls` list pseudo directories to decrease verbosity, `globals` list global variables
- **0.0.1**: basic functionality

### TODO
- improve stability (commands can take down the shell)
- piping and redirecting stdout with multiple commands
- scripting (writing scripts)
- readline() features (cursor left/right, up/down = history)
- always more commands
  - editor
  - ftpd or another upload/download functionality

**Note**: API and Filesystem skeleton might change at any time.
  
## Examples
After power up or reboot, on the serial port of your ESP8266 or ESP32 NodeMCU/Lua device:
```
NodeMCU custom build by frightanic.com
        branch: master
        commit: 5073c199c01d4d7bbbcd0ae1f761ecc4687f7217
        SSL: true
        modules: adc,bit,crypto,encoder,file,gpio,http,i2c,mdns,mqtt,net,node,rtctime,sjson,sntp,struct,tmr,u8g,uart,websocket,wifi,tls
 build  built on: 2018-01-05 07:53
 powered by Lua 5.1.4 on SDK 2.1.0(116b762)
 _  _         _     __  __  ___ _   _   ___ ___ ___ ___ ___  __   __ 
| \| |___  __| |___|  \/  |/ __| | | | | __/ __| _ ( _ )_  )/ /  / / 
| .` / _ \/ _` / -_) |\/| | (__| |_| | | _|\__ \  _/ _ \/ // _ \/ _ \
|_|\_\___/\__,_\___|_|  |_|\___|\___/  |___|___/_| \___/___\___/\___/
                                                                     
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
 _  _         _     __  __  ___ _   _   ___ ___ ___ ___ ___  __   __ 
| \| |___  __| |___|  \/  |/ __| | | | | __/ __| _ ( _ )_  )/ /  / / 
| .` / _ \/ _` / -_) |\/| | (__| |_| | | _|\__ \  _/ _ \/ // _ \/ _ \
|_|\_\___/\__,_\___|_|  |_|\___|\___/  |___|___/_| \___/___\___/\___/

Welcome to NodeMCU Shell 0.0.6 on ESP-XYZ (XYZ / 0xffffff)

% ls
args/                           md5sum/                         
args2/                          net.down.lua*                   
bench/                          net.up.lua*                     
blink/                          private/                        
buggy.lua*                      rtc/                            
cpu/                            shell/                          
display/                        smtpd/                          
edit/                           startup.lua*                    
empty.lua*                      telnet/                         
httpd/                          test.lua*                       
init.lua*                       test2.lua*                      
ipscan/                         tftpd/                          
led/                            wget/                           
lib/                            wifi/                           
luac/                           www/              

% ls -R
args/main.lua*                  shell/bnr.esp8266.bw.txt        
args2/main.lua*                 shell/bnr.esp8266.co.txt        
bench/main.lua*                 shell/buggy.lua*                
blink/main.lua*                 shell/cat.lua*                  
buggy.lua*                      shell/clear.lua*                
cpu/main.lua*                   shell/cp.lua*                   
display/display.conf.dist       shell/date.lua*                 
display/init.lua*               shell/df.lua*                   
display/logo.mono               shell/dofile.lua*               
display/logo48.mono             shell/echo.lua*                 
display/main.lua*               shell/exec.lua*      
....
..
.

% ls -l
drwx       0  Jan  1 1970  args/
drwx       0  Jan  1 1970  args2/
drwx       0  Jan  1 1970  bench/
drwx       0  Jan  1 1970  blink/
-rwx      14  Jan  1 1970  buggy.lua
drwx       0  Jan  1 1970  cpu/
drwx       0  Jan  1 1970  display/
drwx       0  Jan  1 1970  edit/
-rwx       0  Jan  1 1970  empty.lua
drwx       0  Jan  1 1970  httpd/
-rwx      81  Jan  1 1970  init.lua
....
...
.

% ls -lR
-rwx     258  Jan  1 1970  args/main.lua
-rwx      59  Jan  1 1970  args2/main.lua
-rwx     540  Jan  1 1970  blink/main.lua
-rwx      81  Jan  1 1970  init.lua
-rwx    1108  Jan  1 1970  luac/main.lua
-rwx      30  Jan  1 1970  net.down.lua
-rwx      76  Jan  1 1970  net.up.lua
-rwx    1359  Jan  1 1970  rtc/init.lua
-rwx     327  Jan  1 1970  shell/cat.lua
-rwx     771  Jan  1 1970  shell/cp.lua
-rwx     476  Jan  1 1970  shell/date.lua
-rwx     537  Jan  1 1970  shell/df.lua
-rwx     246  Jan  1 1970  shell/dofile.lua
...
..
.
                         
% df
Filesystem    Total    Used   Avail.   Use%  Mounted On
/flashfs      3322738  26606  3296132  0%    /

% uptime
0d 0h 46m 51s

% cat startup.lua
-- add action done at boot/startup
node.setcpufreq(node.CPU160MHZ)  -- 2x the speed
dofile("lib/console.lua")
dofile("lib/syslog.lua")
syslog.print(syslog.INFO,"device #"..node.chipid()..string.format(" / 0x%x",node.chipid()).." starting up")
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
                                                            
% help
available commands:
   args              dofile            ls                sysinfo        
   blink             echo              lua               time           
   cat               exit              man               touch          
   clear             grep              more              uptime         
   cp                heap              mv                wc             
   cpu               help              ping           
   date              hostname          reboot         
   df                led               rm             

% grep dofile *.lua
display/init.lua:    local conf = dofile("display/display.conf")
display/init.lua:                dofile("lib/display.lua")
edit/main.lua: dofile("edit/helpers.lua")
httpd/init.lua: dofile("httpd/simple.lua")
httpd/init.lua: -- dofile("httpd/complex.lua")      -- other httpd servers
httpd/simple.lua: local conf = dofile("httpd/httpd.conf")
httpd/simple.lua:          dofile(fn)(c,req,gv)                   -- let's execute it
...
..
.

% exit
Connection closed by foreign host.
```

**Hint**: hit CTRL + ']' and then 'q' to exist the current telnet session.

## System Layout of Commands

Following filesystem layout has been adopted:
- every **command** or app has its own directory or namespace, with main entry point of `<appname>/main.lua`
- every **shell built-in command** resides in `shell/<command>.lua`
- each `<appname>/main.lua` or `shell/<command>.lua` must conform to following skeleton:

```
return function(...) 
   -- arg[1] contains the command name itself (e.g. 'ls')
   -- arg[2] optionally contains the first argument (e.g. `ls a.lua` then arg[2] = "a.lua")
   -- etc.
end
```

- every **configuration** has `.conf` as extension but is also Lua code like:
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
  - `rtc/init.lua`: tries to retrieve real time clock from various sources (via sntp/http)
  - `display/init.lua`: `display/display.conf` as configuration, initializes a display (e.g. an I2C OLED)
  - `httpd/init.lua`: `httpd/httpd.conf` as configuration, simple http/web server
  - more to come ...

- every **library** for common use resides in `lib/*` like:
  - `lib/console.lua`: provides `console.print()` as replacement of `print()`
  - `lib/syslog.lua`: simple syslog functionality to log INFO, WARN, ERROR or FATAL messages
  - `lib/display.lua`: provides higher level display functionality (e.g. `display.print()` with autoscroll)
  - `lib/timer.lua`: replacing `tmr.*` to make ESP32 / ESP8266 compatible
  - `lib/http.lua`: ESP32 only `http` library (ESP8266 has it already)
  
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
   mode = "station",     -- "station" (client) or "ap" (access point) or "stationap" (both)
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

Either have the device join your existing WIFI, edit then the "station" part, or let the device operate as access point (AP) then change "mode" to "ap", or run both at the same time, being an access point and join an existing WIFI.
Check `wifi/readme.txt` for defining multiple stations.

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

Install the firmware with `esptool.py` or other flashing tool.

### Float vs Integer Firmware
NodeMCU Shell is tolerant whether you use `-float.bin` or `-integer.bin` firmware, but for the ESP8266 preferably use the `-integer.bin` which is apprx. ~3.5KB RAM/Heap lighter (NodeMCU 2.1).

Hint: `lib/integer.lua`, which is loaded by default, contains a single function called `int()` and converts a number (integer or float) to an integer.
Whenever you code with integers in mind, convert with `int()` so regardless which firmware is loaded the code behaves
the same way.

### Prebuilt ESP8266 Firmware
- **[nodemcu-master-2018-01-05-integer.bin](fw/nodemcu-master-oled-2018-01-05-font_4x6,font_6x10,font_6x12,font_helvR08,font_chikita,font_04b_03-integer.bin)**  (4MB flash)
  - with ssd1306 128x64 OLED controller support and couple of fonts
  - flash with `esptool.py write_flash -fm dout 0 nodemcu-...bin`

### Prebuilt ESP32 Firmware
- **[nodemcu-esp32-spiritdude-math-2018-03-08-clean.bin](fw/nodemcu-esp32-spiritdude-math-2018-03-08-clean.bin)** (4MB flash)
  - `dev-esp32` branch with my extensions: `node.info()` support added, and `tmr.now()`, `tmr.time()` and `tmr.uptime()` etc, with `math` library experimentally enabled, contains ssd1306 128x64 OLED controller support and a few fonts
  - **Note**: requires my patched [nodemcu-tool](https://github.com/Spiritdude/nodemcu-tool) to upload Lua code when you use this firmware
  - flash with `esptool.py write_flash -fm dout 0 nodemcu-...bin`
  
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

In case you develop with multiple attached NodeMCU devices, consider my [nodemcu-enum](https://github.com/Spiritdude/nodemcu-enum).

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
 _  _         _     __  __  ___ _   _   ___ ___ ___ ___ ___  __   __ 
| \| |___  __| |___|  \/  |/ __| | | | | __/ __| _ ( _ )_  )/ /  / / 
| .` / _ \/ _` / -_) |\/| | (__| |_| | | _|\__ \  _/ _ \/ // _ \/ _ \
|_|\_\___/\__,_\___|_|  |_|\___|\___/  |___|___/_| \___/___\___/\___/
                                                                     
Welcome to NodeMCU Shell 0.0.6 on ESP-XYZ (XYZ / 0xffffff)

% help
available commands:
   args              dofile            ls                sysinfo        
   blink             echo              lua               time           
   cat               exit              man               touch          
   clear             grep              more              uptime         
   cp                heap              mv                wc             
   cpu               help              ping           
   date              hostname          reboot         
   df                led               rm             
   
```

## ls
List content of flash storage, by default it presents "pseudo" directory view (all files with '/'), `-R` shows all files:
```
% ls
args/                           ipscan/                         startup.lua*                    
args2/                          led/                            telnet/                         
bench/                          lib/                            test.lua*                       
blink/                          luac/                           test/                           
buggy.lua*                      md5sum/                         test2.lua*                      
cpu/                            net.down.lua*                   tftpd/                          
display/                        net.up.lua*                     wget/                           
edit/                           private/                        wifi/                           
empty.lua*                      rtc/                            www/                            
httpd/                          shell/                          
init.lua*                       smtpd/                          

% ls -R
args/main.lua*                  rtc/init.lua*                   shell/ping.lua*                 
blink/main.lua*                 shell/cat.lua*                  shell/reboot.lua*               
cpu/main.lua*                   shell/clear.lua*                shell/rm.lua*                   
display/init.lua*               shell/cp.lua*                   shell/sysinfo.lua*              
display/logo.mono               shell/date.lua*                 shell/time.lua*                 
display/logo48.mono             shell/df.lua*                   shell/touch.lua*                
display/readme.txt              shell/dofile.lua*               shell/uptime.lua*               
httpd/header.lua*               shell/echo.lua*                 shell/wc.lua*                   
httpd/init.lua*                 shell/grep.lua*                 startup.lua*                    
httpd/readme.txt                shell/heap.lua*                 wifi/init.lua*                  
httpd/simple.lua*               shell/help.lua*                 wifi/readme.txt                 
init.lua*                       shell/hostname.lua*             wifi/wifi.conf                  
led/main.lua*                   shell/ls.lua*                   www/api.lua*                    
led/man.txt                     shell/ls.txt                    www/favicon.ico.gz              
led/readme.txt                  shell/lua.lua*                  www/imgs/esp8266.png.gz         
lib/console.lua*                shell/main.lua*                 www/imgs/espressif.png.gz       
lib/display.lua*                shell/man.lua*                  www/imgs/nodemcu.png.gz         
lib/syslog.lua*                 shell/more.lua*                 www/index.html                  
net.down.lua*                   shell/mv.lua*                   www/simple.lua*                 
net.up.lua*                     shell/mv.txt                    www/sysinfo.lua*     

% ls -l
-rwx     258  Jan  1 1970  args/main.lua
-rwx     540  Jan  1 1970  blink/main.lua
...
..
.

% ls -l init.lua
-rwx      81  Jan  1 1970  init.lua

% ls shell
shell/bnr.esp32.bw.txt          shell/esp8266.co.txt            shell/mv.txt                    
shell/bnr.esp32.co.txt          shell/exec.lua*                 shell/ping.lua*                 
shell/bnr.esp8266.bw.txt        shell/globals.lua*              shell/reboot.lua*               
shell/bnr.esp8266.co.txt        shell/grep.lua*                 shell/rm.lua*                   
shell/buggy.lua*                shell/heap.lua*                 shell/shell.conf                
shell/cat.lua*                  shell/help.lua*                 shell/shell.conf.dist           
shell/clear.lua*                shell/hostname.lua*             shell/sysinfo.lua*              
shell/cp.lua*                   shell/ls.lua*                   shell/template                  
shell/date.lua*                 shell/ls.txt                    shell/time.lua*                 
shell/df.lua*                   shell/lua.lua*                  shell/touch.lua*                
shell/dofile.lua*               shell/main-ss.lua*              shell/uptime.lua*               
shell/echo.lua*                 shell/main.lua*                 shell/wc.lua*                   
shell/esp32.bw.txt              shell/man.lua*                  shell/wifi.lua*                 
shell/esp32.co.txt              shell/more.lua*                 
shell/esp8266.bw.txt            shell/mv.lua*                   

```
options:
- `-1` single column
- `-2` double column
- `-3` triple column
- `-4` quadruple column
- `-l` long output
- `-R` recursive

By default the amount of columns are calculated according size of shell window.

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
...
..
.
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

## globals
Displays global variables (_G table):
```
% globals
__index (lightfunction)
__nmtwrite (function)
a (table)
arch (string): esp8266
console (table)
gpiox (romtable)
int (function)
ipairs (function)
module (function)
newproxy (function)
package (table)
pairs (function)
printTable (function)
require (function)
shell_srv (userdata)
sysconf (table)
syslog (table)
terminal (table)
timer (romtable)

% globals -r
   __index (lightfunction)
   __nmtwrite (function)
   a (table)
      1 (string): globals
      2 (string): -r
   arch (string): esp8266
   console (table)
      input (function)
      output (function)
      print (function)
   gpiox (romtable)
      FLOAT (number): 0
      HIGH (number): 1
      INPUT (number): 0
      INT (number): 2
      LOW (number): 0
      OPENDRAIN (number): 3
      OUTPUT (number): 1
      PULLUP (number): 1
      mode (lightfunction)
      read (lightfunction)
      serout (lightfunction)
      trig (lightfunction)
      write (lightfunction)
...
..
.

% globals terminal syslog
terminal:
   height (number): 32
   input (function)
   output (function)
   print (function)
   width (number): 132
syslog:
   ERROR (number): 2
   FATAL (number): 3
   INFO (number): 0
   WARN (number): 1
   count (number): 0
   level (number): 0
   print (function)
   verbose (function)
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
## luac
Compile does compile `.lua` into `.lc`, the shell prefers `.lc` over `.lua` when executing commands - in other words, once you start to execute `.lc` and you update the system with `.lua` files, keep your `.lc` in sync.
```
% luac args/main.lua
> luac args/main.lua: args/main.lc
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

% args *.txt
arg[1] = 'args'
arg[2] = 'display/readme.txt'
arg[3] = 'httpd/readme.txt'
arg[4] = 'led/man.txt'
arg[5] = 'led/readme.txt'
arg[6] = 'shell/ls.txt'
arg[7] = 'shell/mv.txt'
arg[8] = 'wifi/readme.txt'
```

## display
Manipulate the display (e.g. I2C connected OLED as configured in `display/display.conf`):
```
Usage: display <cmd> <settings>
   commands:
      on                   display on (default)
      off                  display off (sleep)
      print <string> ..    print strings (like `echo`)
      contrast <value>     value: 0..255
      font <font>          font: font_chikita, font_6x10 etc
      rotate <angle>       angle: 0, 90, 180, 270
      clear                clear screen
      info                 show display info
```
Examples:
```
% display print "hello world"
% display font font_6x10
% display rotate 90
% display off
% display on
```

Note: you can only select fonts which are included in the firmware.

## dofile
Execute a .lua file via `dofile()`:
```
% dofile example.lua
```

Note: commands which can be executed by the shell need to return a function, `dofile` just executes a "raw" .lua file;
unfortunately `dofile("test.lua")` (raw) and `dofile("test.lua")()` (returns a function) are two different things and
not interchangable.

## lua
Execute actual Lua code:
```
% lua 'print("abc")'
abc

% lua 'print(node.bootreason())'
2     6
```

## exec
Execute another program with its optional arguments:
```
% exec echo "hello world"
hello world
```

## repeat
Repeat n-times another program with its arguments:
```
% repeat 3 echo "hello world"
hello world
hello world
hello world

% repeat 3 time bench
arithmetic: 212 LuaKIPS
while-loop: 733 LuaKIPS
function: 283 LuaKIPS
822 ms
arithmetic: 211 LuaKIPS
while-loop: 746 LuaKIPS
function: 285 LuaKIPS
811 ms
arithmetic: 204 LuaKIPS
while-loop: 746 LuaKIPS
function: 296 LuaKIPS
811 ms

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
- [NodeMCU Platform](https://github.com/devyte/nodemcu-platform): some formalism on apps on ESP8266, conceived 2016, abandoned in 2017/01.
- [ESuite-Lua](https://github.com/BLavery/esuite-lua): collection of libraries, very useful, uses simple `dofile()` to load individual libraries
- [ESP8266 Frankenstein](https://github.com/nekromant/esp8266-frankenstein): terminal software with a few useful commands specific to ESP8266.

