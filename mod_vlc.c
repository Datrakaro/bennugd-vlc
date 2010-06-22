/* libVLC module for BennuGD
 * Heavily based on the libVLC+libSDL example by Sam Hocevar <sam@zoy.org>
 * Copyright © 2010 Joseba García Etxebarria <joseba.gar@gmail.com>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <stdlib.h>

#include <SDL.h>
#include <vlc/vlc.h>

/* BennuGD stuff */
#include <bgddl.h>
#include <xstrings.h>
#include <libgrbase.h>
#include <g_video.h>
 
struct ctx
{
    SDL_Surface *surf;
};
 
static char clock[64], cunlock[64], cdata[64];
static char width[32], height[32], pitch[32];
static libvlc_exception_t ex;
static libvlc_instance_t *libvlc;
static libvlc_media_t *m;
static libvlc_media_player_t *mp=NULL;
static struct ctx video;
static int playing_video=0;
static char const *vlc_argv[] =
{
    "-q",
//    "-vvvvv",
    "--ignore-config", /* Don't use VLC's config files */
    "--no-video-title-show",
    "--sub-autodetect-file",
    "--vout", "vmem",
    "--plugin-path", "vlc", /* For win32 */
    "--vmem-width", width,
    "--vmem-height", height,
    "--vmem-pitch", pitch,
    "--vmem-chroma", "RV16",
    "--vmem-lock", clock,
    "--vmem-unlock", cunlock,
    "--vmem-data", cdata,
};
static int vlc_argc = sizeof(vlc_argv) / sizeof(*vlc_argv);
static GRAPH *gr=NULL;
 
static void catch (libvlc_exception_t *ex)
{
    if(libvlc_exception_raised(ex))
    {
        fprintf(stderr, "Exception: %s\n", libvlc_exception_get_message(ex));
        exit(1);
    }
 
    libvlc_exception_clear(ex);
}
 
#ifdef VLC09X
static void * lock(struct ctx *ctx)
{
    SDL_LockSurface(ctx->surf);
    return ctx->surf->pixels;
}
#else
static void lock(struct ctx *ctx, void **pp_ret)
{
    SDL_LockSurface(ctx->surf);
    *pp_ret = ctx->surf->pixels;
}
#endif
 
static void unlock(struct ctx *ctx)
{
    SDL_UnlockSurface(ctx->surf);
}

/* Mark the graphic as dirty */
static void graph_update()
{
    if(playing_video && gr != NULL && gr->code != -1) {
        gr->modified = 1;
        gr->info_flags &=~GI_CLEAN;
    }
}

/* Checks wether the current video is being played */
static int video_is_playing() {
    if(mp) {
        return libvlc_media_player_is_playing(mp, NULL);
    } else {
        return 0;
    }
}

/*********************************************/
/* Plays the given video with libVLC         */
/* Must be given:                            */
/*    filename to be played                  */
/*    width  of the video to render          */
/*    height of the video to render          */
/*********************************************/
static int video_play(INSTANCE *my, int * params)
{
    /* Ensure we're not playing a video already */
    if(playing_video == 1)
        return -1;

    /* Start the graphics mode, if not initialized yet */
	if(! scr_initialized) gr_init(320, 240);
	
    /* Lock the video playback */
    playing_video = 1;
 
    /* Create the 16bpp surface that will hold the video          */
    /* We don't yet support 32bpp surfaces, but this'll work fine */
    /* in bennugd's 32bpp video mode.                             */
    video.surf = SDL_CreateRGBSurface(SDL_SWSURFACE, params[1],
            params[2], 16, (((Uint32)0xff) >> 3) << 11,
            (((Uint32)0xff) >> 2) << 5, ((Uint32)0xff) >> 3, 0);
 
    sprintf(clock, "%lld", (long long int)(intptr_t)lock);
    sprintf(cunlock, "%lld", (long long int)(intptr_t)unlock);
    sprintf(cdata, "%lld", (long long int)(intptr_t)&video);
    sprintf(width, "%i", params[1]);
    sprintf(height, "%i", params[2]);
    sprintf(pitch, "%i", params[1] * 2);

    /* This could really be done earlier, but we need to know the      */
    /* video width/height before doing it and we'd have to use default */
    /* values for them.                                                */
    libvlc_exception_init(&ex);
    libvlc = libvlc_new(vlc_argc, vlc_argv, &ex);
    catch(&ex);

    /* The name of the file to play */ 
    m = libvlc_media_new(libvlc, string_get(params[0]), &ex);
    catch(&ex);
    mp = libvlc_media_player_new_from_media(m, &ex);
    catch(&ex);
    libvlc_media_release(m);
    libvlc_media_player_play(mp, &ex);
    catch(&ex);

    /* Discard the file path, as we don't need it */
    string_discard(params[0]);
 
    // Create the graphic that will hold the video surface data
    gr = bitmap_new_ex(0, video.surf->w, video.surf->h,
        video.surf->format->BitsPerPixel, video.surf->pixels,
        video.surf->pitch);
    gr->code = bitmap_next_code();
    grlib_add_map(0, gr);
    
    return gr->code;
}

