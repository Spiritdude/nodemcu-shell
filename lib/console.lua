-- == Console ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: print() abstraction -> console.print()
-- 
-- History:
-- 2018/01/10: 0.0.1: first version

console = {
   _print = print,
   
   print = function(s) 
      console._print(s)
   end,

   output = function(f) 
      console._print = f
   end,
   
   input = function(f)
   end
}
