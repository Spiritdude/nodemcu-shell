PORT=/dev/ttyUSB0
NAME=NodeMCU-Shell
BACKUP=${NAME}-`date +%F`.tar.gz

all::
	@echo "make upload_all upload_shell upload_shell_core console terminal"

upload_all::
	nodemcu-tool --port ${PORT} upload --keeppath *.lua */*.lua */*.txt */*.conf */*.dist display/*.mono www/imgs/* www/*.html www/favicon.ico.gz
	nodemcu-tool --port ${PORT} upload --keeppath beep/*.song beep/rtttl/0071.txt
	nodemcu-tool --port ${PORT} upload --keeppath --minify --compile shell/main.lua
	touch .lastupload

upload_shell::
	nodemcu-tool --port ${PORT} upload --keeppath shell/*.lua shell/*.txt
	nodemcu-tool --port ${PORT} upload --keeppath --minify --compile shell/main.lua
	touch .lastupload

upload_shell_core::
	nodemcu-tool --port ${PORT} upload --keeppath --minify --compile shell/main.lua
	touch .lastupload

upload_new::
	find -newer .lastupload | xargs nodemcu-tool --port ${PORT} upload --keeppath
	touch .lastupload

console::
	nodemcu-tool --port ${PORT} terminal

terminal::
	nodemcu-tool --port ${PORT} terminal

# -- developer only:

edit::
	dee4 README.md Makefile *.lua */*.lua

backup::
	cd ..; tar cfvz ${BACKUP} ${NAME}; mv ${BACKUP} ~/Backup/
	scp ~/Backup/${BACKUP} backup:Backup/
