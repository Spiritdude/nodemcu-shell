-- == GPIO ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Set one or more pins to on/off/0/1
--
-- History:
-- 2018/03/17: 0.0.1: first version

return function(...) 
   local arg = {...}
   table.remove(arg,1)

   for i,v in pairs(arg) do   
      if v:match("^[%d,]+=$") then         -- read
         local p = v:match("^([%d,]+)=$")
         p:gsub("([%d]+),*",function(p) 
            p = p:gsub(",","")
            p = tonumber(p)
            gpio.mode(p,gpio.INPUT)
            console.print("pin["..p.."]",'=',gpio.read(p))
         end)
      elseif v:match("^([%d,]+)=%S+$") then  -- write
         local p, s = v:match("^([%d,]+)=(%S+)$")
         p:gsub("([%d]+),*",function(p) 
            p = p:gsub(",","")
            if s=='0' or s=='1' then
               s = tonumber(s)
            elseif s=='off' then
               s = 0
            elseif s=='on' then
               s = 1
            end
            p = tonumber(p)
            --console.print("pin["..p.."]",'=',s)
            gpio.mode(p,gpio.OUTPUT)
            gpio.write(p,s)
            return ""
         end)
      end
   end
   if #arg==0 then
      console.print("USAGE: gpio [<pin>=<value>] [<pin>="..[[

   pin:
      <int>          single pin
      <int>[,<int>]  multiple pins
   value:
      <value>        0, 1, on or off
   read: 
      <pin>=
   write:
      <pin>=<value>

   examples:
      gpio 0=           read gpio #0 as input
      gpio 0=1          write gpio #0 to high
      gpio 0=0
      gpio 0=on
      gpio 0=off
      gpio 0,1,5=on 2,3=off
]])
   end
end

