-- == Man ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: display some simple manual page if it exists
--
-- History:
-- 2018/01/06: 0.0.1: first version

return function(...)
   table.remove(arg,1)
   if #arg > 0 then
      local function man(n)
         local fn
         if file.exists("shell/"..n..".txt") then
            fn = "shell/"..n..".txt"
         elseif file.exists(n.."/man.txt") then
            fn = n .. "/man.txt"
         end
         if fn then
            file.open(fn)
            console.print(file.read())
            file.close()
         end
      end
      man(arg[1])
   end
end
