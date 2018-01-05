-- == NodeMCU Shell ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: adapted from telnet.lua and further extended to provide NodeMCU shell functionality
--    See http://github.com/Spiritdude/nodemcu-shell for details
--
-- History:
-- 2018/01/04: 0.0.3: unpacking args at dofile()
-- 2018/01/04: 0.0.2: simple arguments passed on, proper prompt and empty input handled
-- 2018/01/03: 0.0.1: first version

-- a simple shell (based on telnet server)

local VERSION = '0.0.3'

local port = 2323
telnet_srv = net.createServer(net.TCP, 180)

print("NodeMCU shell started on port "..port)
    
telnet_srv:listen(port, function(socket)
    local fifo = {}
    local fifo_drained = true
    local prompt = false
    
    local function sender(c)
        if #fifo > 0 then
            c:send(table.remove(fifo, 1))
        else
            fifo_drained = true
            if(not prompt) then
               c:send("% ")
               prompt = true
            end
        end
    end

    local function s_output(str)
        table.insert(fifo, str)
        if socket ~= nil and fifo_drained then
            fifo_drained = false
            sender(socket)
        end
    end

    node.output(s_output, 0)   -- re-direct output to function s_ouput.
    
    socket:on("receive", function(c, l)
        --node.input(l)           -- works like pcall(loadstring(l)) but support multiple separate line
        l = string.gsub(l,"[\n\r]*$","")
        a = { }
        if true then
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
               t = t..c;
               s = 1
             elseif(s == 1) then
               if(c == " ") then
                  table.insert(a,t)
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
            table.insert(a,t)
          end
        else
           -- crude space separating arguments (no strings ".." or '..' parsed)
           string.gsub(l,"([^ ]+)",function(c) 
             a[#a+1] = c
             --print("="..c)
           end)
        end
        --for k,v in ipairs(a) do
        --  print(k.."="..v)
        --end
        if(#a>0) then
           local cmd = a[1]
           --print("process "..cmd)
           if file.exists("shell/"..cmd..".lc") then
              --print("execute "..cmd.."/main.lc")
              dofile("shell/"..cmd..".lc")(unpack(a))
           elseif file.exists("shell/"..cmd..".lua") then
              --print("execute "..cmd.."/main.lua")
              dofile("shell/"..cmd..".lua")(unpack(a))
           elseif file.exists(cmd.."/main.lc") then
              --print("execute "..cmd.."/main.lc")
              dofile(cmd.."/main.lc")(unpack(a))
           elseif file.exists(cmd.."/main.lua") then
              --print("execute "..cmd.."/main.lua")
              dofile(cmd.."/main.lua")(unpack(a))
           elseif file.exists(cmd..".lua") then
              --print("execute "..cmd..".lua")
              dofile(cmd..".lua")(unpack(a))
           else 
              print("ERROR: command <"..cmd.."> not found")
           end
           prompt = false
           --c:send("% ")
           --prompt = true
        else
           c:send("% ")
           prompt = true
        end
        --c:send("> ")
    end)
    socket:on("disconnection", function(c)
        node.output(nil)        -- un-regist the redirect output function, output goes to serial
    end)
    socket:on("sent", sender)

    print("== Welcome to NodeMCU Shell "..VERSION)
end)
