-- == Touch ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: touch (create or change mtime) a file
--
-- History:
-- 2018/01/04: 0.0.1: first version

return function(...)
   if arg[2] then
      if file.open(arg[2],"a") then
         file.write("")
         file.close()
      end
   end
end
