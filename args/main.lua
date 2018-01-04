return function(...)
   for k,v in ipairs(arg) do
      print(k,"=",v)
   end
end

--local a,b,c = { ... }
--print(a,b,c)
--local param = { ... }
--print(param)
