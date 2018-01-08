-- == Simple HTTP Server ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description:
--    Very basic web-server serving just static files for now
-- Todo:
--    - Reduce memory leak
--    - support .lua files (to execute)
--
-- History:
-- 2018/01/06: 0.0.2: adding collectgarbage() and nil local variables, reduces leaks but still not entirely gone
-- 2018/01/05: 0.0.1: first version, very simple

local mm = { ["html"]="text/html", ["txt"]="text/plain", ["png"]="image/x-png", ["jpg"]="image/jpeg", ["ico"]="image/x-icon" }

local conf = dofile("httpd/httpd.conf")
local ip = wifi.ap.getip() or wifi.sta.getip()
syslog.print(syslog.INFO,"httpd:simple started on "..ip.." port "..conf.port)

local srv = net.createServer(net.TCP,10)

function sendFile(c,fn,req,gv) 
   local h = "HTTP/1.0 200 OK\r\n"
   local fno = fn
   
   fn = conf.root .. fn

   local m = "text/html"
   local ext = string.match(fn,"\.(%w+)$")
   if mm[ext] then
      m = mm[ext]
   end

   if string.match(fn,"/$") then
      fn = fn .. "index.html"
   end
   if file.exists(fn..".gz") then
      fn = fn .. ".gz"
      h = h .. "Content-Encoding: gzip\r\n"
      h = h .. "Cache-Control: public, max-age=86400\r\n"
      -- h = h .. "X-Info: something\r\n"
   end 
   
   if file.exists(fn) then
      if string.match(fn,"\.lua$") then         -- a script?
         if conf.debug > 0 then
            print("httpd: execute",fn)
         end
         c:on("sent",function(c) c:close() collectgarbage() end)
         dofile(fn)(c,req,gv)                   -- let's execute it
      else 
         
         h = h .. "Content-Type: " .. m .. "\r\n"
         
         local st = file.stat(fn)
         h = h .. "Content-Length: " .. st['size'] .. "\r\n"
         
         if(conf.debug > 0) then
            print("httpd: send",fno,fn,m,st['size'])
         end
   
         h = h .. "\r\n"   -- end of header
         
         local pos = 0                         
         local function doSend()   -- send it chunk wise, it's slower, but safer
            file.open(fn,'r')
            if file.seek('set',pos) == nil then
               c:close()
            else
               local buf = file.read(512)
               pos = pos + 512
               c:send(buf)
            end
            file.close()
         end
   
         c:on('sent',doSend)     -- the cumbersome part
         c:send(h)               -- send the header
         doSend()                -- then the rest chunk-wise
      end
   else 
      c:send("HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\n404 NOT FOUND")
      c:on('sent',function() c:close() end)
   end
   collectgarbage()
end

srv:listen(conf.port,function(conn)
   collectgarbage()
   
   conn:on("receive", function(client,request)
      collectgarbage()
      
      --print("request="..request)
      local method, path = string.match(request,"^([A-Z]+) (.+) HTTP");
      --print("method="..method,"path="..path)
      local gv = {}
      if true then
         local vars = string.match(path,"\?(.*)$")
         if vars then
            path = string.gsub(path,"\?(.*)$","")
            string.gsub(vars,"(%w+)=(%w+)&*",function(k,v)
              -- todo: decode k,v
              gv[k] = v
              --print("\t"..k.."="..v)
            end)
         end
         -- we later process gv { }
      end
      if(conf.debug > 1) then
         print("before send",node.heap())
      end
      if(conf.debug > 2) then
         client:on("sent",function() client:close() conn = nil client = nil collectgarbage() end)
         client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\ntest")
      else
         sendFile(client,path,request,gv)        -- sending file isn't that trivial
         conn = nil
         client = nil
         method = nil
         path = nil
         collectgarbage()
      end
      if(conf.debug > 1) then
         print("after send",node.heap())
      end
   end)
end)
