-- == Time ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: executes command with arguments and measures time elapsed
--
-- History:
-- 2018/01/04: 0.0.1: first version

return function(...) 
   table.remove(arg,1)
   local t = tmr.now()
   if arg[1] then
      local cmd = arg[1]
      if file.exists("shell/"..cmd..".lc") then
         dofile("shell/"..cmd..".lc")(unpack(arg))
      elseif file.exists("shell/"..cmd..".lua") then
         dofile("shell/"..cmd..".lua")(unpack(arg))
      elseif file.exists(cmd.."./main.lc") then
         dofile(cmd.."/main.lc")(unpack(arg))
      elseif file.exists(cmd.."/main.lua") then
         dofile(cmd.."/main.lua")(unpack(arg))
      else 
         print("ERROR: command <"..arg[1].."> does not exist")
      end
   end
   print(((tmr.now()-t)/1000).." ms")
end

