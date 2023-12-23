//
// Elohim.qc
//
// This is the main file for CRMod++.  CRMod++ was derived from the
// Elohim server, which is why everything is still called "elohim".
//
// Developed by J.P. Grossman (a.k.a. ůMephistopheles) and Paul Baker, 
//
// Written by J.P. Grossman, modified by bucksh0t.
//
// Client fields used:
//
// General:
//
// .style           - Elohim player flags
// .count           - used for entering password / ghostcode / warplevel
// .cnt             - number of suicides remaining
// .wait            - time to do periodic checks
// .state           - unique player id
// .finaldest_y     - used for pinging
// .height          - used to store player team
// .finaldest_x     - used to test for disconnected players
// .use             - pointer to function to call when a number is entered
// .finaldest_z     - the number that was entered
// .owner           - players's ghost entity
// .enemy           - stores last spawn point/camera location for admins
//
// Statistics:
//
// .dest1_x         - damage fired from bullets
// .dest2_x         - damage done from bullets
// .dest1_y         - damage fired from nails
// .dest2_y         - damage done from nails
// .dest1_z         - damage fired from lightning gun
// .dest2_z         - damage done from lightning gun
// .dest_x          - damage fired from rockets
// .dest_y          - damage done from rockets
// .mangle_x        - number of times killed self
// .mangle_y        - number of times killed teammate
// .mangle_z        - number of times was killed
// .crmod_qdwep_x   - damage done with quad        // CRMOD
// .crmod_qdwep_y   - damage fired with quad       // CRMOD
// .crmod_qdwep_z   - number times quad pickedup   // CRMOD
// .crmod_qdkill_x  - number of enemies killed     // CRMOD
// .crmod_qdkill_y  - number of teammates killed   // CRMOD
// .crmod_qdkill_z  - number of self kills         // CRMOD
//
// Observer mode:
//
// .trigger_field   - closest teleport when observing, last spawn if playing
// .t_width         - activation radius for closest teleport
// .dest            - stores destination for popping forward through doors
// .dest1           - stores velocity for popping forward through doors
// .delay           - time to refresh head's up display for observing
// .speed           - z component of velocity from previous frame (for fly)
// .movetarget      - player being watched in observer mode (world if none)
// .owner           - last spawn point/camera for admins
// .lip             - time to clear display when no target is in line of sight (walk/fly)
// .attack_finished - used to delay before flying through obstacles
//
// Used for setting options:
//
// .delay     - time to update display (shared with observer.qc)
// .pos1_x    - timelimit
// .pos1_y    - fraglimit
// .pos1_z    - mode
// .pos2_x    - gibs
// .pos2_y    - teamplay
// .pos2_z    - noexit
// .worldtype - sys_ticrate
// .aflag     - pausable/quad/pent/ring/mode vote
// .t_length  - which option is currently selected
//
// Scoreboard:
//
// .scoreboard_x  - slot used for team 1
// .scoreboard_y  - slot used for team 2
// .scoreboard_z  - slot used for time remaining
//
// Console variables used:
//
// samelevel    = elohim_playmode - server flags
// v_kickroll   = elohim_level    - level number in user level sequence
// v_kicktime   = elohim_overtime - length of overtime
// temp1                          - console commands
// v_kickpitch                    - used non-destructively for utils_stof
//

// function declarations
void () elohim_load_entities;
void (float vlaue) elohim_set_teamplay;
void (float vlaue) elohim_set_fraglimit;
void () stats_reset;
void () stats_show_killstats;
void () stats_show_efficiency;
void () stats_show_summary;
void () motd_init_world;
void () motd_create;
void () score_init_world;
void () score_client_connect;
void () score_client_disconnect;
void (float command) console_command;
void () console_set_aliases;
void (entity client) observer_disconnect_notify;
void () admin_send_aliases1;
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
float () options_get_mode;
void () execute_changelevel;
void () NextLevel;
void (vector org, entity death_owner) spawn_tdeath;
void () player_stand1;
void() ClientDisconnect;
void (vector org) spawn_tfog;
void () rune_drop;

//void () arena_main_loop;
//void () rocket_arena_main_loop;
//void () arena_select_team;
float () mode_is_arena;
entity () SelectFishSpawnPoint;

void () elohim_init_set_hud;
void () stuff_aliases1;
void () crx_connect_event;     //Buckshot NQ compat


void() client_responsetime_show;

void() client_responsetime_set;



