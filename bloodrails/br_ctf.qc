

void() StartItem;
void() W_SetCurrentAmmo;
void (entity client, float fragval) client_frag;
void() hurt_touch;

void() admin_disable_item; //moved from elohim/admin
void() ctf_flag_set;
void() ctf_flag_touch;
void(entity player, entity flag) ctf_drop_flag;
void(entity player, float regenflag) ctf_player_drop_flag;

//TODO: clean this up if (elohim_playmode & ELOHIM_MATCH_MODE)
const string SOUND_GRABDROPPEDFLAG = 	"legacy/boss1_pain.wav";
const string SOUND_WIN = 		"legacy/boss2_pop2.wav";
const string SOUND_GRABFLAG = 		"legacy/shambler_ssight.wav";
const string SOUND_DROPFLAG = 		"legacy/shalrath_pain.wav";
const string SOUND_PICKUP_OWN = 	"doors/medtry.wav";	//christian ice
const string SOUND_PLAYER_RETURNED = 	"doors/meduse.wav";	//christian ice
const string SOUND_PICKUP_ENEMY = 	"legacy/ogre_ogwake.wav";
const string SOUND_RESPAWN = 		"items/itembk2.wav";	//Christian Ice
const string SOUND_HOOK_TEAR = 		"items/br_protect2.wav";	//br
const string SOUND_RETURNED = 		"misc/trigger1.wav";	//Christian Ice
const string SOUND_HOOK_LAND = 		"legacy/blob_hit1.wav";     //Bloodrails - changed from land1 to hit1
const string SOUND_HOOK_ATTACK = 	"legacy/hknight_hit.wav";

const string MODEL_HOOK_HEAD = 		"progs/star_color.mdl";
const string MODEL_WEAPON_HOOK = 	"progs/v_axe_null.mdl";
const string MODEL_FLAG_BLUE = 		"progs/flag_blu.mdl";
const string MODEL_FLAG_RED = 		"progs/flag_red.mdl";



//
//  P U B L I C   M O D E   F U N C T I O N S
//

void () GibPlayer;
void () observer_end;
void () respawn;
entity (entity start) findPlayer;

float () public_put_player_in_team =
{
    local string teamname;

    if (self.team == 1)  return FALSE;

    self.height = self.team - 1;

    if (elohim_team1 == self.height)
    {
		// Add to team1 if possible
		self.player_flag |= PF_TEAM_RED;
		elohim_teamsize1 = elohim_teamsize1 + 1;
    }
    else if (elohim_team2 == self.height)
    {
		self.player_flag |= PF_TEAM_BLUE;
		elohim_teamsize2 = elohim_teamsize2 + 1;
    }
    else
    {
		sprint(self, "You must pick a valid pants color:\n");
		teamname = strings_get_teamname(elohim_team1);
		sprint(self, teamname);
		teamname = ftos(elohim_team1);
		sprint3(self, " (color ", teamname, ") or\n");
		teamname = strings_get_teamname(elohim_team2);
		sprint(self, teamname);
		teamname = ftos(elohim_team2);
		sprint3(self, " (color ", teamname, ")\n");

		return FALSE;
    }

    teamname = strings_get_teamname(self.height);
    bprint4(self.netname, " has joined the ", teamname, "\n");

    return TRUE;
};

void () public_ready = 
{
    // Try to add the player; color him white if unsuccessful
    if (!public_put_player_in_team())
    {
		setcolor2(self, 0, 0);
		self.alpha = 0.001;  //9-17-23  observer transparent
		return;
    }

    self.style = self.style | ELOHIM_READY;

    if (self.style & ELOHIM_OBSERVER)
        observer_end();
};

void () public_notready =
{
    local string teamname; 
    
    self.style = self.style - ELOHIM_READY;

    teamname = strings_get_teamname(self.height);
    bprint4(self.netname, " has left the ", teamname, "\n");

    // Remove from team
    if (self.height == elohim_team1) 		elohim_teamsize1 = elohim_teamsize1 - 1;
    else 					elohim_teamsize2 = elohim_teamsize2 - 1;
};

