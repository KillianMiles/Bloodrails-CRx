
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

//float	intermission_running;
//float	intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
};

void() SetNewParms2;

void() SetChangeParms =
{
	if (self.health <= 0)
	{
        SetNewParms2 ();
		return;
	}

// remove items
	self.items = self.items - (self.items & 
	(IT_SHOTGUN | IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	
// cap super health
	if (self.health > 100)
	{
		self.health = 100;
	}
	if (self.health < 50)
		self.health = 50;
	parm1 = self.items;
	parm2 = self.health;
	if (self.armorvalue > 200)
	{
		self.health = 200;
	}
	parm3 = self.armorvalue;
	if (self.ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;

    // ELOHIM_MOD - parms10-13 contains elohim player flags
    parm10 = self.style;    // player flags
    parm11 = self.state;    // player ID
    parm12 = self.oflags;   // CRMOD observer flags
	parm13 = self.player_flag;
	parm14 = self.hudspace;
    // END_MOD
};

//
// ELOHIM_MOD
//
// Created SetNewParms2 and changed all SetNewParms references to
// SetNewParms2.  SetNewParms is called by Quake.exe when a client
// first connects; SetNewParms2 is called thereafter by the QuakeC
// code every time the client is reinserted into the server (respawn,
// level change, etc.)
//
// Also created SetPracticeParms which is called for practice mode
//

//TODO: don't need to set hook in these if there is a flag check too
void() SetPracticeParms =
{
    parm1 = IT_RAILGUN | IT_AXE |  IT_ARMOR3 | IT_HOOK;
	parm2 = 100;
	parm3 = 200;
    parm4 = 100;
    parm5 = 200;
    parm6 = 100;
    parm7 = 100;
    parm8 = 2;
    parm9 = 80;
};


//
//  Called by Quake server when a new client connects
//
void() SetNewParms =
{
    if (elohim_playmode & RACE_MODE)
        SetPracticeParms();
	else
	{
		parm1 = IT_RAILGUN | IT_AXE | IT_HOOK;
		parm2 = 100;
		parm3 = 0;
		parm4 = 25;
		parm5 = 0;
		parm6 = 0;
		parm7 = 0;
		parm8 = 2;
		parm9 = 0;
	}

    parm10 = ELOHIM_NEW_CLIENT; // CRMOD observer flags moved | ELOHIM_OBSERVER_WALK; // elohim player flags
    //parm13 = OBSERVER_WALK; // CRMOD observer flags
    parm11 = 0; // player ID.. will be set by elohim_client_connect
    parm12 = 0; // ID of player being watched in observer mode
	parm13 = 0;
	parm14 = 0;
};

//
//  Called by QuakeC to reset a clients parameters
//
void() SetNewParms2 =
{
    if (elohim_playmode & RACE_MODE)
        {                               //Practice armor (Full armor)
		SetPracticeParms();
        }

	else
	{
		if ((elohim_playmode & ELOHIM_MATCH_MODE)&&(!(elohim_state & ELOHIM_TIMER_STARTED)))
		{
			SetPracticeParms ();
		}
		else
		{
			parm1 = IT_RAILGUN | IT_AXE | IT_HOOK;
			parm2 = 100;
			parm3 = 0;
			parm4 = 25;
			parm5 = 0;
			parm6 = 0;
			parm7 = 0;
			parm8 = 2;
			parm9 = 0;
		}
	}

	parm10 = self.style; // elohim player flags
	parm11 = self.state; // player ID
	parm12 = self.oflags; // CRMOD observer flags
	parm13 = self.player_flag;
	parm14 = self.hudspace;
};
// END_MOD

void() DecodeLevelParms =
{
    //
    // ELOHIM_MOD
    //
    // First restore player elohim flags *then* check to see if level = start.
    // Also, reset player status at start level even if serverflags = 0.
    // Changed SetNewParms to SetNewParms2.
    self.style = parm10;
    self.state = parm11;
    self.oflags = parm12;  // CRMOD observer flags
	self.player_flag = parm13;
	self.hudspace = parm14;

    if (world.model == "maps/ctf_dissocia_r1.bsp")
        SetNewParms2 ();   // take away all stuff on starting new episode

    // END_MOD
	
	self.items = parm1;
	self.items2 = 0;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
	self.last_returned_flag = -10;
	self.last_fragged_carrier = -10;
	self.flag_since = -10;
	self.last_hurt_carrier = -10;
	self.flag_carrier = 0;	
};

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
	//unreachable - fix warning
	return spot;
};


//string nextmap; // ELOHIM_MOD - moved this to elohim.qc
void() GotoNextMap =
{
    if (cvar("samelevel") & 1)  // if samelevel is set, stay on same level
		changelevel (mapname);
	else
    {
        // ELOHIM_MOD - check for start0/start1
        if (nextmap == "start0")
        {
            serverflags = 0;
            changelevel("start");
        }
        else if (nextmap == "start1")
        {
            serverflags = 15;
            changelevel("start");
        }
        else
            changelevel (nextmap);
        // END_MOD
    }
};


void() ExitIntermission =
{
// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

//
// run some text if at the end of an episode
//
	if (intermission_running == 2)
	{
		
		GotoNextMap();
	}
	
	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{	// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		
		if ( (serverflags&15) == 15)
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}
		
	}

	GotoNextMap();
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	
	
	
	if (time < intermission_exittime)
		return;


	if (!self.button0 && !self.button1 && !self.button2)
		return;
		
	if(elohim_teamfrags1 > 1.25 * elohim_teamfrags2 || elohim_teamfrags2 > 1.25 * elohim_teamfrags1) Rebalance_Teams();  //automatic rebalance after each map

    ExitIntermission ();
};

void() execute_changelevel =
{
	local entity	pos;

    intermission_running = 1;

	elohim_teamsize1 = 0;
	elohim_teamsize2 = 0;
	//elohim_teamsize3 = 0;
	//elohim_teamsize4 = 0;
	
// enforce a wait time before allowing changelevel
	if (deathmatch)
        intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	
	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);

		if (other.player_flag & PF_ITEM_RUNE1_FLAG)
			other.player_flag -= PF_ITEM_RUNE1_FLAG;
		if (other.player_flag & PF_ITEM_RUNE2_FLAG)
			other.player_flag -= PF_ITEM_RUNE2_FLAG;
		if (other.player_flag & PF_ITEM_RUNE3_FLAG)
			other.player_flag -= PF_ITEM_RUNE3_FLAG;
		if (other.player_flag & PF_ITEM_RUNE4_FLAG)
			other.player_flag -= PF_ITEM_RUNE4_FLAG;

		if (other.items2 & IT2_SIGIL1)
			other.items2 -= IT2_SIGIL1;
		if (other.items2 & IT2_SIGIL2)
			other.items2 -= IT2_SIGIL2;
		if (other.items2 & IT2_SIGIL3)
			other.items2 -= IT2_SIGIL3;
		if (other.items2 & IT2_SIGIL4)
			other.items2 -= IT2_SIGIL4;

		if (other.player_flag & PF_ITEM_RUNE_MASK)
			other.player_flag -= PF_ITEM_RUNE_MASK;

		if ((other.player_flag & PF_MIDGAME_JOIN) && !(other.style & ELOHIM_OBSERVER))
		{
			other.player_flag -= PF_MIDGAME_JOIN;
		}

		other = find (other, classname, "player");
	}	

    WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
    // ELOHIM_MOD - do nothing in match mode
	if (!coop)
    	return;
    // END_MOD
 
	if (other.classname != "player")
		return;

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

    // ELOHIM_MOD - flag gameover so that clients can't suicide during intermission
    gameover = TRUE;
    // END_MOD

    if (deathmatch) // ELOHIM_MODE 'coop || deathmatchp' => 'deathmatch'
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
	
	nextmap = self.map;



	SUB_UseTargets ();

	if ( (self.spawnflags & 1) && (deathmatch == 0) )
	{	// NO_INTERMISSION
		GotoNextMap();
		return;
	}
	
	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map)
        objerror ("changelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	if(self.classname == "dummy") return;
	
	SetNewParms2 ();

	PutClientInServer ();

	self.axe_powered = 0;
	self.mag_recharge_time = time - 3.3;
	self.shield_time = time - 10;
	self.shield_recharge_time  = time - 10;
	
				
	self.spawn_protect_time = time;      //ammo_rockets = spawn_protect_time
	if (!(elohim_playmode & RACE_MODE) && !(elohim_playmode & ELOHIM_NO_SPAWN_PROTECT))
	{
		if(!(self.items & IT_ARMOR1) && !(self.items & IT_ARMOR2) && !(self.items & IT_ARMOR3)) self.items = self.items | IT_ARMOR1;   //SPAWN PROTECT
		self.armorvalue  	= 125;
		self.armortype   	= 40.001;
	}

};


