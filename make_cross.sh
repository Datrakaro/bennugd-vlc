#!/bin/sh

i586-mingw32msvc-gcc -O2 -Wall -D_REENTRANT -c mod_vlc-1.1.c -I/usr/i586-mingw32msvc/include/ -I/usr/i586-mingw32msvc/include/bennugd/ -I/usr/i586-mingw32msvc/include/bennugd/libgrbase/ -I/usr/i586-mingw32msvc/include/bennugd/libvideo/ -I/home/joseba/Programas/vlc-1.1.0-rc/sdk/include/ -I/usr/i586-mingw32msvc/include/SDL/

if [ -f mod_vlc-1.1.o ]; then
	i586-mingw32msvc-gcc mod_vlc-1.1.o -o mod_vlc.dll -L /usr/i586-mingw32msvc/lib/ -L /usr/i586-mingw32msvc/lib/bennugd/ -L/home/joseba/Programas/vlc-1.1.0-rc/ -shared -lvlc -lSDL -lSDLmain -lmod_video -lrender -lvideo -lblit -lgrbase -lbgdrtm -Wl,-soname -Wl,mod_vlc.dll
fi

if [ -f mod_vlc.dll ]; then
        i586-mingw32msvc-strip mod_vlc.dll
        rm mod_vlc-1.1.o
fi