//
//  I N I T  W O R L D
//
//  Called from InitWorld in World.qc
//
void () elohim_init_world =
{
	local float mode;
	local string szmode;
  
	//FTE check START
  
	if (cvar("pr_checkextension"))
	{
		if (checkextension("QUAKE_EX"))  //additional FTE server check
		{
			fte_server = 0;
		}
		else
		{
			fte_server = 1;
		}
	}
  
  //FTE check END
  


  elohim_version = "BR 12-2-23 .X1"; 
  elohim_version_info = "Bloodrails CRx";
  bloodrails_version_number = "12-2-23";   // CRMOD - string to be used throughout
          //         code to show version number.

  // Initialize user map names, MOTD, and hotspots, etc..
  userdefs_init_world();
  motd_init_world();
	score_init_world();
  
  // Hack to allow console to emulate an administrator
	world.style = ELOHIM_ADMINISTRATOR;

  // Precache sound used when players connect
  precache_sound("legacy/wizard_wsight.wav");

  // Get/set console variables
  elohim_playmode = cvar("samelevel");
  if (mode_is_public_ctf()) 
  {
    teamplay = 4;  
    //teamplay = 2;
  }
  else if ((elohim_playmode & ELOHIM_MATCH_MODE) || (elohim_playmode & DM_PUBLIC_MODE))
    teamplay = 2;
  else
    teamplay = cvar("teamplay");

//??
  elohim_set_teamplay(-1);


  if ((elohim_playmode & DM_PUBLIC_MODE) || (mode_is_public_ctf() == TRUE))
    elohim_set_fraglimit(120);
  
  else if (mode == ADMIN_NORMAL_MODE)
    elohim_set_fraglimit(40);    //FFA fraglimit is 40
  //else
    //elohim_set_fraglimit(-1);

  // Check to see if we need to initialize the server
  if (!(elohim_playmode & ELOHIM_SERVER_INITIALIZED))
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
    elohim_playmode = elohim_playmode | ELOHIM_DEDICATED_SERVER;
  }
  else
  {
    cprint("Initializing listen server...\n");
    utils_set_cvar("ambient_fade", temp2);
  }

  // Set aliases for console commands
  console_set_aliases();

  // Initialize global variables
  if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
  {
    cvar_set("v_kickroll", "0");  // elohim_level
    cvar_set("v_kicktime", "0");  // elohim_overtime
  }
  serverflags = 0;
  elohim_playmode = elohim_playmode | ELOHIM_SERVER_INITIALIZED;
   elohim_playmode = elohim_playmode | CLANRING_CTF_MODE;           //default mode
   if (!(elohim_playmode & CLANRING_RUNES))
            elohim_playmode = elohim_playmode | CLANRING_RUNES;
        //mapname = "mapname";
        utils_set_cvar("timelimit", elohim_timelimit);
        cvar_set("hostname", ADMIN_CTF_PUBLIC_MODE_STRING);
        
 // elohim_playmode = elohim_playmode | ELOHIM_NO_SPOOGE;
//  //test
//  elohim_playmode |= ELOHIM_MATCH_MODE;
  elohim_playmode = elohim_playmode | ELOHIM_EXTENDED_OBITS;
  elohim_playmode = elohim_playmode | ELOHIM_NO_SPAWN_PROTECT;
  
  utils_set_cvar("samelevel", elohim_playmode);
  }

  if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
  {
  elohim_level = cvar("v_kickroll");
  elohim_overtime = cvar("v_kicktime");
  }

	hookspeedfire = 1200;
	hookspeedpull = 850;   

  // Set global variables
  elohim_player_ids = 1;
  elohim_devparam = 0;
  elohim_nextcheck = time;
  elohim_nextcheck2 = time;
  elohim_request = world;
  elohim_levelcount = 0;
  elohim_lastcount = 0;
  elohim_state = 0;
  //elohim_num_spawns = 0;  //moved to worldspawn
  elohim_num_starts = 0;
  elohim_num_cameras = 0;
  elohim_debug_client = world;
  crmod_best_chase_target = world;
  auto_parm1 = 80;
  auto_parm2 = 270;
  auto_parm3 = 20;
  auto_parm4 = 100;
  elohim_score_count = 0;

  if (mode_is_public())
  {
    elohim_timelimit = cvar("timelimit");
    if (elohim_timelimit == 0)
      elohim_timelimit = 15;
    if (elohim_timelimit < 2)
      elohim_timelimit = 2;
    match_show_timelimit();
  }
  else
    elohim_timelimit = 15;

  // show mode
  mode = options_get_mode();
  szmode = strings_get_mode(mode);
  cprint2(szmode, " mode\n");

  //localcmd("exec crxmod.cfg\n");
  //localcmd("exec brcrxmod.cfg\n");

  if (!(elohim_playmode & ELOHIM_MODE_VOTE))
    elohim_playmode = elohim_playmode | ELOHIM_MODE_VOTE;

  // schedule the entities for a bit later so that they don't
  // interfere with the password
  if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
    utils_make_scheduled_event(elohim_load_entities, 0.2);
};

//
//  L O A D  C A M E R A S
//
//  This is scheduled after elohim_load_entities.
//
void () elohim_load_cameras =
{
    return;
    // cprint3("\"Searching for optional file cameras/", mapname, ".cam\"\n");
    // cprint("\"It is OPTIONAL - there is nothing wrong if it can't be found.\"\n");
    // localcmd3("exec cameras/", mapname, ".cam;wait\n");
    // remove(self);
};

//
//  L O A D  E N T I T I E S
//
void () elohim_load_entities =
{
    return;
    // cprint3("\"Searching for optional file entities/", mapname, ".ent\"\n");
    // cprint("\"It is OPTIONAL - there is nothing wrong if it can't be found.\"\n");
    // localcmd3("exec entities/", mapname, ".ent;wait\n");
    // self.think = elohim_load_cameras;
    // self.nextthink = time + 0.2;
};

//
//  S E T  T E A M P L A Y
//
//  Sets the teamplay server variable to show teamplay and "ClanRing4.0".
//  If value = -1 then the teamplay variable is preserved; otherwise it
//  is changed to 'value'.
//
void (float value) elohim_set_teamplay =
{
    local string temp;

    if (value != -1)
		teamplay = value;
    temp = ftos(teamplay);
    localcmd5("teamplay \"", temp, "?CRX", bloodrails_version_number, "M\"\n");
};

