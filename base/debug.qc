//
// Debug.qc
//
// Debugging routines
//

//
//  I N F O
//
//  General info - currently autochase scores
//
void () debug_info =
{
    local entity e;
	
    sprint(self, "clients:\n");
    e = find(world, classname, "player");
    while (e)
    {
		if (e.style & ELOHIM_CONNECTED)
		{
			local string temp;
			temp = ftos(e.colormap);
			sprint4(self, temp, " ", e.netname, "   ");
			temp = ftos(e.crmod_chase_score);
			sprint2(self, temp, "\n");
		}
        e = find(e, classname, "player");
    }
	sprint(self, "cameras:\n");
    e = find(world, classname, "elohim_camera");
    while (e)
    {
        local string temp2;
        temp2 = ftos(e.crmod_chase_score);
        sprint2(self, temp2, " ");
        e = find(e, classname, "elohim_camera");
    }
	sprint(self, "\n");
};

//
//  F L A G S
//
//  Dump the server flags
//
void () debug_flags =
{
	sprint(self, "Server flags:\n");
    sprint(self, "\n");

	// playmode flags
	if (elohim_playmode & ELOHIM_SAME_LEVEL)
		sprint(self, "ELOHIM_SAME_LEVEL\n");
	if (elohim_playmode & ELOHIM_MATCH_MODE)
		sprint(self, "ELOHIM_MATCH_MODE\n");
	if (elohim_playmode & RACE_MODE)
		sprint(self, "RACE_MODE\n");
	if (elohim_playmode & ELOHIM_SERVER_INITIALIZED)
		sprint(self, "ELOHIM_SERVER_INITIALIZED\n");
	if (elohim_playmode & ELOHIM_NO_QUAD)
		sprint(self, "ELOHIM_NO_QUAD\n");
	if (elohim_playmode & ELOHIM_NO_PENT)
		sprint(self, "ELOHIM_NO_PENT\n");
	if (elohim_playmode & ELOHIM_NO_RING)
		sprint(self, "ELOHIM_NO_RING\n");
	if (elohim_playmode & ELOHIM_MODE_VOTE)
		sprint(self, "ELOHIM_MODE_VOTE\n");
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
		sprint(self, "ELOHIM_DEDICATED_SERVER\n");
	if (elohim_playmode & ELOHIM_NO_ARMOR)
		sprint(self, "ELOHIM_NO_ARMOR\n");
	if (elohim_playmode & CRMOD_QSMACK_ON)
		sprint(self, "CRMOD_QSMACK_ON\n");
	if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
		sprint(self, "ELOHIM_EXTENDED_OBITS\n");
	if (elohim_playmode & CLANRING_CTF_MODE)
        sprint(self, "CLANRING_CTF_MODE\n");

    sprint(self, "\n");

	// state flags
	if (elohim_state & ELOHIM_TIMER_STARTED)
		sprint(self, "ELOHIM_TIMER_STARTED\n");
	if (elohim_state & ELOHIM_MATCH_STARTED)
		sprint(self, "ELOHIM_MATCH_STARTED\n");
	if (elohim_state & ELOHIM_MATCH_PAUSED)
		sprint(self, "ELOHIM_MATCH_PAUSED\n");
	if (elohim_state & ELOHIM_MATCH_OVER)
		sprint(self, "ELOHIM_MATCH_OVER\n");
	if (elohim_state & ELOHIM_MATCH_WAIT)
		sprint(self, "ELOHIM_MATCH_WAIT\n");
	if (elohim_state & ELOHIM_KICKING)
		sprint(self, "ELOHIM_KICKING\n");

    sprint(self, "\n");
};

//
//  V A R S
//
//  Dumps certain elohim global variables to the console.
//
//  (Do NOT dump elohim_password)
//
void () debug_vars = 
{
	// entities
	sprint(self, "elohim_num_spawns = ");
	utils_print_float(elohim_num_spawns);	
	sprint(self, "elohim_num_starts = ");
	utils_print_float(elohim_num_starts);	
	sprint(self, "elohim_num_cameras = ");
	utils_print_float(elohim_num_cameras);	
	sprint(self, "elohim_score_count = ");
	utils_print_float(elohim_score_count);	
	sprint(self, "elohim_teamsize1 = ");
	utils_print_float(elohim_teamsize1);
	sprint(self, "elohim_teamsize2 = ");
	utils_print_float(elohim_teamsize2);
	// sprint(self, "elohim_teamsize3 = ");
	// utils_print_float(elohim_teamsize3);
	// sprint(self, "elohim_teamsize4 = ");
	// utils_print_float(elohim_teamsize4);
};

