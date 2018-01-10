-- == Display ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
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
      if conf.i2c.drv then
         i2c.setup(0,conf.i2c.sda,conf.i2c.scl,i2c.SLOW)
         display.disp = conf.i2c.drv(conf.i2c.sla)
         if display.disp then
            syslog.print(syslog.INFO,"init display driver, "..string.format("mode %s, %dx%d",conf.mode,display.disp:getWidth(),display.disp:getHeight()))
            if(u8g and u8g.font_6x10) then
               display.disp:setFont(u8g.font_6x10)
               display.disp:setFontRefHeightExtendedText()
               display.disp:setDefaultForegroundColor()
               display.disp:setFontPosTop()
            end
            if file.open("display/logo.mono") then
               local data = file.read()
               file.close()
               local w = 31
               local h = 31
               local x = display.disp:getWidth()/2 - w/2
               local y = display.disp:getHeight()/2 - h/2
               display.disp:firstPage()
               repeat
                  display.disp:drawXBM(x,y,w,h,data)
               until display.disp:nextPage() == false
            end
         else
            syslog.print(syslog.WARN,"display init failed")
         end
      else
         syslog.print(syslog.WARN,"display: no driver found (missing module)")
      end
   end
else
   syslog.print(syslog.INFO,"no display/display.conf")
end

