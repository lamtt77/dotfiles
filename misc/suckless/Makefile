# dwmstatus - simple dwm status
.POSIX:

include config.mk

SRC = dwmstatus.c
OBJ = $(SRC:.c=.o)

all: options dwmstatus

options:
	@echo dwmstatus build options:
	@echo "CFLAGS  = $(DWMSTATUSCFLAGS)"
	@echo "LDFLAGS = $(DWMSTATUSLDFLAGS)"
	@echo "CC      = $(CC)"

.c.o:
	$(CC) $(DWMSTATUSCFLAGS) -c $<

$(OBJ): config.mk

dwmstatus: $(OBJ)
	$(CC) -o $@ $(OBJ) $(DWMSTATUSLDFLAGS)

clean:
	rm -f dwmstatus $(OBJ)

install: dwmstatus
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dwmstatus $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dwmstatus

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st

.PHONY: all options clean install uninstall
