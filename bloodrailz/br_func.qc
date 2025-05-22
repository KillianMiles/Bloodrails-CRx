
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

/*
void (entity ent, float flag, float onoff) do_brflag =
{
	if(onoff == 1)
	{
		if(!(ent.brflags & flag)) ent.brflags = ent.brflags | flag;
	}
	
	if(onoff == 0)
	{
		if(ent.brflags & flag) ent.brflags = ent.brflags - flag;
	}
}
*/

void() Called_in_PreThink =
{
	
		
		if (self.classname == "player" && self.frags == top_score_global && self.hascrown == 0 && self.frags > 0 && crown_out == 0 && crown_ent.classname != "crown")   //CROWN
		{
			make_crown();
			self.hascrown = 1;
			crown_out = 1;
		}
		
		if(timelimit-time <15.9 && timelimit-time > 15.5) 
		{
			//stuffcm(self, "scr_matchclock 2\n");
			//stuffcm(self, "scr_matchclockscale 3.4\n");
			//stuffcm(self, "scr_matchclock_y 86.5\n");
			//stuffcm(self, "scr_matchclock_x 72.7\n");
			stuffcmd(self, "mclok01\n");
		}
		
		if ((self.flags & FL_ONGROUND) && self.skiing_on!=0) 
		{
			self.skiing_on =0;
			self.ski_tilt =0;
		}
	
		rune_regen();
		WaterMove();
		spawn_protection ();
		make_speedlines();
		make_hookx();
		turn_indicator();
		if(self.armorvalue >= 100 && self.armor_displayed ==0) make_armoricon();
		if(self.reticule_displayed ==0) make_reticule();
		
		if(mapname == "tut1" && self.origin_z > 2500 && self.tut_displayed1 ==0) make_tut_icon(1);
		
		//if(mapname == "tut1" && self.tut_displayed2 ==0) make_tut_icon(2);
		

		if(time - self.grind_time > 1 && self.angles_not_zero == 0 && self.tilted ==1 && !self.hook_out && self.skiing_on ==0)
		{
			stuffcmd(self, "as23\n");
			stuffcmd(self, "an0\n");
			self.tilted=0;
			//bprint("stuff scr_angle YES!\n");  //badspam
		}
		

		//bprint(ftos(self.rune_bang));
		//bprint("rune_bang\n");
		
		
		if(self.impulse == 100 && elohim_playmode & RACE_MODE)
		{
			self.shield_time = 0;
			self.shield_recharge_time = 1;
		
			if(self.race_completed == 0) 
			{
				self.racing_on = 0;
				bprint("   \b.\b\n");
				bprint("   \b[RUN RESET]\b\n");
				bprint("------------------\n");
			}
			racing_on_global = 0;
			spawn_race_entities();
			ClientKill();
		}
		else if(self.impulse == 101 && elohim_playmode & RACE_MODE && mapname =="tut1")
		{
			self.shield_time = 0;
			self.shield_recharge_time = 1;
		
			sound (self, CHAN_VOICE, "trig/br_tp1.wav", 1, ATTN_NORM);
			setorigin(self, '0 0 2750');
		}
		else if(self.impulse == 102 && elohim_playmode & RACE_MODE && mapname =="tut1")
		{
			stuffcmd(self,"r_particledesc particles_not\n");
			stuffcmd(self,"playdemo 0_tutorial.dem\n");
		}
		else if(self.impulse == 103 && mapname == "tut1")
		{
			WriteByte(MSG_BROADCAST, SVC_STUFFTEXT);   //TUTORIAL DEMO IMPULSE
			WriteString(MSG_BROADCAST, "map tut1\n");
		}
		else if(self.impulse == 149)
		{
			if(!(self.oflags & OBSERVER_ACTIONCAM)) 
			{
				observer_clear_flags();
				self.oflags = self.oflags | OBSERVER_ACTIONCAM;
				//if (self.style & ELOHIM_OBSERVER) self.style = self.style - ELOHIM_OBSERVER;
				HorrorScope (camera_deathmatch);	
			}
			else if(self.oflags & OBSERVER_ACTIONCAM) 
			{
				//observer_clear_flags();
				self.oflags = self.oflags - OBSERVER_ACTIONCAM;	
				Exit_HorrorScope();
			}
			
			
		}
		
		if(mapname == "tut1" && dummy_spawned == 0)
		{
			if(tut_gib_time ==0 || time - tut_gib_time > 1.25)
			{
				PutDummyInServer();
				dummy_spawned = 1;
			}
		}
		
		
		if(quasar_origin1 != '0 0 0' && gravity_origin1 != '0 0 0')    //repulsor effect diminished by grav well
		{
			if(vlen(quasar_origin1-gravity_origin1) < 500)
			{
				quasar_time -=0.01;
				quasar_flash_time = time;
			}
		}
		
		
		
		
		if((elohim_playmode & ELOHIM_WRAITH) && (self.items & IT_INVISIBILITY) && (self.items & IT_SUIT) && !(self.items & IT_RAILGUN) && self.wraith == 0)
		{
			self.items = self.items - IT_INVISIBILITY;
			self.items = self.items - IT_SUIT;
			self.items = self.items | IT_RAILGUN;
			self.alpha = 1;
		}

		else if((elohim_playmode & ELOHIM_WRAITH) && !(self.items & IT_INVISIBILITY) && !(self.items & IT_SUIT) && (self.items & IT_RAILGUN) && self.wraith == 1)
		{
			self.items = self.items | IT_INVISIBILITY;
			self.items = self.items | IT_SUIT;
			self.items = self.items - IT_RAILGUN;
		}
	
	

		if(time - self.blast_time > 0.40 && time - self.blast_time < 0.45)   //re-enableable steering after push
		{
			stuffcmd(self, "spd01\n");
		}
		
		
		
		
		
		
		if(self.hookhead)                   //allow to rehook after firing while hook swinging LOL
		{
			
			makevectors(self.v_angle);
			local vector dir = normalize((self.origin + (v_forward*16) + '0 0 16') - self.hookhead.origin);
			local vector dist;
			traceline(self.origin + (v_forward*16) + '0 0 16', self.hookhead.origin + dir*50, FALSE, self);    //NOVEM
			if(trace_ent.takedamage && (trace_ent.classname == "player" || trace_ent.classname == "dummy"))
			{
				dist = trace_endpos-trace_ent.origin;
				if(vlen(dist) < 33)   //want the hit detection to be tighter
				{
					dist_z=0;
					if(vlen(dist) < 18)
					{
						
						local vector dir1 = normalize(trace_ent.origin - self.hookhead.origin);                  //rail momentum add
						local vector dir2 = normalize(trace_ent.origin - self.origin); 
						local vector dir3 = normalize(dir1 + dir2);
		
						trace_ent.velocity = trace_ent.velocity + dir3*270;
						T_DamageOrg(trace_ent, self, self, 40.4, self.origin);
						
						sound (trace_ent, CHAN_AUTO, "weap/br_tension.wav", 0.59, ATTN_NORM);
						
						if(vlen(self.origin-trace_ent.origin) > 600) 
						{
							sound (self, CHAN_AUTO, "weap/br_tension.wav", 0.4, ATTN_NORM);
							//bprint("chain 600\n");
						}

						
					}
				}
			}
			
			/*
			local entity head = findradius(self.hookhead.origin, 110);
			while (head)
			{
					if (head.classname == "smoke")
					{				
			
						local vector dir4 = self.hookhead.origin - self.origin;     
						local float accel = 100*random() + 75;         
						head.velocity = head.velocity + accel*(normalize(dir4));
					}
										
					head = head.chain;
			}
			*/
			
			
			
			if(self.tarzan_time ==1 && !self.button0) self.hookhead.tarzan_time =1;
			
			if(self.impulse ==22 && self.hookhead.tarzan_time ==1)
			{
					local entity oself;
					oself=self;
					self = self.hookhead;
					HookVanish();
			}	
		}
		
			
			
			
			
			
		if(self.hookhead && !(self.player_flag & PF_ITEM_RUNE1_FLAG))                      //HOOK FIX
		{	
			if (self.height == elohim_team1) self.hookhead.skin = 1;   //red
			else if (self.height == elohim_team2) self.hookhead.skin = 2;   //blue
			else self.hookhead.skin = 0;   //blue
			
			if( vlen(self.origin - self.hookhead.origin) < 75) self.hookhead.alpha = 0.001;
			else if( vlen(self.origin - self.hookhead.origin) < 100) self.hookhead.alpha = 0.003;
			else if( vlen(self.origin - self.hookhead.origin) < 200) self.hookhead.alpha = 0.10;
			else if( vlen(self.origin - self.hookhead.origin) < 300) self.hookhead.alpha = 0.3;
			else if( vlen(self.origin - self.hookhead.origin) >= 300) self.hookhead.alpha = 0.7;
			
			if(self.hook_is_anchored == 1) self.hookhead.alpha = 0.7;
			
			local vector dir_adj  = normalize(self.adjusted_hook_impact - self.hookhead.origin);
			if(self.hookhead.weapon == 1800) self.hookhead.velocity = self.hookhead.velocity + dir_adj*200;
			if(self.hookhead.weapon == 2400) self.hookhead.velocity = self.hookhead.velocity + dir_adj*400;
			
			if(self.hookhead.max_health > 1000) self.hookhead.velocity = normalize(self.hookhead.velocity)*self.hookhead.max_health;
			else self.hookhead.velocity = normalize(self.hookhead.velocity)*self.hookhead.weapon;	
		}

		


		if(!self.button0 && self.hook_button_released == 1) self.hook_button_released = 0; // hook button check

		if(!self.button0 && self.rail_button_released == 1) 
		{
			self.rail_button_released = 0; // rail button check
			self.rail_power_time =0;
		}


		if(!self.button0 && self.axe_button_released == 1) 
		{
			self.axe_button_released = 0; // axe button check
			self.axe_power_time = 0;
		}
	
		
		
		if (self.axe_powered == 1 && !self.button0)
		{
			self.shield_recharge_time = time;
			sound (self, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
			self.axe_powered = 0; 
			self.shield_time = time;
			self.weaponmodel = "mdl/v_axe_r.mdl";
			if (self.height == elohim_team2) self.weaponmodel = "mdl/v_axe_b.mdl";
		
			if (self.shields_up == 0) 
			{
				make_shield ();
				self.shields_up = 1;
			}
		}
	
	
		//bprint(ftos(self.shield_time));
		
		if (time - self.shield_time >= 0 && time - self.shield_time < 0.75 && self.old_vel > 800 && self.old_vel > vlen(self.velocity) && vlen(self.velocity) > 300)  //SHIELD BOOST
		{
			//bprint("shield boost ");
			//make_sparks();
			
			makevectors(self.v_angle);
			if(time - self.shield_time < 0.70 && self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
			
			if(vlen(self.velocity) > 425)
			{
				if(self.movement_x ==400) self.velocity = v_forward*self.old_vel*0.93 + '0 0 4';
				else if(self.movement_x ==-400) self.velocity = v_forward*-self.old_vel*0.93  + '0 0 4';
			}
			else
			{
				if(self.movement_x ==400) self.velocity = v_forward*self.old_vel*0.7 + '0 0 4';
				else if(self.movement_x ==-400) self.velocity = v_forward*-self.old_vel*0.7  + '0 0 4';
				self.old_vel = vlen(self.velocity);
				//bprint(ftos(self.old_vel));
			}
		}



		self.ammo_shells = self.frags;    // uncommented these
		self.currentammo = self.frags;
		if(self.frags < 0)  
		{
			self.currentammo = 0;
			self.ammo_shells = 0;
		}
}



vector(vector a, vector b, float mix) lerpVector =
{
    if (mix <= 0) return a;
    if (mix >= 1) return b;
    return (b * mix + a * ( 1 - mix ) );
}


float (float x, float y) angle_difference =
{
    local float a;
    a = x - y;
    a = (a + 180) % 360 - 180;
    if (a > 180) a -= 360;
    if (a < -180) a += 360;
    
    return a;
}


void() turn_indicator =
{
    float turn_cooldown = 130; //90->130
    
    if(self.skiing_on ==0) turn_cooldown = 130;
    else turn_cooldown = 192;
    
    self.turn_speed += angle_difference(self.v_angle[1], self.last_angle);
    self.last_angle = self.v_angle[1];
    
    if (self.turn_speed > 0)
    {
        self.turn_speed -= turn_cooldown * frametime;
        if(self.turn_speed <0) self.turn_speed =0;
    }
    else if (self.turn_speed < 0)
    {
        self.turn_speed += turn_cooldown * frametime;
        if(self.turn_speed >0) self.turn_speed =0;
    }
    
    if(self.turn_speed > 120) self.turn_speed = 120;
    else if(self.turn_speed < -120) self.turn_speed = -120;
}




void() Called_in_PostThink =
{
	
	//local string chat = infokey(self, "chat");
	//if(chat != "") bprint("chatting");
	//local string blah = infokey(self,"chat");
	//if (blah == "1") bprint("chatting");
	
	
	FlickCurves();
	check_jump (); //checks for long presses for wallrun and also for faster rail reload time when looking down
	
	WallRun();
	//ceiling_ride(); 
	swoop();
	

	Skiing();
	Water_bounce();
	
	top_score();
	AirControl ();            //call the AirControl mechanics
	DeathAura();             //call the Death Aura effects
	LandingCheck ();
	CheckPowerups ();
	//movement_check();     [400 0 0] =forward,  [-400 0 0] =backward, [0 -700 0] =left strafe, [0 700 0] =right strafe, 
	Rail_HUD();
	Shield_HUD();
	You_Have_Flag();
	You_Have_Rune();
	Flag_Status();
	make_press_move();
	make_jumbo_red();
	make_jumbo_blue();
	Axe_Splash();
	crash_stomp();
	make_rail_ammo();
	rune_check();
	Stairs();
	flag_carry();
	auto_dash();
	Plasma_Charge_Logic();
	
	
	if(self.armorvalue <= 0 || self.health <=0) self.armorvalue = 1;  //make armor always show up as "1", and set it to 1 if health is zero
	
	
	if(time - self.ski_time2 < 1.20 && (!self.hook_out && (self.impulse !=41))) 	//dont swing axe if skiing
	{

			if(self.ski_sound_counter <16) self.frame = 111;
			else if(self.ski_sound_counter <=32) self.frame = 112;
			else if(self.ski_sound_counter <=48) self.frame = 111;
			else if(self.ski_sound_counter <=64) self.frame = 112;
			else self.frame = 112;
			setsize (self, VEC_HULL_MIN, '16 16 20');
	}
	else setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	if(!self.button0) self.hook_time2=0;
	
	
	local float distz;                        //altimeter
	local vector startz, endz;
	local string altimeter;
		
	startz 	= self.origin;
	endz 	= startz;
	endz_z 	= self.origin_z - 9000;
	traceline (startz, endz, TRUE, self);		
	
	distz = (self.absmin_z - trace_endpos_z);
	if(pointcontents(trace_endpos) == CONTENT_SKY) self.is_over_sky =1;
	else self.is_over_sky =0;

	if (distz < 1)	distz = 0;
		
	self.airborn_pos = floor(distz);
	altimeter = ftos(self.airborn_pos);
	
	//bprint(ftos(smoke_ent_number));  //DECEM smoke counter 
	//bprint("\n");
	//bprint(ftos(self.turn_speed));  //DECEM sturn speed
	//bprint("\n");
	
	if(self.deadflag == DEAD_DYING || self.deadflag == DEAD_DEAD)	//JANUARY player model gib bug
	{
		if(self.model == "mdl/player.md3")
		{
			self.alpha = 0.001;
		}
	}
	
	if(self.frags <0) self.frags =0; //DECEM score
	if(elohim_teamfrags1 < 0) elohim_teamfrags1 =0;
	if(elohim_teamfrags2 < 0) elohim_teamfrags2 =0;
	
	
	if(self.tarzan_time ==0 && self.hook_out ==1 && vlen(self.hookhead.velocity) ==0)
	{
		if ( self.flags & FL_ONGROUND ) self.flags = self.flags - FL_ONGROUND;
	}
	
	//if(((self.hook_out ==1 || (self.weapon == IT_HOOK && self.tarzan_time ==1)) || (self.hook_out ==1 && self.tarzan_time ==1 && !self.button0) ) && self.weaponframe ==0) self.weaponframe = 18;    //show lowered viewmodel when hooking
	if(((self.hook_out ==1 || (self.weapon == IT_HOOK && self.tarzan_time ==1)) || (self.hook_out ==1 && self.tarzan_time ==1 && !self.button0) ) && self.weaponframe ==0) 
	{

				self.weaponframe = 18;    //show lowered viewmodel when hooking

	}
	
	if (   (self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) && self.weapon == IT_HOOK &&  time-self.hook_time < 0.9   )
		{
				self.weaponframe = 18;    //show lowered viewmodel when hooking
				//bprint("hook frame 18\n");
		}
	
	//if (((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) ))

	if(self.weapon == IT_HOOK && self.airborn_pos > 200 && self.weaponframe ==0 && (time-self.hook_time > 0.75)) self.weaponframe = 18; 

	
	
	
	if(!(self.player_flag & PF_ITEM_RUNE3_FLAG))
	{
		if(self.ammo_slugs == 0 && (self.ammo_zero_time ==0 || !(time-self.ammo_zero_time <= 7.1)) )    // Add 1 ammo every 4s up to a max of 1    9-17-23
		{
			self.ammo_zero_time = time;    
		}
		else if(time-self.ammo_zero_time > 7 && time-self.ammo_zero_time < 8.3 && time - self.shot_time > 0.5)     // && self.ammo_slugs ==0)    //10/8/23
		{
			self.ammo_zero_time = time;   //10/8/23
			if(self.ammo_slugs < 3)
			{
				ex_localsound(self, "weap/br_ammo.wav");  // ammo added noise
				ex_localsound(self, "item/br_loot.wav");  // ammo added noise
			}
			
			if(self.ammo_slugs <3) self.ammo_slugs +=1;
		}
	}
	else if(self.player_flag & PF_ITEM_RUNE3_FLAG)  //9-24-23
	{
		if(self.ammo_slugs == 0 && (self.ammo_zero_time ==0 || !(time-self.ammo_zero_time <= 4.6)) )    // Add 1 ammo every 4s up to a max of 1    9-17-23
		{
			self.ammo_zero_time = time;    
		}
		else if(time-self.ammo_zero_time > 4.5 && time-self.ammo_zero_time < 5.8 && time - self.shot_time > 0.3) 
		{
			self.ammo_zero_time = time;   //10/8/23
			if(self.ammo_slugs < 3)
			{
				ex_localsound(self, "weap/br_ammo.wav");  // ammo added noise
				ex_localsound(self, "item/br_loot.wav");  // ammo added noise
			}
			if(self.ammo_slugs <3) self.ammo_slugs +=1;
		}
	}
	
	
	
	
	
	
	if(self.grind_side_is == 0 && self.health > 0)
	{
		//local float oldalpha = self.alpha;
		if(self.leaning ==1) 				//NOVEM fixing bug for when a gib has player model
		{
			//self.angles_z = 0;
			self.leaning =0;
		}
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	
		if(self.hook_out ==0 && vlen(self.velocity) > 300)
		{
			if(self.turn_speed < -8)
			{
					self.angles_z = 5;
					self.leaning =1;
			}
			else if(self.turn_speed > 8)
			{
					self.angles_z = -5;
					self.leaning =1;
			}
		}
	
	
		if(self.hook_out ==0 && vlen(self.velocity) > 440)
		{
			if(self.turn_speed < -14)
			{
				self.angles_z = 7;
			}
	
			else if(self.turn_speed > 14)
			{
				self.angles_z = -7;
			}
		}
	
	
		if(self.hook_out ==0 && vlen(self.velocity) > 440)
		{
			if(self.turn_speed < -21)
			{
				self.angles_z = 10;
			}
	
			else if(self.turn_speed > 21)
			{
				self.angles_z = -10;
			}
		}
		
		//self.alpha =oldalpha;
		
	}
	

	
	
	if ( !(self.flags & FL_ONGROUND) && ((self.turn_speed > 3 && self.turn_speed < 13) || (self.turn_speed <- 3 && self.turn_speed > -13)))   //bhop b-hop
	{	
		
		
		if(vlen(self.velocity) < 475)
		{
			if(self.movement_x == 400) self.velocity = self.velocity + v_forward*5.3;
			else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-5.3);
		}
		else if(vlen(self.velocity) < 550)
		{
			if(self.movement_x == 400) self.velocity = self.velocity + v_forward*4.8;
			else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-4.8);
		}
		else if(vlen(self.velocity) < 725)
		{
			if(self.movement_x == 400) self.velocity = self.velocity + v_forward*4.4;
			else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-4.4);
		}
		else if(vlen(self.velocity) < 925)
		{
			if(self.movement_x == 400) self.velocity = self.velocity + v_forward*4.2;
			else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-4.2);
		}
		else if(vlen(self.velocity) < 1025)
		{
			if(self.movement_x == 400) self.velocity = self.velocity + v_forward*1;
			else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-1);
		}
	
	}
	
	else if ( !(self.flags & FL_ONGROUND) && ((self.turn_speed >= 12 && self.turn_speed < 18) || (self.turn_speed <=- 12 && self.turn_speed > -18)))   //bhop b-hop
	{	
		
		
		if(vlen(self.velocity) < 450)
		{
			if(self.movement_x == 400) self.velocity = self.velocity + v_forward*2.4;
			else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-2.4);
		}
	
	
	}
	
	
	if ( !(self.flags & FL_ONGROUND) && vlen(self.velocity) < 1250)   //strafe bhop
	{		
			if(self.turn_speed > 2 && self.turn_speed < 50 && self.movement_y == -700) 
			{
				self.velocity = self.velocity + v_forward*4.0;
				//bprint("strafe left    ");
			}
			else if(self.turn_speed < -2 && self.turn_speed > -50 && self.movement_y == 700) 
			{
				self.velocity = self.velocity + v_forward*4.0;
				//bprint("strafe right    ");
			}
	}
	
	
	if(self.hook_out ==0 && self.skiing_on ==0 && self.angles_not_zero ==0 && self.tilted ==1) 
	{
		stuffcmd(self, "an0\n");  //backstop scr_nangle
		self.tilted=0;
		//bprint("badspam YES!!!\n");
		
	}


	
}