/*
ClientKill

Player entered the suicide command
============
*/

void() ClientKill =
{
        
    // ELOHIM_MOD
    // if intermission, do nothing
    if (gameover)
        return;

    // observers can't suicide
    if (self.style & ELOHIM_OBSERVER)
        return;

    // check for maximum number of suicides
    if ((elohim_client_suicide() == ELOHIM_TOO_MANY_SUICIDES)  && !(elohim_playmode & RACE_MODE))
        return;
    // END_MOD
	
	
	
	
	if(!(elohim_playmode & RACE_MODE))
	{
		bprint (self.netname);
		bprint (" suicides\n");
	}
	
	set_suicide_frame ();

	if (elohim_playmode & CLANRING_CTF_MODE)
	{
		if(self.items & (IT_KEY1))
		{
			ctf_player_drop_flag(self, 1);
			BLUE_FLAG_TAKEN = 0;
		}
		
		if(self.items & (IT_KEY2))
		{
			ctf_player_drop_flag(self, 1);
			RED_FLAG_TAKEN = 0;
		}
		

		if (self.player_flag & PF_ITEM_RUNE_MASK)
			rune_drop();
	}
    // ELOHIM_MOD
    //
    // - use client_frag so that penalty will be added to team score
    // - changed penalty to -1
    // - no penalty during pre-match
    // - add suicide to stats
    //
    //self.frags = self.frags - 2;    // extra penalty
    if (!(elohim_playmode & ELOHIM_MATCH_MODE) || elohim_state & ELOHIM_MATCH_STARTED)
    {
        client_frag(self, -1);
        self.mangle_x = self.mangle_x + 1;
    }
    // END_MOD

	

	// ELOHIM_MOD
	// check for not-ready non-observers in match mode
	if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		if (!(self.style & (ELOHIM_READY | ELOHIM_OBSERVER)))
		{
			// This is a hack!
			self.style = self.style | ELOHIM_READY;
			respawn();
			self.style = self.style - ELOHIM_READY;
			return;
		}
	}
	// END_MOD

	respawn ();
};

