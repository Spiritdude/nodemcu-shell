-- == Clear ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: clear screen (VT100)
--
-- History:
-- 2018/01/07: 0.0.1: first version

return function(...) 
   --print(string.format("%c[%d;%dH%c[J",27,1,1,27))
   terminal.output(string.format("%c[%d;%dH%c[J",27,1,1,27))
end

