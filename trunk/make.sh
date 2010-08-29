#!/bin/sh

DEPS="bennugd-core bennugd-module-mod_video libvlc sdl"
MODULE="mod_vlc"

# Clean previous module files
if [ -f $MODULE.so ]; then
	rm $MODULE.so
fi

# Compile the source code
gcc -c -Wall $(pkg-config --cflags $DEPS) $MODULE-1.1.c

# Link the module
if [ -f $MODULE-1.1.o ]; then
	gcc -o$MODULE.so $MODULE-1.1.o -shared $(pkg-config --libs $DEPS) -Wl,-soname -Wl,$MODULE.so
fi

# Strip and remove compilation files
if [ -f $MODULE.so ]; then
	rm $MODULE-1.1.o
	strip $MODULE.so
fi

