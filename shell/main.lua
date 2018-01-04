-- == NodeMCU Sehll ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: adapted from telnet.lua and further extended to provide NodeMCU shell functionality
--    See http://github.com/Spiritdude/nodemcu-shell for details
--
-- History:
-- 2018/01/04: 0.0.2: simple arguments passed on, proper prompt and empty input handled
-- 2018/01/03: 0.0.1: first version

-- a simple shell (based on telnet server)

local VERSION = '0.0.2'

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
        string.gsub(l,"([^ ]+)",function(c) 
          a[#a+1] = c
          --print("="..c)
        end)
        --for k,v in ipairs(a) do
        --  print(k.."="..v)
        --end
        if(#a>0) then
           local cmd = a[1]
           --print("process "..cmd)
           if(file.exists("shell/"..cmd..".lc")) then
              dofile("shell/"..cmd..".lc")(a)
           elseif(file.exists("shell/"..cmd..".lua")) then
              dofile("shell/"..cmd..".lua")(a)
           elseif(file.exists(cmd.."/main.lc")) then
              --print("execute "..cmd.."/main.lc")
              dofile(cmd.."/main.lc")(a)
           elseif(file.exists(cmd.."/main.lua")) then
              --print("execute "..cmd.."/main.lua")
              dofile(cmd.."/main.lua")(a)
           elseif(file.exists(cmd..".lua")) then
              --print("execute "..cmd..".lua")
              dofile(cmd..".lua")(a)
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
