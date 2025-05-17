
entity s; //spawn_tfog

void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

float	SPAWNFLAG_NOMESSAGE = 1;
float	SPAWNFLAG_NOTOUCH = 1;

// the wait time has passed, so set back up for another activation
void() HookVanish;
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	if (self.nextthink > time)
	{
		return;		// allready been triggered
	}

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;
		found_secrets = found_secrets + 1;
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);
	}

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;
	
	SUB_UseTargets();

	if (self.wait > 0)	
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_touch =
{
	if (other.classname != "player")
		return;
	
// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	
	self.enemy = other;
	multi_trigger ();
};

/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_multiple =
{
	if (self.sounds == 1)
	{

	}
	else if (self.sounds == 2)
	{
		//self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("ctf/br_flag_return.wav");
		self.noise = "ctf/br_flag_return.wav";
	}
	
	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch don't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) )
		{
			self.touch = multi_touch;
		}
	}
};


/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void() trigger_relay =
{
	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ?
secret counter trigger
sounds
1)	secret
2)	beep beep
3)
4)
set "message" to text string
*/
void() trigger_secret ={      };

//=============================================================================


void() counter_use =
{
	self.count = self.count - 1;
	if (self.count < 0)
		return;
	
	if (self.count != 0)
	{
		if (activator.classname == "player"
		&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			if (self.count >= 4)
				centerprint (activator, "There are more to go...");
			else if (self.count == 3)
				centerprint (activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint (activator, "Only 2 more to go...");
			else
				centerprint (activator, "Only 1 more to go...");
		}
		return;
	}
	
	if (activator.classname == "player"
	&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		centerprint(activator, "Sequence completed!");
	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_counter =
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};


/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/

float	PLAYER_ONLY	= 1;
float	SILENT = 2;
float	PARTICLE_EFFECT = 4;

void() play_teleport =
{
	local	float v;
	local	string tmpstr;

	v = random() * 4;
	if (v <= 1)
		tmpstr = "trig/br_tp1.wav";
	else if (v <= 2)
		tmpstr = "trig/br_tp2.wav";
	else if (v <= 3)
		tmpstr = "trig/br_tp3.wav";
	else if (v <= 4)
		tmpstr = "trig/br_tp4.wav";

	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove (self);
};

void(vector org) spawn_tfog =
{
	s = spawn ();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};


void() tdeath_touch =
{
	if (other == self.owner || other.classname == "dummy")
		return;

// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (other.invincible_finished > time)
			self.classname = "teledeath2";
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			T_Damage (self.owner, self, self, 50000);
			return;
		}
		
	}

	if (other.health)
	{
		T_Damage (other, self, self, 50000);
	}
};


void(vector org, entity death_owner) spawn_tdeath =
{
	local entity	death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	
	force_retouch = 2;		// make sure even still objects get hit
};

