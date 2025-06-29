// function declarations
void (float vlaue) crx_set_teamplay;
void (float vlaue) crx_set_fraglimit;

void () motd_init_world;
void () motd_create;
void () score_init_world;
void () score_client_connect;
void () score_client_disconnect;
void (float command) console_command;
void () console_set_aliases;
void (entity client) observer_disconnect_notify;
void () admin_impulse;
void () admin_start_code;
void (float fDoKick) admin_confirm_kick_response;
void (entity player) admin_disconnect_notify;
void () observer_impulse;
void () observer_help;
void () observer_start;
void () observer_find_teleport;
void () observer_check_size;
void (float response) observer_confirm_leave_response;
void () match_show_timelimit;
void () match_impulse;
void (entity player) match_verify_team;
void (entity player) match_disconnect_notify;
void () vote_impulse;
void () execute_changelevel;
void () NextLevel;
void (vector org, entity death_owner) spawn_tdeath;
void () player_stand1;
void() ClientDisconnect;
void (vector org) spawn_tfog;
void () rune_drop;

void () crx_init_set_hud;

void() client_responsetime_show;
void() client_responsetime_set;

//
//  I N I T  W O R L D
//
//  Called from InitWorld in World.qc
//
void () crx_init_world =
{
	local float mode;
	local string szmode;

  br_version = "BR v1.2"; 
  br_version_info = "Bloodrailz CRx";
  bloodrailz_version_number = "v1.2";

	// Initialize
	motd_init_world();
	score_init_world();
  
  // Hack to allow console to emulate an administrator
	world.style = STYLE_ADMINISTRATOR;

  // Precache sound used when players connect
  precache_sound("misc/br_init.wav");   //soniss free libraries

  // Get/set console variables
  
  
  
  crx_playmode = cvar("samelevel");
  
		if (mapname == "ctf_takayama_r1") map_is_dark = 1;
		else if (mapname == "ctf_dissocia_r1") map_is_dark = 1;
		else if (mapname == "ctf_bridge_r1") map_is_dark = 1;
		else if (mapname == "ctf_hanghigh_r1") map_is_dark = 1;
		else if (mapname == "ctf_swingest_r1") map_is_dark = 0;
		else if (mapname == "ctf_teardown_r1") map_is_dark = 1;
		else if (mapname == "ctf_eyesout_r1") map_is_dark = 1;
		else if (mapname == "ctf_relic2_r1") map_is_dark = 1;
		else if (mapname == "ctf_rebirth_r1") map_is_dark = 0;
		else if (mapname == "ctf_edge3_r1") map_is_dark = 1;
		else if (mapname == "ctf_faceoff_r1") map_is_dark = 1;
		else if (mapname == "ctf_sandstorm_r1") map_is_dark = 0;
		else if (mapname == "ctf_lasertag_r1") map_is_dark = 1;
		else if (mapname == "ctf_dreamland_r1") map_is_dark = 1;
		else if (mapname == "ctf_bikini_r1") map_is_dark = 0;
		else if (mapname == "ctf_doglyfe_r1") map_is_dark = 0;
		else if (mapname == "ctf_bamboo_r1") map_is_dark = 1;
		else if (mapname == "ctf_daywalker_r1") map_is_dark = 0;
		else if (mapname == "ctf_easter_r1") map_is_dark = 0;
		else if (mapname == "ctf_fulcrum_r1") map_is_dark = 1;
		else if (mapname == "ctf_albatross_r1") map_is_dark = 1;
		else if (mapname == "ctf_firestorm_r1") map_is_dark = 1;
		else if (mapname == "ctf_feral_r1") map_is_dark = 1;
		else if (mapname == "ctf_gulch_r1") map_is_dark = 0;



		local float RACE_YES=0;
		if (mapname == "race24") RACE_YES=1;
		else if (mapname == "race23") RACE_YES=1;
		else if (mapname == "race22") RACE_YES=1;
		else if (mapname == "race21") RACE_YES=1;
		else if (mapname == "race20") RACE_YES=1;
		else if (mapname == "race19") RACE_YES=1;
		else if (mapname == "race18") RACE_YES=1;
		else if (mapname == "race17") RACE_YES=1;
		else if (mapname == "race16") RACE_YES=1;
		else if (mapname == "race15") RACE_YES=1;
		else if (mapname == "race14") RACE_YES=1;
		else if (mapname == "race13") RACE_YES=1;
		else if (mapname == "race12") RACE_YES=1;
		else if (mapname == "race11") RACE_YES=1;
		else if (mapname == "race10") RACE_YES=1;
		else if (mapname == "race9") RACE_YES=1;
		else if (mapname == "race8") RACE_YES=1;
		else if (mapname == "race7") RACE_YES=1;
		else if (mapname == "race6") RACE_YES=1;
		else if (mapname == "race5") RACE_YES=1;
		else if (mapname == "race4") RACE_YES=1;
		else if (mapname == "race3") RACE_YES=1;
		else if (mapname == "race2") RACE_YES=1;
		else if (mapname == "race1") RACE_YES=1;
		else if (mapname == "race") RACE_YES=1;
		else if (mapname == "slide12") RACE_YES=1;
		else if (mapname == "slide11") RACE_YES=1;
		else if (mapname == "slide10") RACE_YES=1;
		else if (mapname == "slide9") RACE_YES=1;
		else if (mapname == "slide8") RACE_YES=1;
		else if (mapname == "slide7") RACE_YES=1;
		else if (mapname == "slide6") RACE_YES=1;
		else if (mapname == "slide5") RACE_YES=1;
		else if (mapname == "slide4") RACE_YES=1;
		else if (mapname == "slide3") RACE_YES=1;
		else if (mapname == "slide2") RACE_YES=1;
		else if (mapname == "slide1") RACE_YES=1;
		else if (mapname == "slide") RACE_YES=1;
		else if (mapname == "subslide") RACE_YES=1;
		else if (mapname == "treerace") RACE_YES=1;
		else if (mapname == "slidefox") RACE_YES=1;
		else if (mapname == "treerace") RACE_YES=1;	
		else if (mapname == "race_orange_b1") RACE_YES=1;
		else if (mapname == "race_orange_b2") RACE_YES=1;
		else if (mapname == "race_orange_b3") RACE_YES=1;
		else if (mapname == "race_valley_b2") RACE_YES=1;
		else if (mapname == "race_valley_b3") RACE_YES=1;
		else if (mapname == "race_valley_b4") RACE_YES=1;
		else if (mapname == "petra") RACE_YES=1;
		
		else if (mapname == "tut1") RACE_YES=1;
		else if (mapname == "tut2") RACE_YES=1;
		else if (mapname == "tut3") RACE_YES=1;
		else if (mapname == "tut4") RACE_YES=1;
		else if (mapname == "tut5") RACE_YES=1;
		else if (mapname == "tut6") RACE_YES=1;
		else if (mapname == "tut7") RACE_YES=1;
		else if (mapname == "tut8") RACE_YES=1;
		else if (mapname == "tut9") RACE_YES=1;
		
		if(RACE_YES==1 && !(crx_playmode & RACE_MODE))
		{
			crx_playmode = crx_playmode - (crx_playmode & (RACE_MODE | MATCH_MODE | CTF_MODE | MODE_RUNES | MODE_NO_HOOK | DM_PUBLIC_MODE | MODE_NO_ARMOR | MODE_NOAMMO));
            
			crx_playmode = crx_playmode | RACE_MODE;
			crx_playmode = crx_playmode | MODE_NO_ARMOR;
			crx_playmode = crx_playmode | MODE_NOAMMO;
			if(mapname =="tut1" || mapname =="tut2") crx_playmode = crx_playmode | MODE_RUNES;
			if(mapname =="tut1" || mapname =="tut2") localcmd("scr_matchclock 0\n");
			cvar_set("hostname", ADMIN_RACE_MODE_STRING);
			
			spawn_race_entities();
		}
		
		else if(RACE_YES==0 && (crx_playmode & RACE_MODE))
		{
			crx_playmode = crx_playmode - (crx_playmode & (RACE_MODE | MATCH_MODE | CTF_MODE | MODE_RUNES | MODE_NO_HOOK | DM_PUBLIC_MODE | MODE_NO_ARMOR));

			 crx_maxsize = 16;
       			 crx_teamsize1 = 0;
        			crx_teamsize2 = 0;
       			 crx_playmode = crx_playmode | CTF_MODE;   
        		if (!(crx_playmode & MODE_RUNES)) crx_playmode = crx_playmode | MODE_RUNES;
        		if (crx_playmode & MODE_NOAMMO) crx_playmode = crx_playmode - MODE_NOAMMO;
        		
        		localcmd("scr_matchclock 3\n");
        		
     			   utils_set_cvar("timelimit", crx_timelimit);
        		cvar_set("hostname", ADMIN_CTF_PUBLIC_MODE_STRING);
		}
  
  if (mode_is_public_ctf()) 
  {
    teamplay = 4;  
    //teamplay = 2;
  }
  else if ((crx_playmode & MATCH_MODE) || (crx_playmode & DM_PUBLIC_MODE))
    teamplay = 2;
  else
    teamplay = cvar("teamplay");

//??
  crx_set_teamplay(-1);


  if ((crx_playmode & DM_PUBLIC_MODE) || (mode_is_public_ctf() == TRUE))
    crx_set_fraglimit(120);
  
  else if (mode == ADMIN_NORMAL_MODE)
    crx_set_fraglimit(40);    //FFA fraglimit is 40
  //else
    //crx_set_fraglimit(-1);

  // Check to see if we need to initialize the server
  if (!(crx_playmode & MODE_SERVER_INITIALIZED))
  {
  // Check to see if this is a dedicated server.
  // Dedicated servers do not have an ambient_fade cvar, so the
  // value returned by cvar() will not change.
  local float temp2;
  temp2 = cvar("ambient_fade");
  utils_set_cvar("ambient_fade", temp2 + 1);
  if (temp2 == cvar("ambient_fade"))
  {
    cprint("Initializing dedicated server...\n");
    crx_playmode = crx_playmode | MODE_DEDICATED_SERVER;
  }
  else
  {
    cprint("Initializing listen server...\n");
    utils_set_cvar("ambient_fade", temp2);
  }

  // Set aliases for console commands
  console_set_aliases();

  // Initialize global variables
  if (crx_playmode & MODE_DEDICATED_SERVER)
  {
    cvar_set("v_kicktime", "0");  // crx_overtime
  }
  serverflags = 0;
  crx_playmode = crx_playmode | MODE_SERVER_INITIALIZED;
   crx_playmode = crx_playmode | CTF_MODE;           //default mode
   if (!(crx_playmode & MODE_RUNES))
            crx_playmode = crx_playmode | MODE_RUNES;
        //mapname = "mapname";
        utils_set_cvar("timelimit", crx_timelimit);
        cvar_set("hostname", ADMIN_CTF_PUBLIC_MODE_STRING);
        


  crx_playmode = crx_playmode | MODE_NO_SPAWN_PROTECT;
  
  utils_set_cvar("samelevel", crx_playmode);
  }

  if (crx_playmode & MODE_DEDICATED_SERVER)
  {
	crx_overtime = cvar("v_kicktime");
  }

	hookspeedfire = 1200;
	hookspeedpull = 850;   

  // Set global variables
  crx_player_ids = 1;
  crx_nextcheck = time;
  crx_nextcheck2 = time;
  crx_request = world;
  crx_state = 0;
  //num_spawns = 0;  //moved to worldspawn
  num_starts = 0;
  num_cameras = 0;
  crmod_best_chase_target = world;
  auto_parm1 = 80;
  auto_parm2 = 270;
  auto_parm3 = 20;
  auto_parm4 = 100;
  crx_score_count = 0;

  if (mode_is_public())
  {
    crx_timelimit = cvar("timelimit");
    if (crx_timelimit == 0) crx_timelimit = 8.05;
    if (crx_timelimit < 2) crx_timelimit = 2;
    match_show_timelimit();
  }
  else crx_timelimit = 8.05;

  // show mode
  mode = utils_get_mode();
  szmode = strings_get_mode(mode);
  cprint2(szmode, " mode\n");

  if (!(crx_playmode & MODE_VOTE))
    crx_playmode = crx_playmode | MODE_VOTE;
};

