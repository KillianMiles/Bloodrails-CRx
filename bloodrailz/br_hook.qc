

void(vector org, vector vel, float damage) SpawnBlood;
void () trigger_push_touch;




void() Plasma_Charge_Logic=
{
	//plasma pop TIMING LOGIC
		
		if (!(self.items2 & IT2_SIGIL1)) 
		{
			//bprint("no rune\n");
			if(!self.button0) self.hook_time2 =0;
			
			return; //DECEM no plasma withou rune
		}
		
		if (time - self.hook_time2 > 0.9 && time - self.hook_time2 <= 2.5 && self.button0 && self.hook_time2 != 0 && self.plasma_powered == 0)
		{
			self.plasma_powered =1;
			//bprint("charged!\n");
			//sound (self, CHAN_AUTO, "weap/br_lockon.wav", 0.8, ATTN_NORM);
			
		}
		else if(time - self.hook_time2 > 2.4 && self.hook_time2 != 0 && self.plasma_powered == 1)
		{
			self.plasma_powered =0;
			if(self.hook_is_anchored == 0) sound (self, CHAN_AUTO, "weap/br_slowdn.wav", 0.7, ATTN_NORM);
		}
		
		if(self.hook_is_anchored == 0)
		{
			if(time - self.hook_time2 > 1.3 && time - self.hook_time2 < 1.3 + my_ticrate) sound (self, CHAN_WEAPON, "weap/br_lockon.wav", 0.7, ATTN_NORM);
			else if(time - self.hook_time2 > 1.7 && time - self.hook_time2 < 1.7 + my_ticrate) sound (self, CHAN_WEAPON, "weap/br_lockon.wav", 0.59, ATTN_NORM);
		}
		
		if(self.weapon != IT_HOOK) self.plasma_powered =0;
		
}




