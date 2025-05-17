//
// Utils.qc
//
// This file contains a bunch of useful definitions and utilities.
//
// Written by J.P. Grossman, modified by bucksh0t.
//

// Overloaded centerprints
void (entity client, string s1, string s2) centerprint2 = #73;
void (entity client, string s1, string s2, string s3) centerprint3 = #73;
void (entity client, string s1, string s2, string s3, string s4) centerprint4 = #73;
void (entity client, string s1, string s2, string s3, string s4, string s5) centerprint5 = #73;
void (entity client, string s1, string s2, string s3, string s4, string s5, string s6) centerprint6 = #73;
void (entity client, string s1, string s2, string s3, string s4, string s5, string s6, string s7) centerprint7 = #73;

// Overloaded sprints
void (entity client, string s1, string s2) sprint2 = #24;
void (entity client, string s1, string s2, string s3) sprint3 = #24;
void (entity client, string s1, string s2, string s3, string s4) sprint4 = #24;
void (entity client, string s1, string s2, string s3, string s4, string s5) sprint5 = #24;
void (entity client, string s1, string s2, string s3, string s4, string s5, string s6) sprint6 = #24;

// Overloaded bprints
void (string s1, string s2) bprint2 = #23;
void (string s1, string s2, string s3) bprint3 = #23;
void (string s1, string s2, string s3, string s4) bprint4 = #23;
void (string s1, string s2, string s3, string s4, string s5) bprint5 = #23;
void (string s1, string s2, string s3, string s4, string s5, string s6) bprint6 = #23;

//
// Functions for printing to console
//
// Caution:  when printing multiple strings to the same line, use cprint
//           for the first string(s) and localcmd for subsequent strings.
//
// example:
//
// cprint3("my ", "name ", "is ");
// localcmd2("bob", "\n");
//
void (string s1, string s2) localcmd2 =
{
    localcmd(s1);
    localcmd(s2);
};

void (string s1, string s2, string s3) localcmd3 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
};

void (string s1, string s2, string s3, string s4) localcmd4 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
};

void (string s1, string s2, string s3, string s4, string s5) localcmd5 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
};

void (string s1, string s2, string s3, string s4, string s5, string s6) localcmd6 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
    localcmd(s6);
};

void (string s1, string s2, string s3, string s4, string s5, string s6, string s7) localcmd7 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
    localcmd(s6);
    localcmd(s7);
};

void (string s1) cprint =
{
    localcmd("cmd ");
    localcmd(s1);  
};

void (string s1, string s2) cprint2 =
{
    localcmd("cmd ");
    localcmd(s1);
    localcmd(s2);
};