//
//  S E T  T E A M P L A Y
//
//  Sets the teamplay server variable to show teamplay and "ClanRing4.0".
//  If value = -1 then the teamplay variable is preserved; otherwise it
//  is changed to 'value'.
//
void (float value) crx_set_teamplay =
{
    local string temp;

    if (value != -1)
		teamplay = value;
    temp = ftos(teamplay);
    localcmd5("teamplay \"", temp, "?CRX", bloodrailz_version_number, "M\"\n");
};

//
//  S E T  F R A G L I M I T
//
void (float value) crx_set_fraglimit =
{
    local string temp;
    if (mode_is_public_ctf())
    {
      utils_set_cvar("fraglimit", value);
      fraglimit = cvar("fraglimit");
      temp = ftos(fraglimit);
      localcmd2("fraglimit \"", temp);
    }
    else
    {
      if (value != -1)
        utils_set_cvar("fraglimit", value);
      fraglimit = cvar("fraglimit");
      temp = ftos(fraglimit);
      localcmd2("fraglimit \"", temp);
    }

    if (crx_playmode & MATCH_MODE)
    {
      if (crx_playmode & CTF_MODE)
        localcmd("CTFMatch\"\n");
      else 
		    localcmd("Match\"\n");
    }
    else if (crx_playmode & RACE_MODE)
    {
      if (crx_playmode & CTF_MODE)
        localcmd("CTFPractice\"\n");
      else 
        localcmd("Practice\"\n");
    }

    else if (crx_playmode & DM_PUBLIC_MODE)
      localcmd("TDMPublic\"\n");
    else
    {
      if (crx_playmode & CTF_MODE)
        localcmd("CTFPublic\"\n");
      else 
        localcmd("FFA\"\n");
    }
};


