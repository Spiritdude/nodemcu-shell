-- == Hostname ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: display or set hostname
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...) 
   if arg[2] then
      wifi.sta.sethostname(arg[2])
   else
      console.print(wifi.sta.gethostname())
   end
end
