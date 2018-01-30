-- == SYSLOG ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description:
--    syslog.print(what,"message")
--       what = syslog.INFO
--              syslog.WARN
--              syslog.ERROR
--              syslog.FATAL
-- History:
-- 2018/01/07: 0.0.1: first version

syslog = {
   INFO = 0,
   WARN = 1,
   ERROR = 2,
   FATAL = 3,

   level = 0,
   count = 0,
   
   verbose = function(lv)
      level = lv
   end,

   print = function(type,m)
      local tm = { [0]='INFO', [1]='WARN', [2]='ERROR', [3]='FATAL' }
      local t
      --if arch=='esp8266' then
         t = timer and (timer.time() .. "." .. string.format("%03d",int((timer.now()/1000)%1000))) or 0
      --else
      --   t = syslog.count
      --   syslog.count = syslog.count + 1
      --end
      console.print((tm[type] or 'UNKNOWN') .. " [" .. t .. "] " .. m)
   end
}
