-- rtctime.set(t,0)
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
   syslog.print(syslog.WARN,"sntp module does not exist")
   if false then            -- future
      local now = tmr.time()
      local h = '...'         -- edit host which just returns unix epoch
      http.get(h, nil, 
         function(code, data)
            if (code < 0) then
               syslog.print(syslog.WARN,"rtc fallback failed as well, no proper rtc available")
            else
               -- print(code, data)
               if rtctime then
                  local t = tonumber(data);
                  t = t + (tmr.time() - now)    -- try to adjust connection & retrieval time (only 1 sec exact)
                  rtctime.set(t,0)
                  local tm = rtctime.epoch2cal(t)
                  local tz = 'UTC'
                  syslog.print(syslog.INFO,"rtc set to "..string.format("%04d/%02d/%02d %02d:%02d:%02d %s", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"], tz).." ("..t..")")
               else
                  syslog.print(syslog.WARN,"no rtctime module available, cannot set rtctime")
               end
            end
         end
      )
   end
end               
