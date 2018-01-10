-- == Cat ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: display content of a file
--
-- History:
-- 2018/01/08: 0.0.2: line-wise is more memory efficient
-- 2018/01/03: 0.0.1: first version

return function(...) 
   table.remove(arg,1)
   for i,f in ipairs(arg) do
      if file.open(f,"r") then
         local l
         repeat
            l = file.read("\n")
            if l ~= nil then
               l = string.gsub(l,"[\r\n]*$","")
               console.print(l)
            end
         until l == nil
         file.close()
      elseif arg[2] == '-' then
         -- future: take stdin 
      else
         console.print("ERROR: file <"..arg[2].."> not found")
      end
   end
   if #arg == 0 then
      -- dofile("shell/man.lua")('man','cat')
   end
end