//
//  S E T  F R A G L I M I T
//
//  Sets the fraglimit server variable to show fraglimit, "CRMod++",
//  and either "FFA", "Practice" or "Match" depending on the current mode.
//  If value = -1 then the fraglimit variable is preserved; otherwise it
//  is changed to 'value'.
//
void (float value) elohim_set_fraglimit =
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
    if (elohim_playmode & CLAN_ARENA_MODE)
    {
      utils_set_cvar("fraglimit", value);
      fraglimit = cvar("fraglimit");
      temp = ftos(fraglimit);
      localcmd2("fraglimit \"", temp);

      cvar_set("fraglimit", "0");
    }
    else
    {
      if (value != -1)
        utils_set_cvar("fraglimit", value);
      fraglimit = cvar("fraglimit");
      temp = ftos(fraglimit);
      localcmd2("fraglimit \"", temp);
    }

    if (elohim_playmode & ELOHIM_MATCH_MODE)
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        localcmd("CTFMatch\"\n");
      else 
		    localcmd("Match\"\n");
    }
    else if (elohim_playmode & ELOHIM_PRACTICE_MODE)
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        localcmd("CTFPractice\"\n");
      else 
        localcmd("Practice\"\n");
    }
    else if (elohim_playmode & CLAN_ARENA_MODE)
      localcmd("ClanArena\"\n");
    else if (elohim_playmode & ROCKET_ARENA_MODE)
      localcmd("RocketArena\"\n");
    else if (elohim_playmode & DM_PUBLIC_MODE)
      localcmd("TDMPublic\"\n");
    else
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        localcmd("CTFPublic\"\n");
      else 
        localcmd("FFA\"\n");
    }
};

void () stuff_aliases =
{
  //sprint3(self, "Sending ", elohim_version, " bindings\n");
  stuffcmd(self, "seta scr_usekfont 0;\n");

  //sprint(self, "Sending aliases...\n");
  sprint(self, "_Aliases sent!\n");

  // Set aliases

  
  stuffcmd(self, "alias dbinfo impulse 40\n");    // undocumented debug command
  stuffcmd(self, "alias dbflags impulse 41\n");   // undocumented debug command
  stuffcmd(self, "alias dbvars impulse 42\n");    // undocumented debug command
  stuffcmd(self, "alias dbcvar impulse 43\n");    // undocumented debug command
  stuffcmd(self, "alias dbclient impulse 44\n");  // undocumented debug command
  stuffcmd(self, "alias dbcflags impulse 45\n");  // undocumented debug command
  stuffcmd(self, "alias dbparm1 impulse 46\n");   // undocumented debug command
  stuffcmd(self, "alias dbparm2 impulse 47\n");   // undocumented debug command
  stuffcmd(self, "alias dbparm3 impulse 48\n");   // undocumented debug command
  stuffcmd(self, "alias dbparm4 impulse 49\n");   // undocumented debug command
  stuffcmd(self, "alias dbparms impulse 50\n");   // undocumented debug command
  stuffcmd(self, "alias dbhelp impulse 59\n");	// undocumented debug command
  stuffcmd(self, "alias chase_act1ve say chase_active has been disabled on this server.\n");  // CRMOD cheat fix
  stuffcmd(self, "alias sethud impulse 70\n");
  stuffcmd(self, "alias help-server impulse 100\n");
  stuffcmd(self, "alias help-observer impulse 101\n");
  stuffcmd(self, "alias help-ctf impulse 102\n");
  stuffcmd(self, "alias help-misc impulse 105\n");
  stuffcmd(self, "alias commands impulse 106\n");
  stuffcmd(self, "alias levels impulse 107\n");
  stuffcmd(self, "alias warp impulse 190\n");
  stuffcmd(self, "alias warp2 impulse 191\n");
  stuffcmd(self, "alias warp3 impulse 192\n");
  stuffcmd(self, "alias admin impulse 108\n");
  stuffcmd(self, "alias motd impulse 109\n");
  stuffcmd(self, "alias killstats impulse 110\n");
  stuffcmd(self, "alias efficiency impulse 111\n");
  stuffcmd(self, "alias eff impulse 111\n");                  // CRMOD - so people don't have to spell out efficiency
  stuffcmd(self, "alias stats impulse 112\n");
  stuffcmd(self, "alias quadstats impulse 113\n");    // CRMOD - new impulse
  stuffcmd(self, "alias autoweapon impulse 114\n");
  stuffcmd(self, "alias aw impulse 114\n");
  stuffcmd(self, "alias help-info impulse 117\n");
  stuffcmd(self, "alias ticrate impulse 118\n");
  stuffcmd(self, "alias yes impulse 115\n");
  stuffcmd(self, "alias no impulse 116\n");
  stuffcmd(self, "alias ready impulse 120\n");
  stuffcmd(self, "alias green color 3\n");
  stuffcmd(self, "alias red color 4\n");
  stuffcmd(self, "alias yellow color 12\n");
  stuffcmd(self, "alias blue color 13\n");
  stuffcmd(self, "alias notready impulse 121\n");
  stuffcmd(self, "alias unlock impulse 122\n");
  stuffcmd(self, "alias ready? impulse 123\n");
  stuffcmd(self, "alias timerstop impulse 124\n");
  stuffcmd(self, "alias timerstart impulse 125\n");
  stuffcmd(self, "alias ghostcode impulse 126\n");
  stuffcmd(self, "alias ghost impulse 127\n");
  stuffcmd(self, "alias score impulse 128\n");
  stuffcmd(self, "alias help-match impulse 129\n");
  stuffcmd(self, "alias lock impulse 130\n");
  stuffcmd(self, "alias +teamscores impulse 131\n");
  stuffcmd(self, "alias -teamscores impulse 132\n");
  stuffcmd(self, "alias observer impulse 140\n");
  stuffcmd(self, "alias walk impulse 141\n");
  stuffcmd(self, "alias flyme impulse 142\n");
  stuffcmd(self, "alias chase impulse 143\n");
  stuffcmd(self, "alias chasecam impulse 143\n");
  //stuffcmd(self, "alias headsup impulse 148\n");
  stuffcmd(self, "alias eyecam impulse 149\n");
  stuffcmd(self, "alias help-walk impulse 144\n");
  stuffcmd(self, "alias help-fly impulse 145\n");
  stuffcmd(self, "alias help-chase impulse 146\n");
  stuffcmd(self, "alias tourney impulse 151\n");              // CRMOD - enables tournament mode chasecam
  stuffcmd(self, "alias camera impulse 153\n");               // CRMOD - sets camera mode
  stuffcmd(self, "alias autocam impulse 154\n");              // CRMOD - autocam
  stuffcmd(self, "alias autocamera impulse 154\n");   // CRMOD - autocam
  stuffcmd(self, "alias quaketv impulse 154\n");              // CRMOD - autocam
  stuffcmd(self, "alias autochase impulse 155\n");    // CRMOD - autochase
  stuffcmd(self, "alias help-camera impulse 156\n");  // CRMOD - camera help
  stuffcmd(self, "alias setmode impulse 208\n");
  stuffcmd(self, "alias setmode2 impulse 210\n");
  

  
  
  
  
  //stuffcmd(self, "alias sm1 \"echo Smoothing ON ; cl_nolerp 1 ; alias smooth sm0\"\n");       // CRMOD - smooth now uses aliases
  //stuffcmd(self, "alias sm0 \"echo Smoothing OFF ; cl_nolerp 0 ; alias smooth sm1\"\n");  // CRMOD
  //stuffcmd(self, "alias smooth sm1\n");                                                                                                   // CRMOD
  stuffcmd(self, "alias init echo\n");                            // CRMOD - So clients only see 'init' once
};

