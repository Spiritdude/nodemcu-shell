-- == Disk Space Usage ==
-- Author: Rene K. Mueller <spiritdude@gmail.com>
-- Description: displays df and df -h
--
-- History:
-- 2018/01/03: 0.0.1: first version

return function(arg) 
   local remain, used, total = file.fsinfo()
   print("Filesystem","Total","Used","Avail.","Use%","Mounted On")
   if(arg[2] and arg[2]=='-h') then
      print("/flashfs",(total/1024).."K",(used/1024).."K",((total-used)/1024).."K",(100*used/total).."%","/")
   else
      print("/flashfs",total,used,total-used,(100*used/total).."%","/")
   end
end
