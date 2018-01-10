-- == Disk Space Usage ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: displays df and df -h
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(...) 
   local remain, used, total = file.fsinfo()
   local fmt = "%-12s %10s %10s %10s %4s %s";
   console.print(string.format(fmt,"Filesystem","Total","Used","Available","Use%","Mounted on"))
   
   if(arg[2] and arg[2]=='-h') then
      --console.print("/flashfs",(total/1024).."K",(used/1024).."K",((total-used)/1024).."K",(100*used/total).."%","/")
      console.print(string.format(fmt,"/flashfs",(total/1024).."K",(used/1024).."K",((total-used)/1024).."K",(100*used/total).."%","/"))
   else
      console.print(string.format(fmt,"/flashfs",total.."",used.."",(total-used).."",(100*used/total).."%","/"))
   end
end
