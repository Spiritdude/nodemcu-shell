-- == Display Library ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: 
--    This small library provides some higher level print() functionality
--    Note that all rendering is performed by display.flush(), so call it when
--       when all display.print() or display.clear() is done
--    Depending on the screen height there is auto-scroll.
--
--    display.disp      display pointer, to access lower-level functionality
--    display.setFont()
--    display.clear()   clear screen
--    display.print()   print a string to the display
--    display.flush()   render clear/print to display
--
--  Weight: ~2400 bytes heap
--
-- History: 
-- 2018/01/09: 0.0.1: from display/init.lua extracted

if display and display.disp then
   display.buffer = {}                     -- content buffer (array of lines)
   display.width = display.disp:getWidth()
   display.height = display.disp:getHeight()
   display.fontHeight = display.disp:getFontAscent() - display.disp:getFontDescent() + 1

   display.setFont = function(fo)
      if fo then
         display.disp:setFont(fo)
         display.disp:setFontRefHeightExtendedText()
         display.disp:setDefaultForegroundColor()
         display.disp:setFontPosTop()
         display.fontHeight = display.disp:getFontAscent() - display.disp:getFontDescent() + 1
      end
   end

   display.setRotation = function(a) 
      local w = display.width
      local h = display.height
      if a == 0 then
         display.disp:undoRotation()
      elseif a == 90 then
         display.disp:setRot90()
         display.width = h
         display.height = w
      elseif a == 180 then
         display.disp:setRot180()
      elseif a == 270 then
         display.disp:setRot270()
         display.width = h
         display.height = w
      end
   end

   display.render = function(f)            -- render content (anything)
      display.disp:firstPage()
      repeat
         f();
      until display.disp:nextPage() == false
      collectgarbage()
   end
   
   display.flush = function()               -- render content (strings)
      display.disp:firstPage()
      repeat
         local y = 0;
         for i,v in ipairs(display.buffer) do
            --console.print("=",v)
            display.disp:drawStr(0,y,v)
            y = y + display.fontHeight;
         end
      until display.disp:nextPage() == false
      collectgarbage()
   end

   -- global functions
   display.clear = function()
      display.buffer = {}
      --display.flush()
   end
   
   display.print = function(s)
      table.insert(display.buffer,s)
      while(#display.buffer * display.fontHeight > display.height) do   -- scrolling required?
         table.remove(display.buffer,1)
      end
      --display.flush()
      collectgarbage()
   end
end
