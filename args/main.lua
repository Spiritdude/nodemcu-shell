-- == Args ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: just displays the arguments
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...)
   for k,v in ipairs(arg) do
      print(k.." = '"v.."'")
   end
end
