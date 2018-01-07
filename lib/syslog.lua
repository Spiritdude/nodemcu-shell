syslog = {
   INFO = 0,
   WARN = 1,
   ERROR = 2,
   FATAL = 3,

   level = 0,
   verbose = function(lv)
      level = lv
   end,
   print = function(l,m)
      local tm = { [0]='INFO', [1]='WARN', [2]='ERROR', [3]='FATAL' }
      print((tm[l] or 'UNKOWN') .. " " .. ((tmr and (tmr.now()/1000) .. "ms") or 0) .. ": " .. m)
   end
}
