-- == Sample RESTful API with httpd/simple.lua ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: gives a a basic framework to a RESTendpoint
--
-- History:
-- 2018/01/13: 0.0.2: req=chipid and req=chipid,heap,filelist combined as well
-- 2018/01/06: 0.0.1: first version

return function(conn,req,gv)
   dofile("httpd/header.lua")(conn,200,"application/json")
   local d = { }
   local w = gv.req
   if w then
      string.gsub(w,"([^,]+),*",function(k)
         --console.print("=="..k)
         if k == 'chipid' then
            d.chipid = node.chipid()
         elseif k == 'heap' then
            d.heap = node.heap()
         elseif k == 'filelist' then
            d.filelist = file.list()
         else
            d.error = "UNKNOWN REQUEST: "..k
         end
      end)
   else
      d.error = "UNKNOWN REQUEST"
   end
   conn:send(sjson.encode(d))
   collectgarbage()
end