//
//  S E T  A L I A S E S
//
//  This is scheduled using a temporary entity; the client
//  is stored in self.owner.
//
void () crx_set_aliases =
{
  local entity temp;

  temp = self;
  self = self.owner;
    
  // Check for binds
  if (self.style & STYLE_FOUND_BINDINGS)
	{
		self = temp;
		remove(self);
		return;
	}

	stuffcmd(self, "r_particledesc particles\n");  //exec particles config -> moved from progs
	stuffcmd(self, "cl_bobcycle 2.5\n"); //moved from progs
	stuffcmd(self, "alias an0 \"cl_screenangle 0\"\n");
	
	stuffcmd(self, "alias as30 \"cl_screenangle_speed 3.0\"\n");
	stuffcmd(self, "alias as27 \"cl_screenangle_speed 2.7\"\n");
	stuffcmd(self, "alias as25 \"cl_screenangle_speed 2.5\"\n");
	stuffcmd(self, "alias as23 \"cl_screenangle_speed 2.25\"\n");
	stuffcmd(self, "alias as20 \"cl_screenangle_speed 2.0\"\n");
	
	stuffcmd(self, "alias as30n6 \"cl_screenangle_speed 3.0; cl_screenangle -6\"\n");
	stuffcmd(self, "alias as30n3 \"cl_screenangle_speed 3.0; cl_screenangle -3\"\n");
	stuffcmd(self, "alias as30p6 \"cl_screenangle_speed 3.0; cl_screenangle 6\"\n");
	stuffcmd(self, "alias as30p3 \"cl_screenangle_speed 3.0; cl_screenangle 3\"\n");
	
	stuffcmd(self, "alias as20n6 \"cl_screenangle_speed 2.0; cl_screenangle -6\"\n");
	stuffcmd(self, "alias as25n12 \"cl_screenangle_speed 2.5; cl_screenangle -12\"\n");
	stuffcmd(self, "alias as27n18 \"cl_screenangle_speed 2.7; cl_screenangle -18\"\n");
	
	stuffcmd(self, "alias as20p6 \"cl_screenangle_speed 2.0; cl_screenangle 6\"\n");
	stuffcmd(self, "alias as25p12 \"cl_screenangle_speed 2.5; cl_screenangle 12\"\n");
	stuffcmd(self, "alias as27p18 \"cl_screenangle_speed 2.7; cl_screenangle 18\"\n");

	stuffcmd(self, "alias as25n5 \"cl_screenangle_speed 2.5; cl_screenangle -5\"\n");
	stuffcmd(self, "alias as25p5 \"cl_screenangle_speed 2.5; cl_screenangle 5\"\n");
	
	stuffcmd(self, "alias spd00 \"cl_forwardspeed 0; cl_sidespeed 0\"\n");
	stuffcmd(self, "alias spd01 \"cl_forwardspeed 200; cl_sidespeed 350\"\n");
	
	
	stuffcmd(self, "alias pcis01 \"cl_forwardspeed 200; cl_sidespeed 350; r_particledesc particles; cl_bob 0.0032; an0\"\n");
	stuffcmd(self, "alias hkv01 \"cl_bob 0.0032; cl_screenangle_speed 2.25; cl_screenangle 0\"\n");
	
	stuffcmd(self, "alias mclok01 \"scr_matchclock 2; scr_matchclockscale 3.4; scr_matchclock_y 86.5; scr_matchclock_x 72.7\"\n");  

	self.style = self.style | STYLE_FOUND_BINDINGS;

  // remove the temporary entity
  self = temp;

	self.nextthink = time + 0.5;
};