/* Stop the currently being played video and release libVLC */
static int video_stop(INSTANCE *my, int * params)
{
    if(! playing_video)
        return 0;

    /* Stop the playback and release the media */
    if(mp) {
        if(video_is_playing()) {
            libvlc_media_player_stop(mp, &ex);
            catch(&ex);
        }

        libvlc_media_player_release(mp);
        mp = NULL;
    }

    libvlc_release(libvlc);

    /* Unload the graph & free the SDL_Surface */
    grlib_unload_map(0, gr->code);
    SDL_FreeSurface(video.surf);

    /* Release the video playback lock */
    playing_video = 0;        

    return 0;
}

/* Pause the currently playing video */
static int video_pause() {
    if(!mp)
        return -1;

    if(video_is_playing()) {
        libvlc_media_player_pause(mp, &ex);
        catch(&ex);
    }

    return 0;
}


/* Returns the length of the film in centisecs   
 * BennuGD uses centisecs by default, instead of
 * in miliseconds, as libVLC does, so we must correct
 * the returned value.                                */
static int video_get_length() {
    libvlc_time_t length;   // Length is a 64 bit integer
    if(mp) {
        length = libvlc_media_player_get_length(mp, &ex)/10;
        catch(&ex);
        return (int) length;
    } else {
        return -1;
    }
}

/* Returns the current of the film in centisecs   
 * BennuGD uses centisecs by default, instead of
 * in miliseconds, as libVLC does, so we must correct
 * the returned value.                                */
static int video_get_time() {
    if(mp) {
        libvlc_time_t time;   // Time is a 64 bit integer
        time = libvlc_media_player_get_time(mp, &ex)/10;
        catch(&ex);
        return (int) time;
    } else {
        return -1;
    }
}

/* Seek through the video
 * BennuGD uses centisecs by default, instead of
 * in miliseconds, as libVLC does, so we must correct
 * the returned value.                                */
static int video_set_time(INSTANCE *my, int *params) {
    if(mp) {
        libvlc_time_t time;   // Time is a 64 bit integer
        time = (libvlc_time_t)(10*params[0]);

        libvlc_media_player_set_time(mp, time, &ex);
        catch(&ex);
        return 0;
    } else {
        return -1;
    }
}

/* Get the width of the currently being played video */
static int video_get_width() {
    if(mp) {
        int width=libvlc_video_get_width(mp, &ex);
        catch(&ex);

        return width;
    } else {
        return 0;
    }
}

/* Get the height of the currently being played video */
static int video_get_height() {
    if(mp) {
        int height=libvlc_video_get_height(mp, &ex);
        catch(&ex);

        return height;
    } else {
        return 0;
    }
}

/* Get the current muted/unmuted status */
static int video_get_mute() {
    if(mp) {
        int mute=libvlc_audio_get_mute(libvlc, &ex);
        catch(&ex);

        return mute;
    } else {
        return 1;
    }
}

/* Toggle the muted/unmuted status */
static int video_mute() {
    if(mp) {
        libvlc_audio_toggle_mute(libvlc, &ex);
        catch(&ex);

        return 0;
    } else {
        return 1;
    }
}

