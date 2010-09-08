#!/bin/sh

VLC_DIR="/home/joseba/Programas/vlc-1.1.4"
VLC_INCLUDEDIR="$VLC_DIR/sdk/include"
VLC_LIBDIR=$VLC_DIR

i586-mingw32msvc-gcc -O2 -Wall -D_REENTRANT -c mod_vlc-1.1.c -I/usr/i586-mingw32msvc/include/ -I/usr/i586-mingw32msvc/include/bennugd/ -I/usr/i586-mingw32msvc/include/bennugd/libgrbase/ -I/usr/i586-mingw32msvc/include/bennugd/libvideo/ -I$VLC_INCLUDEDIR -I/usr/i586-mingw32msvc/include/SDL/

if [ -f mod_vlc-1.1.o ]; then
	i586-mingw32msvc-gcc mod_vlc-1.1.o -o mod_vlc.dll -L /usr/i586-mingw32msvc/lib/ -L /usr/i586-mingw32msvc/lib/bennugd/ -L$VLC_LIBDIR -shared -lvlc -lmod_video -lrender -lvideo -lblit -lgrbase -lbgdrtm -Wl,-soname -Wl,mod_vlc.dll
fi

if [ -f mod_vlc.dll ]; then
        i586-mingw32msvc-strip mod_vlc.dll
        rm mod_vlc-1.1.o
fi
