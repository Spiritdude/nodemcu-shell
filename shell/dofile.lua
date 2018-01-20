-- == DoFile ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: just dofile()
--
-- History:
-- 2018/01/05: 0.0.1: first version

return function(...) 
   if arg[2] then
      if file.exists(arg[2]) then
         --dofile(arg[2])
         local state,err = pcall(loadfile(arg[2]))
         if err then
            console.print("ERROR: "..err)
         end
      else
         console.print("ERROR: file <"..arg[2].."> not found")
      end
   end
end

