-- == Move(Rename) ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: moves/rename a file, move multiple files to new location
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...)
   table.remove(arg,1)
   -- multiple files moving to new "directory" (won't work yet)
   if(false and string.match(arg[#arg],".+%/$")) then    -- not yet: move file(s) to a new "location"
      local dest = arg[#arg]
      table.remove(arg,#arg)
      for i,f in pairs(arg) do
         local bn = string.match(f,"%/([^%/]+)$")        -- we don't know actual common name, but only basename 
         if base then                                    -- problem: e.g. mv httpd/www/* www/
            file.rename(dest..bn)                        --                            ^--- expands, we don't know 
         end                                             --                                 it was httpd/www/ as base
      end
   -- two "directories" - we rebase all files
   elseif(#arg == 2 and string.match(arg[1],".+%/$") and string.match(arg[2],".+%/$")) then
      -- rebase two dirs
      for f,s in pairs(file.list()) do
         if string.find(f,arg[1]) == 1 then     -- must match from the beginning
            local d = string.sub(f,string.len(arg[1])+1)
            print("   "..f.." to "..arg[2]..d)
            file.rename(f,arg[2]..d)
         end
      end
   elseif(#arg == 2 and arg[1] and arg[2]) then
      if file.exists(arg[1]) then
         print("   "..arg[1].." to "..arg[2])
         file.rename(arg[1],arg[2])
      else
         print("ERROR: file <"..arg[1].."> not found, cannot rename/move")
      end
   else
      print("ERROR: mv requires two arguments")
   end
end

