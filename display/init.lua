-- == Display ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: use display.conf to define a display, and set 'disp' as global variable
-- 
-- History:
-- 2018/01/09: 0.0.2: more structured setup
-- 2018/01/06: 0.0.1: rudimentary

if file.exists("display/display.conf") then
   local conf = dofile("display/display.conf")

   display = {
      disp                    -- display pointer
   }    
   
   if(conf.mode=='i2c') then
      if conf.i2c.driver then
         i2c.setup(0,conf.i2c.sda,conf.i2c.scl,i2c.SLOW)
         display.disp = conf.i2c.driver(conf.i2c.sla)
         if display.disp then
            syslog.print(syslog.INFO,"init display driver: "..string.format("mode %s, %dx%d",conf.mode,display.disp:getWidth(),display.disp:getHeight()))
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
            local fo = u8g and (u8g.font_04b_03 or u8g.font_helv08 or u8g.font_6x10) 
            if fo then
               display.disp:setFont(fo)
               display.disp:setFontRefHeightExtendedText()
               display.disp:setDefaultForegroundColor()
               display.disp:setFontPosTop()
            end
            local fn = (display.disp:getHeight() >= 48) and "logo48.mono" or "logo.mono"
            local sz = (display.disp:getHeight() >= 48) and 48 or 32
            if file.open("display/"..fn) then
               local data = file.read()
               file.close()
               local w = sz
               local h = sz
               local x = int(display.disp:getWidth()/2 - w/2)
               local y = int(display.disp:getHeight()/2 - h/2)
               display.disp:firstPage()
               repeat
                  display.disp:drawXBM(x,y,w,h,data)
               until display.disp:nextPage() == false
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
               tmr.create():alarm(2000,tmr.ALARM_AUTO,function() 
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
   if conf and conf.vcc then     -- any GIOP used as VCC?
      gpio.mode(conf.vcc,gpio.OUTPUT)
      gpio.write(conf.vcc,1)
   end
else
   syslog.print(syslog.INFO,"no display/display.conf")
end

