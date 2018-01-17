-- == RTC ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: try to get realtime clock with actual time (if required) from various sources
--
-- History: 
-- 2018/01/17: 0.0.3: rtctime.set,get,epoch2cal implemented as fallback
-- 2018/01/12: 0.0.2: better fallback and proper JSON epoch parsing (indirect)
-- 2018/01/04: 0.0.1: first version

local function httpsync() 
   if http then
      local now = tmr.time()
      local h = 'http://now.httpbin.org/'       -- http (instead of https) in case tls is not included
      http.get(h,nil,
         function(code,data)
            if code < 0 then
               syslog.print(syslog.WARN,"rtc: fallback failed as well, no current time available")
            elseif sjson then
               --local d = sjson.decode(data)         -- doesn't work, we can't handle floats (d.now.epoch)
               --local t = d and d.now and d.now.epoch or 0
               local t = string.match(data,'"epoch":%s*(%d+)')    -- we parse JSON portion direct
               if rtctime then
                  t = t + (tmr.time() - now)    -- try to adjust connection & retrieval time (only 1 sec exact)
                  rtctime.set(t)
                  local tm = rtctime.epoch2cal(t)
                  local tz = 'UTC'
                  syslog.print(syslog.INFO,"rtc: "..string.format("%04d/%02d/%02d %02d:%02d:%02d %s",tm["year"],tm["mon"],tm["day"],tm["hour"],tm["min"],tm["sec"],tz).." ("..t..")")
               else
                  syslog.print(syslog.WARN,"no rtctime module available, cannot set rtc time")
               end
            else 
               syslog.print(syslog.WARN,"no sjson module, can't decode http response")
            end
         end
      )
   else
      syslog.print(syslog.WARN,"rtc: no http module, can't fallback")
   end
end

if rtctime then
   if(rtctime.get() == 0) then
      if sntp then
         local h = "pool.ntp.org"
         sntp.sync(h,
            function(t,usec,server,info)
               syslog.print(syslog.INFO,"sntp:sync response from "..server)
               local tm = rtctime.epoch2cal(t)
               local tz = "UTC"
               syslog.print(syslog.INFO,"rtc: "..string.format("%04d/%02d/%02d %02d:%02d:%02d %s",tm["year"],tm["mon"],tm["day"],tm["hour"],tm["min"],tm["sec"],tz).." ("..t..")")
            end,
            function()
               syslog.print(syslog.WARN,"sntp.sync failed")
               httpsync()
            end
         )
      else 
         syslog.print(syslog.WARN,"rtc: no sntp module, trying fallback ...")
         httpsync()
      end
   end
else
   syslog.print(syslog.WARN,"rtc: no rtctime module available")
   -- this below likely will move to lib/rtctime.lua
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
   httpsync()
end
