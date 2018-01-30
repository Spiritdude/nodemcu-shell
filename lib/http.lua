-- == HTTP Library ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--    Providing http module for ESP32 NodeMCU
-- History: 
-- 2018/01/30: 0.0.1: http.get() without headers/body and http only works

http = {
   get = function(url,headers,callback) 
      local secure,host,path = string.match(url,"^http(s*)://([%w%.]+)(/.*)$")
      local srv = net.createConnection(net.TCP,secure=='s' and 1 or 0)
      srv:on("receive", function(sck, c) callback(200,c) end)
      srv:on("connection", function(sck, c)
         local xtr = headers and table.concat(headers,"\r\n") or nil
         sck:send("GET "..path.." HTTP/1.1\r\nHost: "..host.."\r\nConnection: close\r\nAccept: */*\r\n"..(xtr and xtr.."\r\n" or "").."\r\n")
      end)
      srv:connect(secure=='s' and 443 or 80,host)
   end,
   post = function() end,
   put = function() end,
   request = function() end
}
