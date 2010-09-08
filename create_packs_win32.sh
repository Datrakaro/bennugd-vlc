#!/bin/sh

# Win32 VLC dir
VLC_DIR="/home/joseba/Programas/vlc-1.1.4"
PACKS_DIR="/home/joseba/Programas/VLC_PACKS"
# Files shared by all the packs
COMMON_FILES="mod_vlc.dll COPYING"
# Base VLC files
BASE_DEPS="libvlccore.dll libvlc.dll"
# VLC plugins required for all the modules
COMMON_DEPS="libaout_directx_plugin.dll"
COMMON_DEPS="$COMMON_DEPS libaudio_format_plugin.dll"
COMMON_DEPS="$COMMON_DEPS libbandlimited_resampler_plugin.dll libfilesystem_plugin.dll"
COMMON_DEPS="$COMMON_DEPS libfloat32_mixer_plugin.dll libscaletempo_plugin.dll"
COMMON_DEPS="$COMMON_DEPS libswscale_plugin.dll libvmem_plugin.dll"
COMMON_DEPS="$COMMON_DEPS libvout_wrapper_plugin.dll"

# Create the MPEG4 pack
PACK="mpeg4"
MPEG4_DEPS="$COMMON_DEPS liba52_plugin.dll liba52tofloat32_plugin.dll"
MPEG4_DEPS="$MPEG4_DEPS libavi_plugin.dll libblend_plugin.dll"
MPEG4_DEPS="$MPEG4_DEPS libmpeg_audio_plugin.dll libmpgatofixed32_plugin.dll"
MPEG4_DEPS="$MPEG4_DEPS libstream_filter_record_plugin.dll libx264_plugin.dll"
MPEG4_DEPS="$MPEG4_DEPS libyuvp_plugin.dll libavcodec_plugin.dll"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    echo mkdir -p $PACKS_DIR/$PACK/vlc
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/$i $PACKS_DIR/$PACK
done
for i in $MPEG4_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
7z a $PACKS_DIR/bennugd-module-vlc_$PACK.7z $PACKS_DIR/$PACK

# Create the dirac pack
PACK="dirac"
DIRAC_DEPS="$COMMON_DEPS libblend_plugin.dll libmpeg_audio_plugin.dll"
DIRAC_DEPS="$DIRAC_DEPS libmpgatofixed32_plugin.dll libschroedinger_plugin.dll"
DIRAC_DEPS="$DIRAC_DEPS libstream_filter_record_plugin.dll libts_plugin.dll"
DIRAC_DEPS="$DIRAC_DEPS libyuvp_plugin.dll"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    echo mkdir -p $PACKS_DIR/$PACK/vlc
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/$i $PACKS_DIR/$PACK
done
for i in $DIRAC_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
7z a $PACKS_DIR/bennugd-module-vlc_$PACK.7z $PACKS_DIR/$PACK

# Create the ogv (OGG+Theora+Vorbis) pack
PACK="ogv"
OGV_DEPS="$COMMON_DEPS libogg_plugin.dll libtheora_plugin.dll"
OGV_DEPS="$OGV_DEPS libvorbis_plugin.dll libblend_plugin.dll"
OGV_DEPS="$OGV_DEPS libstream_filter_record_plugin.dll libyuvp_plugin.dll"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    echo mkdir -p $PACKS_DIR/$PACK/vlc
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/$i $PACKS_DIR/$PACK
done
for i in $OGV_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
7z a $PACKS_DIR/bennugd-module-vlc_$PACK.7z $PACKS_DIR/$PACK

# Create the webm (MKV+VP8+Vorbis) pack
PACK="webm"
WEBM_DEPS="$COMMON_DEPS libmkv_plugin.dll libvorbis_plugin.dll"
WEBM_DEPS="$WEBM_DEPS libavcodec_plugin.dll"

if [ ! -d $PACKS_DIR/$PACK/vlc ]; then
    echo mkdir -p $PACKS_DIR/$PACK/vlc
    echo "Created nonexistant $PACKS_DIR/$PACK"
fi

cp $COMMON_FILES $PACKS_DIR/$PACK
for i in $BASE_DEPS; do
    cp $VLC_DIR/$i $PACKS_DIR/$PACK
done
for i in $WEBM_DEPS; do
    cp $VLC_DIR/plugins/$i $PACKS_DIR/$PACK/vlc
done

# Compress the files
7z a $PACKS_DIR/bennugd-module-vlc_$PACK.7z $PACKS_DIR/$PACK

