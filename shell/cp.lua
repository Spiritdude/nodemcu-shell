-- == Copy File ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: copy a file
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...)
   if(arg[2] and arg[3]) then
      if file.exists(arg[2]) then
         local src = file.open(arg[2], "r")
         if src then
            local dest = file.open(arg[3], "w")
            if dest then
               local line
               repeat
                  line = src:read()
                  if line then
                     dest:write(line)
                  end
               until line == nil
               dest:close(); dest = nil
            end
            src:close(); dest = nil
         end
      end
   else 
      console.print("ERROR: "..arg[1].." requires 2 arguments")
   end
end
