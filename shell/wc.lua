-- == Wc ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: word count
--
-- History:
-- 2018/01/12: 0.0.1: first version

return function(...) 
   table.remove(arg,1)
   for i,f in ipairs(arg) do
      if file.open(f,"r") then
         local cc = 0
         local wc = 0
         local lc = 0
         local l
         repeat
            l = file.read("\n")
            if l ~= nil then
               cc = cc + string.len(l)
               lc = lc + 1
               string.gsub(l,"%S+",function() wc = wc + 1 end)
            end
         until l == nil
         file.close()
         console.print(string.format("%4d %5d %6d %s",lc,wc,cc,f))
      else
         console.print("ERROR: file <"..arg[1].."> not found")
      end
   end
   if #arg == 0 then
      -- dofile("shell/man.lua")('man','wc')
   end
end