float(vector v) CheckSpawnPoint =
{
		//return FALSE;
	local entity thing;
	thing = findradius(v, 64); // ELOHIM_MOD 32 => 128 //TODO: back to  128?
	while(thing)
	{
		if ((thing.classname == "player") && (thing.style & ELOHIM_CONNECTED) &&
			!(thing.style & ELOHIM_OBSERVER))
		{
			dprint("spawn point is not safe\n");
			thing = world;
			return TRUE;
		}
		else
			thing = thing.chain;
	}
	return FALSE;	
};

//for ctf base spawns
entity() SelectTeamSpawnPoint =
{
	local	entity spot;
	local	float  pcount;
	local   float curTeam;

	//if possible, first spawn should be near base
	if ((elohim_playmode & CLANRING_CTF_MODE && !(elohim_playmode & RACE_MODE)) 
		&& !(self.player_flag & PF_FIRST_SPAWN) && (self.style & ELOHIM_READY))
	{
		if (self.player_flag & PF_MIDGAME_JOIN)
		{
			//Joining a public ctf game in progress, pick a random spawn near base
			curTeam = self.player_flag & PF_TEAM_BLUE ? TEAM_BLUE : TEAM_RED;

			if ((curTeam == TEAM_BLUE && elohim_num_bluespawns > 0) ||
				(curTeam == TEAM_RED && elohim_num_redspawns > 0))
			{
				if (curTeam == TEAM_BLUE)
				{
					pcount = random() * (elohim_num_bluespawns - 0.001);
				}
				else
				{
					pcount = random() * (elohim_num_redspawns - 0.001);
				}

				pcount = floor(pcount);

				spot = findPlayerSpawn(world, curTeam);
				while (spot != world && pcount > 0)
				{
					spot = findPlayerSpawn(spot, curTeam);
			
					if(spot.team == curTeam)
						pcount = pcount - 1;
				}
				if (spot != world)
				{
					// pcount = CheckSpawnPoint(spot.origin);
					// if (pcount == 0)
					// {
						//lastspawn = spot;
						return spot;
					//}
				}
			}
			//no midgame team spawn point found
		}
		else
		{
			//starting a new public ctf game after finishing one on a team
			if (self.player_flag & PF_TEAM_BLUE) {
				spot = findPlayerSpawn(lastspawn_blue, TEAM_BLUE);
				while (spot != world)
				{
					lastspawn_blue = spot;
					if (spot == self.trigger_field)
						pcount = 1;
					else
					{
						pcount = CheckSpawnPoint(spot.origin);
					}
					if (pcount == 0) {
						lastspawn_blue = spot;
						return spot;
					}
					pcount = 0;
					spot = findPlayerSpawn(lastspawn_blue, TEAM_BLUE);
				}
				//fall through to random spot
			}
			else if (self.player_flag & PF_TEAM_RED) {
				spot = findPlayerSpawn(lastspawn_red, TEAM_RED);
				while (spot != world)
				{	
					lastspawn_red = spot;
					if (spot == self.trigger_field)
						pcount = 1;
					else
					{
						pcount = CheckSpawnPoint(spot.origin);
					}
					if (pcount == 0) {
						return spot;
					}
					pcount = 0;
					spot = findPlayerSpawn(lastspawn_red, TEAM_RED);
				}
			}
			//no starting team spawn point found
		}
	}

	return 0;
};

