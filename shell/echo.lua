-- == Echo ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: echo strings
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...) 
   for k,v in ipairs(arg) do
      if k > 1 then
         console.print(v)
      end
   end
end

