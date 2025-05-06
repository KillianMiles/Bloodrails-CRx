//
// Elodefs.qc
//
// Constants and global variables used in the Elohim mod.
//
// Written by J.P. Grossman, modified by bucksh0t.
//

// constants
float ELOHIM_SUICIDE_OK = 0;
float ELOHIM_TOO_MANY_SUICIDES = 1;
float ELOHIM_NEGINF = -9999999;

// client styles
float ELOHIM_NEW_CLIENT = 1;           // set when a client first connects
float ELOHIM_ADMINISTRATOR = 2;        // set if the client is an admin
float CRMOD_DETECTING_QSMACK = 4;    // set when detecting if client is a qsmack bot
float ELOHIM_POP_FORWARD = 8;       // used to walk through doors
float ELOHIM_READY = 16;             // ready to play in match
float ELOHIM_YES = 32;               // used for voting
float ELOHIM_HEADS_UP = 64;          // enable heads up display
float ELOHIM_SETTING_OPTIONS = 128;  // set when setting options
float ELOHIM_MOTD = 256;             // showing MOTD
float ELOHIM_OK_TO_SHOOT = 512;      // don't fire after options/respawn
float ELOHIM_KICK_CONFIRM = 1024;    // used to confirm a kick
float ELOHIM_CONFIRM_LEAVE = 2048;   // confirmation for leaving match
float ELOHIM_CONNECTED = 4096;       // client has been put in server
float ELOHIM_FOUND_BINDINGS = 8192; // used to check for bindings
float CRMOD_SMART_WEAPON = 16384;    // whether or not to use `smart' weapon switching
float ELOHIM_OBSERVER = 32768;		 // set if the client is an observer
float CRMOD_QSMACK = 65536;			// set for qsmack bots
float ELOHIM_SCOREBOARD = 131072;	// player is looking at teamscores
float CRX_NQ_COMPAT = 262144;               
float CRX_QE_COMPAT = 524288;              // Buckshot NQ compat player styles
float CRX_QW_COMPAT = 1048576;


float COLOR_BLUE = 13;
float COLOR_RED = 4;

// observer flags  (/me kills jp)
float OBSERVER_WALK = 1;        // set in walk mode
float OBSERVER_FLY = 2;        // set in fly mode
float OBSERVER_CHASE = 4;      // set in chase mode
float OBSERVER_DEMO = 8;       // see through chasetargets viewport
float OBSERVER_CAMERA = 16;		// set to camera mode
float OBSERVER_AUTO = 32;	   // view autoswitching
float OBSERVER_TOURNEY = 64;	   // set tournement mode for chasecam
float OBSERVER_GO_AUTO = 128;  // player entering an auto mode
float OBSERVER_ACTIONCAM = 256;


// CRMOD qsmack variables
.float qsmack_level;
.float qsmack_trylevel;
float qsmack_statusokay;				// True if qsmack bot just did a status


// server mode - stored in cvar 'samelevel' and preserved across levels
float ELOHIM_SAME_LEVEL = 1;
float ELOHIM_MATCH_MODE = 2;
float ELOHIM_CLASSIC = 4;           //Instagib classic
float ELOHIM_SERVER_INITIALIZED = 8;
float PROJECTILES = 16;           //Spawn with 100 armor
float ELOHIM_WRAITH = 32;
float ELOHIM_NO_QUAD = 64;
float ELOHIM_NO_PENT = 128;
float ELOHIM_NO_SHIELD = 256;
float ELOHIM_MODE_VOTE = 512;
float ELOHIM_DEDICATED_SERVER = 1024; 
float ELOHIM_NO_ARMOR = 2048;			// disable spooging in practice mode -- replaced with NO_ARMOR instead
float ELOHIM_NOAMMO = 4096;			// CRMOD is server using Qsmack?
float ELOHIM_EXTENDED_OBITS = 8192;
float CLANRING_CTF_MODE = 16384;
float AIR_ARENA_MODE = 32768;
float ELOHIM_AURA = 65536;                //DEATH AURA EFFECT
float CLANRING_RUNES = 131072;
float ROCKET_ARENA_MODE = 262144;
float ELOHIM_NO_HOOK = 524288;
float ELOHIM_NO_THROWABLES = 1048576;
float ELOHIM_NO_SPAWN_PROTECT = 2097152;           
float DM_PUBLIC_MODE = 4194304;

float ELOHIM_LOW_GIBS = 8388608;           //moved down
float ELOHIM_NO_GIBS = 16777216;          //moved down
float RACE_MODE = 33554432;      //moved down
float ELOHIM_GG_MOD = 67108864;              //moved down
float CLAN_ARENA_MODE = 134217728;            //moved down
float ELOHIM_NO_RING = 268435456;
float CRMOD_QSMACK_ON = 536870912;	

