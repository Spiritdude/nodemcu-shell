-- == Help ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: list all commands
--
-- History:
-- 2018/01/04: 0.0.1: first version

return function(...)
   local l = file.list()

   local function hasMan(f)      -- disabled for now, it slows down help tremendously
      return file.exists("shell/"..f..".txt") or file.exists(f.."/man.txt")
   end

   print("available commands:")
   local cmd = { }
   table.insert(cmd,"exit")         -- built-in command
   for f,k in pairs(l) do
      --print("="..f)
      if string.find(f,"shell/") then
         string.gsub(f,"shell/(.+)\.lua$",function(c)
            if(c ~= 'main') then
               if false and hasMan(c) then
                  c = c .. " (+)"
               end
               table.insert(cmd,c)
            end
         end)
      end
      string.gsub(f,"([%w_\-]+)/main\.lua$",function(c)
         if(c ~= 'shell') then
            if false and hasMan(c) then
               c = c .. " (+)"
            end
            table.insert(cmd,c)
         end
      end)
   end
   table.sort(cmd)
   if false then
      for c,n in pairs(cmd) do
         print("\t"..n)
      end
   else 
      local cols = 4
      local off = #cmd / cols + ((#cmd % cols) > 0 and 1 or 0)
      local i = 1
      while(i <= off) do
         local l = ""
         for j=0,cols-1,1 do
            if i+off*j <= #cmd then
               l = l .. string.format("   %-15s",cmd[i+off*j])
            end
         end
         print(l)
         i = i + 1
      end
   end
   -- print("+: has man page, use `man <cmd>` to read it")
end