void() teleport_touch =
{
	if(elohim_playmode & RACE_MODE && mapname !="tut1" && mapname !="tut2" && mapname !="tut3" && mapname !="tut4" && mapname !="tut5" && mapname !="tut6" && mapname !="tut7") return;
	
	local entity	t;
	local vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	
	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets ();

// put a tfog where the player was
	spawn_tfog (other.origin);

	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");
		
// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org);
	spawn_tdeath(t.origin, other);

// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}
	

	
	setorigin (other, t.origin);
	other.angles = t.mangle;
	
	if (other.classname == "player")
	{	
		if(other.flag_carrier ==1)
		{
			if(other.height == elohim_team1) 		setmodel (blue_flag_ent, "mdl/flag_b_notr.mdl"); 
			else if(other.height == elohim_team2) 		setmodel (red_flag_ent, "mdl/flag_r_notr.mdl");
		}
		
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		
		
		if(other.frags == top_score_global && crown_out ==1 && other.hascrown == 1 && crown_ent.classname == "crown")
		{
			remove(crown_ent);
			other.hascrown = 0;
			crown_out = 0;
		}
		
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void() info_teleport_destination =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
		objerror ("no targetname");
};

void() teleport_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

void() trigger_teleport_effect =
{
	local entity p;
	while((p = find(p,classname,"player")))
	{
		if(self.team == TEAM_ALL || p.team == self.team) {
			msg_entity = p;
			WriteByte (MSG_ONE, SVC_TEMPENTITY);
			WriteByte (MSG_ONE, TE_GUNSHOT);
			WriteCoord (MSG_ONE, self.origin_x);
			WriteCoord (MSG_ONE, self.origin_y);
			WriteCoord (MSG_ONE, self.origin_z + self.cnt);
		}
	}


	self.cnt += 4;
	if(self.cnt > 16)
		self.cnt = -8;

	self.nextthink = time + 0.1;
}

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
*/
void() trigger_teleport =
{
    
    
    local vector o;

	InitTrigger ();
	self.touch = teleport_touch;
	// find the destination 
	if (!self.target)
		objerror ("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SILENT))
	{
		//precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs) * 0.5;
		//ambientsound (self.origin, "ambience/hum1.wav",0.5 , ATTN_STATIC);
	}

	if(self.spawnflags & PARTICLE_EFFECT) {
		self.cnt = 0;
		self.think = trigger_teleport_effect;
		self.nextthink = time + 0.1;
	}
};


void() trigger_setskill =
{
    remove(self);
};


/*
==============================================================================

ONLY REGISTERED TRIGGERS

==============================================================================
*/

void() trigger_onlyregistered_touch ={    };

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void() trigger_onlyregistered ={      };

//============================================================================

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	if(other.classname == "item_rune")   //Respawn rune if it is in Hurt trigger Hurt_trigger
	{			
                   other.think = rune_respawn;
	}
	
	
	
	if (other.takedamage && other.bounce_on ==0)
	{
			
		other.nogib_death = 2;
		self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg);
		
		self.think = hurt_on;
		self.nextthink = time + 1;
	}

	return;
};