// server state - not preserved across level changes
float ELOHIM_TIMER_STARTED = 1;
float ELOHIM_MATCH_STARTED = 2;
float ELOHIM_MATCH_PAUSED = 4;
float ELOHIM_MATCH_OVER = 8;
float ELOHIM_MATCH_WAIT = 16;   // 5 second delay after match ends
float ELOHIM_KICKING = 32;

// admin constants
float ADMIN_NORMAL_MODE = 0;
float ADMIN_RACE_MODE = 1;
float ADMIN_CTF_PUBLIC_MODE = 2;
float ADMIN_CTF_MATCH_MODE = 3;
float ADMIN_DM_PUBLIC_MODE = 4;
float ADMIN_MATCH_MODE = 5;

float ADMIN_RA_MODE = 6;
float ADMIN_CA_MODE = 7;
float ADMIN_AIR_MODE = 8;

string ADMIN_NORMAL_MODE_STRING = "Bloodrailz CRx (FFA)";                //host names
string ADMIN_RACE_MODE_STRING = "Bloodrailz CRx (Race)";
string ADMIN_MATCH_MODE_STRING = "Bloodrailz CRx (TDM-match)";
string ADMIN_DM_PUBLIC_MODE_STRING = "Bloodrailz CRx (Pub-TDM)";
string ADMIN_CTF_MATCH_MODE_STRING = "Bloodrailz CRx (CTF-match)";
string ADMIN_CTF_PUBLIC_MODE_STRING = "Bloodrailz CRx (Pub-CTF)";
string ADMIN_RA_MODE_STRING = "Rocket Arena";
string ADMIN_CA_MODE_STRING = "Clan Arena";
string ADMIN_AIR_MODE_STRING = "1v1 Air Shot";

// elohim global variables
float elohim_player_ids;    // used for assigning unique player ID's
float elohim_password;      // used to store the administrator password
float elohim_devparam;      // used for development
float elohim_playmode;      // current play mode (non volatile flags)
float elohim_state;         // server state (volatile flags)
float elohim_timelimit;     // timelimit for matches (default 10 minutes)
float elohim_overtime;      // length of auto-overtime; 0 if none
float elohim_nextcheck;     // used for periodic checks
float elohim_nextcheck2;	// used for frequent periodic checks
entity elohim_request;      // used to control voting
float maplist;         // number of current level in user level order
//float maplist2;
float current_map;
float elohim_lastcount;     // used to detect end-of-file in levels.cfg
float elohim_num_spawns;    // number of deathmatch spawn points
float elohim_num_redspawns;    // number of red spawn points
float elohim_num_bluespawns;    // number of blue spawn points
float elohim_num_starts;    // number of match extra start points
float elohim_num_cameras;   // number of cameras
string elohim_version;      // used for motd and help-server
string elohim_version_info; // text info including rev. and compile time
string bloodrailz_version_number; // text info storing version number (ie "4.0")
entity elohim_debug_client; // used for debugging
float elohim_server_physics;
float elohim_request_physics;

// match global variables
float elohim_match_pause_time;  // records time that match was paused
float elohim_team1 = 4;             // pants color of team 1
float elohim_team2 = 13;             // pants color of team 2
float elohim_team3 = 12;             // pants color of team 3
float elohim_team4 = 3;             // pants color of team 4
float elohim_lastteam1;         // team 1 color from last match
float elohim_lastteam2;         // team 2 color from last match
float elohim_teamsize1;         // # players in team 1
float elohim_teamsize2;         // # players in team 2
// float elohim_teamsize3;         // # players in team 3
// float elohim_teamsize4;         // # players in team 4
float elohim_teamfrags1;        // team 1 score
float elohim_teamfrags2;        // team 2 score
// float elohim_teamfrags3;        // team 3 score
// float elohim_teamfrags4;        // team 4 score
//float elohim_round_count;       // current round number
float elohim_matchteams;       // number of teams in match (CAx)
float elohim_maxsize;           // maximum allowed team size
entity elohim_match_timer;      // used to time match
entity boss;
.entity chain_gang;

// score global variables
float elohim_winning_team;		// team number of team in the lead
string elohim_winning_teamname;	// name of winning team (as returned by strings_get_teamname)
string elohim_teamname1;		// as returned by strings_get_teamname_bronze
string elohim_teamname2;		// as returned by strings_get_teamname
float elohim_score_number;		// either difference in score or tied score
string ELOHIM_STRING_TIED;		// initialized to "   Tied at "
float elohim_score_count;		// number of clients looking at score

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


entity crmod_best_chase_target; // calculated every second who is the best target to chase // CRMOD - auto
entity crmod_best_camera;       // set after each camera's think

