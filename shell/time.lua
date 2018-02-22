-- == Time ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: executes command with arguments and measures time elapsed
--
-- History:
-- 2018/02/22: 0.0.3: timer.* -> tmr.* (possible now, esp32 tmr.now() not yet in official firmware)
-- 2018/01/30: 0.0.2: switching from tmr.* to timer.*
-- 2018/01/04: 0.0.1: first version

dofile("lib/exec.lua")
return function(...) 
   table.remove(arg,1)
   local t = tmr.now()
   if arg[1] then
      if not exec(unpack(arg)) then
         console.print("ERROR: command <"..arg[1].."> does not exist")
      end
   end
   console.print(int((tmr.now()-t)/1000).." ms")
end

