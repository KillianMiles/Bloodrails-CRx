// constants
float CONSOLE_ENT_YAW = 1;
float CONSOLE_ENT_PITCH = 2;
float CONSOLE_ENT_ROLL = 4;

//
//  S E T  A L I A S E S
//
//  Called once when the server is initialized.
//
void () console_set_aliases =
{
    // console commands valid from dedicated servers only
    if (!(crx_playmode & MODE_DEDICATED_SERVER))
        return;

    // set local aliases (server console commands)
    
    
    localcmd("alias sping temp1 1\n");
    localcmd("alias time temp1 2\n");
    localcmd("alias s temp1 3\n");
    localcmd("alias debug temp1 4\n");
    localcmd("alias score temp1 5\n");
    localcmd("alias ghostlist temp1 6\n");
    localcmd("alias stats temp1 9\n");
    localcmd("alias commands temp1 10\n");
    localcmd("alias vinfo temp1 11\n");
    localcmd("alias normal temp1 12\n");
    localcmd("alias practice temp1 13\n");
    localcmd("alias match temp1 14\n");
	localcmd("alias setcharge temp1 15\n");		
	localcmd("alias setpowerups temp1 19\n");
	localcmd("alias setatx temp1 20\n");
	localcmd("alias shuffle temp1 21\n");
	localcmd("alias modevote temp1 22\n");
	localcmd("alias obits temp1 24\n");

	// undocumented debug commands
    localcmd("alias debugclient temp1 40\n");
    localcmd("alias debugoff temp1 41\n");
    localcmd("alias stuffimpulse temp1 42\n");
    localcmd("alias stuffcolor temp1 43\n");
    localcmd("alias flags temp1 44\n");
	localcmd("alias sflags temp1 45\n");

	// entity file commands
    localcmd("alias newspawn \"temp1 50;wait\"\n");
    localcmd("alias newstart \"temp1 51;wait\"\n");
    localcmd("alias killspawn \"temp1 52;wait\"\n");
    localcmd("alias makecam \"temp1 53;wait\"\n");

    //
    // create map aliases - used for reading levels.cfg
    //
    // e.g.:  alias start "temp1 100;wait"
    //
    local float temp;
    local string szTemp;
    temp = 100;
    while (temp < 170)
    {
        szTemp = strings_get_mapname(temp - 100);
        if (szTemp != "")
        {
            localcmd3("alias ", szTemp, " \"temp1 ");
            szTemp = ftos(temp);
            localcmd2(szTemp, ";wait\"\n");
        }
        temp = temp + 1;
    }
};

//
//  P I N G  T H I N K
//
//  Two seconds after console_ping is called, console_ping_think gets
//  called to see what everyone's ping turned out to be and display this
//  on the console.
//
void () console_ping_think =
{
    local entity client;
    local string temp;
    local float ping;

    cprint("\n");
    cprint("client ping times:\n");
    client = find(world, classname, "player");
    while (client)
    {
        if (client.style & STYLE_CONNECTED)
        {
            if (client.finaldest_y > self.finaldest_x)
                ping = floor(1000 * (client.finaldest_y - self.finaldest_x));
            else
                ping = 2000;
            temp = ftos(ping);
            cprint5("\"   ", temp, " ", client.netname, "\"\n");
        }
        client = find(client, classname, "player");
    }
    cprint("\n");
};

//
//  P I N G
//
//  This is a simple attempt at a manual ping that can be executed
//  from the server console (so that you can ping players without
//  actually joining the game).  It works by stuffing "impulse 38" into
//  everyone's console and seeing how long it takes for the impulse to
//  get back.
//
void () console_ping =
{
    //local entity client;
    local entity ping;


    ping = spawn();
    ping.classname = "crx_ping";
    ping.owner = world;
    ping.nextthink = time + 2;
    ping.think = console_ping_think;
    ping.finaldest_x = time;
};

//
//  S H O W  T I M E
//
//  Show the elapsed time on the server console.
//
void () console_show_time = 
{
    local float h, m, s, t;
    local string temp;

    h = floor(time / 3600);
    t = time - h * 3600;
    m = floor(t / 60);
    t = t - m * 60;
    s = rint(t);

    cprint("\"time = ");
    if (h > 0)
    {
        temp = ftos(h);
        localcmd2(temp, ":");
        if (m < 10)
            localcmd("0");
    }
    temp = ftos(m);
    localcmd2(temp, ":");
    if (s < 10)
        localcmd("0");
    temp = ftos(s);
    localcmd2(temp, "\"\n");
};

//
//  S H O W  S T A T U S
//
//  Show the elapsed time and status on the server console.
//
void () console_show_status = 
{
    local float mode;
    local string szmode;

    cprint("\n");                    
    mode = utils_get_mode();
    szmode = strings_get_mode(mode);
    cprint2(szmode, " mode\n");
    console_show_time();
    localcmd("status;echo\n");
};

