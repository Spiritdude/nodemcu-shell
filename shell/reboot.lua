-- == Reboot ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: just restart device
--
-- History:
-- 2018/01/04: 0.0.1: first version

return function(...)
   console.print("rebooting now ...")
   node.restart()
end