void() movement_check =                           //when called from post think - prints out which of the WASD buttons is pressed
{
	
	sprint(self, ftos(self.movement_x)); 
	sprint(self, " ");
	sprint(self, ftos(self.movement_y));
	sprint(self, " ");
	sprint(self, ftos(self.movement_z));
	sprint(self, " \n");
}


void() spawn_protection =                  // spawn protection
{
	if(time - self.spawn_protect_time < 3 && !(elohim_playmode & RACE_MODE) && !(elohim_playmode & ELOHIM_NO_SPAWN_PROTECT))     //ammo_rockets = spawn_protect_time
	{

		if (self.armorvalue > 100 && self.armortype == 40.001)
		{
			//any = 1;
			if(self.KDR > 2.1 && self.frags == top_score_global) self.armorvalue = self.armorvalue - 0.5;
			else self.armorvalue = self.armorvalue - 0.25;
			
			if (self.armorvalue > 100 && self.armorvalue < 101)
			{
				if(self.items & IT_ARMOR1)
				{
					self.armorvalue = 0;
					self.items = self.items - IT_ARMOR1;
					self.ammo_cells = 0;      //ammo_cells = spawn_protected
					return;
				}
			}
			self.ammo_cells = 1;    //ammo_cells = spawn_protected
		}
	}
	else self.ammo_cells = 0; // persistent spawn protect visual fix     //ammo_cells = spawn_protected
}






