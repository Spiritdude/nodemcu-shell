-- == Console ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: print() abstraction -> console.print()
-- 
-- History:
-- 2018/01/16: 0.0.2: more consistency print(s)/output(f)/input(f)
-- 2018/01/10: 0.0.1: first version

console = {
   print = print,
   receive = nil,
   
   output = function(f) 
      console.print = f
   end,
   
   input = function(f)
      console.receive = f
   end
}