//
//  S E T  A L I A S E S
//
//  This is scheduled using a temporary entity; the client
//  is stored in self.owner.
//
void () elohim_set_aliases =
{
  local entity temp;

  temp = self;
  self = self.owner;
    
  // Check for binds
  if (self.style & ELOHIM_FOUND_BINDINGS)
	{
		self = temp;
		remove(self);
		return;
	}

  stuff_aliases();

	self.style = self.style | ELOHIM_FOUND_BINDINGS;

  // remove the temporary entity
  self = temp;

	self.nextthink = time + 0.5;
	self.think = admin_send_aliases1;
};

//
//  P R E  S E T  A L I A S E S
//
void () elohim_pre_set_aliases = 
{
	sprint(self.owner, "_Sending aliases...\n");
	
	//sprint(self.owner, "use -zone 512 if quake crashes\n");

    self.think = elohim_set_aliases;
    self.nextthink = time + 2.5;
};

//
//  I N I T  T H I N K
//
//  Called 0.2 seconds after a client connects.  Plays the wizard sound
//  and schedules the aliases to be sent.
//
void () elohim_init_think =
{
  local entity temp;
  temp = self;
  self = self.owner;
  if (!(elohim_playmode & ELOHIM_MATCH_MODE) ||	!(elohim_state & ELOHIM_MATCH_STARTED))
		sound(self, CHAN_AUTO, "legacy/wizard_wsight.wav", 1, ATTN_NONE);
	if (utils_illegal_name(self.netname))
		stuffcmd(self, "name player\n");
	
	// test for binds 
  stuffcmd(self, "ignorethis\n");                     // CRMOD

  self = temp;
  self.think = elohim_pre_set_aliases;
  self.nextthink = time + 1.5;
};

//
//  S H O W  M O D E
//
//  Show mode and help info to a player after they connect.
//
void () elohim_show_mode =
{
    sprint2(self.owner, elohim_version, "\n");
    if (elohim_playmode & ELOHIM_MATCH_MODE)
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        sprint(self.owner, "ctf match mode - help-match for help\n");
      else 
        sprint(self.owner, "match mode - help-match for help\n");
    }
    else if (elohim_playmode & ELOHIM_PRACTICE_MODE)
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        sprint(self.owner, "ctf practice mode\n");
      else
        sprint(self.owner, "practice mode\n");
    }
    else if (elohim_playmode & AIR_ARENA_MODE)
      sprint(self.owner, "airshot mode\n");
    else if (elohim_playmode & CLAN_ARENA_MODE)
      sprint(self.owner, "clan arena mode\n");
    else if (elohim_playmode & ROCKET_ARENA_MODE)
      sprint(self.owner, "rocket arena mode\n");
    else if (elohim_playmode & DM_PUBLIC_MODE)
      sprint(self.owner, "public tdm mode\n");
    else
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        sprint(self.owner, "public ctf mode\n");
      else
		    sprint(self.owner, "FFA mode\n");
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
void () elohim_client_connect =
{
  local float newplayer = 0;
  if ((parm10 & ELOHIM_NEW_CLIENT) > 0)
  {
		// This is a new client (just connected over the network)
    newplayer = 1;
    
    
    if (fte_server)            // Buckshot for NQ compat
    {
      utils_make_scheduled_event(crx_connect_event, 3.5);
    }
    
    
    
    
    


		// Show the MOTD
		motd_create();
		utils_make_scheduled_event(elohim_init_think, 0.5);
		if (elohim_playmode & CRMOD_QSMACK_ON)
			utils_make_scheduled_event(qsmack_detect, 1.5);

		// Give the player a unique ID
		parm11 = elohim_player_ids;
		elohim_player_ids = elohim_player_ids + 1;
		if (elohim_player_ids > 65535)
			elohim_player_ids = 1;

		// Get rid of the new client flag
		parm10 = parm10 - ELOHIM_NEW_CLIENT;

		// Set default observer flags
		parm12 = OBSERVER_TOURNEY | OBSERVER_FLY;

    parm13 = 0;

		// Show the status for people who log the console
		localcmd("status\n");

		stats_reset();
  }

	// Check to see if there is a scoreboard conflict
	if (elohim_playmode & ELOHIM_MATCH_MODE || (mode_is_public()))
		score_client_connect();
		
		
		
  
  utils_make_scheduled_event(elohim_show_mode, 0.5);
  self.cnt = ELOHIM_MAX_SUICIDES;  // numer of suicides allowed
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
		(ELOHIM_READY | ELOHIM_KICK_CONFIRM | ELOHIM_MOTD |
		 ELOHIM_SETTING_OPTIONS | ELOHIM_SCOREBOARD |
		 CRMOD_DETECTING_QSMACK | ELOHIM_CONFIRM_LEAVE));

  if ((mode_is_public()) && (newplayer == 0))
  {
    //public - keep team between maps
    if ((parm13 & PF_TEAM_BLUE) || (parm13 & PF_TEAM_RED))
    {
      parm10 |= ELOHIM_READY;
      parm13 = parm13 - (parm13 & (PF_MIDGAME_JOIN | PF_FIRST_SPAWN |
        PF_ITEM_RUNE_MASK | PF_ITEM_RUNE1_FLAG | PF_ITEM_RUNE2_FLAG |
        PF_ITEM_RUNE3_FLAG | PF_ITEM_RUNE4_FLAG));
      self.player_flag = parm13;
      self.team = parm13 & PF_TEAM_BLUE ? 14 : 5;
      self.height = self.team - 1;
      self.style |= ELOHIM_READY;

      if (self.player_flag & PF_TEAM_RED)
        elohim_teamsize1 = elohim_teamsize1 + 1;
      else
        elohim_teamsize2 = elohim_teamsize2 + 1;
    }
  }
  else if (mode_is_arena())
  {
    if (!((boss.state == CA_MATCH_PLAYING) && (self.arena_flag == AF_CA_READY)))
      parm10 = parm10 | ELOHIM_OBSERVER;
  }
};