/* Get the current audio level */
static int video_get_volume() {
    if(mp) {
        int volume=2;

        volume = libvlc_audio_get_volume(libvlc, &ex);
        catch(&ex);

        return volume;
    } else {
        return 0;
    }
}

/* Set the current audio level */
static int video_set_volume(INSTANCE *my, int *params) {
    int volume=params[0];

    /* Volume must be something between 0 and 200 */
    if(volume < 0)
        volume = 0;

    if(volume > 200)
        volume = 200;

    if(mp) {
        libvlc_audio_set_volume(libvlc, volume, &ex);
        catch(&ex);

    }

    return 0;
}

/* Get the number of available tracks */
static int video_get_tracks() {
    int n=0;

    if(mp) {
        n=libvlc_audio_get_track_count(mp, &ex);
        catch(&ex);
    }

    return n;
}

/* Get the number of the currently playing audio track */
static int video_get_track() {
    int track=0;

    if(mp) {
        track = libvlc_audio_get_track(mp, &ex);
        catch(&ex);
    }

    return track;
}

/* Set the audio track */
static int video_set_track(INSTANCE *my, int * params) {
    int track=params[0];
    int numtracks=video_get_tracks();

    if(track > numtracks-1)
        track = numtracks-1;
    if(track < 0)
        track = 0;

    if(mp) {
        libvlc_audio_set_track(mp, track, &ex);
        catch(&ex);
    }

    return 0;
}

/* Get the track description for a given track */
static int video_get_track_description(INSTANCE *my, int * params) {
    int t_descr=0;

    if(mp) {
        libvlc_track_description_t *description;

        description = libvlc_audio_get_track_description(mp, &ex);
        t_descr = string_new(description->psz_name);
        string_use(t_descr);
        libvlc_track_description_release(description);
    }

    return t_descr;
}

DLSYSFUNCS __bgdexport( mod_vlc, functions_exports )[] =
{
	{"VIDEO_PLAY"                  , "SII"  , TYPE_DWORD , video_play       },
	{"VIDEO_STOP"                  , ""     , TYPE_DWORD , video_stop       },
    {"VIDEO_PAUSE"                 , ""     , TYPE_DWORD , video_pause      },
	{"VIDEO_IS_PLAYING"            , ""     , TYPE_DWORD , video_is_playing },
    {"VIDEO_GET_LENGTH"            , ""     , TYPE_DWORD , video_get_length },
    {"VIDEO_GET_TIME"              , ""     , TYPE_DWORD , video_get_time   },
    {"VIDEO_SET_TIME"              , "I"    , TYPE_DWORD , video_set_time   },
    {"VIDEO_GET_WIDTH"             , ""     , TYPE_DWORD , video_get_width  },
    {"VIDEO_GET_HEIGHT"            , ""     , TYPE_DWORD , video_get_height },
    {"VIDEO_GET_MUTE"              , ""     , TYPE_DWORD , video_get_mute   },
    {"VIDEO_MUTE"                  , ""     , TYPE_DWORD , video_mute       },
    {"VIDEO_GET_VOLUME"            , ""     , TYPE_DWORD , video_get_volume },
    {"VIDEO_SET_VOLUME"            , "I"    , TYPE_DWORD , video_set_volume },
    {"VIDEO_GET_TRACKS"            , ""     , TYPE_DWORD , video_get_tracks },
    {"VIDEO_GET_TRACK"             , ""     , TYPE_DWORD , video_get_track  },
    {"VIDEO_SET_TRACK"             , "I"    , TYPE_DWORD , video_set_track  },
    {"VIDEO_GET_TRACK_DESCRIPTION" , ""     , TYPE_STRING, video_get_track_description  },
	{ NULL        , NULL , 0         , NULL              }
};

/* Bigest priority first execute
   Lowest priority last execute */

HOOK __bgdexport( mod_vlc, handler_hooks )[] =
{
    { 4700, graph_update    },
    {    0, NULL            }
} ;
 
char * __bgdexport( mod_vlc, modules_dependency )[] =
{
	"libgrbase",
	"libvideo",
	NULL
};
 
void __bgdexport( mod_vlc, module_finalize )()
{
    video_stop(NULL, NULL);
}