//
//  P R E  S E T  A L I A S E S
//
void () crx_pre_set_aliases = 
{
	//sprint(self.owner, "_Sending aliases...\n");
	
	//sprint(self.owner, "use -zone 512 if quake crashes\n");

    self.think = crx_set_aliases;
    self.nextthink = time + 2.5;
};

//
//  I N I T  T H I N K
//
//  Called 0.2 seconds after a client connects.  Plays the init sound
//  and schedules the aliases to be sent.
//
void () crx_init_think =
{
  local entity temp;
  temp = self;
  self = self.owner;
  if (!(crx_playmode & MATCH_MODE) ||	!(crx_state & STATE_MATCH_STARTED))
		sound(self, CHAN_AUTO, "misc/br_init.wav", 1, ATTN_NONE);
	if (utils_illegal_name(self.netname))
		stuffcmd(self, "name player\n");

  self = temp;
  self.think = crx_pre_set_aliases;
  self.nextthink = time + 1.5;
};

//
//  S H O W  M O D E
//
//  Show mode and help info to a player after they connect.
//
void () crx_show_mode =
{
    if(self.owner.classname == "dummy") return;
     
    sprint2(self.owner, br_version, "\n");
    if (crx_playmode & MATCH_MODE)
    {
		if (crx_playmode & CTF_MODE)	sprint(self.owner, "ctf match mode - help-match for help\n");
		else 	sprint(self.owner, "match mode - help-match for help\n");
    }
    else if (crx_playmode & RACE_MODE)
    {
		if (crx_playmode & CTF_MODE)	sprint(self.owner, "ctf practice mode\n");
		else	sprint(self.owner, "Race mode\n\n------------------\n");
    }
    else if (crx_playmode & DM_PUBLIC_MODE)	sprint(self.owner, "public tdm mode\n");
    else
    {
		if (crx_playmode & CTF_MODE)	sprint(self.owner, "public ctf mode\n");
		else						sprint(self.owner, "FFA mode\n");
    }
    remove(self);
};

