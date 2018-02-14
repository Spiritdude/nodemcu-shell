-- == Ls ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: list files
--
-- History:
-- 2018/02/13: 0.0.4: nicer output, provide "pseudo" directory view by default, '-R' for recursive view
-- 2018/01/06: 0.0.3: default 2 columns output (filename max 32 chars anyway)
-- 2018/01/04: 0.0.2: ls with individual files
-- 2018/01/03: 0.0.1: alphabetical sorting

return function(...)
   local opts = { }
   local mo = { 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' }
   local fl = { }
   
   -- parsing arguments
   for k,v in ipairs(arg) do
      if string.find(v,"^-%w+$") then
         string.gsub(v,"(%w)",function(fl) opts[fl] = 1 end)
      else 
         table.insert(fl,v);
      end
   end

   local cols = opts['1'] and 1 or opts['2'] and 2 or opts['3'] and 3 or opts['4'] and 4 or 
      int(terminal.width / 33)
   cols = cols > 0 and cols or 1
   
   local col = { }
   local testExist = true

   function lf(f,opts,last) 
      if(opts['l']) then
         local st = file.stat and file.stat(f) or { time = { mon=1, day=1, year=1970 }, size=0 }
         if st then 
            local bits = ""
            if st.isdir or f:match("/$") then
               bits = bits .. "d" 
            else 
               bits = bits .. "-"
            end
            bits = bits .. "rwx"   
            console.print(string.format("%s  %6d  %s %2d %d  %s",
               bits,
               st['size'],
               mo[tonumber(st.time['mon'])],st.time['day'],st.time['year'],
               f)
            )
         else
            console.print("ls: cannot access '"..f.."': no such file or directory")
         end
      else
         console.print(f)
      end
   end
   
   table.remove(fl,1)
   
   if #fl == 0 then
      for f,s in pairs(file.list()) do
         table.insert(fl,f)
      end
      table.sort(fl)

      if not opts['R'] then
         -- post-process, and omit files and list "pseudo" directories
         local dl
         local fl2 = { }
         for i,f in ipairs(fl) do
            local d = f:match("([^/]+)/.*")
            if d and d ~= dl then
               table.insert(fl2,d.."/")
            elseif not d then
               table.insert(fl2,f)
            end
            dl = d
         end
         fl = fl2
      end
   else
      -- check existence (and remove from list if required)
      for i,f in ipairs(fl) do
         if (not file.exists(f)) or f:match("/$") then         -- list just content of a "pseudo" directory
            local d = f
            local fl2 = { }
            local fl3 = { }
            
            if not d:match("/$") then
               d = d .. "/"
            end
            for f,s in pairs(file.list()) do
               table.insert(fl2,f)
            end
            table.sort(fl2)
            for i,f in ipairs(fl2) do
               if f:find(d) then
                  table.insert(fl3,f)
               end
            end
            if #fl3 > 0 then
               fl = fl3
            else
               console.print("ls: cannot access '"..f.."': No such file or directory")
               table.remove(fl,i)
            end
         end
      end
   end
   
   if(cols==1 or opts['l']) then
      for n in pairs(fl) do      -- walk through list
         lf(fl[n],opts,#fl==n)
      end
   else
      local off = int(#fl / cols) + ((#fl % cols) > 0 and 1 or 0)
      local i = 1
      while(i <= off) do
         local l = ""
         for j=0,cols-1,1 do
            if i+off*j <= #fl then
               local f = fl[i+off*j]
               f = f:gsub(".lua$",".lua*")
               l = l .. string.format("%-32s",f)
            end
         end
         console.print(l)
         i = i + 1
      end
   end
end