void (string s1, string s2, string s3) cprint3 =
{
    localcmd("cmd ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
};

void (string s1, string s2, string s3, string s4) cprint4 =
{
    localcmd("cmd ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
};

void (string s1, string s2, string s3, string s4, string s5) cprint5 =
{
    localcmd("cmd ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
};

void (string s1, string s2, string s3, string s4, string s5, string s6) cprint6 =
{
    localcmd("cmd ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
    localcmd(s6);
};

//bucksh0t: change a player's colors
void (entity e, float top, float bottom) setcolor2 =
{
    if (cvar("pr_checkextension"))
    {
        if (checkextension("DP_SV_SETCOLOR"))
        {
            local float color = bottom + top * 16;
            setcolor(e, color);
            return;
        }
    }

    stuffcmd(e,"color ");
    stuffcmd(e,ftos(top));
    stuffcmd(e,ftos(bottom));
    stuffcmd(e,";\n");
};

//
//  B P R I N T  F L O A T
//
//  Broadcasts a float followed by a CR.
//
void (float f) utils_bprint_float =
{
    local string s;

    s = ftos(f);
    bprint2(s, "\n");
};

//
//  P R I N T  F L O A T
//
//  Prints a float followed by CR to 'self'.
//
void (float f) utils_print_float =
{
    local string s;

    s = ftos(f);
    sprint2(self, s, "\n");
};

//
//  P R I N T  F L O A T N
//
//  Prints a float with up to n decimal digits followed by CR to self
//
void (float f, float n) utils_print_floatn = 
{
	local string s;
	local float temp;
	local float factor;

	temp = floor(f);
	if (f == temp)
	{
		utils_print_float(f);
		return;
	}
	s = ftos(temp);
	sprint2(self, s, ".");
	f = f - temp;

	factor = 1;
	while (n)
	{
		factor = 10 * factor;
		n = n - 1;
	}
	f = floor(factor * f + 0.5);

	while (factor)
	{
		factor = floor(factor / 10);
		temp = floor(f / factor);
		f = f - temp * factor;
		if (!f)
			factor = 0;
		s = ftos(temp);
		sprint(self, s);
	}
	sprint(self, "\n");
};

//
//  P R I N T  I N T 3
//
//  Prints a 3 character integer to 'self'.
//
void (float f) utils_print_int3 =
{
    local float n;
    local string s;

    n = rint(f);
    if (n < 0)
    {
        if (n < -99)
            sprint(self, "-99");
        else if (n > -10)
            sprint(self, " ");
    }
    else
    {
        if (n < 100)
            sprint(self, " ");
        if (n < 10)
            sprint(self, " ");
    }
    s = ftos(n);
    sprint(self, s);
};

//
//  C P R I N T  I N T 3
//
//  Prints a 3 character integer to the console.
//
void (float f) utils_cprint_int3 =
{
    local float n;
    local string s;

    n = rint(f);
    if (n < 0)
    {
        if (n < -99)
            localcmd("-99");
        else if (n > -10)
            localcmd(" ");
    }
    else
    {
        if (n < 100)
            localcmd(" ");
        if (n < 10)
            localcmd(" ");
    }
    s = ftos(n);
    localcmd(s);
};

//
//  P R I N T  V E C
//
//  Prints a vector followed by CR to 'self'.
//  Used for debugging.
//
void (vector v) utils_print_vec =
{
    local string s;

    s = vtos(v);
    sprint2(self, s, "\n");
};

//
//  P R I N T  B I T
//
//  Prints a single bit to 'self'.
//  Used for debugging.
//
void (float b) utils_print_bit =
{
    if (b)
        sprint(self, "1");
    else
        sprint(self, "0");
};

//
//  P R I N T  B I N
//
//  Prints a binary number followed by CR to 'self'.
//  Used for debugging.
//
void (float n) utils_print_bin =
{
    local float bit;

    if (!n)
    {
        sprint(self, "0\n");
        return;
    }

    bit = 32768 * 32768 * 2;
    while (bit > 0.5)
    {
        if (n & bit)
        {
            while (bit > 0.5)
            {
                utils_print_bit(n & bit);
                bit = bit / 2;
            }
        }
        bit = bit / 2;
    }
    sprint(self, "\n");
};

//
//  D U M P  P O S I T I O N
//
//  Dumps all 3d position information for an entity to 'self'.
//  Used for debugging.
//
void (entity e) utils_dump_position =
{
    sprint(self, "origin = ");
    utils_print_vec(e.origin);
    sprint(self, "mins = ");
    utils_print_vec(e.mins);
    sprint(self, "maxs = ");
    utils_print_vec(e.maxs);
    sprint(self, "size = ");
    utils_print_vec(e.size);
    sprint(self, "absmin = ");
    utils_print_vec(e.absmin);
    sprint(self, "absmax = ");
    utils_print_vec(e.absmax);
};

//
//  M I N
//
float (float a, float b) utils_min =
{
    if (a < b)
        return a;
    return b;
};

//
//  M A X
//
float (float a, float b) utils_max =
{
    if (a > b)
        return a;
    return b;
};

//
//  M I N 3
//
float (float a, float b, float c) utils_min3 =
{
    local float d;
    if (a < b)
        d = a;
    else
        d = b;
    if (d < c)
        return d;
    return c;
};

//
//  M A X 3
//
float (float a, float b, float c) utils_max3 =
{
    local float d;
    if (a > b)
        d = a;
    else
        d = b;
    if (d > c)
        return d;
    return c;
};

//
//  M A X 4
//
float (float a, float b, float c, float d) utils_max4 =
{
    local float e;
    if (a > b)
        e = a;
    else
        e = b;

    if (e > c)
        if (e > d)
            return e;
        else
            return d;
    else if (d > c)
        return d;
    else 
        return c;
};

//
//  M A K E  S C H E D U L E D  E V E N T
//
//  Creates a new dynamic entity which will call the given
//  think function after the given amout of time; the entity's
//  owner is 'self'.
//
entity (void() think_function, float think_time) utils_make_scheduled_event =
{
    local entity temp;
    temp = spawn();
    temp.classname = "elohim_temp";
    temp.owner = self;
    temp.nextthink = time + think_time;
    temp.think = think_function;
    return temp;
};

//
//  S E T  C V A R
//
//  Set the console variable 'varName' to 'value'.
//
void (string varName, float value) utils_set_cvar =
{
    local string temp;

    temp = ftos(value);
    cvar_set(varName, temp);
};

//
//  D O  I T E M
//
//  Do something to all items of the given type.  For each item,
//  'dofunc()' is called with 'self' pointing to the item.
//
void (void () dofunc, string item_name) utils_do_item =
{
    local entity oldself;

    oldself = self;
    self = find(world, classname, item_name);
    while (self)
    {
        dofunc();
        self = find(self, classname, item_name);
    }
    self = oldself;
};

//
//  D O  P R O J E C T I L E S
//
//  Do the same thing to all rockets, grenades and nails.
//
void (void () dofunc) utils_do_projectiles =
{
utils_do_item(dofunc, "missile");
utils_do_item(dofunc, "grenade");
utils_do_item(dofunc, "spike");
};

//
//  D O  I T E M S
//
//  Do the same thing to all respawnable items.
//
void (void () dofunc) utils_do_items =
{
    utils_do_item(dofunc, "item_health");
    utils_do_item(dofunc, "item_armor1");
    utils_do_item(dofunc, "item_armor2");
    utils_do_item(dofunc, "item_armorInv");
    utils_do_item(dofunc, "item_shells");
    utils_do_item(dofunc, "item_spikes");
    utils_do_item(dofunc, "item_rockets");
    utils_do_item(dofunc, "item_cells");
    utils_do_item(dofunc, "weapon_nailgun");
    utils_do_item(dofunc, "weapon_supernailgun");
    utils_do_item(dofunc, "weapon_supershotgun");
    utils_do_item(dofunc, "weapon_rocketlauncher");
    utils_do_item(dofunc, "weapon_grenadelauncher");
    utils_do_item(dofunc, "weapon_lightning");
   // utils_do_item(dofunc, "item_sigil");
    utils_do_item(dofunc, "item_artifact_invulnerability");
    utils_do_item(dofunc, "item_artifact_envirosuit");
    utils_do_item(dofunc, "item_artifact_invisibility");
    utils_do_item(dofunc, "item_artifact_super_damage");
};

//
//  D O  P L A Y E R S
//
//  Do the same thing to all connected players.  For each player,
//  'dofunc()' is called with 'self' pointing to the player.
//
void (void () dofunc) utils_do_players =
{
    local entity oldself;

    oldself = self;
    self = find(world, classname, "player");
    while (self)
    {
        if (self.style & ELOHIM_CONNECTED)
            dofunc();
        self = find(self, classname, "player");
    }
    self = oldself;
};



//
//  S T O F
//
//  Convert a string to a float.
//
float (string s) utils_stof =
{
    local float f, temp;

    temp = cvar("v_kickpitch");
    cvar_set("v_kickpitch", s);
    f = cvar("v_kickpitch");
    utils_set_cvar("v_kickpitch", temp);
    return f;
};

// CRMOD
//  V I S I B L E
//    by Paul Baker
//
//    returns 1 if the entity a can see entity b.
//
float (entity a, entity b) utils_visible =
{
	traceline (a.origin, b.origin, TRUE, a);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

//
//  N E W  V I S I B L E
//     by Paul Baker
//
//  Corrected and optimized by J.P.
//
//  Return TRUE if entity a can 'see' entity b.
//
float (entity a, entity b) utils_new_visible =
{
	local float dist;
	local float crosswater;

	// First trace as far as we can, keeping track of crosswater
	crosswater = 0;
	trace_ent = a;
	trace_fraction = 0;
	while ((trace_ent != world) && (trace_fraction < 1.0))
	{
		traceline(trace_ent.origin, b.origin, TRUE, trace_ent);
		if (trace_inopen && trace_inwater)
			crosswater = 1;
	}

	// If we can see all the way to the player, return 4 - crosswater
	if (trace_fraction == 1.0)
		return (4 - crosswater);

	// If the player is right on the other side of the wall, return 2 - crosswater
    dist = vlen(trace_endpos - b.origin);
	if (dist < 200)
		return (2 - crosswater);

	// Otherwise, player is not visible at all
	return 0;
};


// CRMOD
//  T O G G L E  O F L A G
//    by Paul Baker
//
//  Toggles the specified flag in self.oflags
//
void (float flag, string name) utils_toggle_oflag = 
{
	if (self.oflags & flag)
	{
		self.oflags = self.oflags - flag;
		sprint2(self, name, " disabled\n");
	}
	else
	{
		self.oflags = self.oflags | flag;
		sprint2(self, name, " enabled\n");
	}
};

//
//  T O G G L E  F L A G
//
//  Toggles the specified flag in self.style
//
void (float flag, string name) utils_toggle_flag = 
{
	if (self.style & flag)
	{
		self.style = self.style - flag;
		sprint2(self, name, " disabled\n");
	}
	else
	{
		self.style = self.style | flag;
		sprint2(self, name, " enabled\n");
	}
};

// CRMOD
// S T U F F  T O  P L A Y E R
//      by Paul Baker
//
//   stuffcmd's a message to the player by their entity number (status number).
//   this is used primarily to tell a person they've been kicked.
//

void (float i, string txt) utils_stuff_to_player =
{
	local entity e;
	e = find(world, classname, "player");
	while (e != world)
	{
		if (e.colormap == i)
		{
			stuffcmd(e, txt);
			return;
		}
		e = find(e, classname, "player");
	}
};

//
//  G E T  B I T
//
//  Returns 1 << index
//
float (float index) utils_get_bit =
{
	local float bit;

	if (index & 8)
		bit = 256;
	else
		bit = 1;
	if (index & 4)
		bit = bit * 16;
	if (index & 2)
		bit = bit * 4;
	if (index & 1)
		bit = bit * 2;
	return bit;
};

//
//  F I N D  Z E R O
//
//  Returns the index of the first zero in a binary number
//
float (float num) utils_find_zero = 
{
	local float bit, index;

	index = 0;
	bit = 1;
	while (num & bit)
	{
		bit = bit * 2;
		index = index + 1;
	}
	return index;
};

//
//  I L L E G A L  N A M E
//
//  Returns TRUE if the client name is illegal, FALSE otherwise.
//
float (string cname) utils_illegal_name = 
{
    if (cname == "" || cname == "unconnected" || 
		cname == elohim_teamname1 || cname == elohim_teamname2)
	{
		return TRUE;
	}
	return FALSE;
};

float () mode_is_public_ctf =
{
  if ((elohim_playmode & CLANRING_CTF_MODE) && 
    (!(elohim_playmode & RACE_MODE) && !(elohim_playmode & ELOHIM_MATCH_MODE)))
    return TRUE;
  else 
    return FALSE;
};

float () mode_is_public =
{
  if ((elohim_playmode & DM_PUBLIC_MODE) || (mode_is_public_ctf() == TRUE))
    return TRUE;
  else 
    return FALSE;
};

float () mode_is_prewar =
{
     if ((elohim_playmode & ELOHIM_MATCH_MODE) && !(elohim_state & ELOHIM_MATCH_STARTED))
        return TRUE;
    return FALSE;   
}

float () mode_is_ffa =
{
    if ((elohim_playmode & DM_PUBLIC_MODE) || (elohim_playmode & CLANRING_CTF_MODE))
        return FALSE;
    if (elohim_playmode & RACE_MODE)
        return FALSE;
    if (elohim_playmode & ELOHIM_MATCH_MODE)
        return FALSE;
    return TRUE;
};



float () players_connected =
{
    local entity e;
    local float pcount = 0;

    e = find(world, classname, "player");
    while (e)
    {
        if (e.style & ELOHIM_CONNECTED)
            pcount += 1;
        e = find(e, classname, "player");
    }
    return pcount;
}


float () anybody_connected =
{
    local float somebody = players_connected();
    if (somebody)
        return TRUE;
    return FALSE;
}; 



/////////   MATH


float(float n1,float n2) math_min =
{
    return n1 < n2 ? n1 : n2;
}

float(float n1,float n2) math_max =
{
    return n1 > n2 ? n1 : n2;
}

float(float nValue,float nMin,float nMax) math_clamp =
{
    return math_max(math_min(nValue,nMax),nMin);
}






//////// CTF UTILS   ////////////////


//
//  F I N D   P L A Y E R   F U N C T I O N S
//

entity findPlayerInTeam(float findTeam,entity start) {
    local entity ent = start;
    while((ent = find(ent,classname,"player"))) {
        if(ent.team == findTeam)
            return ent;
    }

    return FALSE;
}

entity findPlayer(entity start) {
    return find(start,classname,"player");
}

entity findPlayerSpawn(entity start,float findTeam) {
    local entity ent;

    if (findTeam == TEAM_RED)
        ent = find(start,classname,"info_player_team1");
    else if (findTeam == TEAM_BLUE)
        ent = find(start,classname,"info_player_team2");
    else
        ent = find(start,classname,"info_player_deathmatch");

    return ent;
}



void (string s1) announce =
{
	bprint2(s1,"\n");
	localcmd("cmd ");
    localcmd(s1);
	localcmd("\n");
};

