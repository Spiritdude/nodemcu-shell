-- == Blink ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: just blinking
--
-- History:
-- 2018/01/12: 0.0.2: another argument to define how many times the blinking occurs
-- 2018/01/04: 0.0.1: first version with blink frequency in ms as optional argument

return function(...)
   if blink_tmr == nil then
      blink_tmr = timer.create()
   end
   d = 500
   pin = arch=='esp8266' and 4 or 22

   if(arg[2] and string.match(arg[2],"^%d+$") and tonumber(arg[2]) > 0) then
      d = tonumber(arg[2])
   end
   
   -- console.print("blink "..d.."ms")
      
   gpiox.mode(pin,gpiox.OUTPUT)
   
   led = 0
   
   if(arg[2] and (arg[2] == 'off' or arg[2] == '0')) then
      blink_tmr:unregister()
      gpiox.write(pin,1)
   else 
      local cnt
      if(arg[3] and string.match(arg[3],"^(%d+)$")) then
         cnt = tonumber(arg[3])
      end
      gpiox.write(pin,led)
      blink_tmr:alarm(d,1, 
         function()
            led = 1-led;
            gpiox.write(pin,led)
            if(led == 1 and cnt ~= nil and cnt > 0) then     -- if off
               --console.print("tmr count: "..cnt)
               cnt = cnt - 1
               if cnt == 0 then
                  --console.print("end of timer")
                  blink_tmr:unregister()
               end
            end
         end
      ) 
   end
end