void () public_verify_team =
{
    if (!(mode_is_public())) return;
    if (self.style & ELOHIM_OBSERVER) return;
    if (gameover) return;
    if (!(self.team > 0 && self.height > -1 && self.player_flag > 0)) return;

    if (self.height != self.team - 1)
    {

        if (self.player_flag & PF_TEAM_RED)
        {
            self.player_flag = self.player_flag - (self.player_flag & PF_TEAM_RED);
            elohim_teamsize1 = elohim_teamsize1 - 1;
        }
        else if (self.player_flag & PF_TEAM_BLUE)
        {
            self.player_flag = self.player_flag - (self.player_flag & PF_TEAM_BLUE);
            elohim_teamsize2 = elohim_teamsize2 - 1;
        }

        if (!public_put_player_in_team())
        {
            setcolor2(self, 0, 0);
            self.alpha = 0.001;  //9-17-23  observer transparent
            return;
        }
        GibPlayerChangeTeams ();
        setmodel (self, "progs/player.mdl");
        self.frame = 0;
        self.modelindex = modelindex_player;
        self.think = respawn;
        self.nextthink = time + 1;
        self.joinmsgtime = time + 5;
    }
};

float () public_join =
{
    if (mode_is_public() == TRUE)
    {
        local float rcnt = 0, bcnt = 0, rfrags = 0, bfrags = 0;
        local float pickteam;
        local entity p = world;
        while((p = findPlayer(p))) {
        if (!(p.style & ELOHIM_OBSERVER) && (p.style & ELOHIM_CONNECTED))          //Bloodrails - team assignment fix suggested by buck - message from 5/8/22
            {
                if(p.team == TEAM_RED)
                {
                    rcnt++;
                    rfrags += p.frags;
                }
                else if(p.team == TEAM_BLUE)
                {
                    bcnt++;
                    bfrags += p.frags;
                }
            }
        }
        
        if (rcnt < bcnt) {		//find best team to join
            pickteam = COLOR_RED;
        } 
        else if (rcnt > bcnt) {
            pickteam = COLOR_BLUE;
        } 
        else
        {
            if (rfrags < bfrags)	 pickteam = COLOR_RED;
            else 			pickteam = COLOR_BLUE;
        }

        setcolor2(self, pickteam, pickteam);

        self.team = pickteam + 1;
        if (!(self.player_flag & PF_MIDGAME_JOIN))	self.player_flag |= PF_MIDGAME_JOIN;

        public_ready();
        self.joinmsgtime = time + 5;
        self.impulse = 0;
        return TRUE;
    }
    else if ((mode_is_ffa()) && !(fte_server))
    {
        observer_end();    //allow jump to join game in match browser
        self.impulse = 0;
        return TRUE;
    }
    return FALSE;
};










/////////  CTF   ////////////////////////////////////////////////////////////////////////////////////////////////





void() ctf_precache =
{
        precache_sound(SOUND_WIN);
        precache_sound(SOUND_GRABFLAG);
        precache_sound(SOUND_DROPFLAG);
        precache_sound(SOUND_GRABDROPPEDFLAG);
        precache_sound(SOUND_PICKUP_OWN);
        precache_sound(SOUND_PICKUP_ENEMY);
        precache_sound(SOUND_RETURNED);
        precache_sound(SOUND_PLAYER_RETURNED);
        precache_sound(SOUND_HOOK_TEAR);
        precache_sound(SOUND_HOOK_LAND);
        precache_sound(SOUND_HOOK_ATTACK);
        
        precache_model(MODEL_HOOK_HEAD);
        precache_model(MODEL_WEAPON_HOOK);
        precache_model(MODEL_FLAG_BLUE);
        precache_model(MODEL_FLAG_RED);
   
}

//respawn flag at base
void(entity flg) ctf_regen_flag =
{
	if (flg == world) return;

	local entity oself = self;
	flg.origin = flg.oldorigin;
	self = flg;
	ctf_flag_set();
	flg = self;
	self = oself;

	sound(flg, CHAN_AUTO, "items/itembk2.wav", 1, ATTN_NORM);
	flg.angles    	= flg.mangle;
	flg.cnt       	= CTF_FLAG_AT_BASE; 
	
	if (flg.owner != world && flg.owner.classname == "player")	flg.owner.items = flg.owner.items - (flg.owner.items & (IT_KEY1 | IT_KEY2));
		
	flg.owner     	= world;
	flg.nextthink 	= (time + my_ticrate);
	flg.watertype	= CONTENT_EMPTY;
	flg.waterlevel	= 0;
};






