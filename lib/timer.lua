-- == Time Library ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Providing consistent ESP8266/ESP32 timer functionality
--       as ESP32 NodeMCU tmr.* lacks essential functionality
--    Use timer.* instead of tmr.* to stay compatible
-- History: 
-- 2018/01/30: 0.0.1: timer.time() and timer.now() for ESP32

if arch == 'esp32' then
   timer = { }

   -- simulate actual time (UNIX epoch)
   timer._time = 0
   tmr.create():alarm(1000,tmr.ALARM_AUTO,function()
      timer._time = timer._time + 1
   end)
   timer.time = function() return timer._time end
   tmr.time = timer.time   -- won't work
   
   -- simulate timer.now() in microseconds
   timer._now = 0
   tmr.create():alarm(100,tmr.ALARM_AUTO,function()
      timer._now = timer._now+1000*100
   end)
   timer.now = function() return timer._now end
   tmr.now = timer.now  -- won't work
   
   timer.create = tmr.create
   timer.ALARM_SINGLE = tmr.ALARM_SINGLE
   timer.ALARM_SEMI = tmr.ALARM_SEMI
   timer.ALARM_AUTO = tmr.ALARM_AUTO
else
   timer = tmr
end