//
//  C L I E N T  C O N N E C T
//
//  Called from ClientConnect in Client.qc when a client enters the
//  server.  This occurs when the client first connects over the network
//  and every time a new level is started.
//
void () crx_client_connect =
{
  local float newplayer = 0;
  if ((parm10 & STYLE_NEW_CLIENT) > 0)
  {
		// This is a new client (just connected over the network)
    newplayer = 1;

    // Show the MOTD
		motd_create();
		utils_make_scheduled_event(crx_init_think, 0.5);

		// Give the player a unique ID
		parm11 = crx_player_ids;
		crx_player_ids = crx_player_ids + 1;
		if (crx_player_ids > 65535)
			crx_player_ids = 1;

		// Get rid of the new client flag
		parm10 = parm10 - STYLE_NEW_CLIENT;

		// Set default observer flags
		parm12 = OBSERVER_TOURNEY | OBSERVER_FLY;

    parm13 = 0;

		// Show the status for people who log the console
		localcmd("status\n");
  }

	// Check to see if there is a scoreboard conflict
	if (crx_playmode & MATCH_MODE || (mode_is_public()))
		score_client_connect();
  
  utils_make_scheduled_event(crx_show_mode, 0.5);
  self.cnt = CONST_MAX_SUICIDES;  // numer of suicides allowed
  self.finaldest_y = 0;    // used for pinging
  self.owner = world;      // no ghost
  self.trigger_field = world; // last spawn point
  self.use = SUB_Null;
  self.style = 0;
	self.delayed_impulse = 0;
	self.crmod_cam_delay = 0;
	self.crmod_did_damage = time - 15;
	self.crmod_lastkill = time - 30;
	self.attack_finished = time - 10;
  self.hudspace = parm14;

	// This is to prevent a condition where one player is another player's
	// movetarget, which can confuse the auto module.
	self.movetarget = world;        
	
    parm10 = parm10 - (parm10 &
		(STYLE_READY | STYLE_KICK_CONFIRM | STYLE_MOTD | STYLE_SCOREBOARD | STYLE_CONFIRM_LEAVE));

  if ((mode_is_public()) && (newplayer == 0))
  {
    //public - keep team between maps
    if ((parm13 & PF_TEAM_BLUE) || (parm13 & PF_TEAM_RED))
    {
      parm10 |= STYLE_READY;
      parm13 = parm13 - (parm13 & (PF_MIDGAME_JOIN | PF_FIRST_SPAWN |
        PF_ITEM_RUNE_MASK | PF_ITEM_RUNE1_FLAG | PF_ITEM_RUNE2_FLAG |
        PF_ITEM_RUNE3_FLAG | PF_ITEM_RUNE4_FLAG));
      self.player_flag = parm13;
      self.team = parm13 & PF_TEAM_BLUE ? 14 : 5;
      self.height = self.team - 1;
      self.style |= STYLE_READY;

      if (self.player_flag & PF_TEAM_RED)
        crx_teamsize1 = crx_teamsize1 + 1;
      else
        crx_teamsize2 = crx_teamsize2 + 1;
    }
  }
  
};

//
//  C L I E N T  D I S C O N N E C T
//
//  Called from ClientDisconnect in Client.qc when a client leaves.
//
void () crx_client_disconnect =
{
    self.style = self.style - (self.style & STYLE_CONNECTED);
    self.finaldest_x = -30;     // Used to test for disconnected players
    self.crmod_chase_score = CONST_NEGINF;  // make sure they don't have some high rating that can't be beat by the other players

    // Check to see if anyone was observing this client;
    observer_disconnect_notify(self);

    // If we're in match mode, then inform match and score modules
    if (crx_playmode & MATCH_MODE || (mode_is_public()))
    {
      match_disconnect_notify(self);
      score_client_disconnect();

      // Let the admin module know in case there's a kick in progress
      admin_disconnect_notify(self);
    }
};

//
//  B F  T H I N K
//
//  Creates a background flash - used for player spawns.
//
void () crx_bf_think =
{
    stuffcmd(self.owner, "bf\n");
    remove(self);
};

//
//  O B S E R V E R  S T A R T  T H I N K
//
//  This is a hack.. observer_start is being called a second time, 0.6
//  seconds after the first time, to cover a few details that don't make
//  it when the client first connects (such as the observer colour).
//
void () observer_start_think =
{
    local entity oself;

    oself = self;
    self = self.owner;
    if ((self.style & STYLE_OBSERVER) || ((crx_playmode & MATCH_MODE) && !(self.style & STYLE_READY)))
    observer_start();
    self = oself;
    remove(self);
};

//
//  P U T  C L I E N T  I N  S E R V E R
//
//  Called from PutClientInServer in Client.qc
//
void () crx_put_client_in_server =
{
  //bprint4(self.netname, " connected as ", vtos(self.team), "\n");
  /*
  dprint(self.netname);            //debug dprints
  dprint(" has style ");
  dprint(ftos(self.style));
  dprint(" at ");
  dprint(vtos(self.origin));
  dprint("\n");
  dprint(" self.jump_flag = ");
  dprint(ftos(self.jump_flag));
  dprint("\n");
  */
  
  utils_make_scheduled_event(crx_bf_think, 0.1);

 if ((self.style & STYLE_OBSERVER) || ((crx_playmode & MATCH_MODE) && (!(self.style & STYLE_READY))))
  {
    observer_start();
    utils_make_scheduled_event(observer_start_think, 0.6);
  }
  else if (mode_is_public())
  {
    if (self.style & STYLE_READY)
    {
      player_stand1();
      spawn_tdeath (self.origin, self);
      makevectors(self.angles);
      spawn_tfog (self.origin + v_forward*20);
      self.oflags = self.oflags - self.oflags & (OBSERVER_WALK | OBSERVER_FLY | OBSERVER_CHASE | OBSERVER_DEMO | OBSERVER_CAMERA | OBSERVER_AUTO | OBSERVER_ACTIONCAM);
    }
    else
    {
      observer_start();
      utils_make_scheduled_event(observer_start_think, 0.6);
    }
  }
  else
  {
    player_stand1();
    spawn_tdeath (self.origin, self);
    makevectors(self.angles);
    spawn_tfog (self.origin + v_forward*20);
  }

  if (crx_playmode & MODE_NO_HOOK)
  {
    if (self.items & IT_HOOK)
      self.items = self.items - IT_HOOK;
  }
  else
  {
    if (!(self.items & IT_HOOK))
      self.items = self.items | IT_HOOK;
  }

  // Prevent fire-on-respawn (in case player used attack button to respawn)
  self.style = self.style - (self.style & STYLE_OK_TO_SHOOT);
  self.style = self.style | STYLE_CONNECTED;
  self.button0 = 1;
  self.wait = time + 2;    // for periodic checks
  self.finaldest_x = time; // used to check for disconnected clients
  self.lip = 0;
};

