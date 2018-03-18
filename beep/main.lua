-- == Beep ==
-- Copyright (c) 2018 by Rene K. Mueller <spiritdude@gmail.com>
-- License: MIT License (see LICENSE file)
-- Description: 
--   just playing some basic sounds via gpio ping
--
-- History:
-- 2018/03/13: 0.0.2: utilizing pwm module, functional including song.load() and song.play()
-- 2018/02/23: 0.0.1: first version, not functional

return function(...)
   local tbase = {
      c  = 262, 
      cS = 277, 
      d  = 294, 
      dS = 311, 
      e  = 330, 
      f  = 349, 
      fS = 370, 
      g  = 392,
      gS = 415, 
      a  = 440, 
      aS = 466, 
      b  = 494, 
   }
   local tt = { }

   if false then
      for o=1, 3 do     -- init 3 octaves
         table.foreach(tbase,function(i,k)
            tt[i..(o==1 and '' or (o-1))] = k*o
         end)
      end
   else 
      tt = tbase
   end
   
   -- table.foreach(tt,print)
   
   local beep = function(pin,t,d,cb,a1,a2,a3) 
      local sc = 1
      if type(t)=='string' and t:match("(%d+)$") then
         t = t:gsub("(%d+)$",function(a) 
            sc = tonumber(a)+1                        -- calculate scale/octave separate
            return ''
         end)
      end
      local fq = tt and tt[t] and tt[t]*sc or t        -- we calculate octave in here, or direct frequency
      if t ~= 'p' then
         pwm.setup(pin,fq,512)  
         pwm.start(pin)  
      end
      tmr.create():alarm(d,tmr.ALARM_SINGLE,function(tm) 
         if t ~= 'p' then
            pwm.stop(pin)  
         end
         tm:unregister()
         if cb then
            cb(a1,a2,a3)
         end
      end)
   end  

   local beep_basic = function(pin,t,d,cb)
      local tm = tmr.create()
      local bz = tmr.create()
      local buzz = 0

      bz:alarm(t,tmr.ALARM_AUTO,function(t)     -- crude buzzing: t: 1..10
        buzz = 1 - buzz
        gpio.write(pin,buzz)
      end)

      tm:alarm(d,tmr.ALARM_SINGLE,function(t)
         bz:unregister()
         bz = nil
         t:unregister()
         collectgarbage()
      end)
   end

   local song = {  }
   song.load = function(fn) 
      local f = file.open(fn)
      local sg = { }
      local t
      if fn:match(".song") then
         repeat
            t = f:read("\n")
            if t then
               if not t:match("^%s*#") then
                  local f, d = t:match("(%w+)%s+(%d+)")
                  if f and d then
                     table.insert(sg,{ f = f, d = tonumber(d) or 400 })
                  else 
                     console.print("song.load(): malformed notes in "..fn..": "..t)
                  end
               end
            end
         until t == nil
      elseif fn:match(".txt") or fn:match(".rtttl") then    -- rtttl: https://en.wikipedia.org/wiki/Ring_Tone_Transfer_Language
         t = f:read()
         f:close()
         local t,df,st = t:match("([^:]+):([^:]+):(.*)")
         local def = { d = 4, o = 4, b = 100 }
         df:gsub("([dob])=([%.%d]+)",function(k,v)
            --console.print("default",k,v)
            def[k] = tonumber(v)
         end)
         st:gsub("([^,]+)",function(p) 
            --console.print(p)
            if p:match("%d*%w[#]*[%.%d]*") then
               local d, n, o = p:match("(%d*)(%w[#]*)([%.%d]*)")
               d = d == "" and 1 or d
               d = 1000 / (tonumber(d) or 1) * def.d 
               n = n:lower()
               n = n:gsub('#','S')
               o = o:gsub("^%.","")
               o = (tonumber(o) or def.o or 4) - 4
               o = o<0 and 0 or o or o>6 and 6 or o
               n = n .. ( o>0 and o or '')
               --print(p,n,d)
               table.insert(sg,{ f = n, d = d })
               table.insert(sg,{ f = 'p', d = def.d*10 })
            end
         end)
      else
         _syslog.print(_syslog.ERROR,"song.load(): unknown extension "..fn.." (.song, .txt and .rtttl supported)")
         return nil
      end
      return sg
   end
   song.play = function(pin,s) 
      local nextNote2 
      local nextNote = function() 
         local n = table.remove(s,1)
         if n then
            --console.print(#s,sjson.encode(n))
            beep(pin,n.f,n.d,nextNote2)
         end
      end
      nextNote2 = nextNote
      nextNote()
   end
   
   table.remove(arg,1)
                        
   local d = 500
   local f = 'c'
   local conf = loadfile("beep/beep.conf") or { pin = 1 }

   gpio.mode(conf.pin,gpio.OUTPUT)
   
   if arg[1] and string.match(arg[1],"^%d+$") and tonumber(arg[1]) > 0 then
      d = tonumber(arg[1])
      if arg[2] then
         if string.match(arg[2],"^%d+$") and tonumber(arg[2]) > 0 then
            f = tonumber(arg[2])
         else 
            f = arg[2]
         end
      end
   elseif arg[1] and file.exists(arg[1]) then
      song.play(conf.pin,song.load(arg[1]) or { f = 'a', d = 50 })
      return
   end
   
   local cnt = arg[3] and tonumber(arg[3]) or 1
   if cnt > 1 then
      local sg = { }
      for i=1, cnt do
         table.insert(sg,{f = f, d = d})
         table.insert(sg,{f = 'p', d = 50})
      end
      song.play(conf.pin,sg)
   else
      beep(conf.pin,f,d)
   end
end
