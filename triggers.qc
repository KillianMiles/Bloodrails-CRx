
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
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
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
void() trigger_secret =
{
	total_secrets = total_secrets + 1;
	self.wait = -1;
	if (!self.message)
		self.message = "SUCCESS!";
	if (!self.sounds)
		self.sounds = 1;
	
	if (self.sounds == 1)
	{

	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}

	trigger_multiple ();
};

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

	v = random() * 5;
	if (v < 1)
		tmpstr = "misc/r_tele1.wav";
	else if (v < 2)
		tmpstr = "misc/r_tele2.wav";
	else if (v < 3)
		tmpstr = "misc/r_tele3.wav";
	else if (v < 4)
		tmpstr = "misc/r_tele4.wav";
	else
		tmpstr = "misc/r_tele5.wav";

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
	if (other == self.owner)
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
local entity	t;
local vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	// // Validate team
	// if (!(elohim_playmode & ELOHIM_PRACTICE_MODE))
	// {
	// 	if(self.team != TEAM_ALL && other.team != self.team)
	// 		return;	
	// }

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
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
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
		precache_sound ("ambience/hum1.wav");
        o = (self.mins + self.maxs) * 0.5;
        ambientsound (self.origin, "ambience/hum1.wav",0.5 , ATTN_STATIC);
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

void() trigger_onlyregistered_touch =
{
	if (other.classname != "player")
		return;
	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (self.message != "")
		{
			centerprint (other, self.message);
			sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
		}
	}
};

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void() trigger_onlyregistered =
{
	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
};

//============================================================================

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	if (other.takedamage && other.bounce_on ==0)
	{
			
		
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

float PUSH_ONCE = 1;

void() trigger_push_touch =
{

		if(elohim_playmode & ELOHIM_PRACTICE_MODE && other.classname == "player")    // RAce mode triggers
		{
		
			if(self.speed == 1 && countdown == 0)    //start trigger
			{
				if(other.racing_on == 0)
				{
					chrono_time = time;
					other.racing_on = 1;
					racing_on_global = 1;
					sprint(other, "START\n");
					other.race_completed = 0;
				}
			
			}
			
		
			
			if(self.speed == 3)   //finish trigger
			{
				if (other.racing_on == 1 && other.race_completed == 0)
				{
					other.race_completed = 1;
			
					countdown = 0;
					other.racing_on = 0;
					other.my_previous_time = time - chrono_time;
		
					if( (other.my_previous_time < place_one_time || place_one_time ==0)) 
					{
						place_one_time = other.my_previous_time;
						sprint(other, "You have set a new record \n");
						sprint(other, utils_get_time(other.my_previous_time));
						sprint(other, "\n");
						return;
						
					}
						
					else if( other.my_previous_time < place_two_time || place_two_time ==0) place_two_time = other.my_previous_time;
					else if( other.my_previous_time < place_three_time || place_three_time ==0) place_three_time = other.my_previous_time;
		
				
					sprint(other, "Your time is ");
					sprint(other, utils_get_time(other.my_previous_time));
					sprint(other, "\n");
	
				}
			
			}
			
			if(self.speed == 5 && other.racing_on == 0)
			{
				if(countdown == 0) 
				{
					countdown = 1;
					bprint("Countdown initiated...\n");
				
				}
				
				
				
			
			}
			

		}

		if(self.speed == 5.1)   				 // trigger for ONLY AXE
		{
			if(!(other.items & IT_AXE)) other.items = other.items | IT_AXE;
			if(other.items & IT_RAILGUN) other.items = other.items - IT_RAILGUN;
			if(other.items & IT_HOOK) other.items = other.items - IT_HOOK;
		}
		
		if(self.speed == 5.2)  					 //trigger for ONLY RAILGUN
		{
			if(!(other.items & IT_RAILGUN)) other.items = other.items | IT_RAILGUN;
			if(other.items & IT_AXE) other.items = other.items - IT_AXE;
			if(other.items & IT_HOOK) other.items = other.items - IT_HOOK;
		}
		
		if(self.speed == 5.3)   				//trigger for ONLY HOOK
		{
			if(!(other.items & IT_HOOK)) other.items = other.items | IT_HOOK;
			if(other.items & IT_RAILGUN) other.items = other.items - IT_RAILGUN;
			if(other.items & IT_AXE) other.items = other.items - IT_AXE;
		}
			
			if(self.speed == 5.11)    			// trigger to ADD AXE
			{
				if(!(other.items & IT_AXE)) other.items = other.items | IT_AXE;
			}
			
			if(self.speed == 5.13)    			// trigger to REMOVE AXE
			{
				if(other.items & IT_AXE) other.items = other.items - IT_AXE;
			}
			
			if(self.speed == 5.21)   			 // trigger to ADD RAILGUN
			{
				if(!(other.items & IT_RAILGUN)) other.items = other.items | IT_RAILGUN;
			}
			
			if(self.speed == 5.23)   			 // trigger to REMOVE RAILGUN
			{
				if(other.items & IT_RAILGUN) other.items = other.items - IT_RAILGUN;
			}
			
			if(self.speed == 5.31)    			// trigger to ADD HOOK
			{
				if(!(other.items & IT_HOOK)) other.items = other.items | IT_HOOK;
			}
		
		
		if(self.speed == 5.4)   //trigger to disable SHIELD and CURVED RAILS
		{
			if (!(elohim_playmode & ELOHIM_CLASSIC)) elohim_playmode = elohim_playmode | ELOHIM_CLASSIC;
		}
		
		if(self.speed == 5.41)   //trigger to enable SHIELD
		{
			if (elohim_playmode & ELOHIM_NO_SHIELD) elohim_playmode =elohim_playmode - ELOHIM_NO_SHIELD;
		}
		
		
		//////////////////////
		
		
		
		if(self.speed == 5.700)   				 // trigger for 700ups speed
		{
			if(vlen(other.velocity) > 700) bprint("Great job, you reached 700ups speed");
		}
		
		if(self.speed == 5.800)   				  // trigger for 800ups speed
		{
			if(vlen(other.velocity) > 800) bprint("Great job, you reached 800ups speed");
		}
		
		if(self.speed == 5.900)   				  // trigger for 900ups speed
		{
			if(vlen(other.velocity) > 900) bprint("Great job, you reached 900ups speed");
		}
		
		if(self.speed == 5.999)   				  // trigger for 1000ups speed
		{
			if(vlen(other.velocity) > 1000) bprint("Great job, you reached 1000ups speed");
		}
		
		
		
		
		if(self.speed == 7.1)   				  // hook swing success trigger
		{
			if(other.tarzan_time ==1) bprint("Great job, you are hook-swinging");
		}
		
		if(self.speed == 7.2)   				  // Wallrun success trigger
		{
			if (other.punchang <= -18 || other.punchang >= 18) bprint("You are wall-running!");
		}
		


if(self.speed <= 10) return;





local float rand;

	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{	
		
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				
				other.fly_sound = time + 1.5;
				
				
				 rand = random()*2;
    
    if (rand <= 1) sound (self, CHAN_AUTO, "ambience/windfly3.wav",1,ATTN_NORM);
    else
    if (rand <= 2 && rand > 1) sound (self, CHAN_AUTO, "ambience/windfly2.wav",1,ATTN_NORM);
   
				
				
				
				
     sound (other, CHAN_AUTO, "ambience/windfly.wav", 0.8, ATTN_NORM);
				
			}
		}
	}
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};


/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void() trigger_push =
{
	
	
	
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	precache_sound ("ambience/windfly2.wav");
	precache_sound ("ambience/windfly3.wav");
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