//
//  H E L P
//
//  Show general help commands.
//
void () crx_help =
{
  sprint2(self, br_version, "\n");
  sprint(self, "Help commands (type in console):\n");
  sprint(self, " help-info     - server info\n");
  sprint(self, " help-misc     - misc commands\n");
  sprint(self, " help-observer - observer commands\n");
  sprint(self, " help-match    - match mode help\n");
  sprint(self, " help-ctf      - ctf commands and rules\n");
  if (self.style & STYLE_ADMINISTRATOR)
    sprint(self, " help-admin    - admin commands\n");
  sprint(self, "Server Impulses\n");
  sprint(self, " impulse 22     - grappling hook\n");
  sprint(self, " impulse 40     - drop rune\n");
	sprint(self, " commands - list commands/impulses\n");
  sprint(self, "To fix bind and text issues, set cl_filterstuffcmd 0; and reconnect to the server\n");
};


//
//  H E L P  M I S C
//
//  Show misc commands.
//
void () crx_help_misc =
{
    //sprint(self, " admin     - enter admin code\n");
    sprint(self, " sethud    - adjust/disable hud\n");
    sprint(self, " setpowerups   - enable/disable power-ups\n");
    sprint(self, " setATX   - enable/disable ATX mode\n"); 
    sprint(self, " setrunes  - enable/disable runes\n");
    
    sprint(self, " setarmor   - enable/disable armor\n");          
    sprint(self, " setrail   - enable/disable railgun\n");       
    sprint(self, " sethook   - enable/disable hook\n");
    
    sprint(self, " shuffle   - shuffle teams\n");
    sprint(self, " rebalance   - re-balance teams\n");
    sprint(self, " set200   - enable/disable spawning with 200 armor\n");
    
    if (crx_playmode & MODE_VOTE)
    {
      sprint(self, " setmode  - request mode change\n");
      sprint(self, " setmode2 - request more mode changes\n");
    }
    sprint(self, " warp     - request id1/dm map change\n");
    sprint(self, " warp2    - request ctf/ra map change\n");
    //sprint(self, " nogibs   - disable gibs\n");
    //sprint(self, " lowgibs  - set gibs to 'low'\n");
    //sprint(self, " highgibs - set gibs to 'high'\n");
    sprint(self, " motd     - show message of the day\n");
    sprint(self, " commands - list commands/impulses\n");
    sprint(self, " observer - toggle observer mode\n");
    sprint(self, " levels   - list all server levels\n");
    sprint(self, " stats    - summarize statistics\n");
    sprint(self, " killstats  - list player kill stats\n");
    sprint(self, " efficiency - list player efficiency\n");
	  sprint(self, " quadstats  - list player quad stats\n");
	  sprint(self, " autoweapon - toggle smartweapon\n");
	  sprint(self, " ticrate  - view sys_ticrate\n");
};


//
//  C O M M A N D S
//
//  List all commands and impulses.
//
void () crx_commands =
{
  // regular user commands
  //TODO: organize and add impulses
  sprint(self, " help-info | help-server |");
  sprint(self, " help-misc | help-match |");
  sprint(self, " help-observer | help-walk |");
  sprint(self, " help-fly | help-chase |");
  sprint(self, " help-camera | commands |");
  sprint(self, " levels | autoweapon |");
  sprint(self, " admin | motd |");
  sprint(self, " observer | walk |");
  sprint(self, " flyme | chase |");
  sprint(self, " eyecam | camera |");
  sprint(self, " autochase | autocam |");
  sprint(self, " headsup | smooth |");
  sprint(self, " tourney | yes\n");
  sprint(self, " no | ready |");
  sprint(self, " notready | ready? |");
  sprint(self, " unlock | lock |");
  sprint(self, " timerstop | timerstart |");
  sprint(self, " +teamscores | -teamscores |");
  sprint(self, " timelimit5 | timelimit10 |");
  sprint(self, " timelimit15 | timelimit20 |");
  sprint(self, " timelimit25 | timelimit30 |");
  sprint(self, " fraglimit15 | fraglimit50 |");
  sprint(self, " fraglimit120 | setrounds |");
  sprint(self, " warp | warp2 |");
  sprint(self, " ghostcode | ghost |");
  sprint(self, " score | nogibs |");
  sprint(self, " set200 | rebalance | sethud |");
  sprint(self, " setpowerups | setatx |");
  sprint(self, " shuffle | setrunes |");
  sprint(self, " setrail | setarmor |");
  sprint(self, " sethook | setmode | setmode2 |");
  sprint(self, " efficiency | stats |");
  sprint(self, " killstats | quadstats |");
  sprint(self, " obits | ticrate\n");

  // admin commands
  if (self.style & STYLE_ADMINISTRATOR)
  {
    sprint(self, " help-admin | force\n");
    sprint(self, " setcharge | kick!\n");
    sprint(self, " abort | ghostlist\n");
    sprint(self, " modevote | spot\n");
    sprint(self, " nextspawn | makespawn\n");
    sprint(self, " nextcam | makecam\n");
  }
  sprint(self, "\n");
};

