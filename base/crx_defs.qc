void () admin_create;
void () observer_start;
void () observer_start_think;

// constants
float CONST_MAX_SUICIDES = 100;
float CONST_NEGINF = -9999999;

// client styles
float STYLE_NEW_CLIENT = 1;           // set when a client first connects
float STYLE_ADMINISTRATOR = 2;        // set if the client is an admin
float STYLE_POP_FORWARD = 8;       // used to walk through doors
float STYLE_READY = 16;             // ready to play in match
float STYLE_YES = 32;               // used for voting
float STYLE_HEADS_UP = 64;          // enable heads up display
//float UNUSED_STYLE = 128;
float STYLE_MOTD = 256;             // showing MOTD
float STYLE_OK_TO_SHOOT = 512;      // don't fire after options/respawn
float STYLE_KICK_CONFIRM = 1024;    // used to confirm a kick
float STYLE_CONFIRM_LEAVE = 2048;   // confirmation for leaving match
float STYLE_CONNECTED = 4096;       // client has been put in server
float STYLE_FOUND_BINDINGS = 8192; // used to check for bindings
float STYLE_SMART_WEAPON = 16384;    // whether or not to use `smart' weapon switching
float STYLE_OBSERVER = 32768;		 // set if the client is an observer
//float UNUSED_STYLE = 65536;
float STYLE_SCOREBOARD = 131072;	// player is looking at teamscores
//float UNUSED_STYLE = 262144;               
//float UNUSED_STYLE = 524288;
//float UNUSED_STYLE = 1048576;

float COLOR_BLUE = 13;
float COLOR_RED = 4;

// observer flags
float OBSERVER_WALK = 1;        // set in walk mode
float OBSERVER_FLY = 2;        // set in fly mode
float OBSERVER_CHASE = 4;      // set in chase mode
float OBSERVER_DEMO = 8;       // see through chasetargets viewport
float OBSERVER_CAMERA = 16;		// set to camera mode
float OBSERVER_AUTO = 32;	   // view autoswitching
float OBSERVER_TOURNEY = 64;	   // set tournement mode for chasecam
float OBSERVER_GO_AUTO = 128;  // player entering an auto mode
float OBSERVER_ACTIONCAM = 256;

// server mode - stored in cvar 'samelevel' and preserved across levels
//float MODE_SAME_LEVEL = 1;
float MATCH_MODE = 2;
float CLASSIC_MODE = 4;           //Instagib classic
float MODE_SERVER_INITIALIZED = 8;
float MODE_PROJECTILES = 16;           //Spawn with 100 armor
float MODE_WRAITH = 32;
float MODE_NO_QUAD = 64;
float MODE_NO_PENT = 128;
float MODE_NO_SHIELD = 256;
float MODE_VOTE = 512;
float MODE_DEDICATED_SERVER = 1024; 
float MODE_NO_ARMOR = 2048;			// disable spooging in practice mode -- replaced with NO_ARMOR instead
float MODE_NOAMMO = 4096;
//float UNUSED6 = 8192;
float CTF_MODE = 16384;
//float UNUSED1 = 32768;
//float UNUSED_MODE = 65536;                //DEATH AURA EFFECT
float MODE_RUNES = 131072;
//float UNUSED2 = 262144;
float MODE_NO_HOOK = 524288;
float MODE_NO_THROWABLES = 1048576;
float MODE_NO_SPAWN_PROTECT = 2097152;           
float DM_PUBLIC_MODE = 4194304;

//float MODE_UNUSED = 8388608;
//float MODE_UNUSED = 16777216;
float RACE_MODE = 33554432;      //moved down
//float UNUSED4 = 67108864;              //moved down
//float UNUSED3 = 134217728;            //moved down
float MODE_NO_RING = 268435456;
//float UNUSED5 = 536870912;	

// server state - not preserved across level changes
float STATE_TIMER_STARTED = 1;
float STATE_MATCH_STARTED = 2;
float STATE_MATCH_PAUSED = 4;
float STATE_MATCH_OVER = 8;
float STATE_MATCH_WAIT = 16;   // 5 second delay after match ends
float STATE_KICKING = 32;

// admin constants
float ADMIN_NORMAL_MODE = 0;
float ADMIN_RACE_MODE = 1;
float ADMIN_CTF_PUBLIC_MODE = 2;
float ADMIN_CTF_MATCH_MODE = 3;
float ADMIN_DM_PUBLIC_MODE = 4;
float ADMIN_MATCH_MODE = 5;

string ADMIN_NORMAL_MODE_STRING = "Bloodrailz CRx (FFA)";                //host names
string ADMIN_RACE_MODE_STRING = "Bloodrailz CRx (Race)";
string ADMIN_MATCH_MODE_STRING = "Bloodrailz CRx (TDM-match)";
string ADMIN_DM_PUBLIC_MODE_STRING = "Bloodrailz CRx (Pub-TDM)";
string ADMIN_CTF_MATCH_MODE_STRING = "Bloodrailz CRx (CTF-match)";
string ADMIN_CTF_PUBLIC_MODE_STRING = "Bloodrailz CRx (Pub-CTF)";

