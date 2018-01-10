-- == Remove ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: remove file(s)
--
-- History:
-- 2018/01/08: 0.0.2: multiple files
-- 2018/01/03: 0.0.1: first version

return function(...)
   table.remove(arg,1)
   for i,f in ipairs(arg) do
      if file.exists(f) then
         file.remove(f)
      else
         console.print("ERROR: file <"..f.."> not found")
      end
   end
   if #arg == 0 then
      console.print("ERROR: rm requires at least an argument")
   end
end
