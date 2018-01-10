return function(...)
   dofile("shell/cat.lua")(unpack(arg))      -- later when user interaction (hitting space) is available this code changes
end