void() update_plasma =
{	
	if(self.owner.plasma_powered ==1 && self.hook_is_anchored == 0)
	{
		if(time - self.owner.hook_time2 > 0.9 && time - self.owner.hook_time2 < 0.9 + 9*my_ticrate) 
		{
			//if(vlen(self.owner.origin-self.origin) > 1000)
			//{
				if(time - self.owner.hook_time2 < 0.9 + my_ticrate) sound (self, CHAN_AUTO, "weap/br_lockon.wav", 1, ATTN_NORM);
				//bprint("1000\n");
			//}
			if (self.owner.height == elohim_team1) self.skin = 1;   //red
			else if (self.owner.height == elohim_team2) self.skin = 4;   //blue
			else self.skin = 4;   //blue
		}
		else if(time - self.owner.hook_time2 > 1.3 && time - self.owner.hook_time2 < 1.3 + 9*my_ticrate) 
		{
			if(vlen(self.owner.origin-self.origin) > 800)
			{
				if(time - self.owner.hook_time2 < 0.9 + my_ticrate) sound (self, CHAN_AUTO, "weap/br_lockon.wav", 0.8, ATTN_NORM);
			}
			if (self.owner.height == elohim_team1) self.skin = 1;   //red
			else if (self.owner.height == elohim_team2) self.skin = 4;   //blue
			else self.skin = 4;   //blue
		}
		else if(time - self.owner.hook_time2 > 1.7 && time - self.owner.hook_time2 < 1.7 + 9*my_ticrate) 
		{
			if(vlen(self.owner.origin-self.origin) > 800)
			{
				if(time - self.owner.hook_time2 < 0.9 + my_ticrate) sound (self, CHAN_AUTO, "weap/br_lockon.wav", 0.7, ATTN_NORM);
			}
			if (self.owner.height == elohim_team1) self.skin = 1;   //red
			else if (self.owner.height == elohim_team2) self.skin = 4;   //blue
			else self.skin = 4;   //blue
		}
		else 
		{
			if (self.owner.height == elohim_team1) self.skin = 6;   //red
			else if (self.owner.height == elohim_team2) self.skin = 5;   //blue
			else self.skin = 5;   //blue
		}
	}
	
	if(self.owner.plasma_powered ==1 && !self.owner.button0) 
	{
		areaTHROW(self, self.origin, self, 400, 150, self);
		areaTHROW(self, self.origin, self, 200, 200, self);
		//areaDMG(self, self.origin, self.owner, 180, 485, self);    
		
		areaDMG(self, self.origin, self.owner, 125, 35, self);   
		areaDMG(self, self.origin, self.owner, 165, 35, self);   
		areaDMG(self, self.origin, self.owner, 205, 35, self);    
				
	
		make_impact('0 0 18', 0);
		if(vlen(self.owner.origin-self.origin) > 700) sound (self.owner, CHAN_WEAPON, "weap/br_explo.wav", 0.4, ATTN_NORM);
		
		self.owner.plasma_powered =0;
		self.hook_time2 =0;
		
		self.alpha =0.009;
		self.think = SUB_Remove;
	
	}
	
	
	//bprint(ftos(vlen(self.velocity)));
	if(vlen(self.velocity) > 251 && (self.velocity_x != 0 && self.velocity_y != 0)) self.punchangle = self.velocity;     //punchangle = old_velocity
	else if(vlen(self.velocity) <= 200) 
	{
		self.velocity = self.punchangle + v_up*250;  //punchangle = old_velocity
		self.avelocity = '50 -50 -125';
	}
	if((vlen(self.velocity) > 249 && vlen(self.velocity) < 251) || (self.velocity_x != 0 && self.velocity_y != 0)) 
	{
		self.velocity = self.punchangle;  //punchangle = old_velocity
		self.avelocity = '75 -75 -250';
	}
	
	if ( self.flags & FL_ONGROUND ) self.flags = self.flags - FL_ONGROUND;
	if(vlen(self.velocity) < 50) self.avelocity = '75 -75 -250';
	

		traceline(self.origin, self.origin + '0 0 -21', FALSE, self);
		if(trace_fraction < 1) 
		{
			setorigin(self, self.origin + '0 0 3' );
			self.velocity = self.punchangle;  //punchangle = old_velocity
		}
		
		if(trace_fraction == 1)
		{
			local vector start = self.origin + self.movement*(-18);     //movement = plasma_forward
			traceline(start, start + '0 0 -21', FALSE, self);
			if(trace_fraction < 1) 
			{
				setorigin(self, self.origin + '0 0 5' );
				self.velocity = self.punchangle;  //punchangle = old_velocity
			}
		}
	
	
	
	if(self.max_health ==1)            //max_health = plasma_is_pushed
	{
		self.speed = self.weaponframe;    //weaponframe = speed_plasma
		self.velocity = self.velocity_plasma;    //old_hook_vel = velocity_plasma
		self.max_health =0;       //max_health = plasma_is_pushed
	}
	
	if(time - self.plasma_time > 2.2) self.think = SUB_Remove;
	
	if(time - self.plasma_time < 2.1 && self.owner.hook_is_anchored == 0) 
	{
		self.alpha = self.alpha + 0.018;
		if(self.alpha >= 0.44 && self.skin == 6) self.alpha =0.44;
		else if(self.alpha >= 0.33 && self.skin == 5) self.alpha =0.33;
	}
	
	else if(time - self.plasma_time >= 2.1) 
	{
		self.alpha = self.alpha - 0.009;
		if(self.alpha <= 0.009) 
		{
			self.alpha =0.009;
			self.think = SUB_Remove;
		}
	}
	
	if(self.owner.hook_is_anchored == 1)
	{
		self.alpha = self.alpha - 0.015;
		self.plasma_time = self.plasma_time - 0.15;
		if(self.alpha <= 0.015) 
		{
			self.alpha =0.015;
			self.think = SUB_Remove;
		}
	}


	
	
	local entity head;
	local float radius = 40;
	
	
	if(self.owner.KDR >= 2.1 && self.owner.frags == top_score_global) // if score leader - reduced AOE radius
	{
		head = findradius(self.origin, radius*0.8);
		while (head)
		{
			if (head != self.owner)
			{

				if (head.takedamage)
				{				
					if (CanDamage (head, self))
					{	
						head.velocity = head.velocity + 900*normalize(self.velocity);  //9-17-23
						if(head.shields_up !=1) 
						{
							T_DamageOrg (head, self, self.owner, 485, self.origin);     //changed damage 485 -> 85 //9-17-23				
							if(head.armorvalue >0) head.armorvalue -= 45;
							if(head.armorvalue <=0) head.armorvalue =0;
						
						
							make_aura();
							sound(self, CHAN_AUTO, "item/br_zap.wav", 1, ATTN_NORM);
						
							if(time - self.plasma_time < 0.5) self.plasma_time = self.plasma_time - 1.3;
							else if(time - self.plasma_time < 0.7) self.plasma_time = self.plasma_time - 1.1;
							else if(time - self.plasma_time < 0.9) self.plasma_time = self.plasma_time - 0.9;
							else if(time - self.plasma_time < 1.1) self.plasma_time = self.plasma_time - 0.7;
							else if(time - self.plasma_time < 1.3) self.plasma_time = self.plasma_time - 0.5;
							else if(time - self.plasma_time < 1.5) self.plasma_time = self.plasma_time - 0.3;
							else if(time - self.plasma_time < 1.7) self.plasma_time = self.plasma_time - 0.1;
							self.velocity = (vlen(self.velocity) - 320) * normalize(self.velocity);
						
							
							self.think = SUB_Remove;   //9-17-23
						}
					}			
				}
			}
			head = head.chain;
		}
		
		self.nextthink = time + 0.01;
		return;
	}
	
	
		head = findradius(self.origin, radius*1.2);
		while (head)
		{
			if (head != self.owner && head.KDR > 2.5)
			{
				if (head.takedamage)
				{				
					if (CanDamage (head, self))
					{	
						T_DamageOrg (head, self, self.owner, 485, self.origin);     //changed damage value for armor damage logic
						make_aura();
						sound(self, CHAN_AUTO, "item/br_zap.wav", 1, ATTN_NORM);
						
						if(time - self.plasma_time < 0.5) self.plasma_time = self.plasma_time - 1.3;
						else if(time - self.plasma_time < 0.7) self.plasma_time = self.plasma_time - 1.1;
						else if(time - self.plasma_time < 0.9) self.plasma_time = self.plasma_time - 0.9;
						else if(time - self.plasma_time < 1.1) self.plasma_time = self.plasma_time - 0.7;
						else if(time - self.plasma_time < 1.3) self.plasma_time = self.plasma_time - 0.5;
						else if(time - self.plasma_time < 1.5) self.plasma_time = self.plasma_time - 0.3;
						else if(time - self.plasma_time < 1.7) self.plasma_time = self.plasma_time - 0.1;
						self.velocity = (vlen(self.velocity) - 320) * normalize(self.velocity);
						
						head.velocity = head.velocity + 900*normalize(self.velocity);
						self.think = SUB_Remove;   //9-17-23
					
					}			
				}
			}
			head = head.chain;
		}
		
		head = findradius(self.origin, radius);
		while (head)
		{
			if (head != self.owner && head != self && head.KDR <= 2.5)
			{
			
				if(head.classname == "plasma")
				{
					
					
					if(vlen(head.velocity) == 0)
					{
						makevectors (self.owner.v_angle);
						setorigin(head, head.origin + '0 0 5' );
						head.velocity = head.velocity + v_up*250;
					}
					
					//if(!head.speed) head.speed = 1000;
					
					local vector dir5 = head.origin - (self.absmin + self.absmax) * 0.5;                  //Bouncing balls bounce
					dir5 = normalize(dir5);
					
					if((time - head.bounce_time > 0.3 && time - self.bounce_time > 0.3) || head.bounce_time == 0)
					{
						if(head.pushed_plasma == 1) 
						{
							head.velocity = 300*dir5;
							//head.pushed_plasma =0;
						}
						else if(head.pushed_plasma == 0) head.velocity = 1000*dir5;
					
						head.bounce_time = time;
						self.bounce_time = time;
						
					sound (self, CHAN_AUTO, "weap/br_plasm3.wav", 0.7, ATTN_NORM);	
					sound (self, CHAN_AUTO, "weap/br_plasm1.wav", 0.7, ATTN_NORM);
					
					
					}
					
					//if(vlen(head.velocity) ==0) 	
					//{
					//	if ( head.flags & FL_ONGROUND ) head.flags = head.flags - FL_ONGROUND;
					//	head.velocity = 1000*dir5 + '0 0 100';
					//	
					//}
					
				}

			
			
			
				if (head.takedamage)
				{				
					if (CanDamage (head, self))
					{	
						T_DamageOrg (head, self, self.owner, 485, self.origin);    //changed damage value for armor damage logic
						make_aura();
						sound(self, CHAN_AUTO, "item/br_zap.wav", 1, ATTN_NORM);						
						if(time - self.plasma_time < 0.5) self.plasma_time = self.plasma_time - 1.3;
						else if(time - self.plasma_time < 0.7) self.plasma_time = self.plasma_time - 1.1;
						else if(time - self.plasma_time < 0.9) self.plasma_time = self.plasma_time - 0.9;
						else if(time - self.plasma_time < 1.1) self.plasma_time = self.plasma_time - 0.7;
						else if(time - self.plasma_time < 1.3) self.plasma_time = self.plasma_time - 0.5;
						else if(time - self.plasma_time < 1.5) self.plasma_time = self.plasma_time - 0.3;
						else if(time - self.plasma_time < 1.7) self.plasma_time = self.plasma_time - 0.1;
						self.velocity = (vlen(self.velocity) - 320) * normalize(self.velocity);
						
						
						head.velocity = head.velocity + 900*normalize(self.velocity);
						self.think = SUB_Remove;   //9-17-23
					}			
				}
			}
			head = head.chain;
		}
		




self.nextthink = time + 0.01;
}



void(float speed1, float f_offset) make_plasma =
{
 	local entity plasma;
 	local vector src;
       
		self.pushed_plasma = 0;
		local vector v_ang;
		v_ang = vectoangles (v_forward*(-1));   
		if (self.flags &FL_ONGROUND && v_ang_x > 75 && v_ang_x < 165) return;  
		
		
		sound(self, CHAN_AUTO, "weap/br_plasm1.wav", 1, ATTN_NORM);
		
       		plasma = spawn ();
       		plasma.plasma_time = time;
		plasma.classname  = "plasma";
        	plasma.owner = self;
       		plasma.movetype = MOVETYPE_FLY;
       		plasma.solid = SOLID_TRIGGER;
		

       		makevectors (self.v_angle);
		
		src = self.origin + (v_forward*f_offset) + v_up*16;
		
		setorigin(plasma, src);
		
		if (self.height == elohim_team1) plasma.skin = 6;   //red
		else if (self.height == elohim_team2) plasma.skin = 5;   //blue
		else plasma.skin = 5;   //blue
	
		
		if(speed1 == 1100) speed1 = 1000;
		
		plasma.velocity = speed1* v_forward;
		
        	plasma.avelocity = '0 0 -500';
		plasma.nextthink 	= time + 0.05;   
		plasma.think 		= update_plasma;
        	setmodel (plasma, "mdl/ef_aura1.mdl");
        	plasma.frame = 2;
        	plasma.alpha = 0.001;
        	
        	plasma.movement = v_forward;      //movement = plasma_forward
        	
		setsize (plasma, '-10 -10 -10', '10 10 10');  //13->8   
		sound (self, CHAN_WEAPON, "weap/br_plasm1.wav", 1, ATTN_NORM);
}