void(entity inflictor, vector org, entity attacker, float radius, float damage, entity ignore) areaDMG =                //area damage function for axe splash damage
    {
    
	local float extra_thors =0;
	local	entity	head = findradius(org, radius);
	attacker.thor_frag_count = 0;
	
	if(damage == 400 && vlen(org - quasar_origin1) < 200)            //thor slam reduces quasar and gravity duration 9-24-23
	{
		quasar_time -=8;
		quasar_flash_time = time;
		//bprint("quasar\n");
	}
	
	if(damage == 400 && vlen(org - gravity_origin1) < 200) 
	{
		gravity_time -=10;
		gravity_flash_time = time;
		//bprint("grav well\n");
	}
	
	while (head)
	{
		if (head != ignore || head.classname == "smoke" || head.classname == "plasma")
		{
			if (head.takedamage  || head.classname == "smoke" || head.classname == "plasma")
			{				
				if (CanDamage (head, inflictor)  || head.classname == "smoke" || head.classname == "plasma")
				{	
					if(damage == 400 && head.shields_up !=1) //9-17-23
					{
						attacker.thor_frag_count = attacker.thor_frag_count + 1; //thor frags
						attacker.thor_slam = 1;   //misidentified thor //comet
						
						local vector dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
						dir5 = normalize(dir5);
						head.velocity = head.velocity + 900*dir5 + v_up*100;
						
					}
					else if(damage == 35) //MARCH
					{
						//attacker.thor_frag_count = attacker.thor_frag_count + 1; //thor frags //QCON quakecon
						//attacker.thor_slam = 1;   //misidentified thor //comet
						
						dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
						dir5 = normalize(dir5);
						head.velocity = head.velocity + 400*dir5 + v_up*100;
						
					}
					if(head.shields_up !=1) 
					{
						if(head != attacker)
						{
							T_DamageOrg (head, inflictor, attacker, damage, org);
							head.armorvalue -= damage/2;
						}
						else                  //if plasma belongs to attacker, deal half damage
						{
							T_DamageOrg (head, inflictor, attacker, damage, org);
							head.health = head.health + damage/2;
							head.armorvalue -= damage/4;
						}
					}
				}			
			}
		}
		head = head.chain;
	}
	
	
		if(attacker.thor_frag_count >= 2 && damage == 400)  //EXTENDED THOR
		{
			head = findradius(org, radius*1.125);
		
			while (head)
			{
			if (head != ignore || head.classname == "smoke" || head.classname == "plasma")
			{
				if (head.takedamage  || head.classname == "smoke" || head.classname == "plasma")
				{				
					if (CanDamage (head, inflictor)  || head.classname == "smoke" || head.classname == "plasma")
					{	
						if(head.shields_up !=1) 
						{
							extra_thors = extra_thors +1; //thor frags
						
							dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
							dir5 = normalize(dir5);
							head.velocity = head.velocity + 900*dir5 + v_up*100;
						}
						if(head.shields_up !=1) 
						{
							T_DamageOrg (head, inflictor, attacker, damage, org);
							head.armorvalue -= damage/2;
						}
					}			
				}
			}
			head = head.chain;
			}
		}
		

		attacker.thor_frag_count = extra_thors + attacker.thor_frag_count;
	
	attacker.thor_slam = 0;
    }
  