//
//  C L I E N T  D I S C O N N E C T
//
//  Called from ClientDisconnect in Client.qc when a client leaves.
//
void () elohim_client_disconnect =
{
    self.style = self.style - (self.style & ELOHIM_CONNECTED);
    self.finaldest_x = -30;     // Used to test for disconnected players
    self.crmod_chase_score = ELOHIM_NEGINF;  // CRMOD make sure they don't have some high rating that can't be beat by the other players

    // Check to see if anyone was observing this client;
    observer_disconnect_notify(self);

    // If we're in match mode, then inform match and score modules
    if (elohim_playmode & ELOHIM_MATCH_MODE || (mode_is_public()) || (mode_is_arena()))
    {
      match_disconnect_notify(self);
      score_client_disconnect();

      // Let the admin module know in case there's a kick in progress
      admin_disconnect_notify(self);
    }

    // Check to see if we were debugging this client
    if (elohim_debug_client == self)
		elohim_debug_client = world;
	
    // CRMOD Qsmack Reset
    self.qsmack_level = 0;
    self.qsmack_trylevel = 0;
    qsmack_statusokay = 0;
    // CRMOD END
};

//
//  B F  T H I N K
//
//  Creates a background flash - used for player spawns.
//
void () elohim_bf_think =
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
void () elohim_observer_start_think =
{
    local entity oself;

    oself = self;
    self = self.owner;
    if ((self.style & ELOHIM_OBSERVER) || ((elohim_playmode & ELOHIM_MATCH_MODE) && !(self.style & ELOHIM_READY)))
    observer_start();
    self = oself;
    remove(self);
};








//
//  P U T  C L I E N T  I N  S E R V E R
//
//  Called from PutClientInServer in Client.qc
//
void () elohim_put_client_in_server =
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
  
  utils_make_scheduled_event(elohim_bf_think, 0.1);

  if ((mode_is_arena() == TRUE) && ((self.arena_flag == AF_CA_DEAD) || (self.arena_flag == AF_CA_WAITING)) || ((boss.state == CA_MATCH_WAITING)))
  {
    observer_start();
    utils_make_scheduled_event(elohim_observer_start_think, 0.6);
  }
  else if ((self.style & ELOHIM_OBSERVER) || (self.style & CRMOD_QSMACK) ||	((elohim_playmode & ELOHIM_MATCH_MODE) && (!(self.style & ELOHIM_READY))))
  {
    observer_start();
    utils_make_scheduled_event(elohim_observer_start_think, 0.6);
  }
  else if (mode_is_public())
  {
    if (self.style & ELOHIM_READY)
    {
      player_stand1();
      spawn_tdeath (self.origin, self);
      makevectors(self.angles);
      spawn_tfog (self.origin + v_forward*20);
      self.oflags = self.oflags - self.oflags & (OBSERVER_WALK | OBSERVER_FLY | OBSERVER_CHASE | OBSERVER_DEMO | OBSERVER_CAMERA | OBSERVER_AUTO | OBSERVER_ACTIONCAM);                   //Bloodrails - debug spawn issue ctf
    }
    else
    {
      observer_start();
      utils_make_scheduled_event(elohim_observer_start_think, 0.6);
    }
  }
  else
  {
    player_stand1();
    spawn_tdeath (self.origin, self);
    makevectors(self.angles);
    spawn_tfog (self.origin + v_forward*20);
  }

  if (elohim_playmode & ELOHIM_NO_HOOK)
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
  self.style = self.style - (self.style & ELOHIM_OK_TO_SHOOT);
  self.style = self.style | ELOHIM_CONNECTED;
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
void () elohim_help =
{
  // local string numsuicides;
  // numsuicides = strings_ftos_gold(ELOHIM_MAX_SUICIDES);

  sprint2(self, elohim_version, "\n");
  sprint(self, "Help commands (type in console):\n");
  sprint(self, " help-info     - server info\n");
  sprint(self, " help-misc     - misc commands\n");
  sprint(self, " help-observer - observer commands\n");
  sprint(self, " help-match    - match mode help\n");
  sprint(self, " help-ctf      - ctf commands and rules\n");
  if (self.style & ELOHIM_ADMINISTRATOR)
    sprint(self, " help-admin    - admin commands\n");
  sprint(self, "Server Impulses\n");
  sprint(self, " impulse 22     - grappling hook\n");
  sprint(self, " impulse 40     - drop rune\n");
	sprint(self, " commands - list commands/impulses\n");
  sprint(self, "To fix bind and text issues, set cl_filterstuffcmd 0; and reconnect to the server\n");
};