void() update_hookx =
{
	self.viewmodelforclient = self.owner;
	self.alpha = 0.7;
	setorigin(self, '3 0 0.22');
	
	makevectors(self.owner.owner.v_angle);
	
	
	if((self.owner.airborn_pos >= 400 && self.owner.crossanim !=2) || (self.owner.x_dist > 0 && self.owner.crossanim == 1))
	{
		self.owner.crossanim =1;
		self.owner.x_dist = self.owner.x_dist+1;
		local float offset = self.owner.x_dist;
	
		
		if(self.owner.x_dist >= 33) 
		{
			offset = 33;
			if(self.owner.x_dist >= 63) 
			{
				self.owner.crossanim = 0;
				self.owner.x_dist = 33;
			}
		
		}
		setorigin(self, '3 0.07 0.22' + v_forward*(offset));
		self.skin =0;
	}
	
	
	else if((self.owner.crossanim != 1 && self.owner.airborn_pos < 400) || self.owner.crossanim ==2)
	{
		self.owner.crossanim =2;
		self.owner.x_dist = self.owner.x_dist-1;
		offset = self.owner.x_dist;
		if(self.owner.x_dist <= 0) 
		{
			offset = 0;
			if(self.owner.x_dist <= -30) 
			{
				self.owner.crossanim = 0;
				self.owner.x_dist = 0;
			}
		}
		setorigin(self, '3 0 0.22' +v_forward*(-offset));
		
		if (self.owner.height == elohim_team1) self.skin = 6;   //red
		else if (self.owner.height == elohim_team2) self.skin = 4;   //blue
		else self.skin = 4;   //blue
	}
	
	

	if(self.owner.weapon & IT_HOOK && self.owner.hanim ==1)
	{
		self.weapon = self.weapon + 1;
		if(self.weapon%7 == 0) self.frame = self.frame -1;
		if(self.weapon >=50 || self.frame <=5)
		{
			self.frame = 7;
			self.owner.hanim = 0;
			self.weapon =0;
		}
	}
	
	
    
    
	if(!((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.player_flag & PF_ITEM_RUNE1_FLAG)))
	{
		self.think = SUB_Remove;
		self.owner.hookx = 0;
	}

	if (self.owner.deadflag != DEAD_NO) 
	{
		self.think = SUB_Remove;
		self.owner.hookx = 0;
	}
    
	self.nextthink = time + my_ticrate;
}




void() make_hookx =
{
	if((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) && self.hookx == 0) // && !(self.weapon & IT_HOOK))//) //&& self.weapon & IT_HOOK)
	{
		self.x_dist =0;
		self.hookx =1;
		local entity hookx;
		hookx = spawn();
		setmodel (hookx, "mdl/hookx.mdl");
		hookx.movetype = MOVETYPE_NOCLIP;
		hookx.solid = SOLID_NOT;
		hookx.classname = "hookx";
		hookx.weapon = 0;
		hookx.frame = 7;
		setsize (hookx, 0,0);
		hookx.alpha = 0.7;
		hookx.owner = self;
		hookx.nextthink = time + 0.01;
		hookx.think = update_hookx;
	}
}




void () LinkPos =
{
	local vector chainVector;
	local entity player  = self.enemy;
	
	local entity hook = self.enemy.hookhead;
	local vector firingOffset;
	local float pctAlongChain = self.up_count;
	
	local float chainLength = 38.5;

	makevectors (player.angles);

	firingOffset =  (v_forward * 0.3) + (v_up*12) - (v_right *12);

	

	
	local vector weaponTip = (player.origin + firingOffset);
	chainVector = hook.origin - weaponTip;  
	local vector chainNormal = normalize(chainVector);
	local vector chainModelOffset = chainNormal * chainLength;
	local vector chainStart =  weaponTip+chainModelOffset;
	
	
	chainVector =  hook.origin - chainStart;
	
	
	

	if(vlen(chainVector) >= 2550) chainVector = normalize(chainVector) * 2550;
	
	self.angles = vectoangles(chainVector);	
	

	
	setorigin(self, chainStart + chainVector * pctAlongChain );
	

	self.alpha = 0.65;
	
	
	//if (vlen(self.origin - hook.origin) <125) 
	if (vlen(self.origin - hook.origin) <150) 
	{
		
		setmodel (self, "mdl/null.mdl");
		self.alpha = 0.005;
	}
	
	else 
	{
		//bprint("******  ");
		setmodel (self, "mdl/br_chain.mdl");
		//chainVector = chainVector - normalize(chainVector)* 240;
		/*
		if(self.up_count == 0/7) self.alpha =0.65;
		else if(self.up_count == 1/7) self.alpha =0.65;
		else if(self.up_count == 2/7) self.alpha =0.65;
		else if(self.up_count == 3/7) self.alpha =0.55;
		else if(self.up_count == 4/7) self.alpha =0.45;
		else if(self.up_count == 5/7) self.alpha =0.40;
		else if(self.up_count == 6/7) self.alpha =0.35;
		else if(self.up_count == 7/7) self.alpha =0.65;
		*/
		
		self.alpha = 0.65;
	}
	
	
	if (vlen(player.origin - hook.origin) >1200) 
	{
		//bprint("chain2  ");
		
		chainVector = chainVector - normalize(chainVector)* 240;
		setorigin(self, chainStart + chainVector * pctAlongChain );
		setmodel (self, "mdl/br_chain2.mdl");
		self.alpha = 0.65;
	}
	
	if ((self.enemy.player_flag & PF_ITEM_RUNE_MASK) && (self.enemy.player_flag & PF_ITEM_RUNE1_FLAG) && self.enemy.hook_is_anchored == 0)
	{
			self.alpha = 0.005;
	}
	
	//self.nextthink = time + 0.01;   //HOOK_THINK_
	self.nextthink = time + 0.01;   //NOVEM
	
};






