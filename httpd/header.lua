return function(conn,status,mime,opts) 
   local sm = { [200] = "OK", [404] = "Not Found" }
   conn:send("HTTP/1.0 "..(sm[status] and (status.." "..sm[status]) or status).."\r\nServer: httpd/simple.lua\r\nContent-Type: "..mime.."\r\n")
   if opts then
      if opts['gzip'] then
         conn:send("Content-Encoding: gzip\r\nCache-Control: max-age=86400\r\n")
      elseif opts['headers'] then
         for i,h in ipairs(opts['headers']) do
            conn:send(h)
         end
      end
   end
   conn:send("Connection: close\r\n\r\n")
end
