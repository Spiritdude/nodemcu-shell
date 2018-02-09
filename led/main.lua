-- == LED ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: control LEDs
--
-- History:
-- 2018/01/07: 0.0.1: first version 

return function(...)
   if file.exists("led/led.conf") or sysconf.led then 
      local conf = dofile("led/led.conf") or sysconf.led
      if arg[2] then
         local led, st = string.match(arg[2],"^(%d+)=(.+)")
         if led and st then
            led = tonumber(led)
         else
            led = 0
            st = arg[2]
         end
         if st == 'on' then
            st = 0
         elseif st == 'off' then
            st = 1
         elseif string.match(st,"^[01]$") then
            st = tonumber(st)
         else
            console.print("ERROR: unknown state <"..st..">, choose 0, 1, on or off")
            st = nil
         end
         if not (conf[led] and conf[led].pin) then
            console.print("ERROR: led #"..led.." not defined in led/led.conf")
         elseif st then
            local pin = conf[led].pin or 4
            console.print("led "..led.." (pin "..pin.."): "..st)
            gpiox.mode(pin,gpio.OUTPUT)
            gpiox.write(pin,st)
         end
      else
         dofile("shell/man.lua")('led','led')
      end
   else
      console.print("WARN: led/led.conf does not exist and sysconf.led not defined")
   end
end