//find and return both flags to base
void() ctf_regen_flags =
{
	if (red_flag_ent != world)	ctf_regen_flag(red_flag_ent);
	if (blue_flag_ent != world)	ctf_regen_flag(blue_flag_ent);	
};






//return flag to base when touched or wait time elapsed
void() ctf_flag_return =
{
	local float otherTeam;
	if (self.team == TEAM_BLUE)
	{
		otherTeam = TEAM_RED;
		BLUE_FLAG_TAKEN = 0;
	}
	else
	{
		otherTeam = TEAM_BLUE;
		RED_FLAG_TAKEN = 0;
	}

	local entity returnedby;
	local entity p = world;
	//who returned flag?
	while((p = findPlayerInTeam(self.team,p)))
	{
		if (p == other)		returnedby = other;
	}

	p = world;
	while((p = findPlayerInTeam(self.team,p)))
	{
		if (p == other) 
		{
			sprint4(p, returnedby.netname, " returned the ", self.netname,"\n");
			sound (p, CHAN_AUTO, SOUND_PLAYER_RETURNED, 1, ATTN_NONE);
            
			client_frag(other, 1);
			other.last_returned_flag = time;
		}
		else 
		{
			if (!returnedby) 
			{
				centerprint(p,"Your flag has been returned\n");
				sound (p, CHAN_AUTO, SOUND_RETURNED, 1, ATTN_NONE);
			}
			else
			{
				sprint4(p, returnedby.netname, " returned the ", self.netname, "\n");
				sound (p, CHAN_AUTO, SOUND_PLAYER_RETURNED, 1, ATTN_NONE);
			}
		}
	}	

	p = world;
	while((p = findPlayerInTeam(otherTeam,p)))
	{
		if (!returnedby) 
		{
			centerprint3(p,"The ", self.netname, " has been returned\n");
			sound (p, CHAN_AUTO, SOUND_RETURNED, 1, ATTN_NONE);
		}
		else
		{
			sprint4(p, returnedby.netname, " returned the ", self.netname, "\n");
			sound (p, CHAN_AUTO, SOUND_PLAYER_RETURNED, 1, ATTN_NONE);
		}
	}

	ctf_regen_flag(self);

	if (returnedby && other.frags >= fraglimit) 	NextLevel();
		
}




//flag think function
void() ctf_flag_think =
{
	local entity e = self.owner;
	
	
	if (elohim_playmode & ELOHIM_PRACTICE_MODE)	return;

	self.nextthink = time + 0.05;  

	if (self.cnt == CTF_FLAG_AT_BASE)
	{          
		self.solid = SOLID_TRIGGER;    
		return;
	}  

	if(self.cnt == CTF_FLAG_DROPPED && !(elohim_state & ELOHIM_MATCH_PAUSED))
	{
		if (time > self.wait)	ctf_flag_return();
		return;
	}

	if (e.deadflag)
	{
		ctf_player_drop_flag(e, 0);
		return;
	}  

	if (self.cnt != CTF_FLAG_CARRIED)	return;
	self.nextthink = time + 0.05;		
}




//flag touched by other team
void(float dropped) ctf_flag_taken =
{
	local float otherTeam;
        local entity p = world;

	if (self.team == TEAM_BLUE)
	{
		otherTeam =  TEAM_RED;
		BLUE_FLAG_TAKEN = 1;
	}
	else
	{
		otherTeam =  TEAM_BLUE;
		RED_FLAG_TAKEN = 1;
	}


	while((p = findPlayerInTeam(self.team,p)))
	{
		sprint4(p, other.netname, " has taken the ", self.netname, "\n");
		centerprint(p,"Your flag has been taken\n");
		sound (p, CHAN_VOICE, SOUND_PICKUP_ENEMY, 1, ATTN_NORM);
		sound (self, CHAN_AUTO, "misc/take_flag.wav", 1, ATTN_NORM);
	}
    
	p = world;
	
	while((p = findPlayerInTeam(otherTeam,p)))
	{
		if(p != other) 
		{
			centerprint(p,"Your team has the flag\n");
			sound (p, CHAN_VOICE, SOUND_PICKUP_OWN, 1, ATTN_NORM);
		}
	}

        if (dropped)
        { 
		sound (p, CHAN_AUTO, SOUND_GRABDROPPEDFLAG, 1, ATTN_NONE);
		sound (self, CHAN_AUTO, "misc/take_flag.wav", 1, ATTN_NORM);
        }
        else
        {
		sound (p, CHAN_AUTO, SOUND_GRABFLAG, 0.8, ATTN_NONE);
		sound (self, CHAN_AUTO, "misc/take_flag.wav", 1, ATTN_NORM);
        }


	other.flag_carrier = TRUE;
	other.flag_since = time;
	other.items |= self.team == TEAM_RED ? IT_KEY2 : IT_KEY1;  	// Add item to the player

	self.owner = other;

	stuffcmd(other,"bf\n"); // Flash screen
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;                     
	self.cnt = CTF_FLAG_CARRIED;
}