/*
============

Returns the entity to spawn at
============
*/
entity(float whatkind) SelectSpawnPoint =
{
	local	entity spot;
	local	float  pcount;

	//if(mapname == "tut1" && self.origin_z > 2600)


	//TODO: need to refactor this some more
    if (deathmatch)
	{
		
		if(mapname == "tut1" && self.health < 0)
		{
			spot = find (world, classname, "info_player_start");
			if (!spot)
				error ("PutClientInServer: no info_player_start on level");
	
			return spot;		
		}	
		else if(mapname == "tut1" && whatkind ==1)
		{
			spot = find (world, classname, "info_player_start");
			if (!spot)
				error ("PutClientInServer: no info_player_start on level");
	
			return spot;
		}
		else
		{
			pcount = random() * (elohim_num_spawns - 0.001);
			pcount = floor(pcount);

			spot = find(world, classname, "info_player_deathmatch");
			while (pcount > 0)
			{
				spot = find(spot, classname, "info_player_deathmatch");
				if (spot != world)
					if(spot.team == TEAM_ALL)
						pcount = pcount - 1;
			}
			lastspawn = spot;
			while (1)
			{
				if (spot != world)
				{
					if (spot == self.trigger_field)
						pcount = 1;
					else
					{
						pcount = CheckSpawnPoint(spot.origin);
					}
					if (pcount == 0)
						return spot;
					pcount = 0;
				}
				spot = find(spot, classname, "info_player_deathmatch");
				if (spot == lastspawn)
				{
					// Can't find a spot!
					// Check self.trigger_field one last time
					pcount = CheckSpawnPoint(self.trigger_field.origin);
					if (pcount == 0)
					{
						return self.trigger_field;
					}
					return lastspawn;
				}
			}
		}
        // END_MOD
	}

	
	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}
	
	
	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	
	return spot;
};







void() DecodeLevelParms;
void() PlayerDie;



void() update_dummy =
{
	if (self.flags & FL_ONGROUND) self.flags = self.flags - (self.flags & FL_ONGROUND);
	
	//if(self.origin_z < 2586) self.origin_z = 2586;
	//setorigin(self, self.origin);
	self.nextthink = time;
}

void() PutDummyInServer =

{
	//local float x = random()*200;
	//local float y = random()*200;
	//static float dum;
	//if(dum == 1) return;
	//dum =1;	
	local	entity dummy, spot;
	//dummy.classname = "dummy";
	spot = SelectSpawnPoint (1);
	dummy = spawn();
	dummy.trigger_field = spot;  // ELOHIM_MOD

	dummy.classname = "dummy";
	dummy.health = 100;
	dummy.takedamage = DAMAGE_AIM;
    	dummy.solid = SOLID_SLIDEBOX;
	dummy.movetype = MOVETYPE_TOSS;
	dummy.show_hostile = 0;
	dummy.max_health = 100;
	dummy.effects = 0;
	dummy.velocity = '0 0 0';
	dummy.frags = -1;
	

	

	dummy.attack_finished = time;
	dummy.th_pain = player_pain;
	dummy.th_die = PlayerDie;
	
	dummy.deadflag = DEAD_NO;

	dummy.avelocity 		= '0 0 0';
	dummy.punchangle		= '0 0 0';


	
	setorigin(dummy, spot.origin + '0 0 -3');	//R00k: change our origin and relink our edict.
	setorigin(dummy, spot.origin + '0 0 80');	//R00k: change our origin and relink our edict.
	dummy.oldorigin = dummy.origin;			//R00k: update oldorigin so we dont respawn where we died.

	setmodel(dummy, "mdl/player.md3");
	dummy.skin = 0;
	dummy.frame = 18;

	setsize (dummy, VEC_HULL_MIN, VEC_HULL_MAX);
	
	dummy.view_ofs = '0 0 22';

	//dummy.state = time;                      


	 player_stand1();
    spawn_tdeath (dummy.origin, self);
    makevectors(dummy.angles);
    spawn_tfog (dummy.origin + v_forward*20);
    
	dummy.nextthink = time;
	dummy.think = update_dummy;

};




