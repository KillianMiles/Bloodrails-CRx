




void(entity inflictor, vector org, entity attacker, float radius, float throw_high, entity ignore) PlasmaPusher =                //Area throw effect function for axe splash damage
{
	local	entity	head = findradius(org, radius);

	while (head)
	{
		if (head != ignore )
		{
				if (head.classname == "plasma")           //Thor slam doest move items
				{
					       
						if(!head.speed) head.weaponframe = 1000;       //weaponframe = speed_plasma
						
						if(vlen(head.velocity) == 0)
						{
							makevectors (self.v_angle);
							setorigin(head, head.origin + '0 0 5' );
							head.velocity = head.velocity + v_up*250;
						}
						
						head.plasma_time = head.plasma_time + 1.2;
						
						local vector dir = head.origin - (attacker.absmin + attacker.absmax) * 0.5;                  //momentum add
						dir = normalize(dir);
	
						head.velocity_plasma = 1000*dir;   //old_hook_vel = velocity_plasma
						head.max_health = 1;    //max_health = plasma_is_pushed
						head.pushed_plasma =1;
						attacker.pushed_plasma =1;
						
						if(head.skin == 6) head.skin = 5;  
						else if(head.skin == 5) head.skin = 6;  
						
						head.owner = attacker;
						sound (attacker, CHAN_AUTO, "bloodrailz/weapons/plasma2.wav",1,ATTN_NORM);
						
						if (self.height == elohim_team1) head.skin = 6;   //red
						else if (self.height == elohim_team2) head.skin = 5;   //blue
						else
						{
							if(head.skin == 5) head.skin = 6; 
							else if(head.skin == 6) head.skin = 5; 
						} 
				}
		}
		
		head = head.chain;
	}
}






void() Axe_Splash =
{
	if (self.deadflag || self.health <= 0) return;
	
	makevectors(self.v_angle);
	
	
	if(time - self.axe_splash_time < 0.30 && self.done_damage == 0)   //MAY 0.20 -> 0.3
	{
		areaKDR2(self, self.origin + v_forward*30, self, 57, 403, self);    //JANUARY 44 ->55
		if(self.turn_speed >48) areaKDR2(self, self.origin + v_forward*10 + v_right*(-30), self, 33, 403, self);      //damage into direction of turn  //10/8/23 commented this out to see if it fixes double kill issue //NOVEM uncommented bc the issue was elsewhere
		else if(self.turn_speed <-48) areaKDR2(self, self.origin + v_forward*10 + v_right*(30), self, 33, 403, self); 
		
		//sprint(self, ftos(self.turn_speed));
		//sprint(self, "\n");
		//if(self.weaponframe ==0) bprint("weaponframe\n");
	}
	//else if(time - self.axe_splash_time >= 0.4 && time - self.axe_splash_time < 0.42) bprint("done!\n");  
	



}

void() Axe_Charge_Logic=
{
	//SHIELD TIMING LOGIC
		if (elohim_playmode & ELOHIM_NO_SHIELD) return;
		if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.items2 & IT2_SIGIL3)) return; //DECEM no shield with haste
		
		local float RECHARGE = 18;
		if(mapname == "tut1") RECHARGE = 2;

		if (time - self.axe_power_time > 0.59 && self.axe_power_time != 0 && self.axe_powered == 0)
		{
			
			
			if(time - self.shield_recharge_time > RECHARGE || self.shield_recharge_time == 0)
			{
				self.axe_powered = 1;
				
				self.old_vel = vlen(self.velocity);    //store velocity at shield powerup for glide
				
				sound (self, CHAN_WEAPON, "bloodrailz/weapons/axe_charge.wav", 1, ATTN_NORM);
				//sprint(self, "shield powered-up\n");
			
				self.weaponmodel = "progs/bloodrailz/v_br_axe_redzz.mdl";
				if (self.height == elohim_team2) self.weaponmodel = "progs/bloodrailz/v_br_axe_bluzz.mdl";
				self.weaponframe = 0;
			}
			
			else if (time - self.shield_recharge_time <= 13 && self.shield_recharge_time != 0)	
			{
				if (time - self.axe_power_time > 0.59 && time - self.axe_power_time < 0.62 && self.axe_power_time != 0 && self.axe_powered == 0) sprint(self, "shield depleted\n");
				if (time - self.axe_power_time > 0.59 && time - self.axe_power_time < 1.58 && self.axe_power_time != 0 && self.axe_powered == 0)sound (self, CHAN_WEAPON, "bloodrailz/misc/menu3.wav", 0.9, ATTN_NORM);
			}
		}
	

	
	//END. SHIELD TIMING LOGIC
}





