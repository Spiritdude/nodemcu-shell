-- == RTC ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: try to get realtime clock with actual time (if required) from various sources
--
-- History: 
-- 2018/01/04: 0.0.1: first version

if((not rtctime) or (rtctime and rtctime.get() == 0)) then
   if sntp then
      local h = "pool.ntp.org"
      sntp.sync(h,
         function(sec, usec, server, info)
            syslog.print(syslog.INFO,"sntp:sync via "..h, sec, usec, server)
         end,
         function()
            syslog.print(syslog.WARN,"sntp.sync failed")
         end
      )
   else 
      syslog.print(syslog.WARN,"rtc: no sntp module, trying fallback ...")
      if http then
         local now = tmr.time()
         local h = 'http://now.httpbin.org/'       -- http (instead of https) in case tls is not included
         http.get(h,nil,
            function(code,data)
               if code < 0 then
                  syslog.print(syslog.WARN,"rtc: fallback failed as well, no current time available")
               elseif sjson then
                  local d = sjson.decode(data)
                  local t = d and d.now and d.now.epoch or 0
                  if rtctime then
                     t = t + (tmr.time() - now)    -- try to adjust connection & retrieval time (only 1 sec exact)
                     rtctime.set(t,0)
                     local tm = rtctime.epoch2cal(t)
                     local tz = 'UTC'
                     syslog.print(syslog.INFO,"rtc: "..string.format("%04d/%02d/%02d %02d:%02d:%02d %s", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"], tz).." ("..t..")")
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
end               
