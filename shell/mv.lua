-- == Move(Rename) ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: moves/renames a file
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(arg)
   if arg[2] and arg[3] then
      if file.exists(arg[2]) then
         file.rename(arg[2],arg[3])
      else
         print("ERROR: file <"..arg[2].."> not found, cannot rename/move")
      end
   else
      print("ERROR: "..arg[1].." requires 2 arguments")
   end
end

