-- == BLINK ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: just blinking
--
-- History:
-- 2018/01/04: 0.0.1: first version with blink frequency in ms as optional argument

return function(...)
   id = 6
   d = 500
   pin = 4

   if(arg[2] and string.match(arg[2],"^%d+$") and tonumber(arg[2]) > 0) then
      d = tonumber(arg[2])
   end
   
   -- print("blink "..d.."ms")
      
   gpio.mode(pin,gpio.OUTPUT)
   
   led = 0
   
   if(arg[2] and (arg[2] == 'off' or arg[2] == '0')) then
      tmr.unregister(id)
      gpio.write(pin, 1)
   else 
      gpio.write(pin, led)
      tmr.alarm(id, d, 1, 
         function()
            led = 1 - led;
            gpio.write(pin, led)
         end
      ) 
   end
end
