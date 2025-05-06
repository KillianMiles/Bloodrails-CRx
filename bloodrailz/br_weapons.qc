void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(vector org, vector vel, float damage) SpawnBlood;
void() W_ChangeWeapon;
void(vector start, vector end, vector myAngles, entity shooter) rail_make;
void(vector start, vector end, vector myAngles, entity shooter) clean_rail_make;
void() haste_sound;
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()  player_chain1;
void()  player_chain3;

float() W_BestWeapon = {return 1;}
float() crandom = {return 2*(random() - 0.5);};
void(vector org, vector vel, float damage) SpawnBlood = {particle (org, vel*0.1, 73, damage*2);};


vector() wall_velocity =
{
	local vector	vel;
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	return vel;
};






/*
==============================================================================
MULTI-DAMAGE  --  Collects multiple small damages into a single damage
==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =                  //no multidamage
{
	multi_ent = world;
	multi_damage = 0;
};


void() ApplyMultiDamage =               
{
	if (!multi_ent)
	return;
	T_DamageOrg (multi_ent, self, self, 1001, self.origin);
};


void(entity hit, float damage) AddMultiDamage =
{
	if (!hit) return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();        
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};



/*
==============================================================================

BULLETS

==============================================================================
*/



void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, 20);    // damage ->20
		AddMultiDamage (trace_ent, damage);
	}
	else
	{
		if(random() < 0.5)
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
		}
	}
};


void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
	local float shotcount_dmg;
	
	shotcount_dmg = shotcount;


	if (!(elohim_playmode & ELOHIM_MATCH_MODE) || (elohim_state & ELOHIM_MATCH_STARTED)) self.dest1_x = self.dest1_x + 4 * shotcount; // ELOHIM_MOD - stats
	
	
	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage (); 
	 	
		
	while (shotcount > 0)                 //Run through the pellets for spawnblood effect
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*7200, FALSE, self);
		
		if (trace_fraction != 1.0)
		{
			TraceAttack (1001, direction);	
		}

		shotcount = shotcount - 1;
	}
	
	
	while (shotcount_dmg > 0)              //Run through the pellets until a hit is found
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*7200, FALSE, self);
		
		if (trace_fraction != 1.0)
		{
			TraceAttack (1001, direction);    
			ApplyMultiDamage ();
			return;
		}
		shotcount_dmg = shotcount_dmg - 1;
	}
};





void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};




void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/bloodrailz/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};




void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.weaponmodel = "progs/bloodrailz/v_br_axe_red1.mdl";
		if (self.height == elohim_team2) self.weaponmodel = "progs/bloodrailz/v_br_axe_blu1.mdl";
		self.weaponframe = 0;
	}

	else if(self.weapon == IT_HOOK) 
	{


	}

	else if (self.weapon == IT_RAILGUN)
	{
		self.weaponmodel = "progs/bloodrailz/v_br_rail_red1.mdl";
		if (self.height == elohim_team2) self.weaponmodel = "progs/bloodrailz/v_br_rail_blu1.mdl";
		//self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
	}
};





///////////////////////////////////////////////////////////////////////////////////


