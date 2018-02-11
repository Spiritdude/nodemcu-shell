-- == GPIO Extended Library ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Providing consistent ESP8266/ESP32 gpio functionality
--       as ESP32 NodeMCU gpio.* breaks compatibility
--    Use gpiox.* instead of gpio.* to stay compatible
-- Todo:
--    - gpio.trig() [done, but not yet tested]
-- History: 
-- 2018/02/09: 0.0.2: gpiox.trig() added
-- 2018/02/08: 0.0.1: gpiox.* common layer for ESP8266 and ESP32, later might be implemented in the firmware direct

if arch=='esp32' then
   gpiox = { }
   gpiox.OUTPUT = 1
   gpiox.INPUT = 2
   gpiox.INPUT_OUTPUT = 3
   gpiox.OPENDRAIN = 4
   gpiox.INT = 5
   gpiox.PULLUP = 6
   gpiox.PULLDOWN = 7
   gpiox.PULLUPDOWN = 8
   gpiox.mode = function(p,m,pu)
      local d = gpio.IN
      if m==gpiox.INPUT then
         d = gpio.IN
      elseif m==gpiox.OUTPUT then
         d = gpio.OUT
      elseif m==gpiox.INPUT_OUTPUT then
         d = gpio.IN_OUT
      end
      local px = gpio.FLOATING
      if pu==gpiox.PULLUP then
         px = gpio.PULL_UP
      elseif pu==gpiox.PULLDOWN then
         px = gpio.PULL_DOWN
      elseif pu==gpiox.PULLUPDOWN then
         px = gpio.PULL_UP_DOWN
      end
      gpio.config({gpio=p, dir=d, pull=px})
   end
   gpiox.read = gpio.read
   gpiox.write = gpio.write
   gpiox.trig = function(p,t,cb)
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
      gpio.trig(p,ty,cb)
   end
else 
   gpiox = gpio
end