void() HookJump =
{
	local vector start, end, straight_forward, straight_up; 
	local float old_start, dist, Dist2;
	local vector v_ang;

	makevectors(self.v_angle);
	 
	
	start 	= self.origin;
	end 	= start;
	end_z 	= self.origin_z - 2048;
	
	traceline (start, end, TRUE, self);		
	
	dist = (self.absmin_z - trace_endpos_z);
	Dist2 = self.pre_vanish_dist;

	v_ang = vectoangles (v_forward*(-1));
	//if ((v_ang_x > 65 && v_ang_x <= 90) || vlen(self.velocity) > 200) 
	if (vlen(self.velocity) > 300) // check that you came to a stop
		{
			//sprint(self, "speed check \n");
			return;	
		}
		
	//sprint(self, ftos(Dist2));	

	
	makevectors (self.angles); 
	
	straight_up = v_up;
	straight_up_x = 0;
	straight_up_y = 0;
	straight_up = normalize(straight_up);
	
	end = self.origin + straight_up*(125) + v_forward*(16);             //check there is room above
	traceline (start, end, TRUE, self);

		if (trace_fraction < 1)
		{
			//sprint(self, "top check \n");
			return;
		}

	
	
	if (dist < 1) dist = 0;
	if (dist > 50)
	{
	      
	start = self.origin;
	old_start = start_z;
	 
	v_forward_z = 0;
	normalize(v_forward);
	
	start_z = old_start + 33;
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);

		if (trace_fraction < 1 || (Dist2 > 33 && Dist2 < 70))
		{
			self.velocity_z = 440;
			return;
		}
		
	start_z = old_start + 24; 
	//end = start + v_forward*55;
	traceline (start, end, TRUE, self);
		

		if (trace_fraction < 1 || (Dist2 > 33 && Dist2 < 70))
		{
			self.velocity_z = 440;
			return;
		}
		
	start_z = old_start + 16; 
	//end = start + v_forward*55;
	traceline (start, end, TRUE, self);

		if (trace_fraction < 1 || (Dist2 > 33 && Dist2 < 70))
		{
			self.velocity_z = 400;
			return;
		}
		
		start_z = old_start + 8; 
	//end = start + v_forward*55;
	traceline (start, end, TRUE, self);

		if (trace_fraction < 1 || (Dist2 > 33 && Dist2 < 70))
		{
			self.velocity_z = 330;
			return;
		}
		
		start_z = old_start + 0; 
	//end = start + v_forward*55;
	traceline (start, end, TRUE, self);

		if (trace_fraction < 1 || (Dist2 > 33 && Dist2 < 70))
		{
			self.velocity_z = 330;
			return;
		}
		
		start_z = old_start - 8; 
	//end = start + v_forward*55;
	traceline (start, end, TRUE, self);

		if (trace_fraction < 1 || (Dist2 > 33 && Dist2 < 70))
		{
			self.velocity_z = 330;
			return;
		}
		
		start_z = old_start - 16; 
	//end = start + v_forward*55;
	traceline (start, end, TRUE, self);

		if (trace_fraction < 1 || (Dist2 > 33 && Dist2 < 70))
		{
			self.velocity_z = 330;
			return;
		}
	}
		
	start = self.origin;	
	start_z = self.absmax_z;                                     // check that there is visibility ahead
	straight_forward = v_forward;
	straight_forward_z = 0;
	straight_forward = normalize(straight_forward);
	end = start + straight_forward*(40);
	traceline (start, end, TRUE, self);
	if (trace_fraction == 1 && dist > 12)
		{
		//sprint(self, "front check clear \n");
			//end = start + straight_forward*(30)+ straight_up*(-55);
			start = start + straight_forward*(24);
			end = start + straight_up*(-55);
			traceline (start, end, TRUE, self);              // check if that there is obstacle ahead
			if (trace_fraction < 1)
			{
			//sprint(self, "front check obstacle \n");
			self.velocity_z = 320;
			return;
			}
		}
		
		
	
		
		
}


void () HookVanish =
{
        self.owner.hook_out = FALSE;
        local entity old_self;
        old_self=self.owner;
        self.owner.pre_vanish_dist = vlen(self.owner.origin - self.origin);

		
		
		
		
		do
		{
			if ((self.classname == "hook_chain_link") || (self.classname == "hook_entity"))//sanity check
			{
				remove(self);
			}
			self = self.goalentity;
		} while (self);
		self = old_self;
		HookJump();
		
		

		
		
		self.tarzan_time = 0;
		self.bounce_switch = 0;
		self.bounce_yes = 0;
		
		self.stored_frame2 = 0;
		self.stored_z1 =0;
		self.stored_z2 =0;
		self.stored_z3 =0;
		self.stored_z4 =0;
		self.stored_z5 =0;
		self.stored_z6 =0;
		
		self.up_count = 0;
		self.down_count = 0;
		self.spring_chain_on = 0;
		self.hook_swing_ground = 0;
		
		self.hook_lookaway = 0;
		self.hook_is_anchored = 0;
		
		if(self.chain_too_short ==1) self.chain_too_short=0;
		
		
		self.hookhead = 0;		
		
		stuffcmd(self, "cl_bob 0.0032\n");
		stuffcmd(self, "cl_bobcycle 2.5\n");
};





void() UnHookPlayer =
{
	local entity oself;
	

	if (self.hook_out) 
	{
		oself = self;
		self = self.goalentity;
		HookVanish();
		self = oself;	
		
	}
		
		
		
		
	
};