//flag has been captured
void() ctf_flag_capture =
{
	stuffcmd(other,"bf\n");

	local string otherTeam;
	otherTeam = self.team == TEAM_BLUE ? "Red" : "Blue";
    
	if (otherTeam == "Red") 	sound(world,CHAN_AUTO,"ambience/blue.wav", 1, ATTN_NONE);
	else if (otherTeam == "Blue")	sound(world,CHAN_AUTO,"ambience/red.wav", 1, ATTN_NONE);
		
	BLUE_FLAG_TAKEN = 0;
	RED_FLAG_TAKEN = 0;

	other.flag_carrier = FALSE;
	other.items -= other.items & (IT_KEY1 | IT_KEY2);


	local float captime = time - other.flag_since;
    
	bprint (other.netname);
	bprint(" captured the ");
	bprint(otherTeam);
	bprint(" flag!");
    
	sprint3(other, " \b[\b", utils_get_time(captime), "\b]\b");
    
    
	if(other.tarzan_time ==1) bprint(" \b[BATMAN RETURNS]\b "); // 10/5/23
	else if((other.skiing_on ==1 || other.skiing_on ==2) && other.movement_x ==400) bprint(" \b[POWER SLIDE]\b ");
	else if((other.skiing_on ==1 || other.skiing_on ==2) && other.movement_x ==-400) bprint(" \b[BACK ASSWARDS]\b ");
	
	if(vlen(other.origin-smoke_origin) < 80 && other.health < 25) bprint(" \b[WITNESS ME!]\b ");
	else if(timelimit - time < 1.5) bprint(" \b[MIC DROP]\b ");
	bprint("\n");

    
	sound(world,CHAN_AUTO,SOUND_WIN, 0.59, ATTN_NONE); //added 5/17/22

	local entity p = world;
	while((p = findPlayer(p))) 
	{
		if(p != other) 
		{
			if(p.team == self.team)
			{
				sprint4(p, other.netname, " captured the ", otherTeam, " flag!\n");
				centerprint(p,"Your team captured the flag!\n");
				client_frag(p, 1);         //Bloodrails - added 4/8/22  changed cap value from 10 -> 1

				if ((p.last_returned_flag + 4) > time)
				{
					bprint2(p.netname," gets an assist for returning the flag!\n");
					client_frag(p, 1);
				}
			}
			else 
			{
				sprint2(p, other.netname, " captured your flag \n");
				centerprint(p,"Your flag has been captured\n");
				p.last_hurt_carrier = -5;
			}
		}
	}

	sound (p, CHAN_AUTO, SOUND_WIN, 0.7, ATTN_NONE);
        

	if ((other.last_returned_flag + 4) > time)
	{
		bprint2(other.netname," gets an assist for returning the flag!\n");
		client_frag(other, 1);
	}

	ctf_regen_flags();

	client_frag(other, 5);              //Bloodrails - value of cap is 3->5

	p = world;
	//TODO: move this
	
	while((p = findPlayerInTeam(self.team,p))) 
	{
		if (p.frags >= fraglimit)	NextLevel();
	}
}





void() hurt_flag_on =                   //Duped from triggers.qc with diff func name
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};




void() hurt_flag =                       //Duped from triggers.qc with diff func name
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		T_DamageOrg (other, self, self, self.dmg, self.origin);
		self.think = hurt_flag_on;
		self.nextthink = time + 1;
	}

	return;
};




