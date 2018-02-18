-- == Execution Library ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    exec() takes arguments, whereas the first is the name of the file 
--       and all following are arguments
--    the file can come with full path and extension, or just the basename,
--       then it is searched in shell/* */main* and apps/*
--
-- History: 
-- 2018/02/18: 0.0.1: first verson as helper for `time` and `repeat`

function exec(...)
   local cmd = arg[1]
   local f
   local done = false
   local types = { '' }
   if arch=='esp32' then
      types = { '32', '' }
   end
   if file.exists(cmd) then
      f = dofile(cmd)
   else 
      for j,loc in pairs({"shell/"..cmd, cmd.."/main", "apps/"..cmd}) do
         for k,kind in pairs({".lc", ".lua"}) do
            for i,type in pairs(types) do
               if file.exists(loc..type..kind) then
                  -- print("execute "..loc..type..kind)
                  f = dofile(loc..type..kind)
                  done = true
               end
               if done then break end
            end
            if done then break end
         end
         if done then break end
      end
   end
   if f and type(f)=='function' then
      f(unpack(arg))
   end
   return done
end 