void () HookPull =
{
	local vector vel;
	local float v, a, b, c;
	
	local vector start, end, dist; 
	local float old_start;
	local float old_trace_fraction;
	
	


	if (elohim_state & ELOHIM_MATCH_PAUSED)
	{
		return;
	}
	
	if (self.owner.fly_sound > (time + 1.4)) 
	{
		HookVanish();
		return;
	}

	if ((!self.owner.button0 && !self.owner.button2 && (self.owner.deadflag == DEAD_NO))) //let go hook when firing on hook, but keep swinging if you fire but still hold jump
	{
		HookVanish();
		return;
	} 
	
	
	if((self.owner.teleport_time > time ) || self.owner.deadflag || (gameover))
	{
		HookVanish();
		return;
	} 
	
	if(vlen(self.owner.origin-self.origin) < 75 && self.owner.button2 && self.owner.chain_too_short==0)   //hook dash slingshot
	{

		
		
		if(self.owner.airborn_pos < 50) self.owner.velocity = self.owner.velocity + normalize(self.owner.velocity)*375 + '0 0 240';
		else if(self.owner.airborn_pos >= 50) self.owner.velocity = self.owner.velocity + normalize(self.owner.velocity)*375 + '0 0 175';
		
		if(vlen(self.owner.velocity) > 1050) self.owner.velocity = normalize(self.owner.velocity)*(1025+random()*150);
		
		
		
		HookVanish();
		return;
	} 
	
	
	if ((self.owner.weapon == IT_HOOK && !self.owner.button0 && self.owner.button2 && (self.owner.deadflag == DEAD_NO)) ||     //HOOK RELEASE FOR SWING MODE LAUNCH TO DO
	(self.owner.teleport_time > time ) || self.owner.deadflag || (gameover)) {
		HookVanish();   //at this point it prints that impulse =0
		return;
	} 
	
	
	
	else 
	{
		if (self.style & ELOHIM_OBSERVER)
		{
			HookVanish();
			return;
		}
		
		if (self.enemy.solid == SOLID_NOT) 
		{
			HookVanish();
			return;
		}

		if (self.enemy.takedamage) 
		{
			// don't hurt teammates
			if (!teamplay || self.enemy.team != self.owner.team) 
			{

				// 4.1, if we can't see our enemy, unlock
				if (!CanDamage(self.enemy, self.owner)) 
				{
					HookVanish();
					return;
				}

				self.enemy.deathtype = "hook";

				//R00k: tear-away hook if the chain is pulled too hard...
				a = vlen (self.enemy.velocity);
				b = vlen (self.owner.velocity);
				c = (a - b);
				
				if (c > 1150)
				{
					sound (self, CHAN_WEAPON, SOUND_HOOK_TEAR, 1, ATTN_NORM);
					
					T_DamageOrg (self.enemy, self, self.owner, 20.2, self.owner.origin);
					HookVanish();
					return;
				}	

				self.hookdmg = (self.hookdmg + (my_ticrate/0.1));

				if (self.hookdmg >= 1)
				{
					sound (self, CHAN_WEAPON, SOUND_HOOK_LAND, 1, ATTN_NORM);

					T_DamageOrg (self.enemy, self, self.owner, 18, self.owner.origin);       //hook drag damage  40 -> 12
					

					if (self.enemy.classname == "player")
					{
						SpawnBlood (self.origin, self.velocity, 10);
					}
					
					
					
					self.hookdmg = 0.00;
				}
				makevectors (self.v_angle);
			}

			

			if (self.enemy.classname == "player")
			{			
				setorigin(self, self.enemy.origin + self.enemy.mins + (self.enemy.size * 0.5));
			}
			
			else
			{
				self.velocity = self.enemy.velocity;
			}


		} 
		else  self.velocity = self.enemy.velocity;

		
		makevectors (self.owner.v_angle);
		//local vector vel_store;
		
		vel = self.origin - ( self.owner.origin + (v_up * 16) + (v_forward * 16));
		v = vlen (vel);

		if (self.owner.tarzan_time == 1 && !self.owner.button2)    // Let go of JUMP while swinging and the hook lets go -- hook swing
		{
			self.owner.tarzan_time = 0;
			HookVanish();
			return;
		}
		

		
		if(normalize(vel) * v_forward < -0.25) self.owner.hook_lookaway = 1;
		if(normalize(vel) * v_forward >= -0.25) self.owner.hook_lookaway = 0;
		
		
		if(!(self.owner.flags & FL_ONGROUND))  self.owner.hook_swing_ground = 0;
		
		
		if ((self.owner.button2 && self.owner.airborn_pos > 45) || self.owner.tarzan_time == 1)
		{
			if(self.owner.tarzan_time == 0) self.owner.vel_before_swing = vlen(self.owner.velocity);
			
			
			if(self.owner.turn_speed > 10)
			{
				stuffcmd(self.owner, "cl_screenangle_speed 3\n");
				stuffcmd(self.owner, "cl_screenangle -6\n");
			}
			else if(self.owner.turn_speed > 5)
			{
				stuffcmd(self.owner, "cl_screenangle_speed 3\n");
				stuffcmd(self.owner, "cl_screenangle -3\n");
			}
			//////////////////////////////////////////////////////////////
			else if(self.owner.turn_speed < -10)
			{
				stuffcmd(self.owner, "cl_screenangle_speed 3\n");
				stuffcmd(self.owner, "cl_screenangle 6\n");
			}
			else if(self.owner.turn_speed < -5)
			{
				stuffcmd(self.owner, "cl_screenangle_speed 3\n");
				stuffcmd(self.owner, "cl_screenangle 3.0\n");
			}
			else
			{
				stuffcmd(self.owner, "cl_screenangle_speed 2.25\n");
				stuffcmd(self.owner, "cl_screenangle 0\n");
			}
			
			
			
			
			//bprint(ftos(self.owner.vel_before_swing));
			//bprint("   ");

			
			if (self.owner.airborn_pos > 220 || self.owner.is_over_sky ==1) //added the over sky part
			{	
				
				if(self.owner.vel_before_swing < 1200)
				{
					self.owner.velocity = self.owner.velocity + v_forward*24 + (normalize(vel)*22);
					if (vlen(self.owner.velocity) >= 1200) self.owner.velocity = normalize(self.owner.velocity)*(1200+ random()* 30);
				}
				else
				{
					self.owner.velocity = self.owner.velocity + v_forward*24 + (normalize(vel)*22);
					
					if (vlen(self.owner.velocity) >= 1545) self.owner.velocity = normalize(self.owner.velocity)*(1545+ random()*50);
					else if (vlen(self.owner.velocity) >= self.owner.vel_before_swing) self.owner.velocity = normalize(self.owner.velocity)*self.owner.vel_before_swing;	
				}
			}
			if (self.owner.airborn_pos <= 220 && self.owner.is_over_sky ==0)
			{
				self.owner.velocity = self.owner.velocity + v_forward*24 + (normalize(vel)*22) + v_up*(-7);  //NOVEM -9 -> -7
				
				if(self.owner.vel_before_swing < 950)
				{
					if (vlen(self.owner.velocity) > 950) self.owner.velocity = normalize(self.owner.velocity)*950;   //NOVEM 850 -> 950
				}
				else 
				{
					if (vlen(self.owner.velocity) > self.owner.vel_before_swing) self.owner.velocity = normalize(self.owner.velocity)*self.owner.vel_before_swing;   //NOVEM 850 -> 950
				}
			}
			
			
			local vector v_ang = vectoangles (v_forward*(-1));
			if(self.owner.airborn_pos <= 1000 && self.owner.is_over_sky ==1)  // &&v_forward_z > 0.2 && v_ang_x > 10 && v_ang_x < 120)  
			{
				self.owner.velocity = self.owner.velocity + '0 0 5';
			}
		
			self.dest = self.owner.origin;
			self.nextthink = time + 0.01;    //HOOK_THINK_
	
			self.owner.tarzan_time = 1;
		
		
			if(self.owner.flags & FL_ONGROUND && self.owner.hook_swing_ground < 11)          //change 8->11
			{
				self.owner.hook_swing_ground = self.owner.hook_swing_ground + 1;
				//sprint(self.owner, ftos(self.owner.hook_swing_ground));
			
				if (self.owner.hook_swing_ground == 9)                        //change 5->9
				{
					//sprint(self.owner, "unhook\n");
					self.owner.hook_swing_ground = 0;
					HookVanish();
					return;
				}
			}
		
			return;
		}
		
		

	start = self.owner.origin;
	old_start = start_z;
	
	local vector zfor = v_forward;
	zfor_z = 0;
	normalize(zfor);
	
	start_z = self.owner.absmin_z;
	end = start + zfor*59;
	traceline (start, end, TRUE, self.owner);
	
	dist = (self.owner.origin - self.origin);

	old_trace_fraction = trace_fraction;
	

							
							
							
	
		if (trace_fraction < 1)
		{
			start_z = self.owner.absmin_z + 2.0;
			end = start + zfor*59;
			traceline (start, end, TRUE, self.owner);
			//sprint(self.owner, ftos(vlen(dist)));
			//sprint(self.owner, "\n");
			//sprint(self.owner, ftos(self.owner.bounce_switch));
			//sprint(self.owner, " bounce-switch\n");
			
				if(vlen(dist) > 80 && old_trace_fraction == trace_fraction)
				{
					if (!(self.owner.flags & FL_ONGROUND) &&  self.owner.origin_z - self.origin_z < 75 && self.owner.bounce_switch == 0)              // don't hook bounce if ON GROUND / ONGROUND
					{
							
							
							
							//if(self.owner.origin_z-self.origin_z < 24)
							//{
								//bprint("hook bounce yes\n");
								self.owner.velocity_z = self.owner.velocity_z + 200;
								if (self.owner.velocity_z >= 300) self.owner.velocity_z = 330;
							//}
						
							if(vlen(self.owner.velocity) > 1050) self.owner.velocity = 1050*normalize(self.owner.velocity);  //hook dash
						
							self.owner.bounce_yes = 1;
						

							if(self.owner.stored_frame2 == 0)                          //make sure we dont bob up and down
							{
								self.owner.stored_z1 = self.owner.origin_z;
								self.owner.stored_z2 = self.owner.origin_z;
								self.owner.stored_z3 = self.owner.origin_z;
								self.owner.stored_z4 = self.owner.origin_z;
								self.owner.stored_z5 = self.owner.origin_z;
								self.owner.stored_z6 = self.owner.origin_z;

								self.owner.stored_frame2 = self.owner.stored_frame2 +1;
							}
							
							else if(self.owner.stored_frame2 == 1)
								{
								self.owner.stored_z2 = self.owner.origin_z;
								if(self.owner.stored_z2 > self.owner.stored_z1)   self.owner.up_count = self.owner.up_count +1;
								if(self.owner.stored_z1 > self.owner.stored_z2)   self.owner.down_count = self.owner.down_count +1;
								self.owner.stored_frame2 = self.owner.stored_frame2 +1;
								}
							else if(self.owner.stored_frame2 == 2)
								{
								self.owner.stored_z3 = self.owner.origin_z;
								if(self.owner.stored_z3 > self.owner.stored_z2)   self.owner.up_count = self.owner.up_count +1;
								if(self.owner.stored_z2 > self.owner.stored_z3)   self.owner.down_count = self.owner.down_count +1;
								self.owner.stored_frame2 = self.owner.stored_frame2 +1;
								}
							else if(self.owner.stored_frame2 == 3)
								{
								self.owner.stored_z4 = self.owner.origin_z;
								if(self.owner.stored_z4 > self.owner.stored_z3)   self.owner.up_count = self.owner.up_count +1;
								if(self.owner.stored_z3 > self.owner.stored_z4)   self.owner.down_count = self.owner.down_count +1;
								self.owner.stored_frame2 = self.owner.stored_frame2 +1;
								}
							else if(self.owner.stored_frame2 == 4)
								{
								self.owner.stored_z5 = self.owner.origin_z;
								if(self.owner.stored_z5 > self.owner.stored_z4)   self.owner.up_count = self.owner.up_count +1;
								if(self.owner.stored_z4 > self.owner.stored_z5)   self.owner.down_count = self.owner.down_count +1;
								self.owner.stored_frame2 = self.owner.stored_frame2 +1;
								}
					
							else if(self.owner.stored_frame2 == 5)
								{
								self.owner.stored_z6 = self.owner.origin_z;
								if(self.owner.stored_z6 > self.owner.stored_z5)   self.owner.up_count = self.owner.up_count +1;
								if(self.owner.stored_z5 > self.owner.stored_z6)   self.owner.down_count = self.owner.down_count +1;
								self.owner.stored_frame2 = 0;
								}
								
								self.owner.bounce_switch = 0;
								//if ((self.owner.up_count >1 && self.owner.down_count ==1) || (self.owner.up_count ==1 && self.owner.down_count >1)) self.owner.bounce_switch = 1;
								if (self.owner.up_count >0 && self.owner.down_count >0) self.owner.bounce_switch = 1;
						
						
						self.dest = self.owner.origin;
						
						self.nextthink = time + 0.01;  //HOOK_THINK_
						
							//sprint(self.owner, "hook bounce\n");
							//sprint(self.owner, ftos(self.owner.bounce_switch));
							//sprint(self.owner, "\n");
		
						return;
					}
				}
				
				
		}
		

 

		
		if(normalize(self.owner.velocity) * normalize(vel) < -0.25 && self.owner.bounce_yes == 0)             // stretchy chain elastic 
		{
			if (self.owner.spring_chain_on == 0) 
			{
				self.owner.old_hook_vel = self.owner.velocity;
				self.owner.spring_chain_on =1;
			}
			
			//if(v < 100) self.owner.spring_chain_on =0;
					
					
			//sprint(self.owner, ftos(vlen(self.owner.velocity)));
			//sprint(self.owner, " \n");
			self.owner.velocity = self.owner.old_hook_vel + v_forward*1 + v_up*(11) + (normalize(vel)*27);  //10-11, changed 27 to 22
					
			self.owner.old_hook_vel = self.owner.velocity;
			//sprint(self.owner, ftos(vlen(self.owner.old_hook_vel)));
			//sprint(self.owner, " opp \n");
						
					
		}
		else 
		{	
			if (hookspeedpull < 600) hookspeedpull = 850;   
			
			if(vlen(self.owner.origin-self.origin) < 500) hookspeedpull = 1100;
			else if(vlen(self.owner.origin-self.origin) < 625) hookspeedpull = 1025;      //Hook dash -- accelerates linear hook as you get closer to attachment point
			else if(vlen(self.owner.origin-self.origin) < 750) hookspeedpull = 950;
			else hookspeedpull = 850;
			
			
			if (v <= 100) self.owner.velocity = normalize(vel) * v * 10;  
			else if ( v > 100) self.owner.velocity = normalize(vel) * hookspeedpull;
			
			
			//  attempt to straighten the pull
			/*
			local vector straight_vel;
			straight_vel = vel;
			
			local vector vel_vert = normalize(vel);
			bprint (ftos(vel_vert_z));
			bprint(" \n");
			
			straight_vel_z=0;
			straight_vel = normalize(straight_vel);
			if(v < 200 && self.owner.origin_z-self.origin_z < 90 && vel_vert_z > -0.55)
			{
				self.owner.velocity = straight_vel * hookspeedpull;
			}
			*/
			
			
			//bprint(ftos(self.owner.origin_z-self.origin_z));
			//bprint("\n");
			
			vel = normalize(vel);
			//bprint(ftos(vlen(self.owner.velocity)));
			//bprint(" ");
			
			if(v > 42)			//This makes you hook faster when looking down. 
			{				//first checking if we are super close to hook head, so it doesnt twitch when looking down
				if(vel_z < -0.22)	
				{
					self.owner.velocity = self.owner.velocity + '0 0 -130';
				}
			
				if(vel_z > -1 && vel_z < -0.45) 
				{
					self.owner.velocity = self.owner.velocity + '0 0 -55';
				}
				if(vel_z > -1 && vel_z < -0.55) 
				{
					self.owner.velocity = self.owner.velocity + '0 0 -10';
				}
				if(vel_z > -1 && vel_z < -0.70) 
				{
					self.owner.velocity = self.owner.velocity + '0 0 -10';
				}
			}
	
			self.owner.spring_chain_on = 0;
		}

		if (self.owner.flags & FL_INWATER) //Slow down the hook pull if underwater!!
		{
			self.owner.velocity = ((1 - ((0.8 * self.owner.waterlevel) * frametime)) * self.owner.velocity);
		}
	
	

		self.dest = self.owner.origin;
		self.nextthink = time + 0.01;   //HOOK_THINK_
	}
};


