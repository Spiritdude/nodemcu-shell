-- == Copy File ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: copy a file
--
-- History:
-- 2018/02/18: 0.0.2: esp32 support
-- 2018/01/03: 0.0.1: first version

return function(...)
   if(arg[2] and arg[3]) then
      if file.exists(arg[2]) then
         local src = file.open(arg[2], "r")
         if src then
            if arch=='esp32' then         -- src:read() or dest:read() doesn't work (yet)
               local d = ""
               repeat
                  local c = file.read()   -- reading 1KB at a time
                  d = d .. (c or "")
               until c==nil
               file.close()
               local dest = file.open(arg[3], "w")
               if dest then
                  file.write(d)
                  file.close()
               else 
                  console.print("ERROR: can't write to "..arg[3])
               end
            else 
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
               else
                  console.print("ERROR: can't write to "..arg[3])
               end
               src:close(); src = nil
            end
         else
            console.print("ERROR: "..arg[2].." does not exist")
         end
      end
   else 
      console.print("ERROR: "..arg[1].." requires 2 arguments")
   end
end
