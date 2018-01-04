PORT=/dev/ttyUSB0

all::
	@echo "make upload_all upload_shell upload_shell_core"

upload_all::
	nodemcu-tool --port ${PORT} upload --keeppath *.lua */*.lua */*.conf

upload_shell::
	nodemcu-tool --port ${PORT} upload --keeppath shell/*.lua

upload_shell_core::
	nodemcu-tool --port ${PORT} upload --keeppath shell/main.lua


