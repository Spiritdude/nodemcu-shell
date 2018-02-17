-- == Timer(Tmr) Library ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Providing consistent ESP8266/ESP32 timer functionality
--       as ESP32 NodeMCU tmr.* lacks essential functionality like tmr.now() and tmr.time()
-- History: 
-- 2018/02/16: 0.0.1: adapted from lib/timer.lua but using same namespace 'tmr'

if arch == 'esp32' then
   tmr_esp32 = tmr
   tmr = setmetatable({}, { __index = tmr })
   tmr.create = tmr_esp32.create
   tmr.now = tmr_esp32.now
   tmr.time = tmr_esp32.time
   tmr.ALARM_SINGLE = tmr_esp32.ALARM_SINGLE
   tmr.ALARM_SEMI = tmr_esp32.ALARM_SEMI
   tmr.ALARM_AUTO = tmr_esp32.ALARM_AUTO
   if not tmr.time then        -- github.com/Spiritdude/nodemcu-firmware/dev-esp32 has it
      -- simulate actual time (UNIX epoch)
      tmr._time = 0
      tmr.create():alarm(1000,tmr.ALARM_AUTO,function()
         tmr._time = tmr._time + 1
      end)
      tmr.time = function() return tmr._time end
   end
   if not tmr.now then         -- github.com/Spiritdude/nodemcu-firmware/dev-esp32 has it
      -- simulate timer.now() in microseconds
      tmr._now = 0
      tmr.create():alarm(100,tmr.ALARM_AUTO,function()
         tmr._now = tmr._now+1000*100
      end)
      tmr.now = function() return tmr._now end
   end
end


