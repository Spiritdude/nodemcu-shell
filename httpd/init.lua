conf = dofile("httpd/httpd.conf")

print("INFO: httpd starting at port "..conf.port);
dofile("httpd/simple.lua")
