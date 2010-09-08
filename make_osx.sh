#!/bin/sh

DEPS="bennugd-core bennugd-module-mod_video libvlc sdl"
MODULE="mod_vlc"

# Clean previous module files
if [ -f $MODULE.so ]; then
	rm $MODULE.so
fi

# Compile the source code
llvm-gcc-4.2 -O2 -m32 -c -Wall -I../bennugd/base/core/include/ -I../bennugd/base/modules/libgrbase/ -I../bennugd/base/modules/libvideo/ -I../bennugd/base/modules/libblit/ -I/Applications/VLC.app/Contents/MacOS/include -I/sw/include/SDL/ $MODULE.c

# Link the module
if [ -f $MODULE.o ]; then
	llvm-gcc-4.2 -O2 -m32 -o $MODULE.dylib $MODULE.o -dynamiclib -L../bennugd_bin/lib/ -L/Applications/VLC.app/Contents/MacOS/lib -lvlc -lrender -lvideo -lblit -lgrbase -lbgdrtm
fi

# Strip and remove compilation files
if [ -f $MODULE.so ]; then
	rm $MODULE-1.1.o
	strip $MODULE.so
fi