void(entity inflictor, vector org, entity attacker, float radius, float throw_high, entity ignore) areaTHROW =                //Area throw effect function for axe splash damage
    {
    
    
    local	entity	head = findradius(org, radius);
    local vector dir;

	while (head)
	{
		if (head != ignore )
		{
				if (head.takedamage)           //Thor slam doest move items
			{
					        //traceline(attacker.origin, head.origin, TRUE, attacker);           
						//dir = trace_plane_normal;
						//dir = dir + v_up*50;
						dir = v_up;
						dir = normalize(dir);
						head.velocity = head.velocity + v_up*throw_high;  //throw	
					}
					
							
			
		}
		head = head.chain;
	}
    }

void(entity inflictor, vector org, entity attacker, float radius, float damage, entity ignore) areaKDR =                //area damage function for high KDR
    {
    local entity head = findradius(org, radius);
  
	while (head)
	{
		if (head != ignore && head.KDR > 2.4 && (head.classname == "player" || head.classname == "dummy"))
		{
			if (head.takedamage)
			{				
				if (CanDamage (head, inflictor))
				{	
					T_DamageOrg (head, inflictor, attacker, damage, org);
				}			
			}
		}
		head = head.chain;
	}
    }



void(entity inflictor, vector org, entity attacker, float radius, float damage, entity ignore) areaKDR2 =                //area damage function for high KDR
{

	local entity head;
	
	//bprint(ftos(attacker.KDR));
	//bprint("attacker KDR\n");

	if(attacker.KDR >= 2.1 && attacker.frags == top_score_global) // if score leader - reduced AOE radius
	{	
		head = findradius(org, radius*0.9);

		while (head)
		{
			if (head != ignore && (head.classname == "player" || head.classname == "dummy"))
			{
				if (head.takedamage)
				{				
					if (CanDamage (head, inflictor))
					{	
						if(head.hook_is_anchored ==1 && head.hookhead.origin == attacker.origin) damage = damage+0.1;
						T_DamageOrg (head, inflictor, attacker, damage, org);
						attacker.done_damage = 1;
					}			
				}
			}
		

		head = head.chain;
		}
		return;
	}	
	
	
	
	head = findradius(org, radius*1.25);

	while (head)
	{
		
		if (head != ignore && head.KDR >= 2.0 && (head.classname == "player" || head.classname == "dummy"))
		{
			if (head.takedamage)
			{				
				if (CanDamage (head, inflictor))
				{	
					T_DamageOrg (head, inflictor, attacker, damage, org);
					attacker.done_damage = 1;
				}			
			}
		}
		head = head.chain;
	}
	
	
	
	
	
	head = findradius(org, radius*1);
   
	while (head)
	{
		if (head != ignore && head.KDR < 2.0 && (head.classname == "player" || head.classname == "dummy"))
		{
			if (head.takedamage)
			{				
				if (CanDamage (head, inflictor))
				{	
					T_DamageOrg (head, inflictor, attacker, damage, org);
					attacker.done_damage = 1;
				}			
			}
		}
		

		head = head.chain;
	}
	
	

		
}




///////// THOR /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// check to see if player landed and play landing sound or perform THOR Landing 
   