/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





void() W_Fire_BR_Axe =
{
	local    vector    org;
	local float boostspeed = vlen(self.velocity);   //speed limit number

	local float AxLunge1 = 30;   //axe dash multiple
	local float AxLunge2 = 60;   //axe dash multiple
	local float AxLunge3 = 90;   //axe dash multiple

	makevectors (self.v_angle);          
        
        self.speedlines_are_on = 0; 
                               
	if(self.skiing_on !=1 && self.skiing_on !=2)	//MARCH
	{
		if (boostspeed < 500) 
		{
			if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge3;      //AXE DASH  
			else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge3*0.75); 
		}                            
		else if (boostspeed > 500 && boostspeed < 700) 
		{
			if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge2;      //AXE DASH  
			else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge2*0.75); 
		}
		else if (boostspeed >= 700 || boostspeed < 1000) 
		{
			if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*AxLunge1;      //AXE DASH  
			else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-AxLunge1*0.75); 
		} 
	}
		
	
antilag_rewind_all(self.responsetime, world);   //MARCH

	
	local vector source = self.origin + '0 0 16';
	local vector splash_center = source + v_forward*30;
	local float damage2=403;

	areaKDR(self, source, self, 55, 403, self);    //Splash damage only applying to players with KDR>2.4  // reduced from 80 to 55   9-24-23
	PlasmaPusher(self, splash_center, self, 60, 403, self); // 55->60 trying to make plasma deflection a bit easier

antilag_restore_all();  // AXE ANTILAG restore Anti-lag MARCH

	if(!(elohim_playmode & RACE_MODE)) 
	{
		if(boostspeed > 1275) sound (self, CHAN_AUTO, "bloodrailz/items/br_damage3.wav",0.3,ATTN_NORM);  //sound quad noise when moving over a certain speed
	}
   
   
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0) return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1; //no spawnblood, no traceline axe damage because that deals double damage against armor   5/23/22
	}
	else
	{    // hit wall
		if(time - self.axe_time < 0.42) return;    //make sure, the axe clinks only once per hit
		sound (self, CHAN_AUTO, "bloodrailz/weapons/br_clink.wav",1,ATTN_NORM);
		
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
    
};





void() update_spawnprotect =
{
	makevectors(self.owner.owner.v_angle);
	setorigin(self, (self.owner.origin + v_up * 5)  );
    
	
	
	if(self.alpha <= 0.02 || self.owner.deadflag != DEAD_NO)
	{
		self.think = SUB_Remove; 
	}
	else self.alpha = self.alpha - 0.02;
	
    
	self.nextthink = time + 0.01;
}




void(entity targ) make_spawnprotect =
{
	local entity spawnprotect;
	spawnprotect = spawn();
	setmodel (spawnprotect, "progs/bloodrailz/ef_shields.mdl");
	
	setorigin(spawnprotect, targ.origin + '0 0 5');
	
	spawnprotect.movetype = MOVETYPE_NOCLIP;
	spawnprotect.solid = SOLID_NOT;
	spawnprotect.classname = "spawnprotect";
	setsize (spawnprotect, 0,0);
	spawnprotect.alpha = 0.7;     //.59 ->0.7
	spawnprotect.skin = 5;
	spawnprotect.owner = targ;
	spawnprotect.nextthink = time + 0.01;
	spawnprotect.think = update_spawnprotect;
}









/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




