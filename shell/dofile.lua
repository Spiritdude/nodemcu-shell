-- == DoFile ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: just dofile()
--
-- History:
-- 2018/01/05: 0.0.1: first version

return function(...) 
   if(arg[2] and file.exists(arg[2])) then
      dofile(arg[2])
   end
end