//flag touch function
void() ctf_flag_touch =
{
	
	 if (self.cnt != CTF_FLAG_CARRIED)
	 {
		tracebox(self.origin + '0 0 -24', '-16 -16 -24', '16 16 0', self.origin + '0 0 0', 1, self);
		if(trace_startsolid == TRUE && other.classname != "player" && other.classname != "hook_entity" && other.classname != "plasma" && other.classname != "item_rune")
		{
			setorigin(self, self.origin + '0 0 5');
			//self.velocity = self.velocity + '0 0 40';
			//bprint("UP!");
			if(!(self.flags & FL_ONGROUND)) self.flags = self.flags | FL_ONGROUND;
		}
		
		tracebox(self.origin + '0 0 50', '-16 -16 50', '16 16 85', self.origin + '0 0 85', 1, self);
		if(trace_startsolid == TRUE  && other.classname != "player" && other.classname != "hook_entity" && other.classname != "plasma" && other.classname != "item_rune")
		{
			setorigin(self, self.origin + '0 0 -5');
			//self.velocity = self.velocity + '0 0 -20';
			//bprint("DOWN!");
		}
	}
	


    if (other.solid == SOLID_TRIGGER)           //per Buck on 5/23/22 - for flag respawn if in hurt brush
    {
        if (self.cnt == CTF_FLAG_DROPPED) 
        {
		//bprint("dropped in_trigger\n"); //NOVEM
            if (other.touch == hurt_touch && self.wait > time + 5)
            {
                if (other.dmg > 10)
                {
                    self.wait = time + 5;
                    self.cnt = CTF_FLAG_DROPPED;  // flag dropped
                    
                }
            }
        }
    }

    
    
    
    
    if(other.classname != "player" || other.health <= 0)	return;

    if (!(elohim_playmode & CLANRING_CTF_MODE) || ((elohim_playmode & CLANRING_CTF_MODE) && (elohim_playmode & ELOHIM_PRACTICE_MODE)))
    {
            centerprint(other,"Flags are not active in this mode\n");
            return;
    }
    else if ((elohim_playmode & ELOHIM_MATCH_MODE) && !(elohim_state & ELOHIM_MATCH_STARTED))
    {
        centerprint(other,"Flags are not active until match starts\n");
        return;
    }

    if (self.cnt == CTF_FLAG_DROPPED)
    {
		if (other.team == self.team)
		{
			ctf_flag_return();
			return;
		}
		ctf_flag_taken(TRUE);
    }
    else if (self.cnt == CTF_FLAG_AT_BASE)
    {
		if(other.team == self.team)
		{
			if(other.flag_carrier == TRUE)
			{
				ctf_flag_capture();
			}
			return;
		}
        ctf_flag_taken(FALSE);
    }
}






//set flag settings and position
void() ctf_flag_set =
{
	if (self == world || self.classname == "player")	return;

	setorigin(self,self.origin);

	self.flags = FL_ITEM;		
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';  			
	self.origin_z = self.origin_z + (0);
	self.angles = '0 0 0';
	self.owner = world;
	// self.nextthink = time + 0.01; //my_ticrate ->0.01   /NOVEM
}

void() item_flag_team1 =
{   
	if (!(elohim_playmode & CLANRING_CTF_MODE))         //Bloodrails - dont show flags unless CTF
	{
		remove(self);
		return;
	}


	setmodel(self,MODEL_FLAG_RED);
	self.maxs = '16 16 85';
	setsize (self, VEC_HULL_MIN, self.maxs);

	self.classname = "item_flag_team1";
	self.netname = "Red Flag";
	self.touch = ctf_flag_touch;
	self.think = ctf_flag_think;
	self.team      = 5;	
	self.items     = IT_KEY2;	
	self.owner     = world;
	self.effects   = self.effects | EF_RED;
   
	red_flag_ent = self;

	ctf_flag_set();

	self.oldorigin = self.origin;
	self.cnt = CTF_FLAG_AT_BASE;

	droptofloor();
	
	self.nextthink = time + 1;
}

void() item_flag_team2 =
{
        if (!(elohim_playmode & CLANRING_CTF_MODE))         //Bloodrails - dont show flags unless CTF
	{
		remove(self);
		return;
	}
    
	setmodel(self,MODEL_FLAG_BLUE);
	self.maxs = '16 16 85';
	setsize (self, VEC_HULL_MIN, self.maxs);

	self.classname = "item_flag_team2";
	self.netname = "Blue Flag";
	self.touch = ctf_flag_touch;
	self.think = ctf_flag_think;
	self.team      = 14;	
	self.items     = IT_KEY1;	
	self.owner     = world;		
	self.effects   = self.effects | EF_BLUE;

	blue_flag_ent = self;

	ctf_flag_set();

	self.oldorigin = self.origin;
	self.cnt = CTF_FLAG_AT_BASE;

	droptofloor();
	
	self.nextthink = time + 1;
}

