-- rtctime.set(t,0)
if sntp then
   local h = "pool.ntp.org"
   sntp.sync("pool.ntp.org",
      function(sec, usec, server, info)
         print("INFO: sntp:sync via "..h, sec, usec, server)
      end,
      function()
         print("WARN: sntp.sync failed")
      end
   )
else 
   print("WARN: sntp module does not exist")
   if false then            -- future
      local now = tmr.time()
      local h = '...'         -- edit host which just returns unix epoch
      http.get(h, nil, 
         function(code, data)
            if (code < 0) then
               print("WARN: rtc fallback failed as well, no proper rtc available")
            else
               -- print(code, data)
               if rtctime then
                  local t = tonumber(data);
                  t = t + (tmr.time() - now)    -- try to adjust connection & retrieval time (only 1 sec exact)
                  rtctime.set(t,0)
                  local tm = rtctime.epoch2cal(t)
                  local tz = 'UTC'
                  print("INFO: rtc set to "..string.format("%04d/%02d/%02d %02d:%02d:%02d %s", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"], tz).." ("..t..")")
               else
                  print("WARN: no rtctime module available, cannot set rtctime")
               end
            end
         end
      )
   end
end               