void() update_shield_EXTERNAL =
{

	makevectors(self.owner.owner.v_angle);
    
	setorigin(self, (self.owner.origin + v_up * 5)  );

	

	self.alpha = 0.4;
    
  
	if((time - self.owner.shield_time > (2.1+random()*0.5) || self.owner.deadflag != DEAD_NO) && !(self.owner.items & IT_INVULNERABILITY) )		//NOVEM
	{
		self.think = SUB_Remove;
		self.owner.shields_up = 0;
	}
	
	else if((time - self.owner.shield_time > (1.5+random()*0.5) || self.owner.deadflag != DEAD_NO) && !(self.owner.items & IT_INVULNERABILITY) && (self.owner.flag_carrier))
	{
		self.think = SUB_Remove;
		self.owner.shields_up = 0;
	}
	
	else if((time - self.owner.shield_time > (5.2+random()) || self.owner.deadflag != DEAD_NO) && self.owner.items & IT_INVULNERABILITY )
	{
		self.think = SUB_Remove;
		self.owner.shields_up = 0;
		self.owner.items = self.owner.items - IT_INVULNERABILITY;
	}
	
	else if((time - self.owner.shield_time > 4.0 || self.owner.deadflag != DEAD_NO) && self.owner.items & IT_INVULNERABILITY && (self.owner.flag_carrier))
	{
		self.think = SUB_Remove;
		self.owner.shields_up = 0;
		self.owner.items = self.owner.items - IT_INVULNERABILITY;
	}
	
	
	
	if(self.owner.deadflag != DEAD_NO) self.owner.shield_recharge_time = 0;
	
	if(self.owner.health <= 0) self.alpha = 0.01;
    
	if (self.frame_count == 49) self.frame = self.frame + 1;
	if (self.frame >= 4) self.frame = 0;
	
	if(self.frame_count != 50) self.frame_count = self.frame_count + 1;
	if(self.frame_count >= 50) self.frame_count = 0;
	
	
	
		local entity head;
		local vector dir5;
		head = findradius(self.origin, 150);
		while (head)
		{
				if (head.classname == "plasma" || head.classname == "smoke")
				{
	
							dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
							dir5 = normalize(dir5);
							head.velocity = head.velocity + 240*dir5 + v_up*75;
							if(self.weapon == 29 || random() < 0.05) sound(self, CHAN_AUTO, "bloodrailz/weapons/quasar_push.wav", 1, ATTN_NORM);	
							self.weapon +=1;
							if(self.weapon ==30) self.weapon =0;
				}
				head = head.chain;
		}
	
	
	
	self.nextthink = time + 0.01;
}





/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




void() make_shield =
{
	

		// EXTERNAL SHIELD//
    
		local entity shield2;
		shield2 = spawn();
		setmodel (shield2, "progs/bloodrailz/ef_shields.mdl");
		shield2.skin = 0;
		if (self.height == elohim_team2) shield2.skin = 2;
    
		if (self.invincible_finished > time)
		{
			shield2.effects = EF_DIMLIGHT;
			self.items = self.items | IT_INVULNERABILITY;
		}
    
		setorigin(shield2, self.origin + '0 0 5');
		shield2.movetype = MOVETYPE_NOCLIP;
		shield2.solid = SOLID_NOT;
		shield2.classname = "shield2";
		setsize (shield2, 0,0);
		shield2.alpha = 0.01;
		shield2.owner = self;
		shield2.nextthink = time + 0.01;
		shield2.think = update_shield_EXTERNAL;
    
}






void() update_speedlines =
{
 
	self.weapon = self.weapon - 0.59;
	local float x = self.weapon;
 
	makevectors(self.owner.owner.v_angle);
	
	
	self.viewmodelforclient = self.owner;
	setorigin(self, '0 0 0' + v_forward*x);
  
	 if(self.alpha <= 0.05) self.owner.speedlines_are_visible = 0;
  
        if(self.alpha <= 0.005)
	{
		self.think = SUB_Remove; 
		
	}
	self.alpha = self.alpha - 0.001;
	
	self.nextthink = time + 0.01;
}




