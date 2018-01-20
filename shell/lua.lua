-- == Lua ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: execute lua code direct
--
-- History:
-- 2018/01/05: 0.0.1: first version

return function(...)
   if arg[2] then
      assert(loadstring(arg[2]))()
   end
end