//drop flag at carrier's location
void(entity player, entity flag) ctf_drop_flag =
{
	local entity p;
	while((p = find(p,classname,"player")))		sound (p, CHAN_AUTO, SOUND_DROPFLAG, 1, ATTN_NONE);

	bprint4(player.netname, " lost the ", flag.netname, "!\n");

	player.items -= player.items & (IT_KEY1 | IT_KEY2);

	local entity oself = self;
	self = flag;
	self.origin = player.origin;
	ctf_flag_set();
	flag = self;
	self = oself;

	flag.wait = time + 30.0;
	flag.cnt = CTF_FLAG_DROPPED;
	
	//if(player.team == TEAM_RED) red_flag_ent = flag;
	//else if(player.team == TEAM_BLUE) blue_flag_ent = flag;
}




//called when a player needs to drop flag
void(entity player, float regenflag) ctf_player_drop_flag =
{
	local entity e;

	if (player.classname != "player")	return;
	
	e = find(world, classname, "item_flag_team1");	
	
	if ((e != world) && (e.owner != player))
	{	
		e = find(world, classname, "item_flag_team2");	
		if ((e != world) && (e.owner != player))	return;     //dprint("CTFdebug:no owner found\n");	
	}
	
	player.flag_carrier = FALSE;		
	player.items = player.items - (player.items & (IT_KEY1 | IT_KEY2));
	
	if (regenflag) 
	{
		ctf_regen_flag(e);
	}
	else if (e != world)	
	{
		ctf_drop_flag(player, e);
	}
	
}




// FLAG CARRY function, runs from PlayerPostThink
void() flag_carry =
{
	if(self.flag_carrier == FALSE) return;     

	local entity temp_flag;
    
	
	if(self.team == TEAM_RED) 		temp_flag = blue_flag_ent;
	else if(self.team == TEAM_BLUE) 	temp_flag = red_flag_ent;
	
	temp_flag.movetype = MOVETYPE_NOCLIP;
	temp_flag.solid	= SOLID_NOT;
	 
   
	makevectors (self.angles);
	local vector v = v_forward;
	v_z = (-1 * v_z);
	local float f = 14;
   
   
	if (self.frame >= 29 && self.frame <= 40)
	{
		if (self.frame >= 29 && self.frame <= 34)  //axpain
		{
			if      (self.frame == 29) f = f + 2;            
			else if (self.frame == 30) f = f + 8;              
			else if (self.frame == 31) f = f + 12;                
			else if (self.frame == 32) f = f + 11;
			else if (self.frame == 33) f = f + 10;
			else if (self.frame == 34) f = f + 4;
		}
		else if (self.frame >= 35 && self.frame <= 40) // pain
		{
			if      (self.frame == 35) f = f + 2;
			else if (self.frame == 36) f = f + 10;
			else if (self.frame == 37) f = f + 10;
			else if (self.frame == 38) f = f + 8;
			else if (self.frame == 39) f = f + 4;
			else if (self.frame == 40) f = f + 2;
		}
	}    
	else if (self.frame >= 103 && self.frame <= 118)
	{
		if      (self.frame >= 103 && self.frame <= 104) f = f + 6;  //nailattack
		else if (self.frame >= 105 && self.frame <= 106) f = f + 6;  //light
		else if (self.frame >= 107 && self.frame <= 112) f = f + 7;  //rocketattack
		else if (self.frame >= 112 && self.frame <= 118) f = f + 7;  //shotattack
	}
  
	temp_flag.angles = self.angles;
	temp_flag.angles = self.angles + '0 0 -45';
	temp_flag.origin = self.origin + '0 0 -16' - f*v + v_right * 22;
    
    
    
	if(self.team == TEAM_BLUE) 		setorigin(red_flag_ent, temp_flag.origin);
	else if(self.team == TEAM_RED) 		setorigin(blue_flag_ent, temp_flag.origin);
}