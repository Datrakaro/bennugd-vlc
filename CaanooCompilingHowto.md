# Introduction #

In order to compile mod\_vlc for Caanoo, you must first compile (lib)VLC ourselves.
VLC is a HUGE program which can do much more than we need, and building a full version of VLC for Caanoo would require a lot of dependencies that are not present in the Caanoo SDK, therefore, I present here the bare minimum configuration that creates a working libVLC for the console.
These instructions assume you're compiling VLC in Linux, and that you've uncompressed the SDK to "/opt".
Please, take into account that the Caanoo SDK we'll be using is the one found in the Downloads page of this site, as the one distributed by GPH bundles broken pkg-config files and they need a lot of parsing in order to get them to work. The provided SDK also adds [Theora](http://www.theora.org/) support, which is a good thing to have in an open source video suite. No other modifications have been made to the GPH SDK.

# Details #

Grab VLC 1.1.5 source code from the Downloads page in this site, and uncompress it somewhere. Now, assumming the folder with the GPH compiler is in your path (/opt/GPH\_SDK/tools/gcc-4.2.4-glibc-2.7-eabi/bin/ in this example) configure VLC with the following flags:

> NM="arm-gph-linux-gnueabi-nm" CC="arm-gph-linux-gnueabi-gcc" CXX="arm-gph-linux-gnueabi-g++" AR="arm-gph-linux-gnueabi-ar" STRIP="arm-gph-linux-gnueabi-strip" RANLIB="arm-gph-linux-gnueabi-ranlib" CFLAGS="--sysroot /opt/GPH\_SDK/tools/gcc-4.2.4-glibc-2.7-eabi/arm-gph-linux-gnueabi/sys-root/ -mcpu=arm926ej-s -mtune=arm926ej-s" LDFLAGS="--sysroot /opt/GPH\_SDK/tools/gcc-4.2.4-glibc-2.7-eabi/arm-gph-linux-gnueabi/sys-root/" PKG\_CONFIG="/opt/GPH\_SDK/tools/gcc-4.2.4-glibc-2.7-eabi/arm-gph-linux-gnueabi/sys-root/usr/bin/pkg-config" PKG\_CONFIG\_PATH=/opt/GPH\_SDK/tools/gcc-4.2.4-glibc-2.7-eabi/arm-gph-linux-gnueabi/sys-root/usr/lib/pkgconfig/ ./configure --target=arm-gph-linux-gnueabi --host=arm-gph-linux-gnueabi --build=i686 --enable-shared --disable-static --disable-nls --disable-mozilla --disable-a52 --disable-libgcrypt --disable-remoteosd --disable-httpd --disable-dc1394 --disable-dv --disable-jack --disable-mtp --disable-bonjour --disable-libcddb --disable-notify --disable-dvdnav --disable-telepathy --disable-upnp --disable-v4l2 --disable-libv4l2 --disable-telx --disable-xcb --disable-dca --disable-pulse --disable-libass --disable-speex --disable-twolame --disable-x264 --disable-schroedinger --disable-dirac --disable-skins2 --disable-taglib --disable-vcd --disable-flac --disable-libmpeg2 --disable-mod --disable-qt4 --disable-lua --disable-svg --disable-freetype --disable-udev --disable-atmo --disable-postproc --disable-caca --disable-shout --without-x --disable-glx --disable-qt4 --disable-skins2 --disable-x11 --disable-xvideo -disable-xosd --disable-xinerama --disable-dbus --disable-dbus-control --enable-run-as-root --disable-sdl --disable-opengl --disable-xcb --disable-freetype --disable-screen --prefix=_PREFIX_

Obviously, change the _PREFIX_ route to wherever you'll want the VLC binaries installed.
Then, do:
> make -j2 && make install
It'll take some time, and then you'll have a version of VLC with quite a few video codes installed inside.

---

(mod\_vlc build instructions missing)