void() PutClientInServer =
{
	
	
	if(self.classname == "dummy") return;
	
	//checkextension("DP_SV_ROTATINGBMODEL");
	
	local	entity spot, teamSpot;
        self.modelindex = 0;    
	
		spot = SelectSpawnPoint (0);

	

    self.trigger_field = spot;  // ELOHIM_MOD




			

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
    self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.runetime = time;
	self.velocity = '0 0 0';
	
	//if(self.player_flag & PF_ITEM_RUNE1_FLAG) self.player_flag -= PF_ITEM_RUNE1_FLAG;
	//else if(self.player_flag & PF_ITEM_RUNE2_FLAG) self.player_flag -= PF_ITEM_RUNE2_FLAG;
	//else if(self.player_flag & PF_ITEM_RUNE3_FLAG) self.player_flag -= PF_ITEM_RUNE3_FLAG;
	//else if(self.player_flag & PF_ITEM_RUNE4_FLAG) self.player_flag -= PF_ITEM_RUNE4_FLAG;

	DecodeLevelParms ();
	
	

	if(infokey(self, "rail_cvar") =="1")
	{
		if(!(self.player_flag & PF_CLEANTRAIL)) self.player_flag = self.player_flag | PF_CLEANTRAIL;
	}
	else 
	{
		if(self.player_flag & PF_CLEANTRAIL) self.player_flag = self.player_flag - PF_CLEANTRAIL;
	}



	if (elohim_playmode & CLANRING_CTF_MODE)
	{
		if (!(self.player_flag & PF_FIRST_SPAWN))
		{
			teamSpot = SelectTeamSpawnPoint();
			if (teamSpot)
			{
				spot = teamSpot;
			}
			self.player_flag |= PF_FIRST_SPAWN;
		}
	}

	if (mode_is_public() == TRUE)
	{
		if ((self.player_flag & PF_TEAM_BLUE) || (self.player_flag & PF_TEAM_RED))
		{
			if (self.player_flag & PF_TEAM_RED)
			{
				setcolor2(self, COLOR_RED, COLOR_RED);
				self.team = TEAM_RED;
				self.height = self.team - 1;
				 
				
				self.skin = 1;  //skin fullbright red ^^^switch
			}
			else 
			{
				setcolor2(self, COLOR_BLUE, COLOR_BLUE);
				self.team = TEAM_BLUE;
				self.height = self.team - 1;
				
				
				self.skin = 2;  //skin fullbright blue  ^^^switch
			}
		}
	}
	
	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;

// paustime is set by teleporters to keep the player from moving a while
//  self.pausetime = 0; // ELOHIM_MOD - unused
	
	angles_fixangle(spot.angles);

	self.avelocity 		= '0 0 0';
	self.punchangle		= '0 0 0';

	setorigin(self, spot.origin + '0 0 1');	//R00k: change our origin and relink our edict.
	self.oldorigin = self.origin;			//R00k: update oldorigin so we dont respawn where we died.

	self.jump_flag 	= 0; // clear jump velocity to prevent falling damage

// oh, this is a hack!


	setmodel(self, "mdl/player.md3");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

	self.state = time;

	                        

	if (elohim_playmode & ELOHIM_WRAITH && self.wraith ==1)       //start player with Axe and Railgun (with 999 ammo)
	{
	self.items = 0;
	self.items = self.items | IT_AXE | IT_HOOK | IT_INVISIBILITY | IT_SUIT;
	self.impulse = 1; 
        }  
        else 
        {
	self.items = 4098; 
	self.impulse = 3;
	if(!(elohim_playmode & ELOHIM_NOAMMO) && !(elohim_playmode & PROJECTILES)) self.ammo_slugs = 7;
	else if(elohim_playmode & PROJECTILES) self.ammo_slugs = 9;
	
	if(elohim_playmode & ELOHIM_NOAMMO) self.ammo_slugs = 999;
		   
        }     
         


	
	if (elohim_playmode & RACE_MODE)       //start player with 200 red armor if Practice (Full armor)  this replaces set200
	{
		self.items = self.items | IT_ARMOR3;
		self.armorvalue  	= 75;
		self.armortype   	= 80.001;
		self.health 		= 75;
	}
	else 
	{
		self.items = self.items | IT_ARMOR1;
		self.armorvalue  	= 40;
		self.armortype   	= 40.001;
	}
	
	
	self.alpha = 1; //JANUARY player model gib bug
	if(self.nogib_death ==1 || self.nogib_death ==2) self.nogib_death =0;
	
	/*
	stuffcm(self, "cl_forwardspeed 200\n");     //make sure the maxspeed gets reset 9-17-23
	stuffcm(self, "cl_sidespeed 350\n");
	stuffcm(self,"r_particledesc particles\n");
	stuffcm(self, "cl_bob 0.0032\n");
	stuffcm(self, "an0\n");
	*/
	stuffcmd(self, "pcis01\n");
	
	self.tilted =0;


    // Add elohim specific stuff
    elohim_put_client_in_server();
};


