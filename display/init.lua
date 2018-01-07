if file.exists("display/display.conf") then
   local conf = dofile("display/display.conf")
   
   if(conf.mode=='i2c') then
      syslog.print(syslog.INFO,"init display driver, "..string.format("mode %s, %dx%d",conf.mode,conf.w,conf.h))
      i2c.setup(0,conf.i2c.sda,conf.i2c.scl,i2c.SLOW)
      disp = conf.i2c.drv(conf.i2c.sla)
   end
else
   syslog.print(syslog.INFO,"no display/display.conf")
end

