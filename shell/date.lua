-- == Date ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: display rtc date
--
-- History:
-- 2018/02/02: 0.0.3: rtc/rtc.conf support, tz_offset/name
-- 2018/01/05: 0.0.2: adding tz
-- 2018/01/04: 0.0.1: first version

return function(...) 
   local tzc = { tz_offset = 0, tz_name = 'UTC' }
   if file.exists("rtc/rtc.conf") then
      tzc = dofile("rtc/rtc.conf")
   end
   local t = rtctime.get()
   if(t==0) then
      -- retrieve UTC remotely
   end
   local tm = rtctime.epoch2cal(t + tzc.tz_offset*60*60)
   console.print(string.format("%04d/%02d/%02d %02d:%02d:%02d %s",tm["year"],tm["mon"],tm["day"],tm["hour"],tm["min"],tm["sec"],tzc.tz_name))
end