//
//  C V A R  T H I N K
//
void () debug_cvar_think = 
{
	local float f;
	local string s;

	f = cvar(self.owner.netname);
	s = ftos(f);
	sprint4(self.owner, self.owner.netname, " = ", s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 1  T H I N K
//
void () debug_parm1_think = 
{
	local string s;

	s = ftos(auto_parm1);
	sprint3(self.owner, "auto_parm1 changed from ", s, " to ");
	auto_parm1 = utils_stof(self.owner.netname);
	s = ftos(auto_parm1);
	sprint2(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 2  T H I N K
//
void () debug_parm2_think = 
{
	local string s;

	s = ftos(auto_parm2);
	sprint3(self.owner, "auto_parm2 changed from ", s, " to ");
	auto_parm2 = utils_stof(self.owner.netname);
	s = ftos(auto_parm2);
	sprint2(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 3  T H I N K
//
void () debug_parm3_think = 
{
	local string s;

	s = ftos(auto_parm3);
	sprint3(self.owner, "auto_parm3 changed from ", s, " to ");
	auto_parm3 = utils_stof(self.owner.netname);
	s = ftos(auto_parm3);
	sprint2(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 4  T H I N K
//
void () debug_parm4_think = 
{
	local string s;

	s = ftos(auto_parm4);
	sprint3(self.owner, "auto_parm4 changed from ", s, " to ");
	auto_parm4 = utils_stof(self.owner.netname);
	s = ftos(auto_parm4);
	sprint2(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M S
//
void () debug_parms = 
{
	sprint(self, "auto_parm1 = ");
	utils_print_float(auto_parm1);
	sprint(self, "auto_parm2 = ");
	utils_print_float(auto_parm2);
	sprint(self, "auto_parm3 = ");
	utils_print_float(auto_parm3);
	sprint(self, "auto_parm4 = ");
	utils_print_float(auto_parm4);
};

//
//  C L I E N T  F L A G S
//
//  Dumps movetarget's flags
//
void () debug_client_flags = 
{
    if (!self.movetarget)
    {
        sprint(self, "No movetarget\n");
        return;
    }
    sprint3(self, "Client flags for ", self.movetarget.netname, ":\n");
    sprint(self, "\n");
    if (self.movetarget.style & ELOHIM_NEW_CLIENT)
        sprint(self, "ELOHIM_NEW_CLIENT\n");
    if (self.movetarget.style & ELOHIM_ADMINISTRATOR)
        sprint(self, "ELOHIM_ADMINISTRATOR\n");
   	if (self.movetarget.style & CRMOD_DETECTING_QSMACK)	// CRMOD was SMOOTH
		sprint(self, "CRMOD_DETECTING_QSMACK\n");					// CRMOD was SMOOTH
	if (self.movetarget.style & ELOHIM_POP_FORWARD)
        sprint(self, "ELOHIM_POP_FORWARD\n");
    if (self.movetarget.style & ELOHIM_READY)
        sprint(self, "ELOHIM_READY\n");
    if (self.movetarget.style & ELOHIM_YES)
        sprint(self, "ELOHIM_YES\n");
    if (self.movetarget.style & ELOHIM_HEADS_UP)
        sprint(self, "ELOHIM_HEADS_UP\n");
    if (self.movetarget.style & ELOHIM_SETTING_OPTIONS)
        sprint(self, "ELOHIM_SETTING_OPTIONS\n");
    if (self.movetarget.style & ELOHIM_MOTD)
        sprint(self, "ELOHIM_MOTD\n");
    if (self.movetarget.style & ELOHIM_OK_TO_SHOOT)
        sprint(self, "ELOHIM_OK_TO_SHOOT\n");
    if (self.movetarget.style & ELOHIM_KICK_CONFIRM)
        sprint(self, "ELOHIM_KICK_CONFIRM\n");
    if (self.movetarget.style & ELOHIM_CONNECTED)
        sprint(self, "ELOHIM_CONNECTED\n");
    if (self.movetarget.style & ELOHIM_FOUND_BINDINGS)
        sprint(self, "ELOHIM_FOUND_BINDINGS\n");
    if (self.movetarget.style & ELOHIM_CONFIRM_LEAVE)
        sprint(self, "ELOHIM_CONFIRM_LEAVE\n");
	if (self.movetarget.style & CRMOD_SMART_WEAPON)
		sprint(self, "CRMOD_SMART_WEAPON\n");
    if (self.movetarget.style & ELOHIM_OBSERVER)
        sprint(self, "ELOHIM_OBSERVER\n");
    if (self.movetarget.style & CRMOD_QSMACK)
        sprint(self, "CRMOD_QSMACK\n");
    sprint(self, "\n");

    if (self.movetarget.oflags & OBSERVER_WALK)
        sprint(self, "OBSERVER_WALK\n");
    if (self.movetarget.oflags & OBSERVER_FLY)
        sprint(self, "OBSERVER_FLY\n");
    if (self.movetarget.oflags & OBSERVER_CHASE)
        sprint(self, "OBSERVER_CHASE\n");
    if (self.movetarget.oflags & OBSERVER_DEMO)
        sprint(self, "OBSERVER_DEMO\n");
    if (self.movetarget.oflags & OBSERVER_CAMERA)
    	sprint(self, "OBSERVER_CAMERA\n");
	if (self.movetarget.oflags & OBSERVER_AUTO)
		sprint(self, "OBSERVER_AUTO\n");
	if (self.movetarget.oflags & OBSERVER_TOURNEY)
		sprint(self, "OBSERVER_TOURNEY\n");
	if (self.movetarget.oflags & OBSERVER_GO_AUTO)
		sprint(self, "OBSERVER_GO_AUTO\n");
    sprint(self, "\n");
};

//
//  G E T  M O V E T A R G E T
//
void () debug_get_movetarget = 
{
	self.use = SUB_Null;

	self.movetarget = find(world, classname, "player");
	while(self.movetarget)
	{
		if (self.movetarget.colormap == self.finaldest_z)
		{
			sprint3(self, "Debugging ", self.movetarget.netname, "\n");
			return;	
		}
		self.movetarget = find(self.movetarget, classname, "player");
	}
	sprint(self, "Not found\n");
};

//
//  H E L P
//
//  Print out debug commands
//
void () debug_help =
{
	sprint(self, "Debug commands:\n");
	sprint(self, " dbinfo     - General info\n");
	sprint(self, " dbflags    - Server flags\n");
	sprint(self, " dbvars     - Elohim global variables\n");
	sprint(self, " dbcvar     - Console variable\n");
	sprint(self, " dbclient   - Choose movetarget\n");
	sprint(self, " dbcflags   - View movetarget flags\n");
	sprint(self, " dbparm1-4  - change auto_parm1-4\n");
	sprint(self, " dbparms    - view auto_parms\n");
};

//
//  I M P U L S E
//
void () debug_impulse = 
{
    if (!(self.style & ELOHIM_ADMINISTRATOR) && (self.netname != "cr7debug"))
        return;

	if (self.impulse == 40)
		debug_info();
	//else if (self.impulse == 4$1)
	//	debug_flags();
	//else if (self.impulse == 4$2)
	//	debug_vars();
	//else if (self.impulse == 43)
	//	utils_make_scheduled_event(debug_cvar_think, 0.5);
	//else if (self.impulse == 44)
	//{
	//	sprint(self, "Enter client number:\n");
	//	self.use = debug_get_movetarget;
	//}
	else if (self.impulse == 45)
		debug_client_flags();
	else if (self.impulse == 46)
		utils_make_scheduled_event(debug_parm1_think, 0.5);
	else if (self.impulse == 47)
		utils_make_scheduled_event(debug_parm2_think, 0.5);
	else if (self.impulse == 48)
		utils_make_scheduled_event(debug_parm3_think, 0.5);
	else if (self.impulse == 49)
		utils_make_scheduled_event(debug_parm4_think, 0.5);
	else if (self.impulse == 50)
		debug_parms();
	else if (self.impulse == 59)
		debug_help();
};

