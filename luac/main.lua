-- == Lua Compile ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: compiles all .lua of apps
--
-- History:
-- 2018/02/10: 0.0.3: renamed to luac
-- 2018/01/04: 0.0.2: renamed compile_all -> compile, compile all or individually
-- 2018/01/03: 0.0.1: first version, leave /*.lua untouched, but all */*.lua do compile

return function(...)
   table.remove(arg,1)
   if(arg[1] and arg[1]=='all') then
      local l = file.list()
      for k,v in pairs(l) do
         --if(not (k == 'init.lua') and not (k == 'startup.lua') and string.find(k,"\.lua$")) then
         if(string.find(k,"/") and string.find(k,"\.lua$")) then      -- any top-level .lua (without /) are ignored
            --console.print("% process ",k)
            local lc = string.gsub(k,"\.lua$",".lc")
            file.remove(lc)
            if(not file.exists(lc)) then
               console.print("   compiling " .. k .. " to " .. lc)
               node.compile(k)
            end
         end
      end
   else
      for i,f in pairs(arg) do
         if file.exists(f) then
            local lc = string.gsub(f,"\.lua$",".lc")
            console.print("   compiling " .. f .. " to " .. lc)
            node.compile(f)
         end
      end
   end
end