/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
*/
void() trigger_hurt =
{

	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

//============================================================================



void() trigger_push_touch =
{
	
	if(other.health > 0 && other.classname == "player")
	{
		
		if(self.speed == 9.70) 
		{
			other.suppress_hud =1;
			centerprint(other, "\bBloodrailZ movement tutorial\b\n\nStart with Tutorial \"1\"(AXE DASH)\nStop at \"\b!\b\" signs directly in your way\n\nPress \bF1\b at any time to restart map\nPress \bF2\b for combat practice       \nPress \bF3\b to play tutorial demo     ");
		}
		
		else if(self.speed == 9.71) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b2.\b\n\bHook swing tutorial\b\n\nTarget an area above, Press+Hold \b+hook\b\nOnce hook pulls - hold \bJUMP\b to swing\n Steer by looking in dir you want to go\n\nif you hold \b+HOOK\b without holding \bJUMP\b\nHook will pull you in a straight line\n\n\n1. Swing over to the platform across\n2. Then swing up to top of tower");
		}
		else if(self.speed == 9.72) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b1.\b\n\bAxe-Dash tutorial\b\n\nHold \b+FORWARD\b and \bJUMP\b\nTap \b+AXE\b rhythmically\nHold \bSTRAFE\b buttons into turns");
		}
		else if(self.speed == 9.73) 
		{
			other.suppress_hud =1;
			centerprint(other, "\bSliding/Skiing tutorial\b\n\nHold \bSLIDE\b and \b+FORWARD\b\nwhile hitting ground at speed\nRelease \bSLIDE\b while skiing to jump up\n\nPress & Release \bSLIDE\b midair to AIR JUMP\n\nAXE ground while skiing to boost up\n\n Press and hold \bSLIDE\b midair to glide");
		}
		else if(self.speed == 9.74) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b1.\b\n\bAir Jump tutorial\b\n\n\bAXE DASH\b off the platform\n press + release \bSLIDE\b in midair\n\nGET ACROSS THE GAPS");
		}
		else if(self.speed == 9.75) 
		{
			other.suppress_hud =1;
			centerprint(other, "NOW GET TO THE HIGHEST POINT ON MAP");
		}
		else if(self.speed == 9.76) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b4.\b\n\bAdvanced Rail Boosting \b\n\nWhile \bAxe Dashing\b, press \bJUMP\b\nLet go of \b+FORWARD\b and quickly look back\n Press \b+RAIL\b to rail jump/boost\ntap \b+AXE\b mid air for more speed\n\nReach the other side without using hook");
		}
		else if(self.speed == 9.77) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b5.\b\n\bWater movement tutorial\b\n\nHold \bJUMP\b while hitting water to Bounce\nWorks on all liquids\n\nHold \b+FORWARD\b and tap \b+AXE\b after bounce\nTo gain horizontal speed\n\nYou have to re-tap \b+JUMP\b to water bounce again\nTry bouncing between the two ponds");
		}
		else if(self.speed == 9.78) 
		{
			other.suppress_hud =1;
			//centerprint(other, "Once you are done practicing with hook\ndrop down to the yellow \"3\"\nto begin sliding tutorial");
			centerprint(other, "This is all the movement tech you\nneed to start playing \bBLOODRAILZ\b\nyou can press \bF2\b for combat practice\n\nor drop down to the yellow \"3\"\nto begin \bsliding\b and other\n\bAdvanced Movement\b tutorials");
		}
		
		else if(self.speed == 9.79) 
		{
			other.suppress_hud =1;
			centerprint(other, "\bWall Slide tutorial\b\nworks best on non-vertical walls\nbut will let you run up a vert wall too\n\nHold \bSLIDE\b when moving along wall\n look TOWARD wall to move higher\n\n tap \b+AXE\b if you need to get up to speed");
		}
		
		else if(self.speed == 9.80) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b4.\b\n\bAdvanced Rail Boosting (continued)\b\n\n get higher Rail Jumps off of up-ramps");
		}
		else if(self.speed == 9.82) 
		{
			other.suppress_hud =1;
			centerprint(other, "\bWall Run tutorial\b\n\nHold \bJUMP\b & \bSTRAFE\b toward wall\n look UP/DOWN to move higher or lower\n tap \b+AXE\b if you need to get up to speed");
		}
		else if(self.speed == 9.83) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b5.\b\n\bWater movement tutorial (continued)\b\n\nLook downward when hitting water to dive-in\n\nYou'll swim fast in dir you're looking\n\n try diving in, then look up to dive out\n\b+AXE\b when leaving water for extra speed");
		}
		else if(self.speed == 9.84) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b1.\b\n\bBasic Rail Jump tutorial\b\n\nPress \b+JUMP\b then look down\nand press \b+RAIL\b\n\nRAIL JUMP UP TO THE PLATFORM");
		}
		else if(self.speed == 9.85) 
		{
			other.suppress_hud =1;
			centerprint(other, "\b4.\b\n\bAdvanced Rail Boosting (continued)\b\n\n axe dash down the beam\n then dash off, turn around and \b+RAIL\b\nthen \b+RAIL\b again while still in mid air\nGET ACROSS THE CHASM");
		}
		else if(self.speed == 9.87) 
		{
			other.suppress_hud =1;
			centerprint(other, "Once you are done practicing Wall Run..\n\nshoot the button \nto begin Advanced Rail Jumping tutorial");
		}
		else if(self.speed == 9.88) 
		{
			other.suppress_hud =1;
			centerprint(other, "\bThis concludes the movement tutorial!\b\nPress F2 for Combat Practice area");
		}
		else other.suppress_hud =0;
	}
	
	if(self.speed <= 10) return;





	local float rand;

	if (other.classname == "smoke" || other.classname == "plasma") other.velocity = self.speed * self.movedir * 12;
	else if (other.health > 0)
	{	
		
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				
				other.fly_sound = time + 1.5;
				
				
				 rand = random()*2;
    
				if (rand <= 1) sound (self, CHAN_AUTO, "trig/br_jpad3.wav",1,ATTN_NORM);
				else if (rand <= 2 && rand > 1) sound (self, CHAN_AUTO, "trig/br_jpad2.wav",1,ATTN_NORM);
   
			
				sound (other, CHAN_AUTO, "trig/br_jpad1.wav", 0.8, ATTN_NORM);
				
			}
		}
	}

};


/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void() trigger_push =
{
	
	
	
	InitTrigger ();
	self.touch = trigger_push_touch;
	
	
	
	if (!self.speed)
	{
		self.speed = 1000;
	}
};


//============================================================================

void() trigger_monsterjump_touch =
{
	if ( other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER )
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	
	if ( !(other.flags & FL_ONGROUND) )
		return;
	
	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
*/
void() trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