//  T I C R A T E
//
void () crx_ticrate = 
{
	if (crx_playmode & MODE_DEDICATED_SERVER)
	{
		local float ticrate;

    ticrate = my_ticrate;
		//ticrate = cvar("sys_ticrate");
		sprint(self, "sys_ticrate = ");
		utils_print_floatn(ticrate, 3);
	}
	else
		sprint(self, "This is not a dedicated server\n");
};

//
//  I M P U L S E
//
//  Called from PlayerPreThink or observer_pre_think
//
void () crx_impulse =
{
	if (self.impulse == 37)                   //Antilag
		client_responsetime_show();
	else if (self.impulse == 38) 
		client_responsetime_set();
	else if (self.impulse == 39) // used for testing for disconnects (was 104)
		self.finaldest_x = time;
	else if (self.impulse < 100)
	{
    if (self.impulse == 40 && (crx_playmode & MODE_RUNES))
    {
      if (!(self.player_flag & PF_ITEM_RUNE_MASK))
      {
        if(self.rune_bang == 10) self.rune_bang =11;
        else if(self.rune_bang == 20) self.rune_bang =22;
        else if(self.rune_bang == 30) self.rune_bang =33;
        else if(self.rune_bang == 40) self.rune_bang =44;
      }

      if (self.player_flag & PF_ITEM_RUNE_MASK)
        rune_drop();
    }
    else if (self.impulse == 70) crx_init_set_hud();
	}
  else if ((self.impulse >= 120 && self.impulse <= 139))
  {
      match_impulse();
  }
  else if ((self.impulse >= 140 && self.impulse <= 159))
		observer_impulse();		
  else if (self.impulse >= 190)
		admin_impulse();
  else if (self.impulse == 149 && self.style & STYLE_OBSERVER)     //BR_CAM
		{}
  else if (self.impulse == 105)
		crx_help_misc();
  else if (self.impulse == 106) // list commands and impulses
		crx_commands();
  else if (self.impulse == 107) // list valid levels
		{}
  else if (self.impulse == 108) // start entering the admin code
		admin_start_code();
  else if (self.impulse == 109) // show the MOTD
		motd_create();
  else if (self.impulse == 110) 
		{/*call function to show killstats*/}
  else if (self.impulse == 111)
		{/*call function to show eff stats*/}
  else if (self.impulse == 112) // show summary statistics
		{/*call function to show stats*/}
  else if (self.impulse == 113) 
		{}
	else if (self.impulse == 114)
		utils_toggle_flag(STYLE_SMART_WEAPON, "Smart weapon switching");
  else if (self.impulse == 117) // show version info
		{}
	else if (self.impulse == 118)
		crx_ticrate();
  else if (self.impulse == 119)
  {
		//used to be stuff aliases
  }
  else if (self.impulse >= 115 && self.impulse <= 116) // yes/no
  {
		if (self.style & STYLE_KICK_CONFIRM)
			admin_confirm_kick_response(116 - self.impulse);
		else if (self.style & STYLE_CONFIRM_LEAVE)
			observer_confirm_leave_response(116 - self.impulse);
		else
			vote_impulse();
  }
 // else
		//sprint(self, "type 'help-server' in console for help\n");

  self.impulse = 0;
};

//
//  K I C K  P L A Y E R
//
void (entity client) crx_kick_player =
{
  local string temp;
	local entity oself;

  temp = ftos(client.colormap);
  localcmd3("kick # ", temp, "\n");
	oself = self;
	self = client;
	ClientDisconnect();
	self = oself;
};

//
//  C L I E N T  S U I C I D E
//
//  Called from ClientKill in Client.qc.  Checks to see if the player
//  has exceeded their suicide limit and returns either 0 or 1 accordingly.
//
float () crx_client_suicide =
{
 // local string temp;

  // Always OK for admins or practice mode
  if (self.style & STYLE_ADMINISTRATOR)
  return 0;

  self.cnt = self.cnt - 1;
  if (self.cnt < 0)
  {
		// too many suicides
		//if (self.cnt == -1) // only want to do this stuff once
		//{
		//	bprint2(self.netname, " kicked for suiciding\n");
		//	cprint3("\"", self.netname, " kicked for suiciding\"\n");
		//	crx_kick_player(self);
		//}
		//return 1;
  }
  //temp = ftos(self.cnt);
  //if (sprint3(self, "you have ", temp, " suicides remaining\n");
  return 0;
};

//
//  P E R I O D I C  C H E C K S
//
//  Do various checks every second.  Called from PlayerPreThink in
//  Client.qc.
//
void () crx_periodic_checks =
{
	if (!(self.style & STYLE_CONNECTED))
		return;

	if (utils_illegal_name(self.netname))
	{
		// Let's be fairly draconian about this
		bprint("Player kicked for illegal name\n");
		cprint("\"Player kicked for illegal name\"\n");
		crx_kick_player(self);
		return;
	}

  if (self.style & STYLE_OBSERVER)
  {
		// find the closest teleport
		observer_find_teleport();

		// check for 'squished'
		observer_check_size();
  }
	else
		auto_compute_score();
};