void() T_ChainTouch =
{
	if (elohim_state & ELOHIM_MATCH_PAUSED) return;

	if (other == self.owner) return;         // don't attach to owner

	if (pointcontents(self.origin) == CONTENT_SKY)            // || (gameover)) //dont hook the sky
	{
                 HookVanish();
                 return;
	}
	
	
	
	if (other.solid == SOLID_SLIDEBOX) other.axhitme = 1; // make axe noise


	if (other.takedamage) 
	{
		if ( self.owner.armorvalue < other.armorvalue )    //hook steals armor
		{
			//sprint(self.owner, "X");
			self.owner.items = self.owner.items | IT_ARMOR3;
			self.owner.armorvalue = other.armorvalue;
			self.owner.armortype = 80.001;
			other.armorvalue = 0;
		}
	
		T_DamageOrg (other, self, self.owner, 10, self.owner.origin );    //hook impact damage
		

		// don't damage teammates
		if (other.classname == "player")
			SpawnBlood (self.origin, self.velocity, 10);
		else
		{	//R00k: hook hits triggers, just show sparks
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
		}            
	} 
	
	else 
	{
		if (((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.player_flag & PF_ITEM_RUNE1_FLAG) && self.owner.airborn_pos < 400))    //added height check
		{
			//bprint("less than 500");
			HookVanish();
			return;
		}
		
		sound (self, CHAN_AUTO, "weap/br_clink.wav",1,ATTN_NORM);
		sound (self.owner, CHAN_AUTO, "weap/br_clink.wav",0.5,ATTN_NORM);
		
		self.owner.hook_is_anchored = 1;
		if (((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.player_flag & PF_ITEM_RUNE1_FLAG) ))
		{
			setmodel (self, "mdl/ef_aura1.mdl");
			self.frame = 2;
			
			if (self.owner.height == elohim_team1) 
			{
				self.skin = 6;   //red
				self.alpha = 0.44;
			}
			else if (self.owner.height == elohim_team2) 
			{
				self.skin = 5;   //blue
				self.alpha = 0.33;
			}
			else 
			{
				self.skin = 5; 
				self.alpha = 0.33;
			}
		}
		
		
		self.avelocity = '0 0 0';
	}
                
	if (!self.owner.button0) {
			self.nextthink = (time + my_ticrate);
			self.think = HookVanish;
			return;
	} else {
			if (other.solid == SOLID_SLIDEBOX) {
				setorigin (self, other.origin + other.mins + (other.size * 0.5));
				//self.velocity = '0 0 0';
				self.velocity = other.velocity;
			}
			else 
			{
				self.velocity = other.velocity;
			}
			self.weapon = other.nextthink - time;
			
			
			
			self.style = 3;
			self.enemy = other;
			
			if(vlen(self.origin-self.owner.origin) < 250) self.owner.chain_too_short =1;
			
			//bprint(ftos(self.owner.chain_too_short));
			//bprint("\n");
			
			self.owner.ltime = (time + 0.5);
			self.nextthink = time + 0.01;   //HOOK_THINK_
			
			self.think = HookPull;
			self.touch = SUB_Null;
	}
};

