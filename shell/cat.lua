-- == Cat ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: display content of a file
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...) 
   if file.open(arg[2],"r") then
      print(file.read())
      file.close()
   else
      print("ERROR: file <"..arg[2].."> not found")
   end
end
