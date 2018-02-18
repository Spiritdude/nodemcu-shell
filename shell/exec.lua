-- == Exec ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: just execute another program with its arguments
--
-- History:
-- 2018/02/18: 0.0.1: first version

dofile("lib/exec.lua")
return function(...)
   table.remove(arg,1)     -- remove 'exec'
   if #arg > 0 then
      exec(unpack(arg))
   end
end 

