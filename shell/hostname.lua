-- == Hostname ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: display or set hostname
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...) 
   table.remove(arg,1)
   if arch=='esp8266' then
      if arg[1] then
         wifi.sta.sethostname(arg[1])
      else
         console.print(wifi.sta.gethostname())
      end
   else
      console.print(node.chipid())
   end
end