void() info_tfgoal ={};
void() info_player_teamspawn ={};
void() info_player_start ={};
void() monster_army ={};
void() monster_zombie ={};
void() monster_enforcer ={};
void() i_t_g ={};
void() func_explobox ={};



void() info_player_start2 ={};
void() testplayerstart ={};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
	self.classname = "info_player_deathmatch";
    elohim_num_spawns = elohim_num_spawns + 1;
};

void() info_player_team1 =
{
	self.classname = "info_player_team1";
	self.team = TEAM_RED;
	elohim_num_redspawns = elohim_num_redspawns + 1;
};

void() info_player_team2 =
{
	self.classname = "info_player_team2";
	self.team = TEAM_BLUE;
	elohim_num_bluespawns = elohim_num_bluespawns + 1;
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
    remove(self);   // ELOHIM_MOD - coop not supported
};

/*
===============================================================================

RULES

===============================================================================
*/

//
// ELOHIM_MOD
//
// Fixed the bug that causes the start level to loop.  Changed the sequence
// of levels to:
//
// start->episode1->start->episode2->start->episode3->start->episode4->
// start->end->deathmatch->deathmatch->deathmatch->deathmatch->start
//
// (one big loop.. first start = last start).
// (of course, deathmatch = dm1->dm2->dm3->dm4->dm5->dm6)
//
// Included the Underearth in episode 2, but NOT Ziggurat Vertigo in e1.
//

/*
go to the next level for deathmatch
only called if a time or frag limit has expired
*/
void() NextLevel =
{
	local entity o;
	local string teamname;

	if ((mode_is_public()) && elohim_teamsize1 > 0 && elohim_teamsize2 > 0)
	{
		bprint("The match is over\n");
		match_bprint_score();
		teamname = strings_get_teamname(elohim_winning_team);

		if (elohim_teamfrags1 == elohim_teamfrags2)
			bprint("Tie game!\n");
		else if (elohim_teamfrags1 > elohim_teamfrags2)
			bprint("The Red Team has won\n");
		else
			bprint("The Blue Team has won\n");

		BLUE_FLAG_TAKEN = 0;
		RED_FLAG_TAKEN = 0;
	}


	
	if (mapname == "end")
	{
		o = spawn();
		o.map = "dm1";
	}

	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");

		// go back to start if no trigger_changelevel
		if (!o)
		{
			mapname = "ctf_dissocia_r1";
			o = spawn();
			o.map = mapname;
		}
	}
	
	


		nextmap = o.map;
	gameover = TRUE;



    o.think = execute_changelevel;
    o.nextthink = time + 0.1;
};
// END_MOD



//============================================================================

void() PlayerDeathThink =
{
	local float		forward;
	
	
	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		self.sounds = time;  //respawn_delay_time
		
		self.print_killa = 1;
		self.ammo_cells = time; //ammo_cells = print_killa_time
		
		return;
	}

	if(time - self.sounds > 5.9) //sounds = respawn_delay_time
	{
		respawn();
	}
	
// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;
	
	local float delay_VAR;
	
	if(self.KDR >= 2.7) delay_VAR = 3.3;   //respawn delay
	else if(self.KDR >= 2.1 && self.frags == top_score_global) delay_VAR = 3.1;   //respawn delay
	else if((elohim_playmode & ELOHIM_WRAITH) && self.wraith ==0) delay_VAR = 5.0;   //respawn delay

	else delay_VAR = 2.3;
	
	if((elohim_playmode & ELOHIM_CLASSIC) || (!(elohim_playmode & DM_PUBLIC_MODE) && !(elohim_playmode & CLANRING_CTF_MODE) && !(elohim_playmode & RACE_MODE))) delay_VAR = 0.10;   //respawn delay
	
	
	
	
	
	if(time - self.sounds < delay_VAR) return;  //sounds = respawn_delay_time
	
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	
	self.print_killa = 0;

	respawn();
};







/*
===========
WaterMove

============
*/
.float	dmgtime;

void() WaterMove =
{
	if (self.movetype == MOVETYPE_NOCLIP)	return;
	if (self.health < 0)	return;

	if (self.waterlevel != 3)
	{
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)	self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{
			if (self.style & ELOHIM_OBSERVER == 0)	sound (self, CHAN_AUTO, "misc/br_outwatr.wav", 1, ATTN_NORM);	// play leave water sound
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)	self.dmgtime = time + 1;
			else	self.dmgtime = time + 0.2;
			T_Damage (self, world, world, 8.7);		// do damage
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4.7);	// do damage
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{	
		// player enter water sound
		if (!(self.style & ELOHIM_OBSERVER))
		{
			if (self.watertype == CONTENT_LAVA && self.waterlevel >=2)	sound (self, CHAN_BODY, "body/br_lava.wav", 1, ATTN_NORM);
			if (self.watertype == CONTENT_WATER)				sound (self, CHAN_AUTO, "body/br_water.wav", 1, ATTN_NORM);
			if (self.watertype == CONTENT_SLIME)				sound (self, CHAN_AUTO, "body/br_slime.wav", 1, ATTN_NORM);
		}


		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (! (self.flags & FL_WATERJUMP) )	self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
	if (self.waterlevel == 2)		CheckWaterJump ();

};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};


/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{

	if (gameover)
	{
		if (intermission_running)
		{
			// otherwise a button could be missed between the think tics
			IntermissionThink ();
			return;
		}
		if (self.view_ofs == '0 0 0')	return;		// intermission or finale
	}


	public_verify_team();

	if (time > self.wait)
	{
		elohim_periodic_checks();
		self.wait = self.wait + 1;
	}

	if (self.style & ELOHIM_SETTING_OPTIONS)
	{
		options_pre_think();
		return;
	}

	if (self.deadflag == DEAD_DYING)
	{
		return;
	}

	if (self.style & ELOHIM_OBSERVER)
	{
		observer_pre_think();
		return;
	}

	if (self.deadflag)
	{
		if (self.deadflag >= DEAD_DEAD)	PlayerDeathThink ();
		return;
	}

	if (elohim_state & ELOHIM_MATCH_PAUSED)
	{
		self.velocity = '0 0 0';
		return;
	}

	if (self.crmod_did_damage + 1 < time)	self.crmod_inflicted = world;  // CRMOD - reset inflicted info 
		


	Called_in_PreThink();


	
	if (self.button2)						PlayerJump ();
	else if (!self.button2 || self.waterlevel >2) 			self.flags = self.flags | FL_JUMPRELEASED;

};
	


