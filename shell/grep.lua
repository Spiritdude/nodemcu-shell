-- == Grep ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: simple grep 
--
-- History:
-- 2018/01/05: 0.0.1: first version, just one pattern (no regex yet)

return function(...)
   table.remove(arg,1)

   local fl = { }
   
   if #arg < 2 then
      print("ERROR: grep takes at least 2 arguments: pattern file(s)")
   else
      -- parsing arguments
      for k,v in ipairs(arg) do
         if string.find(v,"^-%w+") then
            string.gsub(v,"-(%w+)$",function(fl) opts[fl] = 1 end)
         else 
            table.insert(fl,v);
         end
      end
      local re = fl[1]..""
      
      table.remove(fl,1)

      for i,f in ipairs(fl) do
         if file.exists(f) then
            local src = file.open(f)
            local line
            repeat
               line = src:read("\n")
               if(line and string.find(line,re)) then
                  line = string.gsub(line,"[\r\n]*$","")
                  print((#fl > 1 and f..": " or "") .. line)
               end
            until line == nil
            src:close()
         else
            print("ERROR: <"..f.."> not found")
         end
      end
   end
end