void() make_speedlines =
{
	local float rand = random();
	local vector v_ang;
	 v_ang = vectoangles (v_forward*(-1));   
	
	if(self.speedlines_are_on == 0 && self.speedlines_are_visible == 0 && rand < 0.8 && self.axe_button_released == 1 && (time - self.speedlines_time > 0.4) && (vlen(self.velocity) > 1075 || (self.jump_flag < -600 && self.jump_flag > -750 && v_ang_x > 40 && v_ang_x < 120)))
	{
		
		local entity speedlines;
		
		
		local float y = random();
		local float z = random();
		
		makevectors(self.v_angle);
		
		if(normalize(self.velocity) * v_forward<0.25) return;
		
		self.speedlines_time = time;   
		self.speedlines_are_on = 1;
		self.speedlines_are_visible =1;
		
		speedlines = spawn();
		

		
		setmodel (speedlines, "progs/bloodrailz/ef_speed.mdl");
		
		setorigin(speedlines, '0 y z');
		speedlines.movetype = MOVETYPE_NOCLIP;
		speedlines.solid = SOLID_NOT;
		speedlines.classname = "crown";
		speedlines.weapon = 0;
		setsize (speedlines, 0,0);
		speedlines.alpha = 0.07;
		
		if(random() < 0.25) speedlines.frame = 4;
		else if(random() < 0.5) speedlines.frame = 3;
		else if(random() < 0.75) speedlines.frame = 2;
		else if(random() <= 1) speedlines.frame = 1;
		

		speedlines.skin = 1;
		
		speedlines.owner = self;
		speedlines.nextthink = time + 0.01;
		speedlines.think = update_speedlines;
	}
}


void() auto_dash =
{
		makevectors(self.v_angle);
		
		if(!self.dash_button && self.impulse ==43) 
		{
			self.dash_button =1;
			self.dash_time = time;
		}
		if((self.dash_button && self.impulse ==44) || self.hook_out) 
		{
			self.dash_button =0;
		}
		
		
		if(self.dash_button)
		{
			if(time - self.dash_time > 0.19)
			{
				self.button0 = 0;
				stuffcmd(self,"-attack\n");
				
				if(time - self.dash_time > 0.27)	
				{
					self.dash_time = time;
					stuffcmd(self,"+attack\n");
					self.button0 = 1;
				}
			}
			
			
			
			if(self.movement_y != 700 && self.movement_y != -700)
			{
				local vector velz;
				velz=self.velocity;
				velz_z=0;
				local vector forz;
				forz=v_forward;
				forz_z=0;
				
				if(normalize(velz)*normalize(forz) < 0.75)
				{
					local float oldz = self.velocity_z;
					self.velocity = vlen(self.velocity)*normalize(self.velocity + v_forward*54);
					self.velocity_z =oldz;
					//bprint("dot product\n");
				}
				
				
				
				/*
				if(self.turn_speed >50 || self.turn_speed <-50)
				{
					self.velocity = vlen(self.velocity)* normalize(self.velocity + v_forward*100);
					bprint("adjust 50\n");
				}
				else if(self.turn_speed >40 || self.turn_speed <-40)
				{
					self.velocity = vlen(self.velocity)*normalize(self.velocity + v_forward*90);
					bprint("adjust 40\n");
				}
				else if(self.turn_speed >25 || self.turn_speed <-25)
				{
					self.velocity = vlen(self.velocity)*normalize(self.velocity + v_forward*80);
					bprint("adjust 25\n");
				}
				else if(self.turn_speed >15 || self.turn_speed <-15)
				{
					self.velocity = vlen(self.velocity)*normalize(self.velocity + v_forward*75);
					bprint("adjust 15\n");
				}
				else if(self.turn_speed >2 || self.turn_speed <-3)
				{
					self.velocity = vlen(self.velocity)*normalize(self.velocity + v_forward*70);
					bprint("adjust 2\n");
				}
				*/
			}	

		}
		else
		{
			
			return;
		}
}