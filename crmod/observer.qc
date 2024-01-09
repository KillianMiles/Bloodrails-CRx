//
// Observer.qc
//
// Contains code for handling observers.
//
// Written by J.P. Grossman, modified by bucksh0t.
//
// Fields used:
//
// .wait            - time to look for teleports when observing
// .trigger_field   - closest teleport entity; used when observing
// .t_width         - activation radius for closest teleport
// .dest            - stores destination for popping forward
// .dest1           - stores velocity for popping forward
// .movetarget      - player being watched in observer mode (world if none)
// .crmod_othertarget     - player to focus on during tourney cam // CRMOD
// .delay           - time to refresh head's up display for observing
// .speed           - z component of velocity from previous frame (for fly)
// .lip             - time to clear display when no target is in line of sight (walk/fly)
//

// function declarations
entity (entity e) observer_find_target;
entity (entity e) observer_find_camera;			// CRMOD
void () observer_set_camera_position;			// CRMOD
void () observer_set_chase_position;
void () observer_set_demo_position;
void (entity client) observer_disconnect_notify;
void () observer_heads_up;
void () SetNewParms2;
void () respawn;
void () PutClientInServer;
void () observer_get_target;
void () WaterMove;
//void () AirControl;
void () CheckWaterJump;
void (entity player) match_disconnect_notify;
void () match_ready;
void () match_notready;

//
//  F I N D  T E L E P O R T
//
//  Find the closest teleport and remember it.  Called once every second.
//
void () observer_find_teleport =
{
    local entity e;
    local float d, mindist;
    //local string temp;
    //local vector vtemp;

    // find the closest teleport
    mindist = 99999999;
    e = self.trigger_field = find(world, classname, "trigger_teleport");
    while (e)
    {
        d = vlen(self.origin - (e.mins + e.maxs) * 0.5);
        if (d < mindist)
        {
            mindist = d;
            self.trigger_field = e;
        }
        e = find(e, classname, "trigger_teleport");
    }
    e = self.trigger_field;

    // compute an 'activation raius'
    if (e)
        self.t_width = utils_min3(e.size_x, e.size_y, e.size_z) * 0.7;
};

//
//  S P A W N  T F O G
//
void (vector pos) observer_spawn_tfog =
{
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_TEMPENTITY);
    WriteByte(MSG_ONE, TE_TELEPORT);
    WriteCoord(MSG_ONE, pos_x);
    WriteCoord(MSG_ONE, pos_y);
    WriteCoord(MSG_ONE, pos_z);
};

//
//  C H E C K  T E L E P O R T
//
//  Check to see if on observer hit the closest teleport.
//
void () observer_check_teleport =
{
    local entity t;
    local vector d;

    t = self.trigger_field;
    if (!t)
        return;

    // Only check if the observer is not completely above/below the teleport
    if (self.absmin_z < t.absmax_z && self.absmax_z > t.absmin_z)
    {
        d = self.origin - (t.absmin + t.absmax) * 0.5;
        d_z = 0;
        if (vlen(d) < 24 + self.t_width)
        {
            // find the destination
            t = find(world, targetname, t.target);
            if (!t)
                return;

            // spawn a tfog flash for the observer only
            makevectors(t.mangle);
            observer_spawn_tfog(t.origin + 32 * v_forward);

            // move the observer
            setorigin(self, t.origin);
            self.angles = t.mangle;
            self.fixangle = 1;
            self.velocity = v_forward * 300;
            if (self.oflags & OBSERVER_WALK)
                self.flags = self.flags - self.flags & FL_ONGROUND;
        }
    }
};

//
//  C L E A R  F L A G S
//
void () observer_clear_flags =
{
	if(self.oflags & OBSERVER_ACTIONCAM) 
	{
			self.oflags = self.oflags - OBSERVER_ACTIONCAM;
			//Exit_HorrorScope();
			//bprint("exit\n");
			//self.impulse = 0;
	}
    
    self.oflags = self.oflags - self.oflags & (OBSERVER_WALK | OBSERVER_FLY | OBSERVER_CHASE | OBSERVER_DEMO | OBSERVER_CAMERA | OBSERVER_AUTO);
    self.crmod_othertarget = world;  // CRMOD
};

//
//  C H E C K  D E M O  E N D
//
//  If we're coming out of demo mode, we need to do a bit of cleaning up.
//  The reason for the model junk is that, for some reason, setting
//  the model to string_null (done in observer_demo_start) causes the
//  player to be unable to move.  The hack-fix is to set the model to
//  something real (null.mdl) which allows the player to move, and then
//  immediately assign string_null to self.model so that nobody sees the
//  player.  I don't know enough about quake to understand why it's
//  okay to assign string_null to self.model but not to call setmodel
//  with string_null; all I know is that this works.
//
void () observer_check_demo_end =
{
    if (self.oflags & OBSERVER_DEMO)
    {
        setmodel (self, "progs/null.mdl");
        self.model = string_null;
        msg_entity = self;
        WriteByte(MSG_ONE, SVC_SETVIEWPORT);
        WriteEntity(MSG_ONE, self);
    }
};

//
//  W A L K  S T A R T
//
void () observer_walk_start =
{
    observer_check_demo_end();
    observer_clear_flags();
    self.oflags = self.oflags | OBSERVER_WALK;
    self.movetype = MOVETYPE_WALK;
    self.flags = self.flags - self.flags & FL_ONGROUND;
    self.view_ofs = '0 0 22';
	//sprint(self, "disabling 'smooth' mode\n");
    stuffcmd(self, "cl_nolerp 0\n");
    stuffcmd(self, "cl_predict 1\n");
    stuffcmd(self, "v_centerspeed 500\n");
    self.alpha = 0.001;  //9-17-23  observer transparent

};



//
//  F L Y  S T A R T
//
void () observer_fly_start =
{
    observer_check_demo_end();
    observer_clear_flags();
    self.oflags = self.oflags | OBSERVER_FLY;
    stuffcmd(self, "viewsize 130\n");
    self.movetype = MOVETYPE_FLY;
    self.view_ofs = '0 0 22';
    self.flags = self.flags | FL_ONGROUND;
	self.waterlevel = 0;
	//sprint(self, "disabling 'smooth' mode\n");
    stuffcmd(self, "cl_nolerp 0\n");
    stuffcmd(self, "cl_predict 1\n");
    stuffcmd(self, "v_centerspeed 500\n");
    sprint(self, "fly mode - help-fly for help\n");
    self.alpha = 0.001;  //9-17-23  observer transparent
    
    if(self.style & ELOHIM_OBSERVER) self.style = self.style | ELOHIM_OBSERVER;
};

//
//  T O G G L E  T O U R N E Y
//		by Paul Baker
//
void () observer_toggle_tourney =
{
	// CRMOD FIX ME - add more things here so find enemy can run faster later
	utils_toggle_oflag(OBSERVER_TOURNEY, "Tournament chasecam mode");
};

// CRMOD
// C A M E R A  S T A R T
//   by Paul Baker
//
//   Starts up Camera Mode

