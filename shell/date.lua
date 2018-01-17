-- == Date ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: display rtc date
--
-- History:
-- 2018/01/05: 0.0.2: adding tz
-- 2018/01/04: 0.0.1: first version

return function(...) 
   local t = rtctime.get()
   if(t==0) then
      -- retrieve UTC remotely
   end
   local tm = rtctime.epoch2cal(t)
   local tz = 'UTC'
   console.print(string.format("%04d/%02d/%02d %02d:%02d:%02d %s",tm["year"],tm["mon"],tm["day"],tm["hour"],tm["min"],tm["sec"],tz))
end
