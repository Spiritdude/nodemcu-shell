-- == Clear ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: clear screen (VT100)
--
-- History:
-- 2018/01/16: 0.0.2: terminal.* changed, terminal.print() it is
-- 2018/01/07: 0.0.1: first version

return function(...) 
   --console.print(string.format("%c[%d;%dH%c[J",27,1,1,27))
   terminal.print(string.format("%c[%d;%dH%c[J",27,1,1,27))
end

