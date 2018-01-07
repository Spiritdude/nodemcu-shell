-- == SYSLOG ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
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

   verbose = function(lv)
      level = lv
   end,

   print = function(type,m)
      local tm = { [0]='INFO', [1]='WARN', [2]='ERROR', [3]='FATAL' }
      local t = tmr and (tmr.time() .. "." .. string.format("%03d",((tmr.now()/1000)%1000))) or 0
      print((tm[type] or 'UNKOWN') .. " [" .. t .. "] " .. m)
   end
}
