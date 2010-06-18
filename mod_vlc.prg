import "mod_key"
import "mod_vlc"
import "mod_video"
import "mod_mouse"
import "mod_say"
import "mod_map"
import "mod_file"
import "mod_proc"
import "mod_timers"

#define SCR_WIDTH  640
#define SCR_HEIGHT 480

/* Player main window */
Process main()
Private
    string fname="";
    int time=0, delay=30, track=1;

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
    set_mode(SCR_WIDTH, SCR_HEIGHT, 16);

    /* Finally play the video and place it in the middle of the screen */
    graph = video_play(fname, SCR_WIDTH, SCR_HEIGHT);
    x = SCR_WIDTH/2; y = SCR_HEIGHT/2;
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
End;