void () observer_camera_start =
{
	local entity camera;
    if (!self.movetarget)
    {
        // see if we can find a camera
        self.movetarget = observer_find_camera(world);
        if (!self.movetarget)
        {
            sprint(self, "no cameras found\n");
            observer_fly_start();
            return;
        }
        self.delay = 0;
    }
    else if (self.movetarget.classname != "elohim_camera")
    {
    	// see if we can find a camera
        self.movetarget = observer_find_camera(world);
        if (!self.movetarget)
        {
            sprint(self, "no cameras found\n");
            observer_fly_start();
            return;
        }
        self.delay = 0;
    }
   
    observer_check_demo_end();
    observer_clear_flags();
    self.oflags = self.oflags | OBSERVER_CAMERA;
    self.movetype = MOVETYPE_NONE;
    self.view_ofs = '0 0 0';
    camera = self.movetarget;
	setorigin(self, camera.origin);
	local vector angle;
	if (camera.movetarget != world)
		angle = angles_bestaim(camera.origin, camera.movetarget.origin);
	else
		angle = camera.angles;
	angles_fixangle(angle);
    observer_set_camera_position();
    stuffcmd(self, "v_centerspeed 0\n");
    sprint(self, "camera mode - help-camera for help\n");
    if (self.oflags & OBSERVER_GO_AUTO)				// CRMOD
    {												// CRMOD
    	sprint(self,"Automatic Cameras Enabled.\n");	// CRMOD
    	self.oflags = self.oflags - OBSERVER_GO_AUTO;	// CRMOD
    	self.oflags = self.oflags | OBSERVER_AUTO;	// CRMOD
    }												// CRMOD
    else																// CRMOD
    	sprint(self,"type 'autocam' for automatic camera switching\n");	// CRMOD
    
   // if (!(self.style & ELOHIM_HEADS_UP))
        //sprint(self, "type 'headsup' for fullscreen display\n");
	sprint(self, "type 'smooth' to eliminate choppines\n");
};


//
//  C H A S E  S T A R T
//
void () observer_chase_start =
{
    if (!self.movetarget || self.movetarget.classname != "player")
    {
        // see if we can find a target to chase
        self.movetarget = observer_find_target(world);
        if (!self.movetarget)
        {
            sprint(self, "no chase target found\n");
            observer_fly_start();
            return;
        }
        self.delay = 0;
    }
    observer_check_demo_end();
    observer_clear_flags();
    self.oflags = self.oflags | OBSERVER_CHASE;
    self.movetype = MOVETYPE_FLY;
    self.view_ofs = '0 0 0';
    observer_set_chase_position();
    stuffcmd(self, "v_centerspeed 0\n");
    sprint(self, "chase mode - help-chase for help\n");

	// CRMOD - auto, tourney
    if (self.oflags & OBSERVER_GO_AUTO)
    {
    	sprint(self,"Automatic Chasecam Enabled.\n");
    	self.oflags = self.oflags - OBSERVER_GO_AUTO;
    	self.oflags = self.oflags | OBSERVER_AUTO;
    }
    else
    	sprint(self,"type 'autochase' for automatic chase switching\n");
    if (self.oflags & OBSERVER_TOURNEY)
    	sprint(self,"Tournament Mode Enabled.\n");
	// END_CRMOD
    
    //if (!(self.style & ELOHIM_HEADS_UP))
        //sprint(self, "type 'headsup' for fullscreen display\n");
	//sprint(self, "enabling 'smooth' mode to eliminate choppines\n");
    stuffcmd(self, "cl_nolerp 1\n");
    stuffcmd(self, "cl_predict 0\n");
};

//
//  D E M O  S T A R T
//
//  Not only do we have to set the viewport to the chase target for demo
//  mode to work, but we also have to call setmodel on self.. for some
//  reason the client will draw a player model where 'self' is when the
//  viewport is changed!  The effect is that you seem to be standing
//  inside yourself - even though no-one else can see you.  The fix is
//  the setmodel call.. but this can cause a problem later on when we
//  want to change back to walk mode (see comment before
//  observer_check_demo_end, above).
//
void () observer_demo_start =
{
    if (!self.movetarget || self.movetarget.classname != "player")
    {
        // see if we can find a target to chase
        self.movetarget = observer_find_target(world);
        if (!self.movetarget)
        {
            sprint(self, "no chase target found\n");
            observer_fly_start();
            return;
        }
        self.delay = 0;
    }
    observer_clear_flags();
    self.oflags = self.oflags | OBSERVER_DEMO;
    self.movetype = MOVETYPE_FLY;
    self.view_ofs = '0 0 22';
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SETVIEWPORT);
    WriteEntity(MSG_ONE, self.movetarget);
    setmodel(self, string_null);
    observer_set_demo_position();
    stuffcmd(self, "v_centerspeed 0\n");
    sprint(self, "eyecam mode - help-chase for help\n");
  //  if (!(self.style & ELOHIM_HEADS_UP))
      //  sprint(self, "type 'headsup' for fullscreen display\n");
	sprint(self, "type 'smooth' to eliminate choppines\n");

	self.nextthink = -1;
    self.think = SUB_Null;
};

//
//  S T A R T
//
//  Enter observer mode.
//
void () observer_start =
{
    //local float go_auto;
    
      //if (!(self.player_flag & PF_HUD)) self.player_flag = self.player_flag | PF_HUD;
      
	if (self.cam)
	{
			Exit_HorrorScope();
	}			
    
    self.crmod_chase_score = ELOHIM_NEGINF;  // CRMOD make sure they don't have some high rating that can't be beat by the other players

    if (mode_is_public())
    {
        //TODO: update Team count here?

        if(self.items & (IT_KEY1 | IT_KEY2))
            ctf_player_drop_flag(self, 0);

        self.player_flag = self.player_flag - (self.player_flag & PF_FIRST_SPAWN);
        self.player_flag = self.player_flag - (self.player_flag & PF_MIDGAME_JOIN);    
        self.style = self.style - (self.style & ELOHIM_READY);
        self.player_flag = self.player_flag - (self.player_flag & PF_TEAM_BLUE);
        self.player_flag = self.player_flag - (self.player_flag & PF_TEAM_RED);
        self.height = 0;
    }

    self.style = self.style | ELOHIM_OBSERVER;

    rune_drop();
    UnHookPlayer ();

   
        // If the player is dead, then call respawn to reset a bunch of stuff and
        // give him a new position.
        if (self.deadflag != DEAD_NO)
        {
            if (self.deadflag >= DEAD_DEAD)
            {
                dprint("Observer dead\n");
                if (elohim_playmode & CLAN_ARENA_MODE)
                {
                    PutClientInServer();
                    return;
                }
                else
                {
                    respawn();
                }
            }
            return; 
        }
    

    self.takedamage = DAMAGE_NO;
    self.solid = SOLID_NOT;

    // get rid of powerups
    self.radsuit_finished = 0;
    self.invisible_finished = 0;
    self.invincible_finished = 0;
    self.super_damage_finished = 0;
    self.rad_time = 0;
    self.invisible_time = 0;
    self.invincible_time = 0;
    self.super_time = 0;
    self.effects = 0;

    // status bar stuff
    self.health = 666;
    self.items = 0;
    self.armorvalue = 0;
    self.ammo_shells = 0;
    self.ammo_nails = 0;
    self.ammo_rockets = 0;
    self.ammo_cells = 0;
    self.currentammo = 0;
    if (!(mode_is_arena()))
        self.frags = -99;
    //self.team = 0;
    self.show_hostile = 0;

    // model and view offset
    self.model = string_null;
    self.weaponmodel = string_null;
    setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
    self.view_ofs = '0 0 22';
    self.nextthink = -1;    // thinking is used to animate client models
    self.think = SUB_Null;

    // teleport stuff
    observer_find_teleport();
    self.wait = time + 1;

    // update display immediately
    self.delay = 0;

	// reset display hold time
	self.lip = 0;

    setcolor2(self, 0, 0);
    self.alpha = 0.001;  //9-17-23  observer transparent

    if (self.oflags & OBSERVER_FLY)
        observer_fly_start();
    else if (self.oflags & OBSERVER_CHASE)
	{
		if (self.oflags & OBSERVER_AUTO)
			self.oflags = self.oflags | OBSERVER_GO_AUTO;
        observer_chase_start();
	}
    else if (self.oflags & OBSERVER_DEMO)
	{
		// This is necessary to prevent the other player's model from being 
		// drawn.  Don't fucking ask me why!!!
		self.nextthink = time + 0.1;
		self.think = observer_demo_start;
	}
    else if (self.oflags & OBSERVER_CAMERA)
	{
		if (self.oflags & OBSERVER_AUTO)
			self.oflags = self.oflags | OBSERVER_GO_AUTO;
    	observer_camera_start();
	}
    else
        observer_fly_start();

    if (self.style & ELOHIM_HEADS_UP)
        stuffcmd(self, "viewsize 120\n");

    // Check to see if anyone was observing this client
    observer_disconnect_notify(self);

    // Notify the match module that this player has become an observer
    if (elohim_playmode & ELOHIM_MATCH_MODE)
        match_disconnect_notify(self);
};