// client variables
.vector crmod_qdwep;  // vector to keep track of quad weapon stats	// CRMOD - stats
.vector crmod_qdkill; // vector to keep track of quad kill stats	// CRMOD - stats
.entity crmod_othertarget; // entity to focus on in tourneycam		// CRMOD - tourneycam
.entity crmod_inflicted;   // stores entity last attacked			// CRMOD - combat
.float crmod_chase_score;  // same as above, also used by cameras
.float crmod_did_damage;   // last time person did damage
.float crmod_lastkill;     // last kill time
.float oflags;				// CRMOD observer flags
.float crmod_cam_delay;    // keep autocam from overswitching
.vector crmod_oldangle;    // set by angles_fixangle
.float delayed_impulse;		// saves self.impulse so it doesn't get nuked by a ping
.vector scoreboard;			// records which scoreboard slots are used by teamscores
.float warp_episode;
.float warp_map;
.float hudspace;
.float joinmsgtime;


float CRMOD_ANGLE_SMOOTHING = 0.6; // CRMOD use this instead of typing the number a billion times

float ogEffects;
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



///////////   USERDEFS   ///////////////////////////
//


//contains customizations for the Elohim mod.
// The strings are all buffers that are written to by crmake.
//
// All code by J.P. Grossman unless otherwise commented.
//

float (string s) utils_stof;

// Maximum number of suicides allowed per level in normal and match modes
float ELOHIM_MAX_SUICIDES;

// Intro message
string USER_MOTD1_1, USER_MOTD2_1, USER_MOTD3_1, USER_MOTD4_1, USER_MOTD5_1;
string USER_MOTD1_2, USER_MOTD2_2, USER_MOTD3_2, USER_MOTD4_2, USER_MOTD5_2;
string USER_MOTD1_3, USER_MOTD2_3, USER_MOTD3_3, USER_MOTD4_3, USER_MOTD5_3;
string USER_MOTD1_4, USER_MOTD2_4, USER_MOTD3_4, USER_MOTD4_4, USER_MOTD5_4;
string USER_MOTD1_5, USER_MOTD2_5, USER_MOTD3_5, USER_MOTD4_5, USER_MOTD5_5;
string USER_MOTD1_6, USER_MOTD2_6, USER_MOTD3_6, USER_MOTD4_6, USER_MOTD5_6;
float NUM_USER_MOTD_LINES;

// QSmack password
float QSMACK1, QSMACK2, QSMACK3, QSMACK4, QSMACK5;

//
//  I N I T  W O R L D
//
//  Create all string constants
//
void () userdefs_init_world =
{
    local string temp;

    // Number of suicides
    temp = "3 stag";
    ELOHIM_MAX_SUICIDES = utils_stof(temp);

	// QSMACK
	temp = "100 14733";
	QSMACK1 = utils_stof(temp);


    // Intro message
    temp = "Welcome.  Testing right now...";
    NUM_USER_MOTD_LINES = utils_stof(temp);

    // frame 1
    USER_MOTD1_1 = "                                         mtag11";
    USER_MOTD2_1 = "                                         mtag21";
    USER_MOTD3_1 = "                                         mtag31";
    USER_MOTD4_1 = "                                         mtag41";
    USER_MOTD5_1 = "                                         mtag51";

    // frame 2
    USER_MOTD1_2 = "                                         mtag12";
    USER_MOTD2_2 = "                                         mtag22";
    USER_MOTD3_2 = "                                         mtag32";
    USER_MOTD4_2 = "                                         mtag42";
    USER_MOTD5_2 = "                                         mtag52";

    // frame 3
    USER_MOTD1_3 = "                                         mtag13";
    USER_MOTD2_3 = "                                         mtag23";
    USER_MOTD3_3 = "                                         mtag33";
    USER_MOTD4_3 = "                                         mtag43";
    USER_MOTD5_3 = "                                         mtag53";
                
    // frame 4
    USER_MOTD1_4 = "                                         mtag14";
    USER_MOTD2_4 = "                                         mtag24";
    USER_MOTD3_4 = "                                         mtag34";
    USER_MOTD4_4 = "                                         mtag44";
    USER_MOTD5_4 = "                                         mtag54";

    // frame 5
    USER_MOTD1_5 = "                                         mtag15";
    USER_MOTD2_5 = "                                         mtag25";
    USER_MOTD3_5 = "                                         mtag35";
    USER_MOTD4_5 = "                                         mtag45";
    USER_MOTD5_5 = "                                         mtag55";

    // frame 6
    USER_MOTD1_6 = "                                         mtag16";
    USER_MOTD2_6 = "                                         mtag26";
    USER_MOTD3_6 = "                                         mtag36";
    USER_MOTD4_6 = "                                         mtag46";
    USER_MOTD5_6 = "                                         mtag56";
};







////////////// mostly unused arena stuff


.float dmg_tally;
.float round;
.float arena_flag;
.float team2;


float arena_max_teams = 4;

float COLOR_YELLOW = 12;
float COLOR_GREEN = 3;

float AF_CA_READY = 1;
float AF_CA_PLAYING = 2;
float AF_CA_DEAD = 3;
float AF_CA_WAITING = 4;

float CA_MATCH_WAITING = 1;
float CA_MATCH_ROUNDSTART = 2;
float CA_MATCH_PLAYING = 3;
float CA_MATCH_OVER = 4;
float CA_MATCH_CLEANUP = 5;

