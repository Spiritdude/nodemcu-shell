-- == Sample RESTful API with httpd/simple.lua ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: gives a a basic framework to a RESTendpoint
--
-- History:
-- 2018/01/06: 0.0.1: first version

return function(conn,req,gv)
   dofile("httpd/header.lua")(conn,200,"application/json")
   if gv['req']=='chipid' then
      conn:send(sjson.encode({id=node.chipid()}))
   elseif gv['req']=='heap' then
      conn:send(sjson.encode({heap=node.heap()}))
   elseif gv['req']=='filelist' then
      conn:send(sjson.encode({filelist=file.list()}))
   else
      conn:send("UNKNOWN REQUEST")
   end
   collectgarbage()
end