void() W_Attack =
{
	local	float	r, haste_mult;
	haste_mult = 1;
	local   float   randrail;


	if (time < self.attack_finished) return;

	if (self.player_flag & PF_ITEM_RUNE_MASK)
	{
		if (self.items2 & IT2_SIGIL3) haste_mult = .5; //lower haste multiple
	}
	
	if (self.weapon == IT_AXE)
	{
		Axe_Charge_Logic();
		if (self.axe_button_released == 1 && !(self.items2 & IT2_SIGIL3)) return;  //DECEM
		
		
		if (self.items2 & IT2_SIGIL3) 
		{
			if(time - self.axe_time < 0.59*haste_mult) return;   //DECEM
		}
		
		self.axe_button_released = 1;
		self.axe_power_time = time;    //dont fire axe again until fire button released
	
		
		
		if(time - self.axe_time < 0.44) return;
		
		
		self.axe_splash_time = time;
		self.done_damage = 0;
	
		if(time - self.axe_time > 1.2)      //Axe dash cool down timer
		{
			self.dash_counter = 0;
			self.dash_timer = time;
		}
		sound (self, CHAN_WEAPON, "bloodrailz/weapons/br_axe_swing.wav", 1, ATTN_NORM);
		
		local float boostspeed2 = vlen(self.velocity);
		local float AxLunge1 = 30;
		local float AxLunge2 = 60;
		local float AxLunge3 = 90;
	
	
		if(self.skiing_on !=1 && self.skiing_on !=2)	//MARCH
		{
			if (boostspeed2 < 500) 
			{
				if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge3;      //AXE DASH  
				else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge3*0.75); 
			}                            
			else if (boostspeed2 > 500 && boostspeed2 < 700) 
			{
				if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge2;      //AXE DASH  
				else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge2*0.75); 
			}
			else if (boostspeed2 >= 700 || boostspeed2 < 1000) 
			{
				if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge1;      //AXE DASH  
				else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge1*0.75); 
			}
		}

        
		W_Fire_BR_Axe();

		if(self.turn_speed > 15 || (self.turn_speed > 0 && self.movement_y ==-700 && vlen(self.velocity)> 200)) 
		{
			player_axed1 ();
		}
		else if(self.turn_speed < -15 || (self.turn_speed < 0 && self.movement_y ==700 && vlen(self.velocity)> 200)) 
		{
			player_axec1 ();

		}
		else
		{
			r = random();
			if (r < 0.7) player_axe1 ();
			else player_axed1 ();	
		}

		self.dash_counter = self.dash_counter + 1;
	
	
		if (self.dash_counter < 8)         //Axe dash cool down timer
		{	 
			if(self.skiing_on !=1 && self.skiing_on !=2)	//MARCH
			{	
				if (boostspeed2 < 500) 
				{
					if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge3;      //AXE DASH  
					else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge3*0.8); 
				}                            
				else if (boostspeed2 > 500 && boostspeed2 < 700) 
				{
					if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge2;      //AXE DASH  
					else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge2*0.8); 
				}
				else if (boostspeed2 >= 700 || boostspeed2 < 1100) 
				{
					if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge1;      //AXE DASH  
					else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge1*0.8); 
				}
			}
		}
	

		
		local vector source;
		source = self.origin;
		local vector splash_center_low = source + v_forward*10 + v_up*(-20);    //  20 -> 10, 25 -> 21
    
    
		self.axe_time = time;
	}
	
	else if(self.weapon == IT_HOOK) 
	{
		if (time - self.hook_time > 0.1 && self.hook_button_released == 1) return;
		if (!self.hook_out)
		{
			player_chain1();
			//W_FireChain();
		}
		else     player_chain3();

		self.attack_finished = time + 0.1;       
	}
	
	
	else if (self.weapon == IT_RAILGUN)
	{
		Rail_Charge_Logic();
		if (self.rail_button_released == 1) return;
		self.rail_button_released = 1;
		self.rail_power_time = time;     //dont fire rail again until button released
		
	        self.axe_time = self.axe_time - 0.12; //DECEM
	        if(self.axe_time < 0) self.axe_time =0;
	        
		if(time - self.shot_time < 1.3*haste_mult) return;
		if(time - self.shot_time < 1.33*haste_mult && self.KDR > 2.1 && self.frags == top_score_global) return;   // first place handicap
		if(time - self.shot_time2 < 0.30) return;
		
		self.shot_time = time;      //time of shot used in recharge time calculation
		self.shot_time2 = time;
		
		if(self.ammo_slugs <=0)                // RAIL SLUGS RAIL AMMO
		{
			sound (self, CHAN_AUTO, "bloodrailz/weapons/br_empty.wav", 0.87, ATTN_NORM);
		}
		
		
		if(self.ammo_slugs >0)	
		{
			randrail = random()*3;
			if (randrail < 1 || randrail == 1 ) sound (self, CHAN_AUTO, "bloodrailz/weapons/railgun1.wav",1,ATTN_NORM);
			else
			if (randrail > 1 && randrail < 2) sound (self, CHAN_AUTO, "bloodrailz/weapons/railgun1.wav",1,ATTN_NORM);
			else
			if (randrail < 3 || randrail == 2 || randrail ==3 ) sound (self, CHAN_AUTO, "bloodrailz/weapons/railgun2.wav",1,ATTN_NORM);
		}
		//else sound (self, CHAN_AUTO, "bloodrailz/weapons/empty1.wav",1,ATTN_NORM);
		
	        
	        if (elohim_playmode & PROJECTILES) W_FireProjectile();
	        else W_FireRailgun ();
	        
		player_shot1 ();	
	}
};





