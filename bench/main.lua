-- == Bench(marks) ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Display luakips (kips = thousands of instructions per second) 
--    for a couple of simple use cases
--
-- History:
-- 2018/02/10: 0.0.1: first version
 
return function(...)
   local bench = { }
   
   local n = 10000

   local t = tmr.now()
   local i = n
   while i > 0 do
      i = i - 1
   end
   bench['while-loop'] = tmr.now()-t
   
   t = tmr.now()
   i = n
   local a = 0
   while i > 0 do
      a = a + i / 12
      i = i - 1
   end
   bench['arithmetic'] = tmr.now()-t
   
   t = tmr.now()
   i = n
   local b = function(i) return i end
   while i > 0 do
      b(i)
      i = i - 1
   end
   bench['function'] = tmr.now()-t
   
   for t,v in pairs(bench) do
      local i = int(n * 10 / (v/100))  -- k instructions per 1s
      console.print(t..": "..i.." LuaKIPS") 
   end
end