//
//  S T A R T  F R A M E
//
//  Called from StartFrame in World.qc.  This routine performs periodic
//  checks in match mode and checks for server console commands.
//
void () crx_start_frame =
{
  local float command;
  
  if(time < 2) timelimit = cvar("timelimit") * 60;   //make sure timelimit is set early on for the match clock
  
  if (!(crx_playmode & MATCH_MODE))
  {
    if (time >= timelimit)
    {
      if (timelimit && !gameover)
      NextLevel ();
    }
  }

	// Do some maintenance
  if (time >= crx_nextcheck && !gameover)
  {
		local entity player;

		// update variables
		timelimit = cvar("timelimit") * 60;
		fraglimit = cvar("fraglimit");
		teamplay = cvar("teamplay");

		// send out ping to test for disconnected players
    /*
		WriteByte(MSG_ALL, SVC_STUFFCMD);
		WriteString(MSG_ALL, "impulse 39\n");      
    */
		player = find(world, classname, "player");
		while (player)
		{
			if (player.style & STYLE_CONNECTED)
			{
				if (time > player.finaldest_x + 20)
				{
					// Automatically kick player
          /*
					bprint3("No response from ", player.netname, "\n");
					cprint3("\"No response from ", player.netname, "\"\n");
					crx_kick_player(player);
          */
				}
			}
			else
			{
				// remove clutter
				player.model = string_null;
				player.solid = SOLID_NOT;
			}

			player = find(player, classname, "player");
		}

  crx_nextcheck = time + 5;
  }

  if (time >= crx_nextcheck2 && !gameover)
	{
		auto_find_best();
		crx_nextcheck2 = time + 1;
	}

  my_ticrate = cvar("sys_ticrate");
  if (!my_ticrate)	 my_ticrate = .016666667;
   // my_ticrate = .025;


  // Check for a console command
  command = cvar("temp1");
  cvar_set("temp1", "0");
  if (command)
    console_command(command);
};

void () show_rules_prematch =
{
	/*
	local float temp, timervar;
	local string s0="", s1="", s2="", s3="", s4="", s5="", s6="";


    if (crx_state & STATE_MATCH_STARTED || crx_match_timer.count < 0)
    {
      centerprint(self, "\n");
      return;
    }
    timervar = crx_match_timer.count;
  

  if (timervar > 15)	s0 = "\n\n";   //021824
  else
	  s0 = strings_countdown(timervar);

	if (timervar > 3)
	{
		
		

		if (crx_playmode & MATCH_MODE)
		{
			if (crx_playmode & CTF_MODE) s1 ="-\bctf match mode\b-\n\n";
			else s1 ="-\btdm match mode\b-\n\n";
		}
		else if (crx_playmode & RACE_MODE)
		{
			if (crx_playmode & CTF_MODE) s1 ="-\bctf practice mode\b-\n\n";
			else s1 ="-\b practice mode \b-\n\n";
		}
		else if (crx_playmode & DM_PUBLIC_MODE) return"-\bpublic tdm mode\b-\n\n";
		else
		{
			if (crx_playmode & CTF_MODE) s1 ="-\bpublic ctf mode\b-\n\n";
			else s1 ="-\b  ffa mode  \b-\n\n";
		}
		
		

		temp = crx_timelimit;	
		s2 = strings_timelimit_countdown(temp);
		temp = cvar("fraglimit");
		s3 = strings_fraglimit_countdown(temp);

		temp = cvar("deathmatch");
		if (temp == 1)
			s4 = "                   \n";
		else if (temp == 3 || temp == 2)
			s4 = "                   \n";
		else
			s4 = "               \n";


		s5 = "                                        \n";
		

		if (crx_playmode & MODE_RUNES)
		{
			if (crx_playmode & MODE_NO_HOOK)	s6 = "\bhook        \boff\n\brunes        \bon\n";
			else					s6 = "\bhook         \bon\n\brunes        \bon\n"; 
		}
		else
		{
			if (crx_playmode & MODE_NO_HOOK)	s6 = "\bhook        \boff\n\brunes       \boff\n";
			else					s6 = "\bhook         \bon\n\brunes       \boff\n"; 
		}

		centerprint7(self, s0, s1, s2, s3, s4, s5, s6);
	}
	else
	{
		centerprint(self, s0, "\n\n\n\n\n\n\n\n\n\n\n\n\n");
	}
	*/
};



void () crx_set_hud =
{
    self.use = SUB_Null;
    if (self.finaldest_z > 0)
    {
        self.hudspace = self.finaldest_z - 1;
        sprint(self, "hud spacing set to: ");
        sprint(self, ftos(self.hudspace + 1));
        sprint(self, "\n");
    }
    else
    {
        sprint(self, "Canceled\n");
    }
};

void () crx_init_set_hud =
{
  sprint(self, "hud spacing is currently: ");
  sprint(self, ftos(self.hudspace + 1));
  sprint(self, "\n");
  sprint(self, "\n");
  sprint(self, "hud spacing 1-8 - move the hud down\n");
  sprint(self, "hud spacing   9 - turn the hud off\n");
  sprint(self, "Enter 1-9 to set hud spacing or 0 to cancel:\n");
  self.use = crx_set_hud;
};