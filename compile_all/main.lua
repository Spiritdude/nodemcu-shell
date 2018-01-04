-- == Compile All ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: compiles all .lua of apps
--
-- History:
-- 2018/01/03: 0.0.1: first version, leave /*.lua untouched, but all */*.lua do compile

local l = file.list()
for k,v in pairs(l) do
   --if(not (k == 'init.lua') and not (k == 'startup.lua') and string.find(k,"\.lua$")) then
   if(string.find(k,"/") and string.find(k,"\.lua$")) then
      --print("% process ",k)
      local lc = string.gsub(k,"\.lua$",".lc")
      file.remove(lc)
      if(not file.exists(lc)) then
         print("> compile " .. k .. ": " .. lc)
         node.compile(k)
      end
   end
end
