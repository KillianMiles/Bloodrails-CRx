void() W_SetCurrentAmmo;
void () weapon_touch;
void () ammo_touch;
void() item_health = {return;}
void() weapon_supershotgun = {return;}
void() weapon_nailgun = {return;}
void() weapon_supernailgun = {return;}
void() weapon_grenadelauncher = {return;}
void() weapon_rocketlauncher = {return;}
void() weapon_lightning = {return;}
void() item_shells = {return;}
void() item_spikes = {return;}
void() item_rockets = {return;}
void() item_cells = {return;}
void() item_artifact_envirosuit = {return;}
void() item_artifact_super_damage = {return;}
float() W_BestWeapon;
float WEAPON_BIG2 = 1;
float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
float(entity p) Maps_ShouldRemoveDefaultEntity;
void() bound_other_ammo ={};
float(float w) RankForWeapon ={return 3;};
void(float old, float new) Deathmatch_Weapon ={};
void() weapon_touch ={};
void() ammo_touch ={};


void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "bloodrailz/items/itembk2.wav", 1, ATTN_NORM);	// Christian Ice play respawn sound
	setorigin (self, self.origin);
};


void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

/*
============
PlaceItem -- plants the object on the floor
============
*/
void() PlaceItem =
{
	local float	oldz;

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	
	if (!droptofloor())
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}

    // ELOHIM_MOD - check for noquad, nopent, and noring
	if (self.classname == "item_artifact_super_damage")
	{
		if (elohim_playmode & ELOHIM_NO_QUAD) admin_disable_item();
	}
	if (self.classname == "item_artifact_invulnerability")
	{
		if (elohim_playmode & ELOHIM_NO_PENT) admin_disable_item();
	}
	if (self.classname == "item_artifact_invisibility")
	{
		if (elohim_playmode & ELOHIM_NO_RING) admin_disable_item();
	}
};


/*
============
StartItem  --  Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
    if (elohim_playmode & RACE_MODE || mode_is_arena())
    {
        if (self.touch == weapon_touch || self.touch == ammo_touch)
        {
            remove(self);
            return;
        }
    }
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};





/*
===============================================================================
ARMOR
===============================================================================
*/
void() armor_touch =
{
	local	float	type, value, bit;
	

	if (elohim_playmode & ELOHIM_MATCH_MODE && !(elohim_state & ELOHIM_MATCH_STARTED)) return;

	
	if (other.health <= 0) return;
	if (other.classname != "player") return;

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 175;   //red armor now gives 150 armor instead of 175   9-17-23
		bit = IT_ARMOR3;
	}
	if (other.armorvalue >= value) return;
		
	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch) self.nextthink = time + 20;
	
	self.think = SUB_regen;

	sound(other, CHAN_ITEM, "bloodrailz/items/br_armor1.wav", 0.8, ATTN_NORM);
	stuffcmd (other, "bf\n");
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};




void() item_armor1 =
{
	if(Maps_ShouldRemoveDefaultEntity(self) || (mode_is_arena())) return remove(self);

	self.touch = armor_touch;
	precache_model ("progs/bloodrailz/br_armor.mdl");
	setmodel (self, "progs/bloodrailz/br_armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};



void() item_armor2 =
{
	if(Maps_ShouldRemoveDefaultEntity(self) || (mode_is_arena())) return remove(self);

	self.touch = armor_touch;
	precache_model ("progs/bloodrailz/br_armor.mdl");
	setmodel (self, "progs/bloodrailz/br_armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};



void() item_armorInv =
{
	if(Maps_ShouldRemoveDefaultEntity(self) || (mode_is_arena()))
		return remove(self);

	self.touch = armor_touch;
	precache_model ("progs/bloodrailz/br_armor.mdl");
	setmodel (self, "progs/bloodrailz/br_armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};





/*
===============================================================================

POWERUPS

===============================================================================
*/

void() powerup_touch =
{
	if (elohim_playmode & ELOHIM_MATCH_MODE && !(elohim_state & ELOHIM_MATCH_STARTED)) return;
	if (other.classname != "player") return;
	if (other.health <= 0) return;

	//sprint (other, "You got the ");
	//sprint (other, self.netname);
	//sprint (other,"\n");

	if (deathmatch)
	{
		self.mdl = self.model;
		
		if ((self.classname == "item_artifact_invulnerability") || (self.classname == "item_artifact_invisibility")) self.nextthink = time + 55;   //pent respawn
		else self.nextthink = time + 55;                  
		
		self.think = SUB_regen;
	}	

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

	// do the apropriate action
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}
	
	if (self.classname == "item_artifact_invulnerability")
	{
			if(elohim_playmode & RACE_MODE && other.classname == "player")
			{
				if(racing_on_global == 0)
				{
					racing_start();
					//other.invincible_time = 1;
					other.invincible_finished = time + 500000;
					
					if (self.classname == "item_artifact_invulnerability") self.think = SUB_Remove;
					return;
					
				}
				return;
				
			}
			else
			{
		
				other.invincible_time = 1;
				other.invincible_finished = time + 42;     // pent available // pent time
				other.items = other.items - IT_INVULNERABILITY;  //dont pent the screen upon pickup
			}
	}
	
	if (self.classname == "item_artifact_invisibility")
	{
			if(elohim_playmode & RACE_MODE && other.classname == "player")
			{
					racing_finish();
					other.invincible_finished = time + 500000;
					
					if (self.classname == "item_artifact_invulnerability") self.think = SUB_Remove;
					return;

			}
			
			other.invisible_time = 1;
			other.invisible_finished = time + 30;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + 30;
		other.crmod_qdwep_z = other.crmod_qdwep_z + 1;  //CRMOD - stats
	}	

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


void() item_artifact_invulnerability =
{
	if(Maps_ShouldRemoveDefaultEntity(self) || (mode_is_arena())) return remove(self);

	self.touch = powerup_touch;
	if (!(elohim_playmode & RACE_MODE)) 
	{
		self.noise = "bloodrailz/items/br_protect.wav";
		setmodel (self, "progs/bloodrailz/br_pent.mdl");
		self.netname = "Shield Amplifier";
		setsize (self, '-16 -16 -24', '16 16 32');
	}
	else
	{
		self.noise = "bloodrailz/items/br_protect.wav";
		setmodel (self, "progs/bloodrailz/br_pent.mdl");
		self.netname = "Shield Amplifier";
		setsize (self, '-32 -32 -24', '32 32 75');
	}
	self.items = IT_INVULNERABILITY;
	StartItem ();
};



void() item_artifact_invisibility =
{
	if(Maps_ShouldRemoveDefaultEntity(self) || elohim_playmode & ELOHIM_WRAITH) return remove(self);

	self.touch = powerup_touch;
	if (!(elohim_playmode & RACE_MODE)) 
	{
		self.noise = "bloodrailz/items/br_inv1.wav";
		setmodel (self, "progs/bloodrailz/br_ring1.mdl");
		self.netname = "Cloaking matrix";
		setsize (self, '-16 -16 -24', '16 16 32');
	}
	else 
	{
		self.noise = "bloodrailz/misc/ding2.wav";
		setmodel (self, "progs/bloodrailz/br_pent2.mdl");
		self.netname = "Cloaking matrix";
		setsize (self, '-59 -59 -24', '59 59 80');
	}
	self.items = IT_INVISIBILITY;
	StartItem ();
};
