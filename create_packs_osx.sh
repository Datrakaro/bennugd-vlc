#!/bin/sh

# OSX VLC dir
VLC_DIR="/Applications/VLC.app/Contents/MacOS"
VLC_VERSION=1.1.2
PACKS_DIR="/Users/joseba/Desktop/VLC_PACKS"
# Files shared by all the packs
COMMON_FILES="mod_vlc.dylib COPYING mod_vlc.prg"
# Base VLC files
BASE_DEPS="libvlccore.4.dylib libvlc.5.dylib libintl.8.dylib"
# VLC plugins required for all the modules
COMMON_DEPS="libauhal_plugin.dylib"
COMMON_DEPS="$COMMON_DEPS libaudio_format_plugin.dylib"
COMMON_DEPS="$COMMON_DEPS libbandlimited_resampler_plugin.dylib libfilesystem_plugin.dylib"
COMMON_DEPS="$COMMON_DEPS libfloat32_mixer_plugin.dylib libscaletempo_plugin.dylib"
COMMON_DEPS="$COMMON_DEPS libswscale_plugin.dylib libvmem_plugin.dylib"
COMMON_DEPS="$COMMON_DEPS libvout_wrapper_plugin.dylib"

# Create the MPEG4 pack
PACK="mpeg4"
MPEG4_DEPS="$COMMON_DEPS liba52_plugin.dylib liba52tofloat32_plugin.dylib"
MPEG4_DEPS="$MPEG4_DEPS libavi_plugin.dylib libblend_plugin.dylib"
MPEG4_DEPS="$MPEG4_DEPS libmpeg_audio_plugin.dylib libmpgatofixed32_plugin.dylib"
MPEG4_DEPS="$MPEG4_DEPS libstream_filter_record_plugin.dylib libx264_plugin.dylib"
MPEG4_DEPS="$MPEG4_DEPS libyuvp_plugin.dylib libavcodec_plugin.dylib libavformat_plugin.dylib"
MPEG4_DEPS="$MPEG4_DEPS libdemux_cdg_plugin.dylib  libdemuxdump_plugin.dylib"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    mkdir -p $PACKS_DIR/$PACK/vlc/
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/lib/$i $PACKS_DIR/$PACK
done
for i in $MPEG4_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
tar -cj $PACKS_DIR/$PACK > $PACKS_DIR/bennugd_vlc_OSX_$PACK-$VLC_VERSION.tar.bz2

# Create the dirac pack
PACK="dirac"
DIRAC_DEPS="$COMMON_DEPS libblend_plugin.dylib libmpeg_audio_plugin.dylib"
DIRAC_DEPS="$DIRAC_DEPS libmpgatofixed32_plugin.dylib libschroedinger_plugin.dylib"
DIRAC_DEPS="$DIRAC_DEPS libstream_filter_record_plugin.dylib libts_plugin.dylib"
DIRAC_DEPS="$DIRAC_DEPS libyuvp_plugin.dylib"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    mkdir -p $PACKS_DIR/$PACK/vlc/
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/lib/$i $PACKS_DIR/$PACK
done
for i in $DIRAC_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
tar -cj $PACKS_DIR/$PACK > $PACKS_DIR/bennugd_vlc_OSX_$PACK-$VLC_VERSION.tar.bz2

# Create the ogv (OGG+Theora+Vorbis) pack
PACK="ogv"
OGV_DEPS="$COMMON_DEPS libogg_plugin.dylib libtheora_plugin.dylib"
OGV_DEPS="$OGV_DEPS libvorbis_plugin.dylib libblend_plugin.dylib"
OGV_DEPS="$OGV_DEPS libstream_filter_record_plugin.dylib libyuvp_plugin.dylib"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    mkdir -p $PACKS_DIR/$PACK/vlc/
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/lib/$i $PACKS_DIR/$PACK
done
for i in $OGV_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
tar -cj $PACKS_DIR/$PACK > $PACKS_DIR/bennugd_vlc_OSX_$PACK-$VLC_VERSION.tar.bz2

# Create the webm (MKV+VP8+Vorbis) pack
PACK="webm"
WEBM_DEPS="$COMMON_DEPS libmkv_plugin.dylib libvorbis_plugin.dylib"
WEBM_DEPS="$WEBM_DEPS libavcodec_plugin.dylib"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    mkdir -p $PACKS_DIR/$PACK/vlc/
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/lib/$i $PACKS_DIR/$PACK
done
for i in $WEBM_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
tar -cj $PACKS_DIR/$PACK > $PACKS_DIR/bennugd_vlc_OSX_$PACK-$VLC_VERSION.tar.bz2

