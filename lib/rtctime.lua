-- == RTCTIME Module ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Providing rtctime in case module doesn't exist
-- History: 
-- 2018/02/10: 0.0.1: moved from rtc/init.lua to here

rtctime = {
   t = 0,
   set = function(t) 
      rtctime.t = t - tmr.time()
   end,
   get = function()
      return rtctime.t + tmr.time()
   end,
   epoch2cal = function(t)
      local tm = { }
      local dc = t % (24*60*60)     -- based on gmtime.c
      tm.sec = dc % 60
      tm.min = int(dc % 3600) / 60
      tm.hour = int(dc / 3600)
      local y = 1970
      local dno = int(t / (24*60*60))
      local dm = { { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }, { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 } }
      local lp = function(y) return ((y%4) == 0) and not ((y%100)==0 and (y%400)~=0) end
      local ys = function(y) return 365 + (lp(y) and 1 or 0) end
      tm.wday = (dno + 4) % 7
      while(dno >= ys(y)) do
         dno = dno - ys(y)
         y = y + 1
      end
      tm.yday = dno
      tm.mon = 1
      while(dno >= dm[lp(y) and 2 or 1][tm.mon]) do
         dno = dno - dm[lp(y) and 2 or 1][tm.mon]
         tm.mon = tm.mon+1
      end
      tm.day = dno+1
      tm.year = y
      return tm
   end
}