void() W_ChangeWeapon =
{
	local	float	it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1 && time - self.shot_time > 0.22)  //DECEM
	{
		am = 0;
		fl = IT_AXE;	
	}
	else if (self.impulse == 2)
	{
		am = 0;
		fl = IT_HOOK;
	}
	else if (self.impulse == 3 && time - self.axe_time > 0.18)  // 0.22 -> 0.10
	{
		fl = IT_RAILGUN;
		am = 0;
	}		
	else if (self.impulse == 4)
	{

	}
	else if (self.impulse == 5)
	{

	}

	else if (self.impulse == 6)
	{
			if (self.player_flag & PF_HUD) 
			{
					self.player_flag = self.player_flag - PF_HUD;
					//self.button_press_display = 0;
					
					if(timelimit - time < 16) 
					{	
						stuffcmd(self, "scr_matchclock 2\n");
						stuffcmd(self, "scr_matchclockscale 3.4\n");
						stuffcmd(self, "scr_matchclock_y 86.5\n");
					}
					else 
					{
						stuffcmd(self, "scr_matchclock 3\n");
						stuffcmd(self, "scr_matchclockscale 3.47\n");
					}
					stuffcmd(self, "viewsize 110\n");
					sprint(self, "\bHUD is:\b ON\n");
			}
			else if (!(self.player_flag & PF_HUD))
			{
					self.player_flag = self.player_flag | PF_HUD;
					self.button_press_display = 0;
					stuffcmd(self, "scr_matchclock 0\n");
					stuffcmd(self, "viewsize 130\n");
					sprint(self, "\bHUD is:\b OFF\n");
			}
	}
	else if (self.impulse == 7)
	{
			if (self.player_flag & PF_OVERLAY) 
			{
				self.player_flag = self.player_flag - PF_OVERLAY;
				//self.button_press_display = 0;
				sprint(self, "\binput overlay:\b OFF\n");
			}
			else if (!(self.player_flag & PF_OVERLAY))
			{
				self.player_flag = self.player_flag | PF_OVERLAY;
				self.button_press_display = 0;
				sprint(self, "\binput overlay:\b ON\n");
			}
	}
	
	else if (self.impulse == 8)
	{
			if (self.player_flag & PF_CLEANTRAIL) 
			{
				self.player_flag = self.player_flag - PF_CLEANTRAIL;
				sprint(self, "\bclean rail trails:\b OFF\n");
			}
			else if (!(self.player_flag & PF_CLEANTRAIL))
			{
				self.player_flag = self.player_flag | PF_CLEANTRAIL;
				sprint(self, "\bclean rail trails:\b ON\n");
			}
	}
	

	else if (self.impulse == 22 && self.items & IT_HOOK)
	{
		am = 0;
		fl = IT_HOOK;
	}

	self.impulse = 0;
	
	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		//sprint (self, "no weapon.\n");
		return;
	}
	
	if (am)
	{	// don't have the ammo
		//sprint (self, "not enough ammo.\n");
		return;
	}

	self.weapon = fl;

	W_SetCurrentAmmo ();
};




void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)	W_ChangeWeapon ();
	else if (self.impulse == 22)			W_ChangeWeapon ();

	self.impulse = 0;
};




void() W_WeaponFrame =    //Called every frame so impulse events can be handled as well as possible
{
    if (self.delayed_impulse)
	{
		self.impulse = self.delayed_impulse;
		self.delayed_impulse = 0;
		ImpulseCommands ();
	}

	if (self.deadflag) return;
	
	if (self.button0)
	{
		if (self.style & ELOHIM_OK_TO_SHOOT)
		{
			W_Attack ();
		}
	}
	else if (time > self.attack_finished) self.style = self.style | ELOHIM_OK_TO_SHOOT;
};




void () haste_sound =
{
	if (self.runetime > time) return;
	
	self.runetime = time + 2;
	//sound (self, CHAN_AUTO, SOUND_RUNE_HASTE, 1, ATTN_NORM);
};