//
//  O B S E R V E R  E N D
//
//  Return to normal player mode.
//
void () observer_end =
{
    //local string tmp = "";
   // Exit_HorrorScope();
    
    stuffcmd(self, "viewsize 110\n");
    
    self.style = self.style - (self.style & ELOHIM_OBSERVER);
    if (self.player_flag & PF_HUD) self.player_flag = self.player_flag - PF_HUD;


        self.frags = 0;
        self.dmg_tally = 0;

    observer_check_demo_end();
	//sprint(self, "disabling 'smooth' mode\n");
    stuffcmd(self, "cl_nolerp 0\n");
    stuffcmd(self, "cl_predict 1\n");
    stuffcmd(self, "v_centerspeed 500\n");
    if (self.style & ELOHIM_HEADS_UP)
	    stuffcmd(self, "viewsize 100\n");
    if (!(elohim_playmode & ELOHIM_MATCH_MODE) && !(mode_is_public()) && !(mode_is_arena()))
        centerprint(self, "Observer mode off");

	// This is to prevent a condition where one player is another player's
	// movetarget, which can confuse the auto module.
	self.movetarget = world;	

    stats_reset();
    SetNewParms2();


    PutClientInServer();
};

//
//  P O P  F O R W A R D
//
//  Move forward 100 units if possible.
//
void () observer_pop_forward =
{
    local vector newpos;

    makevectors(self.angles);
    newpos = v_forward;
    newpos_z = 0;
    newpos = newpos * (100 / vlen(newpos));
    newpos = newpos + self.origin;
    if (pointcontents(newpos) != CONTENT_SOLID)
        setorigin(self, newpos);
};

//
//  P O P  D O W N
//
//  Move down 100 units if possible.
//
void () observer_pop_down =
{
    local vector newpos;

    newpos = self.origin + '0 0 -100';
    if (pointcontents(newpos) != CONTENT_SOLID)
        setorigin(self, newpos);
};

//
//  P O P  U P
//
//  Move up 100 units if it is possible to do so.
//
void () observer_pop_up =
{
    local vector newpos;

    newpos = self.origin + '0 0 100';
    if (pointcontents(newpos) != CONTENT_SOLID)
        setorigin(self, newpos);
};

// CRMOD
//  F I N D  C A M E R A
//    by Paul Baker
//
//  Returns the next camera after the given entity.
//
entity (entity e) observer_find_camera =
{
    local entity targ;

    targ = find(e, classname, "elohim_camera");
    if (targ == world)
    	targ = find(targ, classname, "elohim_camera");
    return targ;
};

// CRMOD
//  N E X T  C A M E R A
//    by Paul Baker
//
//  Get next camera to watch from.
//
void () observer_next_camera =
{
	local entity camera;
	local vector angle;
	self.movetarget = camera = observer_find_camera(self.movetarget);
	setorigin(self, camera.origin);
	if (camera.movetarget != world)
		angle = angles_bestaim(camera.origin, camera.movetarget.origin);
	else
		angle = camera.angles;
	angles_fixangle(angle);
	self.delay = 0;
};

// CRMOD
//  P R E V  C A M E R A
//    by Paul Baker
//    
//  Get previous camera to watch from.
//
void () observer_prev_camera =
{
	local entity e, curr, camera;
	local vector angle;
	
	curr = self.movetarget;
	e = observer_find_camera(curr);
	
	while (e != curr)
	{
		self.movetarget = e;
		e = observer_find_camera(e);
	}
	camera = self.movetarget;
	setorigin(self, camera.origin);
	if (camera.movetarget != world)
		angle = angles_bestaim(camera.origin, camera.movetarget.origin);
	else
		angle = camera.angles;
	angles_fixangle(angle);
	self.delay = 0;
};

//
//  F I N D  T A R G E T
//
//  Returns the next watch target after the given entity.
//
entity (entity e) observer_find_target =
{
    local entity targ;

    if ((e.classname != "player") || (e.style & ELOHIM_OBSERVER) ||
        !(e.style & ELOHIM_CONNECTED))
    {
        e = world;
    }
    targ = find(e, classname, "player");
    while (targ != e && (!targ || (targ.style & ELOHIM_OBSERVER) ||
                         !(targ.style & ELOHIM_CONNECTED)))
    {
        targ = find(targ, classname, "player");
    }
    return targ;
};

//
//  N E X T  T A R G E T
//
//  Get the next target to watch.
//
void () observer_next_target =
{
    self.movetarget = observer_find_target(self.movetarget);

    // Force an immediate update of the heads-up display
    self.delay = 0;
    
    if ((self.oflags & OBSERVER_DEMO) && (self.movetarget != world))
	{
		msg_entity = self;
		WriteByte(MSG_ONE, SVC_SETVIEWPORT);
		WriteEntity(MSG_ONE, self.movetarget);
		observer_set_demo_position();
	}
};

//
//  P R E V  T A R G E T
//
//  Get the previous target to watch.
//
void () observer_prev_target =
{
    local entity e, curr;

    if (!self.movetarget)
    {
        observer_next_target();
        return;
    }

    curr = self.movetarget;
    if (curr.style & ELOHIM_OBSERVER || curr.classname != "player" ||
        !(curr.style & ELOHIM_CONNECTED))
    {
        self.movetarget = curr = observer_find_target(curr);
    }
    e = observer_find_target(curr);
    while (e != curr)
    {
        self.movetarget = e;
        e = observer_find_target(e);
    }

    // Force an immediate update of the heads-up display
    self.delay = 0;

    if ((self.oflags & OBSERVER_DEMO) && (self.movetarget != world))
	{
		msg_entity = self;
		WriteByte(MSG_ONE, SVC_SETVIEWPORT);
		WriteEntity(MSG_ONE, self.movetarget);
		observer_set_demo_position();
	}
};

