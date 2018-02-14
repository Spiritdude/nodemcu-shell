-- == Lua ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: execute lua code direct
--
-- History:
-- 2018/02/13: 0.0.2: very basic Lua console
-- 2018/01/05: 0.0.1: first version

return function(...)
   if arg[2] then
      assert(loadstring(arg[2]))()
   else
      console.print("== Lua Console")
      terminal.print("> ")
      terminal.input(function(line) 
         line = line:gsub("[\r\n]*$","")
         if line == 'exit' then
            terminal.input(nil)     -- give input back to shell
            console.print("")       -- triggers the prompt
         else 
            local f, err = loadstring(line)
            console.print(f and f() or (err and "ERROR: "..err) or 'nil')
            terminal.print("> ")
         end
      end)
   end
end
