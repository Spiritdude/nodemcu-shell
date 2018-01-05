conf = dofile("httpd/httpd.conf")

print("INFO: httpd starting at port "..conf.port);
if true then
   dofile("httpd/simple.lua")
else 
   dofile('httpd/httpServer.lua')
   httpServer:listen(conf.port)
end