//
//  L O O K  F O R  T A R G E T
//
//  Helper function for observer_get_target; looks in a single direction.
//  Returns TRUE if a target is found; FLASE otherwise.
//
float (vector from) observer_look_for_target = 
{
	traceline(from, from + v_forward * 1200, FALSE, self);
	if (trace_fraction < 1.0)
	{
		if (trace_ent.classname == "player" && (trace_ent.style & ELOHIM_CONNECTED))
		{
			if (self.movetarget != trace_ent)
			{
				self.movetarget = trace_ent;
				self.delay = 0;
				self.lip = time + 1;
			}
			return TRUE;
		}
	}
	return FALSE;
};

//
//  G E T  T A R G E T
//
//  Looks for a client in the line of sight.
//
void () observer_get_target =
{
	local vector from;
	local vector angle;

	// first check to see if old one is still visible
	if (self.movetarget)
	{
		local float temp;
		angle = vectoangles(self.movetarget.origin - self.origin);
		temp = angle_y - self.v_angle_y;
		if (temp > 180)
			temp = temp - 360;
		temp = fabs(temp);
		if (temp < 15)
		{
			// they're still there
			self.lip = time + 1;
			return;
		}
	}

	angle = self.v_angle;
	from = self.origin + '0 0 22';

    makevectors(angle);
	if (observer_look_for_target(from))
		return;
	angle_y = angle_y + 5;
    makevectors(angle);
	if (observer_look_for_target(from))
		return;
	angle_y = angle_y - 10;
    makevectors(angle);
	if (observer_look_for_target(from))
		return;

	// didn't find anyone
	if (self.movetarget != world && self.lip < time)
	{
		self.movetarget = world;
		self.delay = 0;
	}
};

//
//  D I S C O N N E C T  N O T I F Y
//
//  Called when a client disconnects or becomes an observer.  Used to
//  update the watch target for any observers that were watching this client.
//
void (entity client) observer_disconnect_notify =
{
    local entity e, oself;
    
    e = find(world, classname, "player");
    while (e)
    {
        if ((e.style & ELOHIM_OBSERVER) && (e.movetarget == client))
        {
            oself = self;
            self = e;
            observer_next_target();
            if (!self.movetarget)
			{
				if (self.oflags & (OBSERVER_CHASE | OBSERVER_DEMO))
				{
					sprint(self, "No more chase targets\n");
					observer_fly_start();
				}
				else if (self.oflags & (OBSERVER_CAMERA))
					observer_next_camera();
			}
            self = oself;
        }
        e = find(e, classname, "player");
    }
    
    // CRMOD so cameras don't follow either
    e = find(world, classname, "elohim_camera");
    while (e)
    {
    	if (e.movetarget == client)
    	{
    		oself = self;
    		self = e;
    		auto_camera_think();
    		self = oself;
    	}
    	e = find(e, classname, "elohim_camera");
    }
    
    if (self == crmod_best_chase_target)
    	crmod_best_chase_target = world;
	if (self == crmod_best_camera)
		crmod_best_camera = world;
    // CRMOD END
};

//
//  F I N D  E N E M Y
//    by Paul Baker
//
//  Corrected and optimized by J.P.
//
//  Called by observer_set_chase_position for use in tourneycam mode
//
void () observer_find_enemy =
{
	local entity potential;

	if (self.movetarget.crmod_inflicted)
	{
		if (self.movetarget.crmod_inflicted != self.movetarget)
			self.crmod_othertarget = self.movetarget.crmod_inflicted;
	}
	else if ((!self.crmod_othertarget) || (self.health > self.movetarget.health))
	{
		if (self.movetarget.dmg_inflictor.classname == "missile" || self.movetarget.dmg_inflictor.classname == "grenade")
			self.crmod_othertarget = self.movetarget.dmg_inflictor.owner;
		else if (self.movetarget.dmg_inflictor.classname == "player")
			self.crmod_othertarget = self.movetarget.dmg_inflictor;
	}

	// Sanity check
	if (self.crmod_othertarget)
	{
		if ((self.crmod_othertarget.style & ELOHIM_OBSERVER) || !(self.crmod_othertarget.style & ELOHIM_CONNECTED) || (self.crmod_othertarget == self.movetarget))
			self.crmod_othertarget = world;
		else if ((self.crmod_othertarget.team == self.movetarget.team) && teamplay)
			self.crmod_othertarget = world;
	}

	// Test visibility of crmod_othertarget.
	// If not visible, then look for a good target.
	local float seeable;
	local float oldseeable;
	seeable = oldseeable = 0;
	if (self.crmod_othertarget)
		seeable = utils_new_visible(self.movetarget, self.crmod_othertarget);
	if (!seeable)
	{
		self.crmod_othertarget = world;
		potential = find(world, classname, "player");
		while (potential)
		{
			if (!(potential.style & ELOHIM_OBSERVER) && (potential.style & ELOHIM_CONNECTED))
			{
				if (((potential.team != self.movetarget.team) || !teamplay) && (potential != self.movetarget))
				{
					seeable = utils_new_visible(self.movetarget, potential);
					if (seeable > oldseeable)
					{
						self.crmod_othertarget = potential;
						oldseeable = seeable;
					}
				}
			}
			potential = find(potential, classname, "player");
		}
	}
};