//
//  H E L P  C H A N G E
//
//  Show help on how to change levels.
//
void () elohim_help_change =
{
    sprint(self, "Enter the warp command and select from the menu to change maps\n");
    sprint(self, "Enter the episode number and then the map number to initiate a vote\n");
    sprint(self, "--Capture the Flag modes have different item locations in order to balance the bases\n");
    sprint(self, "--Deathmatch modes may have additional power ups which can be voted off\n");
};

//
//  H E L P  M I S C
//
//  Show misc commands.
//
void () elohim_help_misc =
{
    //sprint(self, " admin     - enter admin code\n");
    sprint(self, " sethud    - adjust/disable hud\n");
    sprint(self, " setpowerups   - enable/disable power-ups\n");
    sprint(self, " setATX   - enable/disable ATX mode\n"); 
    sprint(self, " setrunes  - enable/disable runes\n");
    
    sprint(self, " setarmor   - enable/disable armor\n");           //Bloodrails
    sprint(self, " setrail   - enable/disable railgun\n");           //Bloodrails
    sprint(self, " sethook   - enable/disable hook\n");
    
    sprint(self, " shuffle   - shuffle teams\n");
    sprint(self, " rebalance   - re-balance teams\n");
    sprint(self, " set200   - enable/disable spawning with 200 armor\n");
    
    sprint(self, " setrounds - set wins needed in rocket arena\n");
    if (elohim_playmode & ELOHIM_MODE_VOTE)
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

void () ctf_help =
{
  sprint(self, "---ClanRing Capture the Flag---\n");
  sprint(self, "Use impulse 2 or 22 for grappling hook\n");
  sprint(self, "Runes do not need to be activated to take effect.  Use impulse 40 to drop a rune\n");
  sprint(self, "Rune types and effects:\n");
  sprint(self, "Plasma hook (WHITE-RED)- Hook shoots plasma, armor regenerates slowly.\n");
  sprint(self, "Power (BLACK-RED)- Railgun deals splash damage on impact. Shoot the floor!\n");
  sprint(self, "Haste (Blue) - fire weapons faster\n");
  sprint(self, "Death Aura (ORANGE) - Axe deals extra splash damage\n\n");
  sprint(self, "Beyond the normal frags for killing enemies, you receive bonus frags as follows:\n");
  //sprint(self, "1 - kill an enemy near your flag or your team's flag carrier\n");
  sprint(self, "1 - returning the flag\n");
  sprint(self, "1 - your team captures the flag\n");
  sprint(self, "3 - capturing the flag\n\n");
};

//
//  C O M M A N D S
//
//  List all commands and impulses.
//
void () elohim_commands =
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
  if (self.style & ELOHIM_ADMINISTRATOR)
  {
    sprint(self, " help-admin | force\n");
    sprint(self, " setcharge | kick!\n");          // CRMOD - changed spooge to (dis)charge
    sprint(self, " abortmatch | ghostlist\n");
    sprint(self, " modevote | spot\n");
    sprint(self, " nextspawn | makespawn\n");
    sprint(self, " nextcam | makecam\n");
    sprint(self, " qsmack\n");
  }
  sprint(self, "\n");

  elohim_help_change();
};

//
//  L E V E L S
//
//  List all levels recognized by the server.
//
void () elohim_levels =
{
  local float index;
  local string name;

  elohim_help_change();
  sprint(self, "\n");

  // standard levels
  sprint(self, " start, start0, start1, end\n");
  sprint(self, " e1m1-e1m8\n");
  sprint(self, " e2m1-e2m7\n");
  sprint(self, " e3m1-e3m7\n");
  sprint(self, " e4m1-e4m8\n");
  sprint(self, " dm1-dm8\n");
  //ctf
  sprint(self, " ctfstart, ctf1-ctf9, ctf2m1-ctf2m8, ctf3m1-ctf3m9\n");
  //dm
  sprint(self, " aerowalk, ztndm3, ztndm4, ultrav, aggressr, q3dm6qw\n");
  sprint(self, " cmt3, cmt4, skull, schloss, rock, bravado, dm3again\n");
  sprint(self, " longest_yard, baldm6, efdm9, q1_q3tourney2, battery\n");
  sprint(self, " obsidian, timeless, spine\n");
  //ra
  sprint(self, " 23ar-a, 2pyramid, 2towers, arenarg2, arenarg4, arenarg5\n");
  sprint(self, " arenarg6, arenax, arenazap, arendm1a, arenrg3a, arma4\n");	
  sprint(self, " barena1, basarena, bbarena2, bunmoo3, bunski, chamber1\n");
  sprint(self, " crandome, dm2arena, dom2_1ra, egyptra, football, gear8\n");
  sprint(self, " gnurena, hill20, iarena2, id3, lowgrav, marena2, marena3\n");
  sprint(self, " marena4, mayan1, nilsrar3, pen2, pitarena, ptucket\n");
  sprint(self, " ra_funkf, rarena3, rgarden, soyarena, terrain2, uarena1\n");
  sprint(self, " unholy, xarena3, yard1, boom, midair, endif\n");

  // user defined levels
  index = 0;
  while (index < 10)
  {
		name = array_get_user_map(index);
		if (name != "")
			sprint3(self, " ", name, "\n");
		index = index + 1;
  }
};