//
//  S H O W  D E B U G  I N F O
//
//  Used for development.  Similar to crx_debug_info, but prints to the
//  server console.
//
void () console_show_debug_info =
{
    local entity e;

    cprint("clients:\n");
    e = find(world, classname, "player");
    while (e)
    {
        local string temp;
        temp = ftos(e.colormap);
        if (e.style & STYLE_CONNECTED)
            cprint4(temp, " \"", e.netname, "\" - Connected\n");
        else
            cprint4(temp, " \"", e.netname, "\" - Disconnected\n");
        e = find(e, classname, "player");
    }
};



//
//  L I S T  G H O S T S
//
void () console_list_ghosts =
{
    local entity e;
    e = find(world, classname, "crx_ghost");
    if (!e)
    {
        cprint("There are no ghosts\n");
        return;
    }
    cprint("\n");
    cprint("\" code |    team    | frags |      name\"\n");
    cprint("------+------------+-------+-----------------\n");
    while (e)
    {
        local string num, szTeam, pad;
        local float frag;
        num = ftos(e.count);
        cprint3("\"  ", num, " | ");
    
        szTeam = strings_get_teamname2(e.height);
        if (e.owner.owner == e)
            frag = e.owner.frags;
        else
            frag = e.frags;
        if (frag < -99)
            pad = " | ";
        else if (frag < -9)
            pad = " |  ";
        else if (frag < 0)
            pad = " |   ";
        else if (frag < 10)
            pad = " |    ";
        else if (frag < 100)
            pad = " |   ";
        else
            pad = " |  ";
        num = ftos(frag);
        if (e.owner.owner == e)
            localcmd6(szTeam, pad, num, "  | ", e.owner.netname, "\"\n");
        else
            localcmd4(szTeam, pad, num, "  | Disconnected\"\n");
    
        e = find(e, classname, "crx_ghost");
    }
    cprint("\n");
};




//
//  C O M M A N D S
//
//  Show a list of valid commands (dedicated only)
//
void () console_commands =
{
    cprint("\n");
    cprint("Commands:\n");
    cprint("\n");
    cprint("\"help-info - show server version information\n");
    cprint("\"sping - view approximate client ping times\"\n");
    cprint("\"time  - view time elapsed on current level\"\n");
    cprint("\"s     - view server status including time elapsed\"\n");
    cprint("\"score - view score and time remaining in match\"\n");
    cprint("\"setmode    - set playmode\"\n");
    cprint("\"setmode2   - set gametype\"\n");
	cprint("\"setquad    - enable/disable power-ups\"\n");
	cprint("\"setpent    - enable/disable ATX mode\"\n");
	cprint("\"setring    - enable/disable XTA mode\"\n");
	cprint("\"obits      - enable/disable extended obituaries\n");
	cprint("\"modevote   - enable/disable mode voting\"\n");
    cprint("\"ghostlist  - view all ghosts in database\"\n");
    cprint("\n");
};

//
//  S E R V E R  F L A G S
//
void () console_server_flags =
{
    cprint("\n");
	cprint("Server flags:\n");
    cprint("\n");

	// playmode flags
	if (crx_playmode & MATCH_MODE)
		cprint("MATCH_MODE\n");
	if (crx_playmode & RACE_MODE)
		cprint("RACE_MODE\n");
        if (crx_playmode & MODE_SERVER_INITIALIZED)
		cprint("MODE_SERVER_INITIALIZED\n");
	if (crx_playmode & MODE_NO_QUAD)
		cprint("MODE_NO_QUAD\n");
	if (crx_playmode & MODE_NO_PENT)
		cprint("MODE_NO_PENT\n");
	if (crx_playmode & MODE_NO_RING)
		cprint("MODE_NO_RING\n");
	if (crx_playmode & MODE_VOTE)
		cprint("MODE_VOTE\n");
	if (crx_playmode & MODE_DEDICATED_SERVER)
		cprint("MODE_DEDICATED_SERVER\n");
	if (crx_playmode & MODE_NO_ARMOR)
		cprint("MODE_NO_ARMOR\n");
	if (crx_playmode & MODE_NOAMMO)
		cprint("MODE_NOAMMO\n");
    if (crx_playmode & CTF_MODE)
        cprint("CTF_MODE\n");

    cprint("\n");

	// state flags
	if (crx_state & STATE_TIMER_STARTED)
		cprint("STATE_TIMER_STARTED\n");
	if (crx_state & STATE_MATCH_STARTED)
		cprint("STATE_MATCH_STARTED\n");
	if (crx_state & STATE_MATCH_PAUSED)
		cprint("STATE_MATCH_PAUSED\n");
	if (crx_state & STATE_MATCH_OVER)
		cprint("STATE_MATCH_OVER\n");
	if (crx_state & STATE_MATCH_WAIT)
		cprint("STATE_MATCH_WAIT\n");
	if (crx_state & STATE_KICKING)
		cprint("STATE_KICKING\n");

    cprint("\n");
};