//
//  S E T  C H A S E  P O S I T I O N
//
//  Called every frame for observers in chase mode.  Used to position
//  the observer behind the player being chased.
//
//  Chase cameras are tricky business - they are notoriously choppy.
//  This choppines is due to two problems:
//
//  1.  The network protocol quantizes angles into 256 discreet values.
//      The client, on the other hand, can set the angle (through user
//      input) much more precisely.  Hence, the chase target's view
//      angle is constantly being rounded off.
//
//  2.  The client side doesn't use the exact positions sent by the server
//
//  To address problem 1, we quantize the angles of the player being chased
//  *before* using them to calculate the new position.  This ensures that
//  the player being watched will stay in the center of the screen and will
//  not jitter back and forth due to angle roundoff.
//
//  To address problem 2, the client should enter "cl_nolerp 1" in their
//  console (the "smooth" alias does this automatically);
//
void () observer_set_chase_position =
{
    local vector pos;
    local vector desired_angle;	// CRMOD
    //local float da;
    //local string temp;
    local vector angle;
    
    if (self.oflags & OBSERVER_AUTO)
	{
		// JP - added this because now this can be called from observer_set_camera_position
		if (self.oflags & OBSERVER_CHASE)
			auto_chase();
	}

	// CRMOD - Setting angle equal to v_angle tricks the placement code below into
	// CRMOD - thinking that the direction you are looking is what the chase target
	// CRMOD - is lookin in.  This way freelook still keeps the player in view.

    if (self.button0)	// freelook
	{           
    	angle = self.v_angle;
		self.crmod_oldangle = self.v_angle;
	}
    else
    {
    	// CRMOD - tourney cam
       	if (self.oflags & OBSERVER_TOURNEY)
    	{
    		observer_find_enemy();
    		if (self.crmod_othertarget)
    		   	desired_angle = angles_bestaim(self.movetarget.origin, self.crmod_othertarget.origin);
    		else
    			desired_angle = self.movetarget.v_angle;
    	}
    	else
    		desired_angle = self.movetarget.v_angle;

		angle_x = self.crmod_oldangle_x * (1 - CRMOD_ANGLE_SMOOTHING) + desired_angle_x * CRMOD_ANGLE_SMOOTHING;
		angle_y = angles_pick_angle(self.crmod_oldangle_y, desired_angle_y, CRMOD_ANGLE_SMOOTHING);
		angle_z = 0;
	}

	// Quantize the player's angle so that the angle we use here will
	// be the same as the one used by the client (after the angle has been
	// garbled by the network protocol)
	//
	if (!self.button0)
	{
		angle_x = 360.0 / 256.0 * rint(angle_x * 256.0 / 360.0);
		angle_y = 360.0 / 256.0 * rint(angle_y * 256.0 / 360.0);
	}

    // The "ideal" position is 100 units behind and 40 units above the
    // chase target.  To deal with walls and ceilings, we first trace a
    // line 125 units backwards and then move 80% of the way along the
    // part of the line that was traced.  We then trace a line 50 units up
    // and move 80% of the way along the part that was traced.
    //    
    makevectors(angle);
    pos = self.movetarget.origin;
    traceline(pos, pos - 120 * v_forward, TRUE, self.movetarget);
    pos = pos - (trace_fraction * 100) * v_forward;				
    traceline(pos, pos + 50 * v_up, TRUE, self.movetarget);		
    pos = pos + (trace_fraction * 40) * v_up;					
    setorigin(self, pos);
    //self.velocity = self.movetarget.velocity; // don't think this is needed

    if (self.button0)
        return;  // freelook; don't set the viewing angle

    angles_fixangle(angle);
};

//
//  S E T  D E M O  P O S I T I O N
//
//  Similar to, but simpler than, observer_set_chase_position.  We need
//  to set the view angles.  The view position is set semi-automatically,
//  but quake gets confused if the observer's entity is in a very different
//  location, so to keep it happy we move the observer's entity to the
//  chasetargets location.
//
void () observer_set_demo_position =
{
    setorigin(self, self.movetarget.origin);

    if (self.button0)
        return;  // freelook; don't set the viewing angle

    self.v_angle = self.angles = self.movetarget.v_angle;	// CRMOD added v_angle
    self.fixangle = TRUE;
};

// CRMOD
// S E T  C A M E R A  P O S I T I O N
//   by Paul Baker
//
//   Camera movement
//
void () observer_set_camera_position =
{	
	local float seeable;
	local entity camera, temp;
	local vector angle;
	
	if (self.oflags & OBSERVER_AUTO) auto_camera();
	
	if (self.movetarget.classname == "player")
	{
		observer_set_chase_position();	// JP - added this
		return;
	}

	if (self.button0) // freelook
		return;
	
	// JP - rewrote this
	camera = self.movetarget;

	// don't bother with checks if last camera think was really recent
	if (camera.super_time < time - 0.1)
	{
		seeable = 0;
		if (camera.movetarget)			
			seeable = utils_new_visible(camera, camera.movetarget);
			
		if (seeable < 4)
		{
			temp = self;
			self = camera;
			auto_camera_think();
			self = temp;
			self.delay = 0;
		}
	}

	if (camera.movetarget != world)
		angle = angles_bestaim(camera.origin, camera.movetarget.origin);
	else
		angle = camera.angles;

	angle_x = self.crmod_oldangle_x * (1 - CRMOD_ANGLE_SMOOTHING) + angle_x * CRMOD_ANGLE_SMOOTHING;
	angle_y = angles_pick_angle(self.crmod_oldangle_y, angle_y, CRMOD_ANGLE_SMOOTHING);
	angle_z = 0;
	angles_fixangle(angle);
};

//
//  I M P U L S E  C O M M A N D S
//
//  Called from observer_post_think to check for impulses.
//
void () observer_impulse_commands =
{


    if (self.impulse >= 20 && self.impulse != 22)
        elohim_impulse();
    else if (!(self.oflags & (OBSERVER_CHASE | OBSERVER_DEMO)) && !(mode_is_arena()))
    {
    /*
        if (self.impulse == 1)
            observer_pop_down();
        else if (self.impulse == 2)
            observer_pop_forward();
        else if (self.impulse == 3)
            observer_pop_up();
            */
    }
    self.impulse = 0;
};

//
//  H E L P
//
void () observer_help =
{
    sprint(self, "Observer commands:\n");
    sprint(self, " help-walk - help for walk mode\n");
    sprint(self, " help-fly  - help for fly mode\n");
    sprint(self, " help-chase- help for chase/demo mode\n");
    sprint(self, " help-camera - help for camera mode\n");
    sprint(self, " ready     - exit observer mode\n");
    sprint(self, " walk/flyme    > choose mode\n");
    sprint(self, " chase/eyecam  > choose mode \n");
    sprint(self, " autochase - automatic chasecam mode\n");
    sprint(self, " camera    - camera mode\n");
    sprint(self, " autocam   - automatic camera mode\n");
    //sprint(self, " headsup   - toggle heads up display\n");
	sprint(self, " touney    - toggle tournament chase\n");
};

//
//  W A L K  H E L P
//
void () observer_walk_help =
{
    sprint(self, "Walk mode controls:\n");
    sprint(self, " jump      - jump\n");
	sprint(self, " attack    - fly (through walls)\n");
    sprint(self, "                 through obstacle\n");
    sprint(self, "help-observer - observer mode help\n");
};

//
//  F L Y  H E L P
//
void () observer_fly_help =
{
    sprint(self, "Fly mode controls:\n");
    sprint(self, " jump   - move up\n");
	sprint(self, " attack - fly through walls\n");
    sprint(self, " impulse 1/2/3 - move down/forward/up\n");
    sprint(self, "                 through obstacle\n");
    sprint(self, "help-observer - observer mode help\n");
};

//
//  C H A S E  H E L P
//
void () observer_chase_help =
{
    sprint(self, "Chase/eyecam mode controls:\n");
    sprint(self, " attack    - freelook\n");
	sprint(self, " jump      - select next player\n");
	sprint(self, " attack + jump - previous player\n");
	sprint(self, " smooth    - toggle camera smoothing\n");
	sprint(self, " autochase - automatic chase mode\n");
	sprint(self, "             (chase mode only)\n");
	sprint(self, " tourney   - toggle tourneycam\n");
	sprint(self, "             (chase mode only)\n");
    sprint(self, "help-observer - observer mode help\n");
};

// CRMOD
//  C A M E R A  H E L P
//    by Paul Baker
void () observer_camera_help =
{
	sprint(self, "Camera mode controls:\n");
    sprint(self, " attack    - freelook\n");
	sprint(self, " jump      - select next camera\n");
	sprint(self, " attack + jump - previous camera\n");
	sprint(self, " smooth    - toggle camera smoothing\n");
	sprint(self, " autocam   - automatic camera mode\n");
	sprint(self, "help-observer - observer mode help\n");
};

