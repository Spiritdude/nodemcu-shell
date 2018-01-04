-- == Uptime ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: displays uptime in seconds
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...) 
   local t = tmr.time()
   print(string.format("%dd %02dh %02dm %02ds",t/24/3600,(t/3600)%60,(t/60)%60,t%60))
end