void () LandingCheck =
{ 
   
	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;
    else if (self.jump_flag < -320)       // 
    {
	 makevectors(self.v_angle);
	 local vector v_ang;
	 v_ang = vectoangles (v_forward*(-1));   
	
        if (self.health > 0)
        {
            if (self.watertype == CONTENT_WATER) sound (self, CHAN_BODY, "body/br_splash.wav", 1, ATTN_NORM);
            else if ((((self.jump_flag < -900 || vlen(self.velocity) > 1200) && self.weapon == IT_AXE && v_ang_x > 40 && v_ang_x < 120) || ((self.player_flag & PF_ITEM_RUNE2_FLAG) && self.jump_flag < -900 && time - thor_strike_time < 1.5)) )                     // Thor smash //THOR STRIKE only when holding axe - no fall damage, but explosion particle effect at 950 vertical speed, 1200 ->1500
            {
		
	
		areaTHROW(self, self.origin, self, 600, 400, self); //Thor landing throw
		areaTHROW(self, self.origin, self, 450, 100, self);
		areaTHROW(self, self.origin, self, 300, 100, self);
		areaDMG(self, self.origin, self, 175, 400, self);      //damage zone 165 - > 175     //9-17-23
		
		if((self.player_flag & PF_ITEM_RUNE2_FLAG) && self.jump_flag < -900 && thor_strike_time > 0.2 && time - thor_strike_time < 1.5) 
		{
			self.velocity = self.velocity + v_up*300 + '0 0 250';    //THOR STRIKE
			thor_strike_time =0;
			T_DamageOrg (self, self, self, 20, self.origin + '0 0 -10');
			if(self.armorvalue >0) self.armorvalue -= 10;								
			if(self.armorvalue <=0) self.armorvalue =0;
			
		}
		
		if(!(elohim_playmode & RACE_MODE) || (mapname =="tut1" || mapname =="tut2" || mapname =="tut7"))
		{
			//self.velocity = self.velocity + '0 0 100';    //THOR BOUNCE for normal thor slam thor jump
			make_impact('0 0 0', 1);
			self.thor_time = time;
		}
             
        
            }
            else
                {
			if(random()<0.33) sound (self, CHAN_AUTO, "body/br_land1.wav", 0.7, ATTN_NORM);  // 1 -> 0.5      
			else if(random()<0.62) sound (self, CHAN_AUTO, "body/br_land2.wav", 0.7, ATTN_NORM);
			else if(random()<0.8) sound (self, CHAN_AUTO, "body/br_land3.wav", 0.7, ATTN_NORM);
			else if(random()<=1) sound (self, CHAN_AUTO, "body/br_land4.wav", 0.7, ATTN_NORM);
		}
    
            self.jump_flag = 0;
        }
        
    }
    
    
}



void() crash_stomp =						//NOVEM
{
        if (self.velocity_z < -800)  
	{
			//bprint("crash\n");
			local entity head = findradius(self.origin + '0 0 -33', 44);
  
			while (head)
			{
				if (head != self && (head.classname == "player" || head.classname == "dummy"))
				{			
					T_DamageOrg (head, self, self, 400, self.origin);
				}
				head = head.chain;
			}
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



void() PlayerJump =
{
	if (self.flags & FL_WATERJUMP)
		return;
		
	if(self.impulse ==41 || self.impulse ==42 || self.ski_button) return; //MARCH
	
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_LAVA)		self.velocity_z = 50;
		else if (self.watertype == CONTENT_SLIME)	self.velocity_z = 80;
		
		if (self.swim_flag < time)  // play swiming sound
		{
			self.swim_flag = time + 1;
			if (random() < 0.5) 		sound (self, CHAN_BODY, "misc/br_water1.wav", 1, ATTN_NORM);
			else 				sound (self, CHAN_BODY, "misc/br_water2.wav", 1, ATTN_NORM);
		}
		return;
	}
	local vector horiz;
	horiz = self.velocity;
	horiz_z=0;
	if (!(self.flags & FL_ONGROUND) || self.tarzan_time == 1)  return;
	//if ( !(self.flags & FL_JUMPRELEASED) && ((vlen(self.velocity) < 410) || self.hook_out ))    return;		// don't pogo stick	
	if ( !(self.flags & FL_JUMPRELEASED) && ((vlen(horiz) < 400) || self.hook_out ))    return;
	
	if(self.front_slope >0.6) return;
		

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk 
	
	if(self.angles_not_zero ==0) // && !self.landed_on_decline)   //dont make jumping noise if wallrunning
	{
		if (random() < 0.4) 
		{
			sound (self, CHAN_BODY, "body/br_jmp1.wav", 0.57, ATTN_NORM);   // 1 -> 0.9
			//ex_localsound(self, "body/br_jmp1.wav");
		}
		else if (random() < 0.7) 
		{
			sound (self, CHAN_BODY, "body/br_jmp2.wav", 0.57, ATTN_NORM);  
			//ex_localsound(self, "body/br_jmp2.wav");
		}
		else 
		{
			sound (self, CHAN_BODY, "body/br_jmp3.wav", 0.57, ATTN_NORM);   // alternative jump noise
			//ex_localsound(self, "body/br_jmp3.wav");
		}
		
	}
	if (self.waterlevel <= 2) self.velocity_z = self.velocity_z + 270;
		
};



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void() update_power =
{
	if(self.alpha <= 0.04)
	{
		if(self.classname == "power") self.think = SUB_Remove; 
	}
	else
	{
		self.alpha = self.alpha - 0.04;
		if(self.alpha < 0.6) self.frame = 1;
	}
	
	self.nextthink = time + 0.01;
}




void(vector origin, float _alpha, float _frame) make_power =
{
	local entity power;
	power = spawn();
	setmodel (power, "mdl/ef_power.mdl");
	if (pointcontents(origin + '0 0 5') != CONTENT_SOLID) setorigin(power, origin + '0 0 5');  //added this condition so that the power splash draws when firing at ceiling
	else setorigin(power, origin + '0 0 0');
	power.frame = 6;   //6 -> 7
	power.frame = _frame;
	power.movetype = MOVETYPE_NOCLIP;
	power.solid = SOLID_NOT;
	power.classname = "power";
	setsize (power, 0,0);
	power.alpha = 0.7;
	power.alpha = _alpha;
	power.owner = self;
	power.nextthink = time + 0.01;
	power.think = update_power;
}







void() update_aura =
{
	makevectors(self.owner.owner.v_angle);
	setorigin(self, self.owner.origin + '0 0 8');
    
	if(self.alpha <= 0.07)
	{
		self.think = SUB_Remove; 
	}
	else
	{
		self.alpha = self.alpha - 0.07;
		if(self.alpha < 0.6) self.frame = 4;
		if ((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.player_flag & PF_ITEM_RUNE1_FLAG)) self.frame = 5;
	}
	
	
	
	
	self.nextthink = time + 0.01;
}




void() make_aura =
{
	local entity aura;
	aura = spawn();
	setmodel (aura, "mdl/ef_aura1.mdl");
	setorigin(aura, self.origin + '0 0 8');
	aura.movetype = MOVETYPE_NOCLIP;
	aura.solid = SOLID_NOT;
	aura.frame = 3;
	aura.classname = "aura";
	setsize (aura, 0,0);
	aura.alpha = 0.7;
	aura.owner = self;
	aura.nextthink = time + 0.01;
	aura.think = update_aura;
}




