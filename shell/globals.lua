-- == Globals ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: just displays global variables
--   globals
--   globals terminal
-- History:
-- 2018/02/12: 0.0.1: first version

return function(...)
   printTable = function(ta,lv) 
      lv = lv or 0
      if lv > 5 or ta == nil then
         return
      else 
         local t = { }
         for k in pairs(ta) do
            if k ~= '_G' then
               table.insert(t,k)
            end
         end
         table.sort(t)
         local off = ""
         for l=1,lv,1 do
            off = off .. "   "
         end
         for i,k in pairs(t) do
            local ty = type(ta[k])
            if ty=='table' then
               console.print(off..k.." ("..type(ta[k])..")")
               if lv > 0 then
                  printTable(ta[k],lv+1)
               end
            elseif ty=='string' or ty=='number' then
               console.print(off..k.." ("..type(ta[k]).."): "..ta[k])
            else
               console.print(off..k.." ("..type(ta[k])..")")
            end
         end
      end
   end
   table.remove(arg,1)
   if #arg > 0 then
      for i,k in ipairs(arg) do
         console.print(k..":")
         printTable(_G[k],1)
      end
   else
      printTable(_G)
   end
   printTable = nil
   collectgarbage()
end

