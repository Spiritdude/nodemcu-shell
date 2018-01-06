return function(...)
   table.remove(arg,1)
   if #arg > 0 then
      man(arg[1])
   end
end
