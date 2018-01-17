-- == Ping ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: ping
--
-- History:
-- 2018/01/04: 0.0.1: first version, using net.dns.resolve() for now

return function(...)
   table.remove(arg,1)   -- remove first argument, the name of the command
   if #arg > 0 then
      ip = arg[1]
      local t = tmr.now()
      net.dns.resolve(ip,function(sk,ip) 
         if ip == nil then 
            console.print("ERROR: <"..arg[1].."> did not resolve")
         else
            t = int((tmr.now()-t)/1000)
            console.print("PING "..arg[1].." ("..ip..") time "..t.."ms")
         end
      end)
   else 
      console.print("ERROR: ping requires 1 argument")
   end
end

