return function(conn,req,gv)
   dofile("httpd/header.lua")(conn,200,"text/plain")
   local i
   local s = ""
   for i=1,10,1 do
      s = s .. i .. "\r\n"
   end
   conn:send(s)
end
