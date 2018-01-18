PORT=/dev/ttyUSB0
BACKUP=nodemcu-shell-`date +%F`.tar.gz

all::
	@echo "make upload_all upload_shell upload_shell_core"

upload_all::
	nodemcu-tool --port ${PORT} upload --keeppath *.lua */*.lua */*.txt */*.conf */*.dist display/*.mono www/imgs/* www/*.html www/favicon.ico.gz

upload_shell::
	nodemcu-tool --port ${PORT} upload --keeppath shell/*.lua shell/*.txt

upload_shell_core::
	nodemcu-tool --port ${PORT} upload --keeppath shell/main.lua

# -- developer only:

edit::
	dee4 README.md Makefile *.lua */*.lua

backup::
	cd ..; tar cfvz ${BACKUP} nodemcu-shell; mv ${BACKUP} ~/Backup/
	scp ~/Backup/${BACKUP} backup:Backup/
