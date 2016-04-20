This project hosts the BennuGD bindings for libVLC's libvlc\_media\_player so that the user can play any video format supported by libVLC right from their BennuGD code.

The project also serves as a repository so that you can download (win32 & MacOS X Intel) library packs for playing popular video formats in BennuGD.

In Linux/BSD, it should be enough with having a recent version of VLC installed through your system's package format (i.e. you don't need the packages).

You can go to the Downloads section of the web to get the supported packs.
The preferred formats are:

  * [WebM](http://www.webmproject.org/) videos. **3.6MiB** archived.
  * [Theora](http://www.theora.org/)+[Vorbis](http://xiph.org/vorbis/) videos. Click [here](http://www.v2v.cc/~j/ffmpeg2theora/) for a program that will convert your videos to this format. **1.4MiB** archived.

Both formats are high-quality and open-source formats that you can use, and are the recommended packs.
Other supported packs (less common or non-free) include:
  * [Dirac](http://diracvideo.org/) video. A high-quality free video codec developed by the BBC for internal use and used by them to broadcast the Beijing Olympics ([Wikipedia entry](http://en.wikipedia.org/wiki/Dirac_(codec))). **1.4MiB** archived.
  * MPEG4 video in AVI/FLV container. All those Divx, Xvid and even H.264 video when encapsulated in an AVI/FLV container. For the audio, it should be able to play MPEG audio (including MP3) and AC3 5.1 Surround formats. **3.6MiB** archived.

**If you need to support more than one video format**, just download the packs for the formats you need support for and merge their contents.

Find **sample videos** your can play with these packs in the Downloads section.