void() Hook_Check =
{
	//self.nodrawtoclient = self.owner; // dont draw in the player's view
	if ((!self.owner.button0 && self.owner.weapon == IT_HOOK) || (self.owner.deadflag) || (gameover))
	{
		HookVanish ();
		return;
	}
	
	if (!self.owner.button0 && !self.owner.button2)
	{
		HookVanish ();
		return;
	}
	
	if(vlen(self.origin - self.owner.origin) > 7800)
	{
		HookVanish ();
		return;
	}
	
	
	if (self)
	{
	
		makevectors (self.owner.v_angle);
		local vector dir_look = normalize(self.origin - self.owner.origin);
		
		
		if(dir_look * v_forward < -0.25) self.owner.hook_lookaway = 1;
		if(dir_look * v_forward >= -0.25) self.owner.hook_lookaway = 0;
		

		
		if(self.weapon == 1800)
		{
			if(time - self.owner.hook_time > 2) 
			{
				self.velocity = 4000*normalize(self.velocity);
				self.max_health = 4000;
				//sprint(self.owner, ftos(vlen(self.velocity)));
			}
			else if(time - self.owner.hook_time > 1.5) 
			{
				self.velocity = 3000*normalize(self.velocity);
				self.max_health = 3000;
				//sprint(self.owner, ftos(vlen(self.velocity)));
			}
		}
		
		else if(self.weapon == 2400)
		{
			if(time - self.owner.hook_time > 1.3) 
			{
				self.velocity = 3200*normalize(self.velocity);
				self.max_health = 3200;
				//sprint(self.owner, ftos(vlen(self.velocity)));
			}
			else if(time - self.owner.hook_time > 1.1) 
			{
				self.velocity = 2900*normalize(self.velocity);
				self.max_health = 2900;
				//sprint(self.owner, ftos(vlen(self.velocity)));
			}
		}
		
		
		
			//self.frame +=1;
			//if(self.frame == 6) self.frame = 0;
		
		
		self.nextthink = time + 0.01; // //HOOK_THINK_
		self.think = Hook_Check;
	}
};

