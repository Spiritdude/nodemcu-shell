-- == Display ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: use display.conf to define a display, and set 'disp' as global variable
-- 
-- History:
-- 2018/02/22: 0.0.5: timer.* -> tmr.* (possible now)
-- 2018/02/08: 0.0.4; esp32 support and u8g2 added (not yet tested)
-- 2018/02/01: 0.0.3: using timer.* instead of tmr.*
-- 2018/01/09: 0.0.2: more structured setup
-- 2018/01/06: 0.0.1: rudimentary

if file.exists("display/display.conf") then
   local conf = dofile("display/display.conf")

   display = {
      disp                    -- display pointer
   }    
   
   if(conf.mode=='i2c') then
      display.width = conf.width or 128      -- set some sane defaults (will likely be overridden)
      display.height = conf.height or 64
      if conf.i2c.driver then
         if arch=='esp8266' then
            i2c.setup(0,conf.i2c.sda,conf.i2c.scl,i2c.SLOW)
            display.disp = conf.i2c.driver(conf.i2c.sla)
         else 
            i2c.setup(i2c.HW0,conf.i2c.sda,conf.i2c.scl,i2c.FAST)
            display.disp = conf.i2c.driver(i2c.HW0,conf.i2c.sla)
         end
         if display.disp then
            local w,h
            if arch=='esp8266' then
               w = display.disp:getWidth()
               h = display.disp:getHeight()
            else 
               w = conf.width or display.disp:getDisplayWidth()
               h = conf.height or display.disp:getDisplayHeight()
            end
            syslog.print(syslog.INFO,"init display driver: "..string.format("mode %s, %dx%d",conf.mode,w,h))
            if conf.rotate then
               if conf.rotate == 90 then
                  display.disp:setRot90()
               elseif conf.rotate == 180 then
                  display.disp:setRot180()
               elseif conf.rotate == 270 then
                  display.disp:setRot270()
               elseif conf.rotate == 0 then
                  display.disp:undoRotation()
               end
            end
            local fo = u8g and (u8g.font_04b_03 or u8g.font_helv08 or u8g.font_6x10) or (u8g2 and u8g2.font_baby_tf or u8g2.font_u8glib_4_tf or u8g2.font_chikita_tf or u8g2.font_6x10_tf) or nil
            if fo then
               display.disp:setFont(fo)
               display.disp:setFontRefHeightExtendedText()
               if arch=='esp8266' then
                  display.disp:setDefaultForegroundColor()
               end
               display.disp:setFontPosTop()
            end
            local fn = (h >= 64) and "logo64-"..arch..".mono" or (h >= 48) and "logo48.mono" or "logo.mono"
            local sz = (h >= 64) and 64 or (h >= 48) and 48 or 32
            if file.open("display/"..fn) then
               local data = file.read()
               file.close()
               local wi = sz
               local hi = sz
               local x = int(w/2 - wi/2)
               local y = int(h/2 - hi/2)
               if arch=='esp8266' then
                  display.disp:firstPage()
                  repeat
                     display.disp:drawXBM(x,y,wi,hi,data)
                  until display.disp:nextPage() == false
               else 
                  display.disp:clearBuffer()
                  display.disp:drawXBM(x,y,wi,hi,data)
                  display.disp:sendBuffer()
               end
            end
            if conf.console then
               dofile("lib/display.lua")
               console.output(function(...)
                  local str = ""
                  for i,v in ipairs(arg) do
                     if i > 1 then
                        str = str .. "\t"
                     end
                     str = str .. v
                  end
                  display.print(str)
                  -- display.print(string.sub(str,1,30))    -- truncate a bit otherwise wraps around on the left-side again
               end)
               tmr.create():alarm(arch=='esp32' and 500 or 2000,tmr.ALARM_AUTO,function() 
                  display.flush()
               end)
            end
         else
            syslog.print(syslog.WARN,"display init failed")
         end
      else
         syslog.print(syslog.WARN,"display: no driver found (missing module)")
      end
   end
   if conf and conf.vcc and display and display.disp then     -- any GIOP used as VCC?
      gpio.mode(conf.vcc,gpio.OUTPUT)
      gpio.write(conf.vcc,1)
   end
else
   syslog.print(syslog.INFO,"display: no display/display.conf")
end

