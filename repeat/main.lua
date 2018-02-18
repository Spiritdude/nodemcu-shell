-- == Repeat ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: repeat certain commands n-times
--   repeat 10 echo "hello world"
--
-- History:
-- 2018/02/18: 0.0.1: first version

dofile("lib/exec.lua") 
return function(...)
   table.remove(arg,1) 
   if #arg>=2 then
      local n = tonumber(table.remove(arg,1)) or 1
      for i=1,n do 
         exec(unpack(arg)) 
      end 
   end
end 