void() W_FireChain =
{
		local entity hook;
        
		//T_Damage (self, world, world, 10000);    //for debug
		//remove(self);  //for debug
		
		stuffcmd(self, "cl_bob 0.00025\n");
        
		if(self.hanim == 0 && (self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG))    self.hanim = 1;
		if (self.player_flag & PF_ITEM_RUNE1_FLAG) self.hook_time2 = time; 
		
		makevectors (self.v_angle);
		traceline(self.origin + (v_forward*16) + '0 0 16', self.origin + (v_forward*400) + '0 0 16', 2, hook);
       
		if(!self.button0) return;
		if (self.hook_button_released == 1) return;
		self.hook_button_released = 1;
		if (elohim_state & ELOHIM_MATCH_PAUSED) return;
	
		if (!(self.player_flag & PF_ITEM_RUNE1_FLAG)) sound (self, CHAN_WEAPON, SOUND_HOOK_ATTACK, 1, ATTN_NORM);
	
		
		  // moved up above rune1/plasma switch to work with plasma bangs
		
		if (((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) && self.airborn_pos < 400))
		{
			if(trace_fraction < 0.005) return;
		}


		self.hook_time = time;


		self.hook_out = TRUE;
		hook = spawn ();
		hook.classname  = "hook_entity";
		hook.owner = self;
		self.goalentity = hook;
		hook.movetype = MOVETYPE_FLY;
		hook.solid = SOLID_BBOX;
		hook.alpha = 0.001;   //HOOK FIX
		self.hookhead = hook; //HOOK FIX
       

		traceline(self.origin + (v_forward*16) + '0 0 16', self.origin + (v_forward*400) + '0 0 16', 2, hook);
		

		if ((!(self.flags & FL_ONGROUND) && self.airborn_pos > 700) || (time - self.grind_time < 1))
		{
				hookspeedfire = 2400; 
		}
		else 	
		{
				if (((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) )) hookspeedfire = 1100;
				else hookspeedfire = 1800;
		}
			
		hook.weapon = hookspeedfire;
		
		
		
		if (((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) ))
		{
			local float plasma_speed = hookspeedfire;
			if(normalize(self.velocity) * v_forward>0.5 && vlen(self.velocity)> 1000 && hookspeedfire < 1800)  
			{
				plasma_speed = plasma_speed + (50+vlen(self.velocity) - 1000);
				//bprint(ftos(plasma_speed));
			}
			
			if(trace_fraction< 0.2) make_plasma(plasma_speed, -25);
			else make_plasma(plasma_speed, 0);
			hook.alpha = 0.001;
		}
		hook.velocity 	= hookspeedfire * aim (self, hookspeedfire);
			
		if (((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) && self.airborn_pos < 400))
		{
			local vector v_ang;
			v_ang = vectoangles (v_forward*(-1));   
			
		
			if(trace_fraction < 0.4) hook.velocity = (hookspeedfire/500) * aim (self, hookspeedfire);
			else if(trace_fraction < 1.0 ) hook.velocity = (hookspeedfire/300) * aim (self, hookspeedfire);
			else if(trace_fraction == 1.0 && self.airborn_pos < 300) hook.velocity = (hookspeedfire/300) * aim (self, hookspeedfire);
			//bprint(ftos(trace_fraction));
		}

		

        hook.angles = vectoangles(hook.velocity);
        hook.avelocity = '0 0 -500';
	
        hook.touch = T_ChainTouch;
	

	if (((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG) )) 
	{
		if(self.KDR >= 2.4 && self.frags == top_score_global) hook.nextthink 	= time + 0.59;   //0.5 -> 0.25//instead lets check if we let off the button in mid-flight! eh?
		else hook.nextthink 	= time + 0.59; 
	}
	else hook.nextthink 	= time + 0.25;
	
	hook.think 		= Hook_Check;

        setmodel(hook, MODEL_HOOK_HEAD);
	setsize (hook, '0 0 0', '0 0 0');     
	setorigin (hook, self.origin + (v_forward*16) + '0 0 16');
	
			//local vector hook_src = self.origin + (v_forward*16) + '0 0 16';   //MARCH
			//traceline(hook_src, hook_src + (v_forward*8000), 1, hook);
			//self.adjusted_hook_impact = trace_endpos;
			
			  antilag_rewind_all(self.responsetime, world);			//MARCH
			local vector hook_src = self.origin + (v_forward*16) + '0 0 16';
			traceline(hook_src, hook_src + (v_forward*8000), 1, hook);
			self.adjusted_hook_impact = trace_endpos;
			antilag_restore_all();  
			
			local vector trace_end_central = trace_endpos;
			local float sky_dist = vlen(trace_endpos-hook_src);
			
			if(sky_dist > 2300 && pointcontents(trace_endpos) == CONTENT_SKY && !(self.flags & FL_ONGROUND && (v_forward_z > -0.12 && v_forward_z < 0.04))) 
			{
				local float one_more = 1;
				
				traceline(hook_src, trace_end_central + v_up*50, 1, hook);
				if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80) && trace_fraction < 0.9)
				{
					//bprint(ftos(vlen(trace_endpos-hook_src)));
					//bprint(" 50 up\n");
					self.adjusted_hook_impact = trace_endpos;
					one_more =0;
				}
				if(one_more ==1)
				{	
					traceline(hook_src, trace_end_central + v_up*(-50), 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80) && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 50 down\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1) 
				{
					traceline(hook_src, trace_end_central + v_up*90, 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80)  && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 90 up\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1)
				{	
					traceline(hook_src, trace_end_central + v_up*(-90), 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80) && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 90 down\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1) 
				{
					traceline(hook_src, trace_end_central + v_right*50, 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80)  && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 50 right\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1)
				{	
					traceline(hook_src, trace_end_central + v_right*(-50), 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80) && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 50 left\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1) 
				{
					traceline(hook_src, trace_end_central + v_right*90, 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80)  && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 90 right\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1)
				{	
					traceline(hook_src, trace_end_central + v_right*(-90), 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80) && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 90 left\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
	
					}
				}
				if(one_more ==1) 
				{
					traceline(hook_src, trace_end_central + v_up*180, 1, hook);
					if((vlen(trace_endpos-hook_src) > 900 || self.airborn_pos > 80)  && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 180 up\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1)
				{	
					traceline(hook_src, trace_end_central + v_up*(-180), 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80) && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 180 down\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1)
				{
					traceline(hook_src, trace_end_central + v_right*(180), 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80)  && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 180 right\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				if(one_more ==1)
				{
					traceline(hook_src, trace_end_central + v_right*(-180), 1, hook);
					if((vlen(trace_endpos-hook_src) > 1200 || self.airborn_pos > 80)  && trace_fraction < 0.9)
					{
						//bprint(ftos(vlen(trace_endpos-hook_src)));
						//bprint(" 180 left\n");
						self.adjusted_hook_impact = trace_endpos;
						one_more =0;
					}
				}
				
				
				
				
				
				if((sky_dist > 2000) && self.airborn_pos > 500 && v_forward_z > 0.18)  //9-17-23
				{
					if(one_more ==1) 
					{
						traceline(hook_src, trace_end_central + v_up*180, 1, hook);
						if(vlen(trace_endpos-hook_src) > 700  && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 180 up\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
					if(one_more ==1)
					{	
						traceline(hook_src, trace_end_central + v_up*(-180), 1, hook);
						if(vlen(trace_endpos-hook_src) > 700 && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 180 down\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
					if(one_more ==1)
					{
						traceline(hook_src, trace_end_central + v_right*(180), 1, hook);
						if(vlen(trace_endpos-hook_src) > 700  && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 180 right\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
					if(one_more ==1)
					{
						traceline(hook_src, trace_end_central + v_right*(-180), 1, hook);
						if(vlen(trace_endpos-hook_src) > 700  && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 180 left\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
					
					
					if(one_more ==1) 
					{
						traceline(hook_src, trace_end_central + v_up*270, 1, hook);
						if(vlen(trace_endpos-hook_src) > 700  && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 270 up\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
					if(one_more ==1)
					{	
						traceline(hook_src, trace_end_central + v_up*(-270), 1, hook);
						if(vlen(trace_endpos-hook_src) > 700 && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 270 down\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
					if(one_more ==1)
					{
						traceline(hook_src, trace_end_central + v_right*(270), 1, hook);
						if(vlen(trace_endpos-hook_src) > 700  && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 270 right\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
					if(one_more ==1)
					{
						traceline(hook_src, trace_end_central + v_right*(-270), 1, hook);
						if(vlen(trace_endpos-hook_src) > 700  && trace_fraction < 0.9)
						{
							//bprint(ftos(vlen(trace_endpos-hook_src)));
							//bprint(" 270 left\n");
							self.adjusted_hook_impact = trace_endpos;
							one_more =0;
						}
					}
				}
				
			}
			
	
	
	sound (self, CHAN_WEAPON, SOUND_HOOK_ATTACK, 1, ATTN_NORM);
		


	local entity link, prevlink;
	local float currentLinkNum = 0;
        local float linkCount = 7;		// <---------------number of links to draw starting from hookhead and back towards the player
	prevlink = world;
	
	local entity oldSelf = self;
	while (currentLinkNum < linkCount)
	{
		link = spawn();
		link.classname = "hook_chain_link";
		link.goalentity = prevlink;
		prevlink = link;
		
		link.owner = hook;
		link.enemy = self;
		link.up_count = (currentLinkNum / linkCount); 
		link.movetype = MOVETYPE_NOCLIP;
		link.solid = SOLID_NOT;
		
		if(currentLinkNum == 0)
		
		
		setmodel (link, "mdl/null.spr"); 
		
		//temporarily set 'self' so we can call our 'think' method 
		self = link;
		LinkPos();
		self = oldSelf;
		link.alpha = 0.005;     //HOOK FIX
		
		setsize (link, '0 0 0', '0 0 0');		
		self.nextthink = time;          //HOOK_THINK_
		link.think      = LinkPos;
		currentLinkNum  = currentLinkNum +1;
	}
	hook.goalentity = link;
	

	
	
};