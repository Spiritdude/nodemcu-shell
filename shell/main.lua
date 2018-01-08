-- == NodeMCU Shell ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: adapted from telnet.lua and further extended to provide NodeMCU shell functionality
--    See http://github.com/Spiritdude/nodemcu-shell for details
--    Note: this is very experimental, telnet is a prototype interface for the shell
--
-- History:
-- 2018/01/06: 0.0.4: replacing node.output() and define dedicated print(...) 
-- 2018/01/04: 0.0.3: unpacking args at dofile()
-- 2018/01/04: 0.0.2: simple arguments passed on, proper prompt and empty input handled
-- 2018/01/03: 0.0.1: first version

local VERSION = '0.0.5'

local port = 2323
local shell_srv = net.createServer(net.TCP,180)

local ip = wifi.ap.getip() or wifi.sta.getip()
syslog.print(syslog.INFO,"nodemcu shell started on "..ip.." port "..port)

shell_srv:listen(port,function(socket)
   local fifo = {}
   local fifo_drained = true
   local prompt = false
    
   local function sender(c)
      if #fifo > 0 then
         c:send(table.remove(fifo,1))
      else
         fifo_drained = true
         if not prompt then
            c:send("% ")
            prompt = true
         end
      end
   end
   local function s_output(str)
      table.insert(fifo,str)
      if socket ~= nil and fifo_drained then
         fifo_drained = false
         sender(socket)
      end
   end
   
   -- attempt to have other apps take control of the connection (like an editor)
   terminal = {} 
   terminal.output = function(s)
      s_output(s)
   end
   terminal.input = function(cb)
      --socket:on("receive",cb)
      terminal.input_callback = cb
   end
   
   if false then
      function print(...)
         local str = ""
         for i,v in ipairs(arg) do
            if i > 1 then
               str = str .. "\t"
            end
            str = str .. v
         end
         str = str .. "\n"
         table.insert(fifo,str)
         if socket ~= nil and fifo_drained then
            fifo_drained = false
            sender(socket)
         end
      end
   end

   local function expandFilename(v)
      if string.match(v,"[*?]") then
         local re = v
         re = "^" .. re
         re = string.gsub(re,"%.","%.")
         re = string.gsub(re,"%*",".*")
         re = string.gsub(re,"%?",".")
         re = re .. "$"
         --print("check "..re)
         local repl = { }
         for f,s in pairs(file.list()) do
            --print("check "..f.." vs "..re)
            if string.match(f,re) then
               --print(re..": "..f)
               table.insert(repl,f)
            end
         end
         table.sort(repl)
         return repl
      else
         return nil
      end
   end

   node.output(s_output,0)   -- re-direct output to function s_output
    
   socket:on("receive",function(c,l)      -- we receive line-wise input
      collectgarbage()
      if terminal.input_callback then
         terminal.input_callback(l)
         return
      end
      --node.input(l)           -- works like pcall(loadstring(l)) but support multiple separate line
      l = string.gsub(l,"[\n\r]*$","")
      a = { }
      local fileExpFail
      if true then                 -- argument parser
         local s = 0               -- state: 0 (default), 1 = non-space, 2 = in " string, 3 = in ' string
         local t = ""              -- current token
         local ln = string.len(l)
         for i=1,ln,1 do
            local c = string.sub(l,i,i)
            if(s == 0 and c == '"') then
              s = 2
            elseif(s == 0 and c == "'") then
              s = 3
            elseif(s == 0 and c == " ") then
              s = s
            elseif(s == 0) then
              t = t..c
              s = 1
            elseif(s == 1) then
               if(c == " ") then
                  local ex = expandFilename(t)
                  if(ex and #ex == 0) then
                     fileExpFail = "no match" -- for <"..t..">"
                  elseif ex then
                     fileExpFail = nil
                     for i,v in ipairs(ex) do
                        table.insert(a,v)
                     end
                  else
                     table.insert(a,t)
                  end
                  t = ""
                  s = 0
               else
                  t = t..c;
               end
            elseif(s == 2) then
               if(c == '"') then
                  table.insert(a,t)
                  t = ""
                  s = 0
              else
                  t = t..c;
              end
            elseif(s == 3) then
               if(c == "'") then
                  table.insert(a,t)
                  t = ""
                  s = 0
               else
                  t = t..c;
               end
             end
         end
         
         if(string.len(t) > 0) then
            if(s == 1) then
               local ex = expandFilename(t)
               if(ex and #ex == 0) then
                  fileExpFail = "no match" -- for <"..t..">"
               elseif ex then
                  fileExpFail = nil
                  for i,v in ipairs(ex) do
                     table.insert(a,v)
                  end
               else
                  table.insert(a,t)
               end
            else
               table.insert(a,t)
            end
         end
      else
         -- crude space separating arguments (no strings ".." or '..' parsed)
         string.gsub(l,"([^ ]+)",function(c) 
            a[#a+1] = c
            --print("="..c)    
          end)
      end

      if(#a > 0 and fileExpFail) then
         c:send(a[1]..": "..fileExpFail.."\n")
         c:send("% ")
         prompt = true
      elseif #a > 0 then
         local cmd = a[1]
         --print("process "..cmd)
         if cmd=='exit' then
            prompt = true     -- don't try to print it 
            c:close()
            return
         elseif file.exists("shell/"..cmd..".lc") then
            --print("execute "..cmd.."/main.lc")
            dofile("shell/"..cmd..".lc")(unpack(a))
            --assert(loadfile("shell/"..cmd..".lc"))(unpack(a))
         elseif file.exists("shell/"..cmd..".lua") then
            --print("execute "..cmd.."/main.lua")
            dofile("shell/"..cmd..".lua")(unpack(a))
             --assert(loadfile("shell/"..cmd..".lua"))(unpack(a))
         elseif file.exists(cmd.."/main.lc") then
            --print("execute "..cmd.."/main.lc")
            dofile(cmd.."/main.lc")(unpack(a))
            --assert(loadfile(cmd.."/main.lc"))(unpack(a))
         elseif file.exists(cmd.."/main.lua") then
            --print("execute "..cmd.."/main.lua")
            dofile(cmd.."/main.lua")(unpack(a))
            --assert(loadfile(cmd.."/main.lua"))(unpack(a))
         elseif file.exists(cmd..".lua") then
            --print("execute "..cmd..".lua")
            dofile(cmd..".lua")(unpack(a))
            --assert(loadfile(cmd..".lua"))(unpack(a))
         else 
            print("ERROR: command <"..cmd.."> not found")
         end
         prompt = false
         sender(socket)
      else
         c:send("% ")
         prompt = true
      end
   end)
   socket:on("disconnection",function(c)
      node.output(nil)        -- un-register the redirect output function, output goes to serial
      socket = nil
      collectgarbage()
   end)
   socket:on("sent",sender)
   print("== Welcome to NodeMCU Shell "..VERSION.." on "..wifi.sta.gethostname().." ("..node.chipid()..string.format("/0x%x",node.chipid())..")")
end)