void() DeathAura =              //Death Aura effect
{
		if (self.height == elohim_team1) self.skin = 1;
		else if (self.height == elohim_team2) self.skin =2;

	if (((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE4_FLAG) ))
	{
		if (self.height == elohim_team1) 
		{
			self.skin = 6;
		}
		else if (self.height == elohim_team2) 
		{
			self.skin = 7;	
		}
		
		local float origin_hit = 0;
		local	entity	head;
		
		if(self.wraith == 1 || (self.KDR >= 2.4 && self.frags == top_score_global))  //DECEM 2.1->2.4
		{
			head = findradius(self.origin, 44);   //DECEM 42 -> 44
			while (head)
			{
				if (head != self)
				{
					if (head.takedamage)
					{				
						if (CanDamage (head, self))
						{	
							if(death_aura_counter ==0 || death_aura_counter%2 == 0) 
							{
								T_DamageOrg (head, self, self, 51, self.origin);     //changed damage value for armor damage logic
								make_aura();
								sound(self, CHAN_AUTO, "item/br_zap.wav", 1, ATTN_NORM);
								//bprint("Death Aura\n");
							}
							death_aura_counter+=1;
							origin_hit = 1;
						}			
					}
				}
			head = head.chain;
			}
		}
		else
		{
		
		
			head = findradius(self.origin + '0 0 5', 59);  //DECEM 55 -> 59 and upped the origin by 5 vertical
			while (head)
			{
				if (head != self)
				{
					if (head.takedamage)
					{				
						if (CanDamage (head, self))
						{	
							if(death_aura_counter ==0 || death_aura_counter%2 == 0) 
							{
							T_DamageOrg (head, self, self, 51, self.origin);     //changed damage value for armor damage logic
							make_aura();
							sound(self, CHAN_AUTO, "item/br_zap.wav", 1, ATTN_NORM);
							//bprint("Death Aura\n");
							}
							death_aura_counter+=1;
							
							origin_hit = 1;
						}			
					}
				}
			head = head.chain;
			}
		}
		
		
		
		
		if(origin_hit == 0)
		{
			head = findradius(self.origin + '0 0 -20', 42);
			while (head)
			{
				if (head != self)
				{
					if (head.takedamage)
					{				
						if (CanDamage (head, self))
						{	
							if(death_aura_counter ==0 || death_aura_counter%4 == 0) 
							{
								T_Damage (head, self, self, 51);     //changed damage value for armor damage logic
								make_aura();
								sound(self, CHAN_AUTO, "item/br_zap.wav", 1, ATTN_NORM);
								//bprint("Death Aura\n");
							}
							death_aura_counter+=1;
							
						}			
					}
				}
				head = head.chain;
			}
		}
		
		
		
		
	}
	
	
	
	
}     


void() AirControl =              //additional +forward Air control 
{

	local float V_len;
	local vector for_XY;
	local vector vel_XY;
	local float velz;
	
	
	if (!(self.flags & FL_ONGROUND) && !(self.hook_out) && self.movement_x > 320)
	{
		makevectors (self.v_angle);
	
		for_XY = v_forward;
		for_XY_z = 0;  
		for_XY = normalize(for_XY);
	
		vel_XY = self.velocity;
		vel_XY_z = 0;
		V_len = vlen(vel_XY);

		
		velz = self.velocity_z;   
     
	
			vel_XY = vel_XY + for_XY*11;     //Extent of standard Air control 10 -> 11
			self.velocity = V_len*normalize(vel_XY);
			self.velocity_z = velz;
		
	}
        
};


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	

