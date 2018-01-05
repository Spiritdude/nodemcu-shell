-- == Help ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: list all commands
--
-- History:
-- 2018/01/04: 0.0.1: first version

return function(...)
   local l = file.list()
   print("available commands:")
   local cmd = { }
   table.insert(cmd,"exit")         -- built-in command
   for f,k in pairs(l) do
      --print("="..f)
      if string.find(f,"shell/") then
         string.gsub(f,"shell/(.+)\.lua$",function(c)
            if(not(c == 'main')) then
               table.insert(cmd,c)
            end
         end)
      end
      string.gsub(f,"([%w_\-]+)/main\.lua$",function(c)
         if(not(c == 'shell')) then
            table.insert(cmd,c)
         end
      end)
   end
   table.sort(cmd)
   for c,n in pairs(cmd) do
      print("\t"..n)
   end
end
