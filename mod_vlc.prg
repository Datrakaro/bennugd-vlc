import "mod_vlc"
import "mod_key"
import "mod_video"
import "mod_mouse"
import "mod_say"
import "mod_map"
import "mod_file"
import "mod_proc"
import "mod_timers"
import "mod_wm"

/* Player main window */
Process main()
Private
    string fname="";
    int time=0, delay=30, track=1;
    int resx=640, resy=480, vwidth=0, vheight=0;

Begin
    // Handle the command line
    if(argc != 2)
        say("Must be given file to play, quitting.");
        exit();
    end;

    // Try to find the file that the user wants us to play, or die
    fname = argv[1];
    if(! fexists(fname))
        say("Couldn't find "+fname+" to be played, quitting.");
        exit();
    end

    /* Start the graphics subsystem */
    get_desktop_size(&resx, &resy);
    set_mode(resx, resy, 16, MODE_FULLSCREEN);

    /* We'll load the video once to determine its correct size, then reload
       it at its correct size... */
    if(video_play(fname, resx, resy) == -1)
        say("Sorry, I couldn't play your video :(");
        exit();
    end;
    while(! video_is_playing()) // Wait for the video to actually start
        FRAME;
    end;

    /* We don't want it to play yet, we just need it to start to be able to
       query its properties.*/
    video_pause();

    /* Determine the real size for the video */
    while(vwidth <= 0 || vheight <= 0)
        vwidth  = video_get_width();
        vheight = video_get_height();
    end;

    say("Video is "+vwidth+"x"+vheight);

    /* Determine the size at which we'll display the vide */
    if(vwidth/resx <= vheight/resy)
        vheight = vheight*resx/vwidth;
        vwidth  = resx;
    else
        vwidth  = vwidth*resy/vheight;
        vheight = resy;
    end;

    video_stop();
    
    say("Will play @ "+vwidth+"x"+vheight);

    // Actually play the video at full size with correct aspect-ratio
    graph = video_play(fname, vwidth, vheight);
    x = resx/2; y = resy/2;
    while(! video_is_playing()) // Wait for the video to actually start
        FRAME;
    end;
    
    while(! key(_esc))
        if(timer[0] > time+delay)
            if(key(_space))
                video_pause();
                time = timer[0];
            end;
            if(key(_right))
                video_set_time(video_get_time()+100);
                time = timer[0];
            end;
            if(key(_left))
                video_set_time(video_get_time()-100);
                time = timer[0];
            end;
            if(key(_m))
                video_mute();
                time = timer[0];
            end;
            if(key(_up))
                video_set_volume(video_get_volume()+5);
                time = timer[0];
            end;
            if(key(_down))
                video_set_volume(video_get_volume()-5);
                time = timer[0];
            end;
            if(key(_enter))
                track = video_get_track()+1;
                if(track > video_get_tracks()-1)
                    track = 0;
                end;
                video_set_track(track);
                say("Audio track "+video_get_track()+" of "+video_get_tracks());
                say("            "+video_get_track_description());
                time = timer[0];
            end;
        end;
        FRAME;
    end;

    video_stop();
    while(! key(_q))
        // If you press space bar, we start over
        if(key(_space))
            main();
            return;
        end;
        FRAME;
    end;
    
    exit();
End;