void() update_crown =
{
	if(self.classname != "crown") return;
    
	makevectors(self.owner.v_angle);
	local vector zz = v_forward;
	zz_z = 0;
	zz = normalize(zz);
	
	//setorigin(self, (self.owner.origin + '0 0 55' + zz*(-50))  );
	
	
	/*
	if(self.owner.teleport_time == time +0.7) setmodel (self, "mdl/null.spr");
	else if (self.owner.teleport_time > time +0.6)
	{
		//bprint("switch up");
		if(self.owner.height == elohim_team2) setmodel (self, "mdl/null_trail.mdl");
		else setmodel (self, "mdl/null_trail_gre.mdl");
	}
	
	if(self.print_killa == 1 || (self.deadflag == DEAD_DYING) || (self.deadflag == DEAD_DEAD)) setmodel (self, "mdl/null.spr");    
	else if(self.model == "mdl/null.spr" && (self.print_killa == 0 && (self.deadflag != DEAD_DYING) && (self.deadflag != DEAD_DEAD)))
	{
		//bprint("switch up");
		if(self.owner.height == elohim_team2) setmodel (self, "mdl/null_trail.mdl");
		else setmodel (self, "mdl/null_trail_gre.mdl");
		
	}
	*/
	
	
	
	setorigin(self, (self.owner.origin + v_up*10 + v_forward*(-18) + '0 0 40')  );
	
	
	if(pointcontents(self.owner.origin + '0 0 75' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 21'));
	if(pointcontents(self.owner.origin + '0 0 70' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 21'));
	if(pointcontents(self.owner.origin + '0 0 65' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 20'));
	if(pointcontents(self.owner.origin + '0 0 55' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 20'));
	if(pointcontents(self.owner.origin + '0 0 50' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 19'));
	if(pointcontents(self.owner.origin + '0 0 45' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 19'));
	if(pointcontents(self.owner.origin + '0 0 40' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 18'));
	if(pointcontents(self.owner.origin + '0 0 35' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 18'));
	if(pointcontents(self.owner.origin + '0 0 30' + v_forward*(-18)) == CONTENT_SOLID) setorigin(self, (self.owner.origin + v_forward*(-11) + '0 0 18'));
	
    
	if (self.owner.deadflag != DEAD_NO) 
	{
		self.alpha = 0.01;
	}
	
	if (self.owner.frags < top_score_global || elohim_playmode & ELOHIM_CLASSIC || self.owner.hascrown ==0) 
	{
		self.owner.hascrown = 0;
		self.think = SUB_Remove;
		crown_out = 0;
	}

	self.nextthink = time;
}




void() make_crown =
{
	if(crown_ent.classname == "crown") return;
	//local entity crown;
	crown_ent = spawn();
	
	//if(self.height == elohim_team1) setmodel (crown, "mdl/null_trail_gre.mdl");
	//else setmodel (crown, "mdl/null_trail.mdl");
	
	if(self.height == elohim_team2) setmodel (crown_ent, "mdl/null_trail.mdl");
	else setmodel (crown_ent, "mdl/null_trail_gre.mdl");
	
	setorigin(crown_ent, self.origin + '0 0 40');
	crown_ent.movetype = MOVETYPE_NOCLIP;
	crown_ent.solid = SOLID_NOT;
	crown_ent.nextthink = time + 0.5;
	crown_ent.think = update_crown;
	crown_ent.classname = "crown";
	setsize (crown_ent, 0,0);
	crown_ent.alpha = 0.01;
	crown_ent.owner = self;
	crown_ent.nextthink = time + 0.01;
	crown_ent.think = update_crown;
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



void() update_impact =
{
	makevectors(self.owner.owner.v_angle);
	
	if (self.frame == 9) 
	{
		self.think = SUB_Remove;
	}
	else self.frame = self.frame +1;
	
	if(self.frame > 5) self.alpha -= .24;
	
	self.nextthink = time + 0.025;
}


void(vector z_offset, float shockwave) make_impact =
{
	local entity impact;
	local vector exp_org = self.origin;
	exp_org_z = exp_org_z + z_offset_z;
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, exp_org_x);
	WriteCoord (MSG_BROADCAST, exp_org_y);
	WriteCoord (MSG_BROADCAST, exp_org_z);
        sound (self, CHAN_AUTO, "weap/br_explo.wav", 0.75, ATTN_NORM);
	
	
	if(shockwave ==1)
	{
		impact = spawn();
		setmodel (impact, "mdl/ef_thor.mdl");
		impact.skin = 0;
		impact.frame = 0;
    
		setorigin(impact, self.origin + '0 0 -5' + z_offset);
		impact.movetype = MOVETYPE_NOCLIP;
		impact.solid = SOLID_NOT;
		impact.classname = "shield";
		setsize (impact, 0,0);
		impact.alpha = 0.8;
		impact.owner = self;
		impact.nextthink = time + 0.01;
		impact.think = update_impact;	
	}
}






/////////////////////PLAYER AND TEAM STATS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void() top_score =
{
	local entity player;
	local float new_frag, new_kdr;
	player = find(world, classname, "player");                                         // count players in game
	
	top_KDR_global = 0;
	bottom_KDR_global = 0;
	
	total_players_global = 0;
	red_count_global = 0;
	blue_count_global = 0;
	
	
	total_score_global = 0;  //sum of all players' scores
	top_score_global = 0;
	bottom_score_global = 0;
	
	red_topscore_global = 0;
	red_secondscore_global = 0;
	red_thirdscore_global = 0;
	red_bottomscore_global = 0;
	red_teamscore_global = 0; 
	
	blue_topscore_global = 0;
	blue_secondscore_global = 0;
	blue_thirdscore_global = 0;
	blue_bottomscore_global = 0;
	blue_teamscore_global = 0; 
	
	winning_team_global = 0;
	teams_are_even = 0;
	
	while (player)
	{
		if ((player.style & ELOHIM_CONNECTED))
		{
			if(player.total_deaths <= 0) player.KDR = 0;           // TODO FIX KDR CALCULATOR
			else if (player.total_deaths > 0) player.KDR = player.total_kills/player.total_deaths; 
	    
			new_frag = player.frags;
			new_kdr  = player.KDR;
	  
			if(new_frag > top_score_global) top_score_global = new_frag;           //top and bottom score counts
			if(new_frag < bottom_score_global) bottom_score_global = new_frag;
            
			if(new_kdr > top_KDR_global) top_KDR_global = new_kdr;           //top and bottom KDR counts
			if(new_kdr < bottom_KDR_global) bottom_KDR_global = new_kdr;
            
			if(player.frags != -99) total_players_global = total_players_global + 1;           //total players count in game
			if(player.frags != -99) total_score_global = total_score_global + player.frags;
			
			
			if(player.frags != -99 && player.height == 4) total_score_global = total_score_global + player.frags;
			
			if(player.frags != -99 && player.height == 4) red_count_global = red_count_global + 1;         // team player counts
			if(player.frags != -99 && player.height == 13) blue_count_global = blue_count_global + 1; 
			
			
			if(new_frag > red_topscore_global && player.height == 4) red_topscore_global = new_frag;           //top and bottom RED TEAM scores
			if(new_frag < red_bottomscore_global && player.height == 4) red_bottomscore_global = new_frag;
		
			
			if(new_frag > blue_topscore_global && player.height == 13) blue_topscore_global = new_frag;           //top and bottom RED TEAM scores
			if(new_frag < blue_bottomscore_global && player.height == 12) blue_bottomscore_global = new_frag;
			
			if(player.frags != -99 && player.height == 4) red_teamscore_global = red_teamscore_global + player.frags;       // team score count
			if(player.frags != -99 && player.height == 13) blue_teamscore_global = blue_teamscore_global + player.frags;
			
			if (red_teamscore_global > blue_teamscore_global) winning_team_global = 4;             //which team is winning?
			else if(blue_teamscore_global > red_teamscore_global) winning_team_global = 13;
			else if(blue_teamscore_global == red_teamscore_global) winning_team_global = 0;
            

			if(red_count_global == blue_count_global) teams_are_even = 1;
			if(red_count_global != blue_count_global) teams_are_even = 0;
			
            
        }
        player = find(player, classname, "player");
        
    }
    
	while (player)    //2nd place score calc
	{
		if ((player.style & ELOHIM_CONNECTED) && (!(player.style & CRMOD_QSMACK)))
		{
			if(new_frag > red_secondscore_global && new_frag < red_topscore_global && player.height == 4) red_secondscore_global = new_frag; 
			if(new_frag > blue_secondscore_global && new_frag < blue_topscore_global && player.height == 4) blue_secondscore_global = new_frag; 
		}
		
	player = find(player, classname, "player");
	
	}
	
	while (player)   //3rd place score calc
	{
		if ((player.style & ELOHIM_CONNECTED) && (!(player.style & CRMOD_QSMACK)))
		{
			if(new_frag > red_thirdscore_global && new_frag < red_secondscore_global && player.height == 4) red_thirdscore_global = new_frag; 
			if(new_frag > blue_thirdscore_global && new_frag < blue_secondscore_global && player.height == 4) blue_thirdscore_global = new_frag; 
		}
		
	player = find(player, classname, "player");
	
	}

}






//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



void () Shuffle_Teams =

{
	local entity player;
	player = find(world, classname, "player");      
	local float number_set_red = 0;
	local float number_set_blue = 0;                   

	
	bprint(ftos(total_players_global));
	bprint(" TOTAL PLAYERS \n");
	
	if (total_players_global < 4)
	{
			bprint("Must have at least 4 players to shuffle teams");
			return;
	}
	
	while (player)
	{
		if ((player.style & ELOHIM_CONNECTED))           // && total_players_global % 2 == 0)
		{
			local float rnd = random();
			if((rnd< 0.5 && number_set_blue < total_players_global / 2) || number_set_red >= total_players_global / 2)      
			{
				setcolor(player, 221);  //blue
				player.team = 14;
				number_set_blue = number_set_blue +1;
				bprint(ftos(number_set_blue));
				bprint(" another blue \n");
				
			}
			else if ((rnd>= 0.5 && number_set_red < total_players_global / 2) || number_set_blue >= total_players_global / 2) 
			{
				setcolor(player, 68);  //red
				player.team = 5;
				number_set_red = number_set_red +1;
				bprint(ftos(number_set_red));
				bprint(" another red \n");
			}
			
		}
		
	
		
		
        player = find(player, classname, "player");
        
	}
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void () Rebalance_Teams =
{
	local entity player;
	player = find(world, classname, "player");                                         //count players in game

	if (total_players_global < 4)
	{
			bprint("Must have at least 4 players to rebalance teams");
			return;
	}
	
	else if (total_players_global <= 5)
	{
		while (player)
		{
			if ((player.style & ELOHIM_CONNECTED) && player.frags != -99)
			{
				//bprint("parse <5 \n");
				if (winning_team_global == 4 && red_secondscore_global > blue_secondscore_global) 
				{	
					if (player.frags == red_secondscore_global && player.height == 4) stuffcmd(player, "color 13\n");   //if second on winning team has more points than second on losing team - swap them
					if (player.frags == blue_secondscore_global && player.height == 13) stuffcmd(player, "color 4\n"); 
					bprint("Rebalancing teams..");
				}
				else if (winning_team_global == 13 && blue_secondscore_global > red_secondscore_global) 
				{	
					if (player.frags == blue_secondscore_global && player.height == 13) stuffcmd(player, "color 4\n");   //if second on winning team has more points than second on losing team - swap them
					if (player.frags == red_secondscore_global && player.height == 4) stuffcmd(player, "color 13\n"); 
					bprint("Rebalancing teams..");
				}
				else 
				{
					bprint("Unable to achieve better team balance");
					return;
				}
			player = find(player, classname, "player");
        
			}
		}
	}
	
	else if (total_players_global > 5)
	{
		while (player)
		{
			if ((player.style & ELOHIM_CONNECTED) && player.frags != -99)
			{
				//bprint("parse >5 \n");
				if (winning_team_global == 4 && (red_secondscore_global > blue_secondscore_global || red_secondscore_global > blue_thirdscore_global)) 
				{	
					if(player.frags == red_secondscore_global && player.height == 4) stuffcmd(player, "color 13\n");   //if second on winning team has more points than third on losing team - swap them
					if (player.frags == blue_thirdscore_global && player.height == 13) stuffcmd(player, "color 4\n"); 
				}
				else if (winning_team_global == 13 && (blue_secondscore_global > red_secondscore_global || blue_secondscore_global > red_thirdscore_global)) 
				{	
					if(player.frags == blue_secondscore_global && player.height == 13) stuffcmd(player, "color 4\n");   //if second on winning team has more points than second on losing team - swap them
					if (player.frags == red_thirdscore_global && player.height == 4) stuffcmd(player, "color 13\n"); 
				}
				else 
				{
					bprint("Unable to achieve better team balance");
					return;
				}
            
			}
			player = find(player, classname, "player");
        
		}
	}
	
	
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




void() CheckPowerups =
{
	if(elohim_playmode & RACE_MODE)
	{
		if(self.items & IT_INVULNERABILITY) self.items = self.items - IT_INVULNERABILITY;
		if(self.items & IT_INVISIBILITY) self.items = self.items - IT_INVISIBILITY;
	}
	
	if (self.health <= 0)	return;
	if(elohim_playmode & RACE_MODE) return;
	
	local float selfalpha;
	
	if (self.invisible_finished)				// invisibility
	{
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "item/br_inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, "Adaptive camouflage is running out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "item/br_inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		

		if(vlen(self.velocity) < 100) selfalpha = 0.08;
		else if(vlen(self.velocity) < 300) selfalpha = 0.12;
		else if(vlen(self.velocity) < 500) selfalpha = 0.20;
		else if(vlen(self.velocity) < 700) selfalpha = 0.30;
		else if(vlen(self.velocity) < 900) selfalpha = 0.45;
		else selfalpha = 0.5;
			
		
			
			if(self.alpha > selfalpha) 
			{
				self.alpha = self.alpha - 0.02;
			}
			else if(self.alpha < selfalpha) 
			{
				self.alpha = self.alpha + 0.02;
			}
			//self.alpha = 0.2;
	}
	
	else
	{
		if(elohim_playmode & ELOHIM_WRAITH && (self.items & IT_INVISIBILITY) && self.wraith == 1)
		{
			if(vlen(self.velocity) < 100) selfalpha = 0.08;
			else if(vlen(self.velocity) < 300) selfalpha = 0.12;
			else if(vlen(self.velocity) < 500) selfalpha = 0.20;
			else if(vlen(self.velocity) < 700) selfalpha = 0.30;
			else if(vlen(self.velocity) < 900) selfalpha = 0.45;
			else selfalpha = 0.5;
			
			
			
			if(self.alpha > selfalpha) 
			{
				self.alpha = self.alpha - 0.02;
			}
			else if(self.alpha < selfalpha) 
			{
				self.alpha = self.alpha + 0.02;
			}
			
			
			
		}
		else if (!(self.style & ELOHIM_OBSERVER)) self.alpha = 1;
	}
	
		

	// invincibility
	if (self.invincible_finished)
	{
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "item/br_protec2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{	// just stopped
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
	
	}

	// super damage
	if (self.super_damage_finished)
	{

	// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "item/br_dmg1.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
		{
				self.effects = self.effects | EF_DIMLIGHT;
				self.effects = self.effects | EF_FLICKER;
		}
		else
		{
				self.effects = self.effects - (self.effects & EF_DIMLIGHT);
				self.effects = self.effects - (self.effects & EF_FLICKER);
		}
	}	

	// suit	
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

	// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}	


		

};



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////








void() racing_start =
{
		chrono_time = time;
		other.racing_on = 1;
		racing_on_global = 1;
		bprint("   \b[START!!]\b\n");
		other.race_completed = 0;
		if (other.items & IT_INVULNERABILITY) other.items = other.items - IT_INVULNERABILITY;

		
}

void() racing_finish =
{
					other.race_completed = 1;
					other.racing_on = 0;
					racing_on_global = 0;
					other.my_previous_time = time - chrono_time;
					
					
					if (other.items & IT_INVISIBILITY) other.items = other.items - IT_INVISIBILITY;
					
					
					if( (other.my_previous_time < place_one_time || place_one_time ==0)) 
					{
						place_one_time = other.my_previous_time;
						bprint("   \b.\b\n");
						bprint("   \b.\bnew record \n   \b>>\b");
						bprint(utils_get_time(other.my_previous_time));
						bprint("\b<<\b\n");
						bprint("   \b.\b\n");
						bprint("   \b[FINISH!]\b\n");
						bprint("------------------\n");
						self = other;
						ClientKill();
						spawn_race_entities();
						return;
						
					}
						
					else if( other.my_previous_time < place_two_time || place_two_time ==0) place_two_time = other.my_previous_time;
					else if( other.my_previous_time < place_three_time || place_three_time ==0) place_three_time = other.my_previous_time;
		
				
					bprint("   \b.\b\n");
					bprint("   \b.\byour time \n   \b>>\b");
					bprint(utils_get_time(other.my_previous_time));
					bprint("\b<<\b\n");
					bprint("   \b.\b\n");
					bprint("   \b[FINISH!]\b\n");
					bprint("------------------\n");
					self = other;
					ClientKill();
					spawn_race_entities();

}



void() racing_countdown =
{
	if(countdown == 1)
	{
				
				
				if(countdown_ct == 60)
				{
					bprint("3\n");
					sound(self, CHAN_AUTO, "weap/br_charged.wav", 0.5, ATTN_NORM);

				}
				
				else if(countdown_ct == 120)
				{
					bprint("2\n");
					sound(self, CHAN_AUTO, "weap/br_charged.wav", 0.5, ATTN_NORM);
				}
				
				else if(countdown_ct == 180)
				{
					bprint("1\n");
					sound(self, CHAN_AUTO, "weap/br_charged.wav", 0.5, ATTN_NORM);
				}
				
				else if(countdown_ct == 240)
				{
					bprint("GO!!!\n");
					sound(self, CHAN_AUTO, "misc/br_ding1.wav", 1, ATTN_NORM);
					chrono_time = time;
					racing_on_global = 1;
				}
				countdown_ct = countdown_ct + 1;
	
	}

}


string (float t) utils_get_time =
{
    local float minutes;
    local float seconds;
    local float csec;
    local string temp;
    local string tmin="",tsec="",tcsec="";

    minutes = floor((t/60));
    seconds = floor(    (  (t/60)-minutes  )*60   );
    csec    = floor((((((t/60)-minutes)*60)-seconds)*100));

    temp = ftos(minutes);
    if ((minutes < 10))
        tmin = sprintf("0%s", temp);
    else
        tmin = temp;

    temp = ftos(seconds);
    if ((seconds < 10))
        tsec = sprintf("0%s", temp);
    else
        tsec = temp;

    temp = ftos(csec);
    if ((csec < 10))
        tcsec = sprintf("0%s", temp);
    else
        tcsec = temp;

    return sprintf("%s:%s.%s",tmin,tsec,tcsec);
};



void(string cmd) SV_ParseClientCommand =
{	
	//sprint(self, "check here\n");
	//return;
		
	float argc = tokenize_console(cmd);
	switch(argv(0))
	{
		case "skiing_on": self.skiing_on = 0; break;
		case "skiing_off": self.ski_button =0; self.skiing_on = 3; break;
		default: clientcommand(self, cmd); break;
		
	}
}


float() splat_customize =
{
	if(vlen(other.origin - self.origin) < 105 && (other.deadflag == DEAD_DEAD || other.deadflag == DEAD_DYING || other.deadflag == DEAD_RESPAWNABLE)) 
	{
		//bprint("customized   ");
		return FALSE;
	}
	
	else if(other == self.owner || other == self.owner.owner) return FALSE;
	
	
	else return TRUE;
}
