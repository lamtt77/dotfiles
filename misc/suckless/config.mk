# dwmstatus version
VERSION = 0.1

# Customize below to fit your system

# paths
PREFIX = /usr/local

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# includes and libs
INCS = -I$(X11INC)
LIBS = -L$(X11LIB) -lX11

# flags
DWMSTATUSCFLAGS = $(INCS) $(CPPFLAGS) $(CFLAGS)
DWMSTATUSLDFLAGS = $(LIBS) $(LDFLAGS)

# CPPFLAGS = -Wno-implicit-function-declaration -DVERSION=\"$(VERSION)\" -D_XOPEN_SOURCE=600
# OpenBSD:
CPPFLAGS = -Wno-implicit-function-declaration -DVERSION=\"$(VERSION)\" -D_XOPEN_SOURCE=600 -D_BSD_SOURCE

# compiler and linker
CC = cc
