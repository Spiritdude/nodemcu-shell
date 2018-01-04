-- == Touch ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: touch (create or change mtime) a file
--
-- History:
-- 2018/01/04: 0.0.1: first version

return function(arg)
   if arg[2] then
      if file.open(arg[2],"a") then
         file.write("")
         file.close()
      end
   end
end
