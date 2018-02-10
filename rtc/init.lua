-- == RTC ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: try to get realtime clock with actual time (if required) from various sources
--
-- History: 
-- 2018/01/30: 0.0.4: switching from tmr.* to timer.*
-- 2018/01/17: 0.0.3: rtctime.set,get,epoch2cal implemented as fallback
-- 2018/01/12: 0.0.2: better fallback and proper JSON epoch parsing (indirect)
-- 2018/01/04: 0.0.1: first version

local function httpsync() 
   if http then
      local now = timer.time()
      local h = 'http://now.httpbin.org/'       -- http (instead of https) in case tls is not included
      http.get(h,nil,
         function(code,data)
            if code < 0 then
               syslog.print(syslog.WARN,"rtc: fallback failed as well, no current time available")
            --elseif sjson then
            elseif true then
               --local d = sjson.decode(data)         -- doesn't work, we can't handle floats (d.now.epoch)
               --local t = d and d.now and d.now.epoch or 0
               local t = string.match(data,'"epoch":%s*(%d+)')    -- we parse JSON portion direct
               if rtctime then
                  t = t + (timer.time() - now)    -- try to adjust connection & retrieval time (only 1 sec exact)
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
   syslog.print(syslog.WARN,"rtc: no rtctime module available, using LUA rtctime module")
   dofile("lib/rtctime.lua")
   httpsync()
end
