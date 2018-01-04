-- == Remove ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: remove a file
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(arg)
   if arg[2] then
      if file.exists(arg[2]) then
         file.remove(arg[2])
      else
         print("ERROR: file <"..arg[2].."> not found")
      end
   else
      print("ERROR: "..arg[1].." requires an argument")
   end
end
