OS := $(shell uname)
ifeq ($(OS),Darwin)
# Run MacOS commands 
all: macTests 
else
# check for Linux and run other commands
all: dgpio
endif

dgpio: directGpio.c
	gcc -std=gnu99 $^ -g -lm -lPJ_RPI -lpthread -o $@

macTests: directGpio.c
	gcc -std=gnu99 $^ -g -lm -lpthread -Dmac=1 -o $@

clean:
	rm -f *.o dgpio macTests directGpio directGpio2 macTests2 macClang*

install:
	useradd -r -G gpio dgpio
	cp dgpio /usr/local/bin/
	cp dgpio.service /etc/systemd/system/
	mkdir /var/log/dgpio
	chown dgpio.dgpio /var/log/dgpio
	mkdir /var/run/dgpio
	chown dgpio.dgpio /var/run/dgpio
	systemctl enable dgpio.service
	systemctl start dgpio.service

uninstall:
	-systemctl disable dgpio.service
	-systemctl stop dgpio.service
	-userdel dgpio
	-rm /usr/local/bin/dgpio
	-rm /etc/systemd/system/dgpio.service
	-rm -rf /var/run/dgpio
	-rm -rf /var/log/dgpio
