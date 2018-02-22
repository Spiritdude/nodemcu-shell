-- == Uptime ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: displays uptime in seconds
--
-- History:
-- 2018/02/04: 0.0.2: hours corrected
-- 2018/01/03: 0.0.1: first version

return function(...) 
   local t = tmr.time()
   console.print(string.format("%dd %dh %dm %ds",int(t/24/3600),int(t/3600)%24,int(t/60)%60,t%60))
end