// global variables
float crx_player_ids;    // used for assigning unique player ID's
float crx_password;      // used to store the administrator password
float crx_playmode;      // current play mode (non volatile flags)
float crx_state;         // server state (volatile flags)
float crx_timelimit;     // timelimit for matches (default 10 minutes)
float crx_overtime;      // length of auto-overtime; 0 if none
float crx_nextcheck;     // used for periodic checks
float crx_nextcheck2;	// used for frequent periodic checks
entity crx_request;      // used to control voting
float maplist;         // number of current level in user level order
//float maplist2;
float current_map;
float num_spawns;    // number of deathmatch spawn points
float num_redspawns;    // number of red spawn points
float num_bluespawns;    // number of blue spawn points
float num_starts;    // number of match extra start points
float num_cameras;   // number of cameras
string br_version;      // used for motd and help-server
string br_version_info; // text info including rev. and compile time
string bloodrailz_version_number; // text info storing version number (ie "4.0")
float crx_server_physics;
float crx_request_physics;
entity array_kick[16];

// match global variables
float match_pause_time;  // records time that match was paused
float crx_team1 = 4;             // pants color of team 1
float crx_team2 = 13;             // pants color of team 2
float crx_team3 = 12;             // pants color of team 3
float crx_team4 = 3;             // pants color of team 4
float crx_lastteam1;         // team 1 color from last match
float crx_lastteam2;         // team 2 color from last match
float crx_teamsize1;         // # players in team 1
float crx_teamsize2;         // # players in team 2
// float crx_teamsize3;         // # players in team 3
// float crx_teamsize4;         // # players in team 4
float crx_teamfrags1;        // team 1 score
float crx_teamfrags2;        // team 2 score
// float crx_teamfrags3;        // team 3 score
// float crx_teamfrags4;        // team 4 score
float crx_matchteams;       // number of teams in match
float crx_maxsize;           // maximum allowed team size
entity crx_match_timer;      // used to time match

// score global variables
float crx_winning_team;		// team number of team in the lead
string crx_winning_teamname;	// name of winning team (as returned by strings_get_teamname)
string crx_teamname1;		// as returned by strings_get_teamname_bronze
string crx_teamname2;		// as returned by strings_get_teamname
float crx_score_number;		// either difference in score or tied score
string STRING_TIED;		// initialized to "   Tied at "
float crx_score_count;		// number of clients looking at score

// auto parameters
float auto_parm1;	// activity bonus factor (default 20)
float auto_parm2;	// proximity bonus for cameras (default 100)
float auto_parm3;	// proximity factor for players (default 10)
float auto_parm4;	// chasetarget hysteresis (default 100)

// other global variables
string nextmap;  // moved here from client.qc
float timelimit; // this used to be local in CheckRules in Client.qc        
float fraglimit; // this used to be local in CheckRules in Client.qc
float my_ticrate;


entity crmod_best_chase_target; // calculated every second who is the best target to chase
entity crmod_best_camera;       // set after each camera's think

// client variables
.entity crmod_othertarget; // entity to focus on in tourneycam
.entity crmod_inflicted;   // stores entity last attacked
.float crmod_chase_score;  // same as above, also used by cameras
.float crmod_did_damage;   // last time person did damage
.float crmod_lastkill;     // last kill time
.float oflags;				// observer flags
.float crmod_cam_delay;    // keep autocam from overswitching
.vector crmod_oldangle;    // set by angles_fixangle
.float delayed_impulse;		// saves self.impulse so it doesn't get nuked by a ping
.vector scoreboard;			// records which scoreboard slots are used by teamscores
.float warp_episode;
.float warp_map;
.float hudspace;
.float joinmsgtime;

float CONST_ANGLE_SMOOTHING = 0.6;

float EF_QUADLIGHT = 16;
float EF_PENTLIGHT = 32;
float EF_FLICKER = 64;
//float EF_OGBLUE = 64;
float EF_OGRED = 128;

//player_flag 
float PF_FIRST_SPAWN = 1; //set after a player spawns the first time (public ctf)
float PF_TEAM_BLUE = 2;
float PF_TEAM_RED = 4;
float PF_TEAM_YELLOW = 8;
float PF_TEAM_GREEN = 16;
float PF_MIDGAME_JOIN = 32;  //set when joining game in progress
float PF_OVERLAY = 64;
float PF_ITEM_RUNE_MASK = 128;
float PF_ITEM_RUNE1_FLAG = 256;
float PF_ITEM_RUNE2_FLAG = 512;
float PF_ITEM_RUNE3_FLAG = 1024;
float PF_ITEM_RUNE4_FLAG = 2048;
float PF_CLEANTRAIL = 4096;
float PF_HUD = 8192;

.vector lastorigin1;
.vector lastorigin2;
.vector lastorigin3;
.vector lastorigin4;
.vector lastorigin5;
.vector lastorigin6;
.vector lastorigin7;
.vector lastorigin8;
.vector lastorigin9;
.float lastorigintime1;
.float lastorigintime2;
.float lastorigintime3;
.float lastorigintime4;
.float lastorigintime5;
.float lastorigintime6;
.float lastorigintime7;
.float lastorigintime8;
.float lastorigintime9;
.vector hold_origin;
.float responsetime;
.float responsetime1;
.float responsetime2;
.float responsetime3;
float responsetimecheck;
float ANTILAG_MAX_RESPONSETIME = 150;
float SVC_STUFFTEXT = 9;