//
//  C A N C E L  L E A V E
//
//  *Don't* leave the match.
//
void () observer_cancel_leave =
{
    if (self.owner.style & ELOHIM_CONFIRM_LEAVE)
    {
        self.owner.style = self.owner.style - ELOHIM_CONFIRM_LEAVE;
        sprint(self.owner, "Canceled\n");
    }
    remove (self);
};

//
//  C O N F I R M
//
//  If someone enters the 'observer' impulse during a match, ask
//  them if they are sure they want to leave the match.
//
void () observer_confirm =
{
    if (self.style & ELOHIM_CONFIRM_LEAVE)
        return;

    sprint(self, "Leave match?  Type yes to confirm.\n");
    self.style = self.style | ELOHIM_CONFIRM_LEAVE;
    utils_make_scheduled_event(observer_cancel_leave, 5);
};

//
//  C O N F I R M  L E A V E  R E S P O N S E
//
//  They entered yes or know in response to the above prompt.
//
void (float response) observer_confirm_leave_response =
{
    self.style = self.style - ELOHIM_CONFIRM_LEAVE;
    if (response)
    {
		
        observer_start();
    }
    else
        sprint(self, "Cancelled\n");
};

//
//  I M P U L S E
//
//  Called from elohim_impulse in elohim.qc to handle observer impulses.
//
void () observer_impulse =
{
    if (self.style & ELOHIM_OBSERVER)
    {
        if (self.impulse == 141)
            observer_walk_start();
        else if (self.impulse == 142)
        {
		if(self.cam) 
		{
			Exit_HorrorScope();
		}
		observer_fly_start();
	}
	
        else if (self.impulse == 100)
        {	}
        else if (self.impulse == 143)
        {
            if(self.cam) 
		{
			Exit_HorrorScope();
		}
            
            observer_chase_start();
	}
        else if (self.impulse == 148)
            observer_heads_up();
        else if (self.impulse == 149)
	{ 
			if(!(self.oflags & OBSERVER_ACTIONCAM)) 
			{
				observer_clear_flags();
				self.oflags = self.oflags | OBSERVER_ACTIONCAM;
			}
	}
        else if (self.impulse == 150)						
        	stuffcmd(self,"smooth\n"); 
        else if (self.impulse == 151)						
			observer_toggle_tourney();
		// CRMOD no longer used else if (self.impulse == 152)
		// CRMOD no longer used	utils_toggle_oflag(OBSERVER_AUTO, "Automatic Chase/Camera Mode");
		else if (self.impulse == 153)
			observer_camera_start();
		else if (self.impulse == 154)
			auto_camera_start();
		else if (self.impulse == 155)
			auto_chase_start();
    }
    else
    {                                                                              // CRMOD more commands to go observer
        if ((self.impulse >= 140 && self.impulse <= 143) || self.impulse == 149 || (self.impulse >= 153 && self.impulse <= 155))
        {
			if (self.impulse != 140)
			{
				observer_clear_flags();
				if (self.impulse == 141)
					self.oflags = self.oflags | OBSERVER_WALK;
				else if (self.impulse == 142)
        {
		if(self.oflags & OBSERVER_ACTIONCAM) 
		{
			self.oflags = self.oflags - OBSERVER_ACTIONCAM;

		}
		observer_fly_start();
	}
				else if (self.impulse == 143)
					self.oflags = self.oflags | OBSERVER_CHASE;
				else if (self.impulse == 149)
				{ 
					if(!(self.oflags & OBSERVER_ACTIONCAM)) 
					{
						observer_clear_flags();
						self.oflags = self.oflags | OBSERVER_ACTIONCAM;
						
					}
				}
				
				// CRMOD more commands to go observer
				else if (self.impulse == 155)
					self.oflags = self.oflags | OBSERVER_CHASE | OBSERVER_GO_AUTO;
				else if (self.impulse == 153)
					self.oflags = self.oflags | OBSERVER_CAMERA;
				else if (self.impulse == 154)
					self.oflags = self.oflags | OBSERVER_CAMERA | OBSERVER_GO_AUTO;
				// CRMOD END
			}
			
            if ((elohim_playmode & ELOHIM_MATCH_MODE) && (elohim_state & ELOHIM_MATCH_STARTED))
                observer_confirm();
            else if ((mode_is_arena()) && (boss.state == CA_MATCH_PLAYING))
            {
                //TODO:Can't leave right now
                //TODO:RA leave queue
            }
            else
            {
                if (mode_is_public()) {
                    public_notready();
                }
                rune_toss();
                observer_start();
            }
        }
        else if (self.impulse >= 147 && self.impulse != 156)
            sprint(self, "You must be an observer first\n");
    }

    if (self.impulse == 144)
        observer_walk_help();
    else if (self.impulse == 145)
        observer_fly_help();
    else if (self.impulse == 146)
        observer_chase_help();
    else if (self.impulse == 156)
    	observer_camera_help();
};

//
//  J U M P
//
//  Modified version of PlayerJump in Client.qc
//  Fast movement in water/slime/lava; no sounds.
//
//  jump is TRUE if 'jump' was just pressed, FALSE if it is being
//  held down.
//
void (float jump) observer_jump =
{
	if (self.flags & FL_WATERJUMP)
		return;

    if (self.waterlevel >= 2)
	{
        if (self.waterlevel == 3)
            self.velocity_z = 320;
        else
            self.velocity_z = 100;
		return;
	}

    if (!(self.flags & FL_ONGROUND) || !jump)
		return;

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
    self.velocity_z = 270;
};

//
//  C H E C K  S I Z E
//
//  If an observer gets caught in a door/platform etc, their size can
//  be set to zero.  This routine is called once every second to make
//  sure that this doesn't last.
//
void () observer_check_size =
{
    if (self.maxs_x < 16 || self.maxs_y < 16)
        setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
};

//
//  U P D A T E  D I S P L A Y
//
//  Heads up display for watching targets.  The format of the display is
//  as follows:
//
//     <player name> [QOR] <weapon>
//     Armour: <type> <value>  Health: <value>  Ammo: <value>
//
//  Q, O, R are the quad, ring and suit flags.  The suit flag is not really
//  an R; it's some weird quake symbol.
//
void () observer_update_display =
{
    local string w, armour, aval, healthammo, ammo;
	local entity player;	// CRMOD cameras
	local string score, pad, teamname;

	// compute score and pad
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		teamname = elohim_winning_teamname;
		score = ftos(elohim_score_number);
		if (elohim_score_number >= 100)
			pad = "";
		else if (elohim_score_number >= 10)
			pad = " ";
		else if (elohim_score_number >= 0)
			pad = "  ";
		else if (elohim_score_number >= -9)
			pad = " ";
		else 
			pad = "";
	}
	else
	{
		score = pad = "";
		teamname = "                       ";
	}

	
    self.delay = time + 0.5;
    if ((elohim_state & ELOHIM_MATCH_PAUSED) ||
        (self.style & (ELOHIM_SETTING_OPTIONS | ELOHIM_MOTD)))
        return;

    // CRMOD account for cameras
	player = self.movetarget;
	if ((player != world) && (player.classname == "elohim_camera"))
		player = player.movetarget;

    if ((mode_is_public()) && !(self.style & ELOHIM_MOTD) && !(self.player_flag & PF_HUD))
    {
        centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress \bF1\b to join");
        return;
    }


    if (!player)
    {
		if (elohim_state & ELOHIM_MATCH_STARTED)
			centerprint4(self, "\n\n\n\n\n\n\n\n\n\n\n\n               ", teamname, score, pad);
		else
			centerprint(self, " ");
        return;
    }

    if (self.style & ELOHIM_HEADS_UP)
    {
        w = strings_get_weapon(player);
        armour = strings_get_armour_type(player);
        aval = strings_get_armour_val(player);
        healthammo = strings_get_health_ammo(player);
        ammo = ftos(player.currentammo);
    
        centerprint7(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n",
            player.netname, w, armour, aval, healthammo, ammo);
    }
    else
    {
		local string othertarget;

		if ((self.oflags & OBSERVER_TOURNEY) && (self.crmod_othertarget != world) && (self.movetarget.classname == "player"))
			othertarget = self.crmod_othertarget.netname;
		else
			othertarget = "";

		centerprint7(self, "\n\n\n\n\n\n\n\n\n\n", othertarget, "                       \n\n",
					 player.netname, teamname, score, pad);
    }
};

