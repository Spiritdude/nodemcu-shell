-- == Ls ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: list files
--
-- History:
-- 2018/01/04: 0.0.2: ls with individual files
-- 2018/01/03: 0.0.1: alphabetical sorting

return function(arg)
   if #arg > 1 then
      for i,f in ipairs(arg) do
         if i>1 then
            if file.exists(f) then
               local st = file.stat(f)
               print(string.format("%6d  %s",st['size'],f))
            else
               print("ERROR: file <"..f.."> does not exist")
            end
         end
      end
   else
      local l = file.list();
   
      local d = "/"
      print(d)
      
      local nl = { }
      for n in pairs(l) do       -- walk through list extract keys
         table.insert(nl,n)
      end
      table.sort(nl)             -- sort keys
      for n in pairs(nl) do      -- walk through list
         print(string.format("%6d  %s",l[nl[n]],nl[n]))
      end
   end
end