//
//  P I N G  R E P L Y
//
//  Called when a client responds to a manual ping via impulse 38 (was 103).
//
void () elohim_ping_reply =
{
    cprint3("reply from \"", self.netname, "\"\n");
    self.finaldest_y = time;
};

//
//  B A D  I M P U L S E
//
//  Seems like some people get stuck with the old clanring bindings.
//  Let them know that something ain't right.
//
void () elohim_bad_impulse =
{
    sprint(self, "You have entered an invalid impulse.\n");
    sprint(self, "Your bindings may be incorrect - try\n");
    sprint(self, "reconnecting to the server.\n");
};

//
//  V E R S I O N  I N F O
//
void () elohim_vinfo =
{
    sprint2(self, elohim_version_info, "\n");
    sprint(self, "Adapted from the Elohim/Clan Ring Team Deathmatch Server\n");
    sprint(self, "Modified to include Capture the Flag, Clan Arena and Rocket Arena\n");
};

//
//  T I C R A T E
//
void () elohim_ticrate = 
{
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
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
void () elohim_impulse =
{
  if (self == elohim_debug_client)
  {
		local string temp;
		temp = ftos(self.impulse);
		cprint3("elohim impulse ", temp, "\n");
  }

	// CRMOD Qsmack
	if (self.style & CRMOD_DETECTING_QSMACK)
		qsmack_detecting();
	
	/*
	if (self.impulse == 7)
	{
			if (self.button_press_display_is_off == 1) self.button_press_display_is_off =0;
			else if (self.button_press_display_is_off == 0) self.button_press_display_is_off =1;
	}
	*/
	
		
	if (self.impulse == 37)                   //Antilag
		client_responsetime_show();
	else if (self.impulse == 38) 
		client_responsetime_set();

		
		
	else if (self.impulse == 39) // used for testing for disconnects (was 104)
		self.finaldest_x = time;
	else if (self.impulse < 100)
	{
    if ((self.impulse == 40 && (elohim_playmode & CLANRING_RUNES))    ||    (self.impulse == 40 && (elohim_playmode & ELOHIM_PRACTICE_MODE))  )
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
        
      if(elohim_playmode & ELOHIM_PRACTICE_MODE)
      {
	self.shield_time = 0;
	self.shield_recharge_time = 1;
	
	self.my_previous_time = 0;
	self.racing_on = 0;
	racing_on_global = 0;
	countdown = 0;
	countdown_ct = 0;
	ClientKill();
	}
    }
		else if ((self.impulse >= 40) && (self.impulse <= 59))
			debug_impulse();
    else if (self.impulse == 70)
      elohim_init_set_hud();
		else
			qsmack_impulse();
	}
  // CRMOD END
  else if ((self.impulse >= 120 && self.impulse <= 139))
  {
      match_impulse();
  }
  else if ((self.impulse >= 140 && self.impulse <= 159))
		observer_impulse();		
  else if (self.impulse >= 190)
		admin_impulse();
		
  else if (self.impulse == 149 && self.style & ELOHIM_OBSERVER)     //BR_CAM
		{}
  else if (self.impulse == 101 && self.style & ELOHIM_OBSERVER) 
		{}
  else if (self.impulse == 102 && self.style & ELOHIM_OBSERVER) 
		{}
  else if (self.impulse == 103 && self.style & ELOHIM_OBSERVER) 
		{}
		
  else if (self.impulse == 105)
		elohim_help_misc();
  else if (self.impulse == 106) // list commands and impulses
		elohim_commands();
  else if (self.impulse == 107) // list valid levels
		elohim_levels();
  else if (self.impulse == 108) // start entering the admin code
		admin_start_code();
  else if (self.impulse == 109) // show the MOTD
		motd_create();
  else if (self.impulse == 110) 
		stats_show_killstats();
  else if (self.impulse == 111)
		stats_show_efficiency();
  else if (self.impulse == 112) // show summary statistics
		stats_show_summary();
  else if (self.impulse == 113) // CRMOD - show quad statistics
		return;
	else if (self.impulse == 114)
		utils_toggle_flag(CRMOD_SMART_WEAPON, "Smart weapon switching");
  else if (self.impulse == 117) // show version info
		elohim_vinfo();
	else if (self.impulse == 118)
		elohim_ticrate();
  else if (self.impulse == 119)
  {
		stuff_aliases();
		stuff_aliases1();
  }
  else if (self.impulse >= 115 && self.impulse <= 116) // yes/no
  {
		if (self.style & ELOHIM_KICK_CONFIRM)
			admin_confirm_kick_response(116 - self.impulse);
		else if (self.style & ELOHIM_CONFIRM_LEAVE)
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
void (entity client) elohim_kick_player =
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
//  has exceeded their suicide limit and returns either ELOHIM_SUICIDE_OK
//  or ELOHIM_TOO_MANY_SUICIDES accordingly.
//
float () elohim_client_suicide =
{
 // local string temp;

  // Always OK for admins or practice mode
  if (self.style & ELOHIM_ADMINISTRATOR)
  return ELOHIM_SUICIDE_OK;

  self.cnt = self.cnt - 1;
  if (self.cnt < 0)
  {
		// too many suicides
		//if (self.cnt == -1) // only want to do this stuff once
		//{
		//	bprint2(self.netname, " kicked for suiciding\n");
		//	cprint3("\"", self.netname, " kicked for suiciding\"\n");
		//	elohim_kick_player(self);
		//}
		//return ELOHIM_TOO_MANY_SUICIDES;
  }
  //temp = ftos(self.cnt);
  //if (sprint3(self, "you have ", temp, " suicides remaining\n");
  return ELOHIM_SUICIDE_OK;
};

//
//  P E R I O D I C  C H E C K S
//
//  Do various checks every second.  Called from PlayerPreThink in
//  Client.qc.
//
void () elohim_periodic_checks =
{
	if (!(self.style & ELOHIM_CONNECTED))
		return;

	if (utils_illegal_name(self.netname))
	{
		// Let's be fairly draconian about this
		bprint("Player kicked for illegal name\n");
		cprint("\"Player kicked for illegal name\"\n");
		elohim_kick_player(self);
		return;
	}

  if (self.style & ELOHIM_OBSERVER)
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
void () elohim_start_frame =
{
  local float command;
  
  if (!(elohim_playmode & ELOHIM_MATCH_MODE))
  {
    if (time >= timelimit)
    {
      if (timelimit && !gameover)
      NextLevel ();
    }
  }




	// Do some maintenance
  if (time >= elohim_nextcheck && !gameover)
  {
		local entity player;

		// update variables
		timelimit = cvar("timelimit") * 60;
		fraglimit = cvar("fraglimit");
		teamplay = cvar("teamplay");

		// send out ping to test for disconnected players
    /*
		WriteByte(MSG_ALL, SVC_STUFFCMD);
		WriteString(MSG_ALL, "impulse 39\n");           // CRMOD changed from 104 to 39
    */
		player = find(world, classname, "player");
		while (player)
		{
			if (player.style & ELOHIM_CONNECTED)
			{
				if (time > player.finaldest_x + 20)
				{
					// Automatically kick player
          /*
					bprint3("No response from ", player.netname, "\n");
					cprint3("\"No response from ", player.netname, "\"\n");
					elohim_kick_player(player);
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

  elohim_nextcheck = time + 5;
  }

  if (time >= elohim_nextcheck2 && !gameover)
	{
		auto_find_best();
		elohim_nextcheck2 = time + 1;
	}

  if (elohim_levelcount)
  {
		// Check for end of file in levels.cfg.  We assume end of file
		// if it's been 1 second since the last update to levelcount.
		// When end of file is detected, levelcount is reset to 0 to
		// allow players to exit the intermission.
		if (time >= elohim_nextcheck)
		{
			if (elohim_levelcount == elohim_lastcount)
			  elohim_levelcount = 0;
			elohim_lastcount = elohim_levelcount;
			elohim_nextcheck = time + 1;
		}
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
	local float temp, timervar;
	local string s0="", s1="", s2="", s3="", s4="", s5="", s6="";

  if (elohim_playmode & AIR_ARENA_MODE)
  {
    if (boss.state != CA_MATCH_ROUNDSTART)
    {
      centerprint(self, "\n");
      return;
    }
    timervar = boss.count;
  }
  else
  {
    if (elohim_state & ELOHIM_MATCH_STARTED || elohim_match_timer.count < 0)
    {
      centerprint(self, "\n");
      return;
    }
    timervar = elohim_match_timer.count;
  }

  if (timervar > 10)
    s0 = "\n\n";
  else
	  s0 = strings_countdown(timervar);

	if (timervar > 3)
	{
    s1 = strings_mode_countdown();

		temp = elohim_timelimit;	
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

		if (elohim_playmode & ELOHIM_NO_THROWABLES)
    {
  		if (elohim_playmode & ELOHIM_GG_MOD)
        s5 = "                                        \n";
      else
        s5 = "                                        \n";
    }
    else
    {
  		if (elohim_playmode & ELOHIM_GG_MOD)
        s5 = "\bquad drop\b   off\n\bgg  mod\b      on\n";
      else
        s5 = "\bquad drop\b   off\n\bgg  mod\b     off\n";
    }

    if (elohim_playmode & CLANRING_RUNES)
    {
      if (elohim_playmode & ELOHIM_NO_HOOK)
        s6 = "\bhook        \boff\n\brunes        \bon\n";
      else
        s6 = "\bhook         \bon\n\brunes        \bon\n"; 
    }
    else
    {
      if (elohim_playmode & ELOHIM_NO_HOOK)
        s6 = "\bhook        \boff\n\brunes       \boff\n";
      else
        s6 = "\bhook         \bon\n\brunes       \boff\n"; 
    }

		centerprint7(self, s0, s1, s2, s3, s4, s5, s6);
	}
	else
	{
		centerprint(self, s0, "\n\n\n\n\n\n\n\n\n\n\n\n\n");
	}
};

entity() SelectFishSpawnPoint =
{
	local	entity spot;
  local float pcount = floor(random() * 5);
  spot = find(world, classname, "fish_spot");
  while (spot != world && pcount > 0)
  {
    spot = find(spot, classname, "fish_spot");
    pcount = pcount - 1;
  }


	return spot;
};

void () elohim_set_hud =
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

void () elohim_init_set_hud =
{
  sprint(self, "hud spacing is currently: ");
  sprint(self, ftos(self.hudspace + 1));
  sprint(self, "\n");
  sprint(self, "\n");
  sprint(self, "hud spacing 1-8 - move the hud down\n");
  sprint(self, "hud spacing   9 - turn the hud off\n");
  sprint(self, "Enter 1-9 to set hud spacing or 0 to cancel:\n");
  self.use = elohim_set_hud;
};