//
//  U P D A T E  S T A T U S  B A R
//
//  Copy the chasetarget's status into the observer's status bar.
//
void () observer_update_status_bar =
{
    local entity player;
    if (self.movetarget == world)
    {
        self.health = 666;
        self.items = 0;
        self.armorvalue = 0;
        self.ammo_shells = 0;
        self.ammo_nails = 0;
        self.ammo_rockets = 0;
        self.ammo_cells = 0;
        self.currentammo = 0;
        self.show_hostile = 0;
        self.weapon = 0;
	    self.weaponmodel = string_null;
    }
    else
    {
        // CRMOD account for cameras
        if (self.movetarget.classname == "player")
    		player = self.movetarget;
  		else if (self.movetarget.classname == "elohim_camera")
    	{
    		if (self.movetarget.movetarget != world)
	    		player = self.movetarget.movetarget;
	    	else
	    	{
	    		self.health = 666;
		        self.items = 0;
        		self.armorvalue = 0;
		        self.ammo_shells = 0;
		        self.ammo_nails = 0;
		        self.ammo_rockets = 0;
		        self.ammo_cells = 0;
		        self.currentammo = 0;
        		self.show_hostile = 0;
		        self.weapon = 0;
			    self.weaponmodel = string_null;
			    return;
			}
		}
    	else
    		return;
    		
        self.health = player.health;
        self.items = player.items;
        self.armorvalue = player.armorvalue;
        self.ammo_shells = player.ammo_shells;
        self.ammo_nails = player.ammo_nails;
        self.ammo_rockets = player.ammo_rockets;
        self.ammo_cells = player.ammo_cells;
        self.currentammo = player.currentammo;
        self.show_hostile = player.show_hostile;
        self.weapon = player.weapon;
		if (self.oflags & OBSERVER_DEMO)
		{
			self.weaponmodel = player.weaponmodel;
			self.weaponframe = player.weaponframe;
		}
		else
		    self.weaponmodel = string_null;
		if (self.health < 0)
			self.health = 1000;
		// CRMOD END
    }
};

//
//  S E T  O R I G I N
//
//  Try to put the observer somewhere around spot.  Return TRUE if successful,
//  FALSE otherwise.
//
float (vector spot) observer_set_origin = 
{
	local float d1, d2;

	// x
	traceline(spot, spot + '32 0 0', TRUE, world);
	d1 = 32 * trace_fraction;
	traceline(spot, spot - '32 0 0', TRUE, world);
	d2 = 32 * trace_fraction;
	if (d1 + d2 < 32)
		return FALSE;
	if (d1 < 16)
		spot_x = spot_x - (16 - d1);
	else if (d2 < 16)
		spot_x = spot_x + (16 - d2);

	// y
	traceline(spot, spot + '0 32 0', TRUE, world);
	d1 = 32 * trace_fraction;
	traceline(spot, spot - '0 32 0', TRUE, world);
	d2 = 32 * trace_fraction;
	if (d1 + d2 < 32)
		return FALSE;
	if (d1 < 16)
		spot_y = spot_y - (16 - d1);
	else if (d2 < 16)
		spot_y = spot_y + (16 - d2);

	// z
	traceline(spot, spot + '0 0 56', TRUE, world);
	d1 = 56 * trace_fraction;
	traceline(spot, spot - '0 0 56', TRUE, world);
	d2 = 56 * trace_fraction;
	if (d1 + d2 < 56)
		return FALSE;
	if (d1 < 32)
		spot_z = spot_z - (32 - d1);
	else if (d2 < 24)
		spot_z = spot_z + (24 - d2);

	setorigin(self, spot);
	return TRUE;
};

//
//  F L Y  T H R O U G H  O B S T A C L E
//
void () observer_fly_through_obstacle =
{
	local float i, spots;
	local vector spot, inc;

	spot = self.origin + '0 0 22';
	traceline(spot, spot + 48 * v_forward, TRUE, self);
	if (trace_fraction == 1)
	{
		self.attack_finished = time;
		return;
	}
	else if (time < self.attack_finished + 0.2)
		return;

	inc = 32 * v_forward;
	spot = spot + 100 * v_forward;
	i = 0;
	spots = 0;
	while (i < 6)
	{
		local float c;
		c = pointcontents(spot);
		if ((c != CONTENT_SOLID) && (c != CONTENT_SKY))
		{
			spots = spots + 1;
			if (spots > 1)
			{
				if (observer_set_origin(spot - 16 * v_forward))
					return;
			}
		}
		else
			spots = 0;
		spot = spot + inc;
		i = i + 1;
	}
};

//
//  F L Y  M O V E
//
//  Called every frame for observers in Fly mode.
//
void () observer_fly_move =
{
    local float dz, zvel, right_coef, forward_coef, norm;
    local vector f;

    // Check if the observer is pressing up or down by looking at the
    // change in velocity_z.  zvel is set to 1 if the observer is pressing
    // up (or jump), -1 if the observer is pressing down, and 0 otherwise.
    // Note that velocity_z can change as a result of hitting the ground/
    // ceiling, so it is necessary to verify that the change in velocity_z
    // has the same sign as velocity_z.
    //
    dz = self.velocity_z - self.speed;
    if (self.button2 || (dz > 0 && self.velocity_z > 0))
        zvel = 1;
    else if (dz < 0 && self.velocity_z < 0)
        zvel = -1;
    else
        zvel = 0;
        
 
    

    // If there is no horizonal movement, then move up/down.
    if (!self.velocity_x && !self.velocity_y)
    {
        self.speed = self.velocity_z = zvel * 300;
		if (self.button0)
			observer_fly_through_obstacle();
        return;
    }

    // Project the velocity onto the xy plane.  v_right gives one basis
    // vector for the xy plane; '-vright_y vright_x 0' gives the other one
    // (in the forward direction).  The resulting forward component gives
    // the forward component of motion, which will be in the v_forward
    // direction.  The orthogonal component gives the strafing component
    // of motion, which will be in the v_right direction.  Note that if
    // the player is pointing up or down the forward component will appear
    // smaller (since the magnintude of the forward component is the length
    // of v_foward projected onto the xy plane).  The purpose of dividing
    // by vlen(f) is to compensate for this.
    //
    makevectors(self.v_angle);
    f = v_forward;
    f_z = 0;
    right_coef = self.velocity * v_right;
    forward_coef = self.velocity_y * v_right_x - self.velocity_x * v_right_y;
    forward_coef = forward_coef / vlen(f);
    self.velocity = right_coef * v_right + forward_coef * v_forward;

    // Now compute the observer's velocity by taking zvel into account
    // and imposing a maximum speed limit.
    norm = vlen(self.velocity);
    if (zvel)
    {
        if (norm > 280)
            self.velocity = self.velocity * (280 / norm);
        self.velocity_z = 150 * zvel;
    }
    else if (norm > 320)
        self.velocity = self.velocity * (320 / norm);

    self.speed = self.velocity_z;

	if (self.button0)
		observer_fly_through_obstacle();
	else
		self.attack_finished = time;
		
		///*
		if(self.ski_button == 1 && self.movement_x > 300)
		{
			//bprint("faster\n");
			self.velocity = self.velocity + v_forward*300;
			self.velocity_z=self.velocity_z*0.7;
		}
		else if(self.ski_button == 1 && self.movement_x < -300)
		{
			//bprint("faster\n");
			self.velocity = self.velocity + v_forward*-300;
			self.velocity_z=self.velocity_z*0.7;
		}
			///*
		if(self.ski_button == 1 && self.movement_y > 300)
		{
			//bprint("faster\n");
			self.velocity = self.velocity +v_right*300;
		}
		else if(self.ski_button == 1 && self.movement_y < -300)
		{
			//bprint("faster\n");
			self.velocity = self.velocity +v_right*-300;
		}
		//*/
		
		
};

