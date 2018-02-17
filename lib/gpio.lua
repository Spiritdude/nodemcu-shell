-- == GPIO Library ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Providing consistent ESP8266/ESP32 gpio functionality
--       as ESP32 NodeMCU gpio.* breaks compatibility
-- Todo:
--    - gpio.trig() [done, but not yet tested]
-- History: 
-- 2018/02/16: 0.0.1: lib/gpiox.lua taken, adjusted

if arch=='esp32' then
   gpio_esp32 = gpio
   gpio = setmetatable({}, { __index = gpio })
   gpio.mode = gpio_esp32.mode
   gpio.read = gpio_esp32.read
   gpio.write = gpio_esp32.write
   gpio.INPUT = gpio_esp32.IN
   gpio.OUTPUT = gpio_esp32.OUT
   gpio.INPUT_OUTPUT = gpio_esp32.IN_OUT
   gpio.PULLUP = gpio_esp32.PULL_UP
   gpio.PULLDOWN = gpio_esp32.PULL_DOWN
   gpio.PULLUPDOWN = gpio_esp32.PULL_UP_DOWN
   if gpio.mode then                -- does it exist?
      if arch ~= 'esp8266' then
         syslog.print(syslog.INFO,"gpio: gpio.mode() natively exists, using it")
      end
   else 
      gpio.mode = function(p,m,pu)
         local d = gpio.IN
         if m==gpio.INPUT then
            d = gpio.IN
         elseif m==gpiox.OUTPUT then
            d = gpio.OUT
         elseif m==gpio.INPUT_OUTPUT then
            d = gpio.IN_OUT
         end
         local px = gpio.FLOATING
         if pu==gpio.PULLUP then
            px = gpio.PULL_UP
         elseif pu==gpio.PULLDOWN then
            px = gpio.PULL_DOWN
         elseif pu==gpio.PULLUPDOWN then
            px = gpio.PULL_UP_DOWN
         end
         gpio.config({gpio=p, dir=d, pull=px})
      end
   end
   gpio.trig = function(p,t,cb)
      local ty = gpio.INTR_UP
      if t=='up' then
         ty = gpio.INTR_UP
      elseif t=='down' then
         ty = gpio.INTR_DOWN
      elseif t=='both' then
         ty = gpio.INTR_UP_DOWN
      elseif t=='low' then
         ty = gpio.INTR_LOW
      elseif t=='high' then
         ty = gpio.INTR_HIGH
      end
      gpio_esp32.trig(p,ty,cb)
   end
end