//  G E T  O R I G I N
//
//  Return the vector 'scr_ofsx scr_ofsy scr_ofsz'
//
vector () console_get_origin =
{
    local vector v;

    v_x = cvar("scr_ofsx");
    v_y = cvar("scr_ofsy");
    v_z = cvar("scr_ofsz");
    return v;
};

//
//  G E T  A N G L E S
//
//  Return the angles vector 'v_ipitch_level v_iyaw_level v_iroll_level'
//
vector () console_get_angles =
{
    local vector v;

    v_x = cvar("v_ipitch_level");
    v_y = cvar("v_iyaw_level");
    v_z = cvar("v_iroll_level");
    return v;
};

//
//  M A K E  E N T I T Y
//
//  Create a new entity using the origin and angle specified in a
//  configuration file.
//
void (string name, float angleflags) console_make_entity =
{
    local entity newent;
    local string temp;

    // create entity
    newent = spawn();
    newent.owner = world;
    newent.solid = SOLID_NOT;
    newent.movetype = MOVETYPE_NONE;
    newent.takedamage = DAMAGE_NO;
    newent.fixangle = TRUE;
    newent.classname = name;
    newent.origin = console_get_origin();
    newent.angles = console_get_angles();
    if (!(angleflags & CONSOLE_ENT_PITCH))
        newent.angles_x = 0;
    if (!(angleflags & CONSOLE_ENT_YAW))
        newent.angles_y = 0;
    if (!(angleflags & CONSOLE_ENT_ROLL))
        newent.angles_z = 0;

    temp = vtos(newent.origin);
    cprint4(name, " created at ", temp, ", ");
    temp = vtos(newent.angles);
    localcmd2(temp, "\n");
    if (name == "crx_camera")
    {
    	newent.nextthink = time + 0.2;
    	newent.think = auto_camera_think;
    }
};

//
//  K I L L  E N T I T Y
//
//  Search for the entity of the given type at origin specified in the
//  configuration file; kill it if it exists.
//
void (string name) console_kill_entity =
{
    local vector location;
    local entity e;
    local string temp;

    location = console_get_origin();
    temp = vtos(location);

    e = find(world, classname, name);
    while (e)
    {
        local vector v;
        v = e.origin - location;
        if (vlen(v) < 10)
        {
            cprint5("removed ", name, " at ", temp, ", ");
            temp = vtos(e.angles);
            localcmd2(temp, "\n");

            remove(e);
            return;            
        }
        e = find(e, classname, name);
    }
    cprint5("\"killentity: couldn't find ", name, " at ", temp, "\"\n");
};

//
//  C O M M A N D
//
//  Interpret a console command.  Called from crx_start_frame.
//
void (float command) console_command =
{
    if (command == 1)
        console_ping();
    else if (command == 2)
        console_show_time();
    else if (command == 3)
        console_show_status();
    else if (command == 4)
        console_show_debug_info();
    else if (command == 5)
        {}
    else if (command == 6)
        console_list_ghosts();
    else if (command == 7)
        {}
    else if (command == 8)
        {}
    else if (command == 9)
        {}
    else if (command == 10)
        console_commands();
    else if (command == 11)
        {}
    else if (command >= 12 && command <= 14)
        admin_init_set_mode();
	else if (command == 15)
		admin_set_armor();
	else if (command >= 16 && command <= 18)
		admin_request_set_gibs(command - 16);
	else if (command == 19)
		admin_set_powerups();
	else if (command == 20)
		admin_set_atx();
	else if (command == 21)
		admin_set_airwalk();
	else if (command == 22)
		admin_set_mode_vote(); //TODO: reassign this
	else if (command == 23)			
	{}
	else if (command == 24)
	{}
    else if (command == 40)
    {}
    else if (command == 41)
    {}
    else if (command == 42)
    {}
    else if (command == 43)
    {}
    else if (command == 44)
    {}
    else if (command == 45)
        console_server_flags();
    else if (command == 50)
    {
        console_make_entity("info_player_deathmatch", CONSOLE_ENT_YAW);
        num_spawns = num_spawns + 1;
    }
    else if (command == 51)
    {
        console_make_entity("crx_start_point", CONSOLE_ENT_YAW);
        num_starts = num_starts + 1;
    }
    else if (command == 52)
        console_kill_entity("info_player_deathmatch");
    else if (command == 53)
    {
        console_make_entity("crx_camera", CONSOLE_ENT_PITCH | CONSOLE_ENT_YAW);
        num_cameras = num_cameras + 1;
    }
    else if (command >= 100 && command < 170)
       {}
    else if (command >= 1000)
    {
        crx_password = command;
        cprint("password set\n");
    }
    else
        cprint("unknown command\n");
};