//
//  P R E  T H I N K
//
//  Called from PlayerPreThink in client.qc
//
void () observer_pre_think =
{
    local float jump;

    // Deal with button2.  jump is set to TRUE is button2 was just pressed,
    // FALSE otherwise.
    if (self.button2)
    {
        if (self.flags & FL_JUMPRELEASED)
        {
            jump = TRUE;
            self.flags = self.flags - FL_JUMPRELEASED;
        }
        else
            jump = FALSE;
    }
    else
    {
        jump = FALSE;
        self.flags = self.flags | FL_JUMPRELEASED;
    }

    if (self.oflags & (OBSERVER_CHASE | OBSERVER_DEMO | OBSERVER_CAMERA))
    {
        if (jump)
		{
			if (self.movetarget.classname == "player")
			{
				if (self.button0)
					observer_prev_target();
				else
					observer_next_target();
			}
			else
			{
    			if (self.button0)
    				observer_prev_camera();
    			else
    				observer_next_camera();
			}
			self.crmod_cam_delay = time + 6;
		}
    }
    else
    {
        if (self.oflags & OBSERVER_WALK && !self.button0)
        {
            if (self.impulse == 100)    //NOVEM jump to impulse 5 (F1)
            {
                if (public_join())
                    return;
            }
            else if (self.impulse == 6)
		{
			if (self.player_flag & PF_HUD) 
			{
					self.player_flag = self.player_flag - PF_HUD;

			}
			else if (!(self.player_flag & PF_HUD))
			{
					self.player_flag = self.player_flag | PF_HUD;
			}
		}

            WaterMove();
    
            if (self.waterlevel == 2)
                CheckWaterJump ();
    
            if (self.button2) 
            {
                observer_jump(jump);
            }

            self.movetype = MOVETYPE_WALK;
        }
        else if (self.oflags & OBSERVER_FLY && !self.button0)
        {
            if (self.impulse == 100)
            {
                if (public_join())
                    return;
            }
            else if (self.impulse == 6)
		{
			if (self.player_flag & PF_HUD) 
			{
					self.player_flag = self.player_flag - PF_HUD;

			}
			else if (!(self.player_flag & PF_HUD))
			{
					self.player_flag = self.player_flag | PF_HUD;
			}
		}
		
			self.waterlevel = 0;
            observer_fly_move();
            self.movetype = MOVETYPE_FLY;
        }
        
        else
        {
		self.waterlevel = 0;
            observer_fly_move();
            self.flags = self.flags | FL_ONGROUND;
            self.movetype = MOVETYPE_FLY;
        }
        observer_check_teleport();

		// check for player in sight every frame
		observer_get_target();
    }
};

//
//  P O S T  T H I N K
//
//  Called from PlayerPostThink in Client.qc
//
void () observer_post_think =
{
    if (self.oflags & OBSERVER_CHASE)
        observer_set_chase_position();
    else if (self.oflags & OBSERVER_DEMO)
        observer_set_demo_position();
    else if (self.oflags & OBSERVER_CAMERA)
    	observer_set_camera_position();
    	
    // When an observer touches a door they are not teleported through
    // the door immediately as this doesn't seem to work.  Instead, the
    // POP_FORWARD flag is set and they are teleported through the next
    // time observer_post_think is called.
    //
    if (self.style & ELOHIM_POP_FORWARD)
    {
        self.style = self.style - ELOHIM_POP_FORWARD;
        setorigin(self, self.dest);
        self.velocity = self.dest1;
    }

    // CRMOD - this was moved here, so the observers.health could be
    //         compared to movetarget's in tourney and auto modes
    //         to see if movetarget was damaged
        
    // Update the status bar every frame
    observer_update_status_bar();

    // Update the heads up display every 0.5 seconds
    if (time > self.delay)
        observer_update_display();

    if (self.impulse)
    {
        self.finaldest_x = time;//R00k
        // Redirect impulses 1-10 when player is entering a number
        if (self.use != SUB_Null)
        {
            if (self.impulse >= 1 && self.impulse <= 10)
            {
                if (self.impulse == 10)
                    self.impulse = 230;
                else
                    self.impulse = self.impulse + 230;
            }
        }

        observer_impulse_commands();
    }
};

//
//  D O O R  T O U C H
//
//  Called from door_touch in Doors.qc.  When an observer in walk or
//  fly mode touches a door, their POP_FORWARD flag is set when it is
//  possible to teleport them through the door.  The global variable
//  'other' points to the player that touched the door.
//
void () observer_door_touch =
{
    local float temp;

    // Ignore observers that are in chase mode or who are above the door
    if (other.origin_z > self.absmax_z || self.oflags & (OBSERVER_CHASE | OBSERVER_DEMO))
        return;

    temp = utils_min(self.size_x, self.size_y) + 40;
    other.dest1 = other.dest = other.velocity;
    other.dest_z = 0;
    other.dest = other.dest * (temp / vlen(other.dest));
    other.dest = other.origin + other.dest;
    if (pointcontents(other.dest) != CONTENT_SOLID)
        other.style = other.style | ELOHIM_POP_FORWARD;
};

//
//  H E A D S  U P
//
//  Enable/disable heads up display.
//
void () observer_heads_up =
{
    if (self.style & ELOHIM_HEADS_UP)
    {
        self.style = self.style - ELOHIM_HEADS_UP;
        sprint(self, "Heads up display disabled\n");
        stuffcmd(self, "viewsize 100\n");
    }
    else
    {
        self.style = self.style | ELOHIM_HEADS_UP;
        sprint(self, "Heads up display enabled\n");
        stuffcmd(self, "viewsize 120\n");
    }
    self.delay = 0;
};