/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{
	// HorrorScope
	hr_frame();

	if (self.cam)
		return;
	

	if (self.impulse == 37)
		client_responsetime_show();
	else if (self.impulse == 38)
		client_responsetime_set();

	SetPositions();
	
	if (!(self.style & ELOHIM_CONNECTED))
		return;

    // ELOHIM_MOD
    //
    // - don't do post think stuff while observing
    // - don't do post think stuff while setting options
    // - redirect impulses in [20, 254]
    // - changed gameover test from (self.view_ofs == '0 0 0') to (gameover)



	if (self.deadflag == DEAD_DYING)
	{
		return;
	}



	Called_in_PostThink();			
	




	if (self.style & ELOHIM_OBSERVER)
	{
		observer_post_think();
		return;
	}
	else if ((elohim_state & ELOHIM_TIMER_STARTED) && !(elohim_state & ELOHIM_MATCH_STARTED))
	{
		if (time >= self.delay)
		{
			self.delay = time + 0.1;
			show_rules_prematch();
		}
	}
	else if (!(self.style & ELOHIM_MOTD))
	{
		
		if (time >= self.delay)
		{
			self.delay = time + 0.1;
			if ((mode_is_public() == TRUE) && self.joinmsgtime >= time)
			{
				if (self.height == COLOR_RED)	centerprint(self, "You are on the RED team\n\n\bpress \b'F10'\b for quick-help\b"); //, wsp, qdp, ggp);
				else if (self.height == COLOR_BLUE) centerprint(self, "You are on the BLUE team\n\n\bpress \b'F10'\b for quick-help\b"); //, wsp, qdp, ggp);
			}
			else	hud_update();
		}
	}
	

    if (self.impulse)
    {
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

        if (self.impulse != 22 && (self.impulse >= 20) && (self.impulse <= 255))
            elohim_impulse ();
		else
			self.delayed_impulse = self.impulse;
    }

	if (gameover || self.view_ofs == '0 0 0')
        return;     // intermission or finale
    if (self.deadflag)
        return;
    if (self.style & ELOHIM_SETTING_OPTIONS)
        return;
    if (elohim_state & ELOHIM_MATCH_PAUSED)
        return;
    // END_MOD
		
    // ELOHIM_MOD - Don't let clients change team after committing
    match_verify_team(self);

// do weapon stuff
	W_WeaponFrame ();

	if(time - self.ski_time2 < 1.20 && self.skiing_on !=0) //dont swing axe if skiing
	{
		if(!self.hook_out && (self.impulse !=41))
		{
			if(self.ski_sound_counter <16) self.frame = 111;
			else if(self.ski_sound_counter <=32) self.frame = 112;
			else self.frame = 112;
		}
		
	}
	else if(time - self.axe_time <0.1 && time-self.ski_time2 < 0.5)
	{
		if(self.ski_sound_counter <16) self.frame = 111;
		else if(self.ski_sound_counter <=32) self.frame = 112;
		else self.frame = 112;	
	}
	else if(time - self.axe_time <0.1 || self.flags & FL_ONGROUND || self.hook_out) self.ski_time2 -=1;
	
	//if(self.grind_sound_counter1 != 18) self.frame = 110;   //head grind
    // END_MOD
	
	
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
    // ELOHIM_MOD - do elohim specific stuff
    elohim_client_connect();
    // END_MOD
	
	
	bprint (self.netname);
	bprint (" entered the game\n");
	
// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	if (!(elohim_playmode & RACE_MODE))
	{
		if(self.items & (IT_KEY1 | IT_KEY2))
			ctf_player_drop_flag(self, 0);
	}

	// ELOHIM_MOD - check to see if we've already done this
	// (can happen since elohim_kick_player calls ClientDisconnect directly
	if (!(self.style & ELOHIM_CONNECTED))
		return;
	// END_MOD

	// ELOHIM_MOD - check for null name
	if (utils_illegal_name(self.netname))
		self.netname = "player";
	// END_MOD

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
	bprint (" frags\n");

    // ELOHIM_MOD - play gib sound if client was kicked for suiciding
    if (self.cnt < 0)
        sound(self, CHAN_BODY, "body/br_gib.wav", 1, ATTN_NONE);
    else
        sound (self, CHAN_BODY, "body/br_gib.wav", 1, ATTN_NONE);
    // END_MOD

	set_suicide_frame ();

	

    // ELOHIM_MOD
    elohim_client_disconnect();
    // END_MOD
};

//
// ELOHIM_MOD
//
// Added a bunch of new obituaries; got rid of "can't exist on slime alone"
// (I never much liked that one)
//
// Added a same-team check for telefragging.
//
// Added code to keep track of team scores
//
// Added code to keep track of kill stats
//
// Removed check for killed by monster
//

//
//  F R A G
//
//  Adds/substracts a frag to a client and his team in match mode.
//
void (entity client, float fragval) client_frag =
{
    client.frags = client.frags + fragval;
    
    client.crmod_lastkill = time; // CRMOD got a kill

    if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		score_frag(client.height, fragval);
	}
	else if (mode_is_public())
	{
		score_frag(client.height, fragval);
		if (client.frags >= fraglimit)
		{
			if (!gameover)
			{
				bprint("Fraglimit Hit -- Game Over!\n");
				NextLevel();
			}
		}
	}
	else
    {
		if (client.frags >= fraglimit)
		{
			if (fraglimit)
			{
				if (!gameover)
				{
					bprint("Fraglimit Hit -- Game Over!\n");
					NextLevel();
				}
			}
		}
	}
};

