
void() update_sparks =
{

	makevectors(self.owner.v_angle);
	if (self.owner.grind_side_is == 1)  setorigin(self, self.owner.origin + '0 0 -29' + v_right*(-21));
	else  setorigin(self, self.owner.origin + '0 0 -29' + v_right*(21));
    
	local vector dir;
	dir = aim (self.owner, 1000);
	self.angles = vectoangles(dir);

    
	if (self.owner.grind_completed != 2) 
	{
		self.think = SUB_Remove;
		self.owner.sparks_out = 0;
	}

	if (self.owner.deadflag != DEAD_NO) 
	{
		self.think = SUB_Remove;
		self.owner.sparks_out = 0;
	}
    
    self.nextthink = time + 0.01;
}





void() make_sparks =
{
	if (self.sparks_out == 0) 
	{
    
		self.sparks_out = 1;
		local entity sparks;
		local vector dir;
		sparks = spawn();
		setmodel (sparks, "progs/br_sparks.mdl");

		setorigin(sparks, self.origin + '0 0 -29');
		dir = aim (self, 1000);
		sparks.angles = vectoangles(dir);
		sparks.movetype = MOVETYPE_NOCLIP;
		sparks.solid = SOLID_NOT;
		sparks.nextthink = time + 0.5;
		sparks.think = update_sparks;
		sparks.classname = "sparks";
		setsize (sparks, 0,0);
		sparks.alpha = 1;
		sparks.owner = self;
		sparks.nextthink = time + 0.01;
		sparks.think = update_sparks;
	}
}






void() check_jump =
{	
	
	makevectors(self.v_angle);  
	local vector v_ang = vectoangles (v_forward*(-1));
	if(vlen(self.velocity) > 300 && self.velocity_z < 500 && v_ang_x > 50 && v_ang_x < 130 && self.shot_time > 1.1 && self.shot_downward == 0) self.shot_time = self.shot_time - 0.6;      //checks if rail reload time can be reduced for rail jumping

}



void() ceiling_ride =
{
	
	local vector start, end; 
	makevectors (self.v_angle);    
	start = self.origin + '0 0 27';            
	end   = start + '0 0 55';
	traceline (start, end, TRUE, self);
	
	local float up_dist = vlen(self.origin - trace_endpos);
	if(up_dist < 55 && self.angles_not_zero ==1) self.velocity_z +=-75;
	

	if(trace_fraction< 1 && (self.ski_button ==1) && !(self.hook_out) && self.airborn_pos > 200 && vlen(self.velocity) > 450)   // && vlen(self.velocity)> 800)
	{
		//stuffcmd(self, "cl_screenangle_speed 2.4\n");
		//stuffcmd(self, "cl_screenangle 180\n");
		
		if(self.stored_z1 !=1)
		{
			self.stored_z2 = time;
			self.stored_z1 =1;
		}
		if (time - self.stored_z2 > 4) self.stored_z1=0;
		else if(time - self.stored_z2 > 1.1) return;
		
		self.velocity_z = self.velocity_z +27;
		
		if(self.movement_x == 400) self.velocity = self.velocity + v_forward*7;
		else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-7);
		
		if(vlen(self.velocity)> 1000) self.velocity = normalize(self.velocity)*1000;
	}
	else 
	{
		self.grind_sound_counter1 = 18;
		//stuffcmd(self, "cl_screenangle_speed 2.4\n");
		//stuffcmd(self, "cl_screenangle 0\n");
	}
	
	
	if (self.grind_sound_counter1 >= 32)
	{
			//sound (self, CHAN_AUTO, "misc/runsteps1.wav", 1, ATTN_NORM);
			if (random() < 0.34) 
			{
				sound (self, CHAN_AUTO, "misc/grind1.wav", 0.55, ATTN_NORM);
			
			}
			else if (random() < 0.67) 
			{
				sound (self, CHAN_AUTO, "misc/grind2.wav", 0.55, ATTN_NORM);
			}
			else 
			{
				sound (self, CHAN_AUTO, "misc/grind3.wav", 0.55, ATTN_NORM);
			}
			self.grind_sound_counter1 = 0;	
	}
	else if (self.grind_sound_counter1 < 32) self.grind_sound_counter1 = self.grind_sound_counter1 +1;
	
}






void() WallRun =
{		
	local vector start, end, velo; 
	local float trace_frac_plus, trace_frac_minus, trace_frac_plus_long, trace_frac_minus_long;

	local float minspeed = 450;
	
	if (!(self.button2))	self.grind_completed = 0;

	velo = self.velocity;
	velo_z = 0;
	makevectors (self.v_angle);           //Bloodrails 
	
	self.punchang = self.anglestored;  //set punchangle to stored value
	
	start = self.origin + v_right*10 + v_forward*190;              
	end   = start + v_right*(-110);
	traceline (start, end, TRUE, self);
	trace_frac_minus_long = trace_fraction;
		
	start = self.origin + v_right*(-10) + v_forward*190;
	end   = start + v_right*(110);
	traceline (start, end, TRUE, self);
	trace_frac_plus_long = trace_fraction;

	start = self.origin;
		
	end = self.origin + v_right*(-90); //90
		
	traceline (start, end, TRUE, self);
	trace_frac_minus = trace_fraction;

	start = self.origin;
		
	end   = self.origin + v_right*(90); //90
		
	traceline (start, end, TRUE, self);
	trace_frac_plus = trace_fraction;
		
	local float grind_check = 0;
	local float tilt_check = 0;
	
	if ((trace_frac_plus > trace_frac_minus && trace_frac_minus_long == 1)) grind_check = 1;
	if ((trace_frac_minus > trace_frac_plus && trace_frac_plus_long == 1)) grind_check = 1;
		
	if (trace_frac_plus == 1 && trace_frac_minus == 1) tilt_check = 1;
		
	if (self.grind_completed == 0) 
	{
		self.vel_before_wallrun = vlen(self.velocity);
		//sprint(self, ftos(self.vel_before_wallrun));
	}
		
	if(vlen(velo) > minspeed && ((grind_check == 0 && tilt_check == 0) || self.grind_completed == 2) && !(self.hook_out) && (self.button2 && (self.movement_y <= -400 || self.movement_y >= 400)))  // change 420->525
	{

		if (trace_frac_plus == 1 && trace_frac_minus == 1) self.grind_completed = 1;   //added at swing hook debug
		
		if (trace_frac_plus > trace_frac_minus && self.grind_side_is != 2 && (self.movement_y <= -400)) // && (trace_frac_minus_long < 1 || self.grind_completed == 2))       //LEFT-SIDE GRIND
		{
			make_sparks();
			self.grind_side_is = 1;                              //grind on left
		
			stuffcmd(self, "cl_screenangle_speed 2.5\n");
			stuffcmd(self, "cl_screenangle 18\n");
			
			if (self.punchang < 4) self.punchang = self.punchang + 0.6;           //gradual lean for left-side (1) grind
			else if (self.punchang < 9) self.punchang = self.punchang + 0.8;
			else if (self.punchang < 13) self.punchang = self.punchang + 1.0;
			else if (self.punchang >= 13) self.punchang = self.punchang + 1.25;
			if (self.punchang >= 18) self.punchang = 18;
			
			
			if(self.punchang < 6) //staged tilt
			{
				stuffcmd(self, "cl_screenangle_speed 2.0\n");
				stuffcmd(self, "cl_screenangle 6\n");
			}
			else if(self.punchang < 12)
			{
				stuffcmd(self, "cl_screenangle_speed 2.5\n");
				stuffcmd(self, "cl_screenangle 12\n");
			}
			else if(self.punchang >= 12)
			{
				stuffcmd(self, "cl_screenangle_speed 2.7\n");
				stuffcmd(self, "cl_screenangle 18\n");
			}
			
			if (self.punchang >= 18) 	  setmodel (self, "progs/player_right_20.mdl");
			else if (self.punchang >= 14) setmodel (self, "progs/player_right_15.mdl");
			else if (self.punchang >= 10) setmodel (self, "progs/player_right_10.mdl");
			else if (self.punchang >= 5)  setmodel (self, "progs/player_right_5.mdl");
			
			self.anglestored = self.punchang;
		
			if (self.punchang > 0)
			{
				self.grind_completed = 2;
				self.angles_not_zero = 1;
				self.grind_time = time;
				
			}
			
			if (self.punchang > 10 && trace_frac_minus > 0.59) self.grind_completed = 1;
		
			
			
			/////////////////////////////////////////
			local vector adj_forward_left = v_forward + (-v_right);
		
			if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*13.3 +v_right*(-40) + '0 0 6.4';  //9 -> 6.4
			else if(self.movement_x ==-400) self.velocity = self.velocity + adj_forward_left*(-18.3) +v_right*(-40) + '0 0 2';
			//if(vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(800);
			setorigin(self, self.origin + v_right*0.99);
			
			
			
			if (self.vel_before_wallrun <= 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(800);
			else if (self.vel_before_wallrun > 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(self.vel_before_wallrun);
		
			if (self.grind_sound_counter == 32 && self.skiing_on ==0)
			{	
				sound (self, CHAN_AUTO, "misc/runsteps1.wav", 1, ATTN_NORM);
				if (random() < 0.34) 
				{
					sound (self, CHAN_AUTO, "misc/grind1.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps1.wav", 0.4, ATTN_NORM);
				}
				
				else if (random() < 0.67) 
				{
					sound (self, CHAN_AUTO, "misc/grind2.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps2.wav", 0.4, ATTN_NORM);
				}
			
				else 
				{
					sound (self, CHAN_AUTO, "misc/grind3.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps3.wav", 0.4, ATTN_NORM);
				}
				self.grind_sound_counter = 0;	
			}
			
			else if (self.grind_sound_counter < 32) self.grind_sound_counter = self.grind_sound_counter +1;
		
		}
		
		if (trace_frac_plus < trace_frac_minus && self.grind_side_is != 1 && (self.movement_y >= 400))     //RIGHT-SIDE GRIND
		{
			make_sparks();
			self.grind_side_is = 2;                                 //grind on right
		
			//stuffcmd(self, "cl_screenangle_speed 2.5\n");
			//stuffcmd(self, "cl_screenangle -18\n");
			
			if (self.punchang > -4) self.punchang = self.punchang - 0.6;            //gradual lean for right-side (2) grind
			else if (self.punchang > -9) self.punchang = self.punchang - 0.8;
			else if (self.punchang > -13) self.punchang = self.punchang - 1.0;
			else if (self.punchang <= -13) self.punchang = self.punchang - 1.25;
			if (self.punchang <= -18) self.punchang = -18;
			
			
			if(self.punchang > -6) //staged tilt
			{
				stuffcmd(self, "cl_screenangle_speed 2.0\n");
				stuffcmd(self, "cl_screenangle -6\n");
			}
			else if(self.punchang > -12)
			{
				stuffcmd(self, "cl_screenangle_speed 2.5\n");
				stuffcmd(self, "cl_screenangle -12\n");
			}
			else if(self.punchang <= -12)
			{
				stuffcmd(self, "cl_screenangle_speed 2.7\n");
				stuffcmd(self, "cl_screenangle -18\n");
			}
			
			if (self.punchang <= -18)      setmodel (self, "progs/player_left_20.mdl");
			else if (self.punchang <= -14) setmodel (self, "progs/player_left_15.mdl");
			else if (self.punchang <= -10) setmodel (self, "progs/player_left_10.mdl");
			else if (self.punchang <= -5)  setmodel (self, "progs/player_left_5.mdl");
			
			
			self.anglestored = self.punchang;
		
			if (self.punchang < 0) 
			{
				self.grind_completed = 2;
				self.angles_not_zero = 1;
				self.grind_time = time;
			}
			if (self.punchang < -10 && trace_frac_plus > 0.59) self.grind_completed = 1;
			
			
			
			//////////////
			local vector adj_forward_right = v_forward + (v_right);
		
			if(self.movement_x ==400 || self.movement_x ==0) self.velocity = self.velocity + v_forward*13.3 +v_right*(40) + '0 0 6.4';    //v_up6.4 -> 0 0 6.4//            //9 -> 6.4
			else if(self.movement_x ==-400) self.velocity = self.velocity + adj_forward_right*(-18.3) +v_right*(40) + '0 0 2';                //9 -> 6.4
			//if(vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(800);
			
			setorigin(self, self.origin + v_right*-0.99);
			
			if (self.vel_before_wallrun <= 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(800);
			else if (self.vel_before_wallrun > 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(self.vel_before_wallrun);
		
		
			if (self.grind_sound_counter == 32 && self.skiing_on ==0)
			{
				sound (self, CHAN_AUTO, "misc/runsteps1.wav", 1, ATTN_NORM);
				if (random() < 0.34) 
				{
					sound (self, CHAN_AUTO, "misc/grind1.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps1.wav", 0.4, ATTN_NORM);
				}
				else if (random() < 0.67) 
				{
					sound (self, CHAN_AUTO, "misc/grind2.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps2.wav", 0.4, ATTN_NORM);
				}
				else 
				{
					sound (self, CHAN_AUTO, "misc/grind3.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps3.wav", 0.4, ATTN_NORM);
				}
				self.grind_sound_counter = 0;	
			}
			
			else if (self.grind_sound_counter < 32) self.grind_sound_counter = self.grind_sound_counter +1;
		
		}
		
	}
	
	else	
		{
			self.grind_sound_counter = 18;
		
			if (self.grind_completed == 2) 
			{
				self.grind_completed = 1;
			}

			if (self.angles_not_zero == 0) 
			{
				self.grind_side_is = 0;
				return;
			}
			
			stuffcmd(self, "cl_screenangle_speed 3\n");
			stuffcmd(self, "cl_screenangle 0\n");
			
			if (self.punchang > 0) self.punchang = self.punchang - 1.15;
			else if (self.punchang < 0) self.punchang = self.punchang + 1.15;
			self.anglestored = self.punchang;
			
			if (self.punchang <= -18)      setmodel (self, "progs/player_left_20.mdl");
			else if (self.punchang <= -14) setmodel (self, "progs/player_left_15.mdl");
			else if (self.punchang <= -10) setmodel (self, "progs/player_left_10.mdl");
			else if (self.punchang <= -5)  setmodel (self, "progs/player_left_5.mdl");
			
			if (self.punchang >= 18)      setmodel (self, "progs/player_right_20.mdl");
			else if (self.punchang >= 14) setmodel (self, "progs/player_right_15.mdl");
			else if (self.punchang >= 10) setmodel (self, "progs/player_right_10.mdl");
			else if (self.punchang >= 5)  setmodel (self, "progs/player_right_5.mdl");
			
			if (self.punchang >= -1.15 && self.punchang <= 1.15) 
			{
				self.punchang = 0;
				self.anglestored = 0;
				self.angles_not_zero = 0;
				if(self.health > 0) setmodel (self, "progs/player.mdl");  //10/9/23 
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				return;
			}
					
		}	
	
}






/////////////////SKIING
void(float radius, float force) flag_homing_slide =
{

	local entity head;
	local vector old_vel, dir1;
	//makevectors(self.v_angle);

	
				head = findradius(self.origin, radius);
				while (head)
				{

							if (head.classname == "item_flag_team1" && self.flag_carrier && self.height == elohim_team1)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;
								
								//if(normalize(self.origin - head.origin)*v_forward < 0.4)
								
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								
							}

							else if (head.classname == "item_flag_team2" && self.flag_carrier && self.height == elohim_team2)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;
								
								//if(normalize(self.origin - head.origin)*v_forward < 0.4)
								
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								
							}
							
							
							else if (head.classname == "item_flag_team1" && !self.flag_carrier && self.height == elohim_team2)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;
								
								//if(normalize(self.origin - head.origin)*v_forward < 0.4)
								
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								
							}

							else if (head.classname == "item_flag_team2" && !self.flag_carrier && self.height == elohim_team1)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;

								//if(normalize(self.origin - head.origin)*v_forward < 0.4)
								
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								
							}

									
						
					
					head = head.chain;
				}


}









.float decline_time;
void() Skiing =
{
		local float slide_duration =3.1;  // flat adjustment
		
		if(!self.ski_button && self.impulse ==41) self.ski_button =1;
		if(self.ski_button && self.impulse ==42) self.ski_button =0;
		
		if(self.waterlevel > 1 && v_forward_z < -0.45 && self.velocity_z < -300) self.shark_time = time;
		
		if(self.waterlevel > 2 && time-self.shark_time < 3)			//NOVEM Sharking Dolphin
		{
			self.velocity = self.velocity + v_forward*75;
			if(vlen(self.velocity) > 850) self.velocity = normalize(self.velocity)*850;
			return;
		}
		else if((self.waterlevel>0 && self.waterlevel<2) && (time-self.shark_time > 0.8 && time-self.shark_time < 3))
		{
			self.velocity = self.velocity + '0 0 45';
			self.velocity = self.velocity + v_forward*45;
		}
		
		
		
		if((self.impulse == 42 || time-self.ski_time >=slide_duration) || (self.skiing_on ==0 && self.view_ofs_z < 22))
		{
			self.skiing_on =0;
			self.view_ofs_z += 1;
			if(self.view_ofs_z >= 22) self.view_ofs_z = 22;
		}
	
	
		if(self.impulse == 42 && time-self.ski_time < slide_duration && self.view_ofs_z < 10 && self.airborn_pos < 18)// && trace_startsolid == TRUE)  //DECEM
		{
			if (random() < 0.6) sound (self, CHAN_BODY, "player/br_jump1.wav", 0.8, ATTN_NORM);   // 1 -> 0.9
			else if (random() < 0.8) sound (self, CHAN_BODY, "player/br_jump2.wav", 0.8, ATTN_NORM);  
			else sound (self, CHAN_BODY, "player/br_jump3.wav", 0.8, ATTN_NORM);   // alternative jump noise
			self.velocity_z = self.velocity_z + 255;
		
			self.skiing_on =0;
		
			//bprint(ftos(time-self.ski_time));
			//bprint(" ski time\n");
		}
		
		if(self.ski_button ==0) return;     //DECEM
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		makevectors(self.v_angle);
		local vector horizon_forward = v_forward;
		horizon_forward_z = 0;
		
		horizon_forward =normalize(horizon_forward);
		
		//bprint(ftos(v_forward_z));
		//bprint("\n");
		
		
	
		traceline(self.origin + horizon_forward*40, self.origin + horizon_forward*40 + '0 0 -1000', TRUE, self);
		local float dist = (self.origin_z - trace_endpos_z);
		
		local float need_vel_adjusted;  // flat adjustment
		if(dist <1) dist = 0;
		
		if(dist > 30 && self.flags & FL_ONGROUND) self.landed_on_decline =1;
		else self.landed_on_decline =0;
		
		traceline(self.origin + horizon_forward*80, self.origin + horizon_forward*80 + '0 0 -1000', TRUE, self);
		
		dist = (self.origin_z - trace_endpos_z);
		if(dist > 59 && self.landed_on_decline ==1 && self.flags & FL_ONGROUND) self.landed_on_decline =1;
		else self.landed_on_decline =0;
		
		
		traceline(self.origin + horizon_forward*10, self.origin + horizon_forward*80, TRUE, self); 
		if(trace_fraction <1) self.landed_on_decline =0;
		
		
		// flat adjustment
		if(self.landed_on_decline ==0 && dist < 30)
		{
			traceline(self.origin + horizon_forward*10 + '0 0 -8', self.origin + horizon_forward*480 + '0 0 -8', TRUE, self);  
			if(trace_fraction ==1) 
			{
				need_vel_adjusted =1;
			}
		}
		

		
	
		
		

		
	tracebox(self.origin + '0 0 -40', '-18 -18 -40', '18 18 0', self.origin + '0 0 -41', 1, self);
	
	
	
	if(self.landed_on_decline ==1 || (self.velocity_z < -300 && trace_startsolid == TRUE)) self.decline_time = time;
	
	
	
	if(self.impulse ==41 && (  self.velocity_z <= -100 || (vlen(self.velocity) > 750 && self.velocity_z > -100 && self.velocity_z < 50 && need_vel_adjusted ==0)) && self.view_ofs_z ==22 && self.skiing_on ==0)   //initiate crouch slide
	{
			
		self.vel_before_wallrun = vlen(self.velocity);
		self.ski_time=time;
		
		if(need_vel_adjusted ==0) self.skiing_on =1;
		else if((need_vel_adjusted ==1 && self.velocity_z < 325)) self.skiing_on =2;
		
		self.ski_sound_counter =27;
		//bprint(ftos(dist));
		//bprint("primed\n");
			//bprint("UP!");
	}
	
	
	
	
	if((self.skiing_on ==1 || self.skiing_on ==2) && (trace_startsolid == TRUE))
	{
		
		//bprint(ftos(self.skiing_on));
		//bprint(" skiing_on\n");
		local float old_water_level = self.origin_z;
		
		setorigin(self, self.origin + '0 0 0.8');
		self.view_ofs_z -=1;
		if(self.view_ofs_z <= 7) self.view_ofs_z = 7;
		
		
		if(self.movement_x ==400) self.velocity = self.velocity + v_forward*7.0;
		else if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*-7.5;
		
		
		if (self.vel_before_wallrun <= 850 && vlen(self.velocity) > 850) self.velocity = normalize(self.velocity)*(850);
		else if (self.vel_before_wallrun <= 900 && vlen(self.velocity) > 900) self.velocity = normalize(self.velocity)*(self.vel_before_wallrun);
		else if (self.vel_before_wallrun > 900 && vlen(self.velocity) > 900) self.velocity = normalize(self.velocity)*(self.vel_before_wallrun*0.95);
		
		
		
		if(vlen(self.velocity) > 1050) self.velocity = normalize(self.velocity)*1050;
		
		
		if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*1.5;
		else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-1.25;
		
		
		if((need_vel_adjusted ==1 && time - self.decline_time > 0.7) || self.skiing_on ==2) 
		{
			
			if(time-self.ski_time > 1.1)
			{
				self.velocity =self.velocity*.9797;  // flat adjustment
				if(time-self.ski_time > 1.25) self.skiing_on =2;
			}
		}
		
		
		flag_homing_slide(500, 55);
		
		if(time-self.ski_time < 0.25 && self.velocity_z > 25 && vlen(self.velocity) < 852) self.skiing_on =2;
		if(time-self.ski_time < 0.25 && self.velocity_z < 400 && self.landed_on_decline ==0 && dist < 30) self.skiing_on =2;
		
		if(vlen(self.velocity) < 410) self.skiing_on =0;
		
		
		if ( self.flags & FL_ONGROUND ) self.flags = self.flags - FL_ONGROUND;
		
		
		
		
		if(trace_startsolid == TRUE && vlen(self.velocity) > 440)
		{
		
			if (self.ski_sound_counter == 32)
			{
			
				sound (self, CHAN_AUTO, "misc/runsteps1.wav", 1, ATTN_NORM);
				if (random() < 0.34) 
				{
					sound (self, CHAN_AUTO, "misc/grind1.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps1.wav", 0.4, ATTN_NORM);
				}
				else if (random() < 0.67) 
				{
					sound (self, CHAN_AUTO, "misc/grind2.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps2.wav", 0.4, ATTN_NORM);
				}
				else 
				{
					sound (self, CHAN_AUTO, "misc/grind3.wav", 0.55, ATTN_NORM);
					sound (self, CHAN_AUTO, "misc/runsteps3.wav", 0.4, ATTN_NORM);
				}
				self.ski_sound_counter = 0;	
			
			}
			else if (self.ski_sound_counter < 32) self.ski_sound_counter +=1;
		}
		
			
		
		
		
	}
	
	
	//bprint(ftos(self.velocity_z));
	//bprint(" vel_z\n");
}



////////WATER BOUNCE



.float bounce_on;
void() Water_bounce =   	//10/8/23
{
	local vector horiz_vel = self.velocity;
	horiz_vel_z =0;
	
	if(self.waterlevel == 3) return;	//NOVEM dont trigger underwater
	//makevectors(self.v_angle);
	
	local float slide_duration = 1.5;
	if(self.button2 && (pointcontents(self.origin + '0 0 -45') == CONTENT_WATER || pointcontents(self.origin + '0 0 -45') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -45') == CONTENT_LAVA))
	{
		if(vlen(self.velocity) > 590 && self.bounce_on ==0) 
		{
			self.ski_time=time;
			self.bounce_on =1;
			self.ski_sound_counter =1;
			//bprint("primed\n");
		}
	}

	
	
	if((pointcontents(self.origin + '0 0 -47') == CONTENT_WATER || pointcontents(self.origin + '0 0 -47') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -47') == CONTENT_LAVA) && (self.bounce_on ==1 || self.bounce_on ==2) && time-self.ski_time < slide_duration)
	{
		//self.view_ofs_z -=1;
		//if(self.view_ofs_z <= 2) self.view_ofs_z = 2;
		if(pointcontents(self.origin + '0 0 -24') == CONTENT_WATER || pointcontents(self.origin + '0 0 -24') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -24') == CONTENT_LAVA) self.bounce_on =2;
		
		if(vlen(horiz_vel) > 280 && self.bounce_on ==2)
		{
			if(pointcontents(self.origin + '0 0 -40') == CONTENT_WATER || pointcontents(self.origin + '0 0 -40') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -40') == CONTENT_LAVA) 
			{
				self.velocity = self.velocity + '0 0 70'; //self.origin_z = old_water_level;
				if (pointcontents(self.origin + '0 0 -40') == CONTENT_LAVA && self.velocity_z < -550) 
				{
					self.velocity_z = self.velocity_z*(-0.5);
					//bprint("UP!\n");
				}
				
				if(self.velocity_z < -700) self.velocity = self.velocity + '0 0 250';
				else if(self.velocity_z < -550) self.velocity = self.velocity + '0 0 200';
				else if(self.velocity_z < -400) self.velocity = self.velocity + '0 0 125';
			
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*8;   //NOVEM 3 -> 8
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-8;   //NOVEM 3 -> 8
				self.ski_time -=0.05;
			}
			else if(pointcontents(self.origin + '0 0 -30') == CONTENT_WATER || pointcontents(self.origin + '0 0 -30') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -30') == CONTENT_LAVA) 
			{
				self.velocity = self.velocity + '0 0 50'; //self.origin_z = old_water_level;
				if (pointcontents(self.origin + '0 0 -30') == CONTENT_LAVA && self.velocity_z < -550) self.velocity_z = self.velocity_z*(-0.5);
				if (pointcontents(self.origin + '0 0 -30') == CONTENT_WATER && self.velocity_z < -550) self.velocity_z = self.velocity_z*(-0.5);  //NOVEM added
				
				if(self.velocity_z < -700) self.velocity = self.velocity + '0 0 250';
				else if(self.velocity_z < -550) self.velocity = self.velocity + '0 0 200';
				else if(self.velocity_z < -400) self.velocity = self.velocity + '0 0 125';
			
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*8;		//NOVEM 3 -> 8
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-8;		//NOVEM 3 -> 8
				self.ski_time -=0.05;
			}
			
			if(vlen(horiz_vel) < 325)
			{
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*18; //NOVEM 12 -> 18
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-18;
				//bprint("horizontal1\n");
			}
			else if(vlen(horiz_vel) < 525)
			{
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*27; 	//NOVEM 18 -> 27
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-27;
				//bprint("horizontal2\n");
			}
			else if(vlen(horiz_vel) < 700)
			{
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*18; 	//NOVEM 18 -> 27
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-18;
				//bprint("horizontal2\n");
			}
	
			if(self.watertype == CONTENT_LAVA && self.velocity_z > 50 && self.movement_x ==400) self.velocity = self.velocity + v_forward*30;
			else if(self.watertype == CONTENT_LAVA && self.velocity_z > 50 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-30;
			
			//if (self.watertype == CONTENT_LAVA && self.velocity_z < -200) 
			//{
			//	self.velocity_z = self.velocity_z + 100;
			//	bprint("UP!\n");
			//}
	
		}

		if((pointcontents(self.origin + '0 0 -45') == CONTENT_WATER || pointcontents(self.origin + '0 0 -45') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -45') == CONTENT_LAVA) && self.bounce_on ==2)
		{
			if (self.velocity_z > 2 && self.ski_sound_counter ==1)
			{
			
				if(vlen(self.velocity) > 500) sound (self, CHAN_AUTO, "misc/water_bounce1.wav", 0.59, ATTN_NORM);
				if(vlen(self.velocity) > 400) sound (self, CHAN_AUTO, "misc/water_bubble1.wav", 0.9, ATTN_NORM);
				
				self.ski_sound_counter = 0;	
			
			}
			//else if (self.ski_sound_counter < 32) self.ski_sound_counter +=1;
		
		}
	}
	
	if(!self.button2 || self.waterlevel ==3)
	{
		self.bounce_on =0;
		//self.view_ofs_z += 1;
		//if(self.view_ofs_z >= 22) self.view_ofs_z = 22;
	}

}




void() Stairs =
{
		makevectors(self.v_angle);
		local vector h_forward = v_forward;
		h_forward_z = 0;
		h_forward =normalize(h_forward);
		
	
		traceline(self.origin + h_forward*16 + '0 0 -24', self.origin + h_forward*16 + '0 0 -40', TRUE, self);	//check directly below player
		local float z0 = (self.origin_z - trace_endpos_z);
		local float vert0;
		if(trace_plane_normal_x ==0 && trace_plane_normal_y ==0) vert0 =1;
		else vert0 =0;
	
		traceline(self.origin + h_forward*-16 + '0 0 -24', self.origin + h_forward*-16 + '0 0 -40', TRUE, self);	//check directly below player
		local float z1 = (self.origin_z - trace_endpos_z);
		local float vert1;
		if(trace_plane_normal_x ==0 && trace_plane_normal_y ==0) vert1 =1;
		else vert1 =0;
		
		if (z0 > z1) z1 =z0;
		else if(z1 > z0) z1 =z1;
		
		
		
		traceline(self.origin + h_forward*18 + '0 0 -24', self.origin  + h_forward*18 + '0 0 -800', TRUE, self);   //check 20 units in front
		local float z2 = (self.origin_z - trace_endpos_z);
		local float vert2;
		if(trace_plane_normal_x ==0 && trace_plane_normal_y ==0) vert2 =1;
		else vert2 =0;
		
		traceline(self.origin + h_forward*36 + '0 0 -24', self.origin  + h_forward*36 + '0 0 -1200', TRUE, self);	//check 40 units in front
		local float z3 = (self.origin_z - trace_endpos_z); 
		local float vert3;
		if(trace_plane_normal_x ==0 && trace_plane_normal_y ==0) vert3 =1;
		else vert3 =0;
		

		
		if((z3<z1 || z2<z1) && ((vert2 ==1 || vert3 ==1) && (vert1 ==1 || vert0 ==1)))
		{
			if((z1 <= 40 && z1 > 28) && self.button2 && (time- self.jump_time > 0.21 || self.jump_time ==0)) 
			{
				//setorigin(self, self.origin + '0 0 3');
				//self.velocity = self.velocity + h_forward*40 + '0 0 50';   //this one worked
				self.velocity = self.velocity + '0 0 52';
				if(self.velocity_z < 120) self.velocity = self.velocity + '0 0 52';
				self. jump_time = time;	
			}
			if ( !(self.flags & FL_ONGROUND) && self.velocity_z < 159 && self.velocity_z > -80) self.flags = self.flags | FL_ONGROUND;
			
		}
		



}


/*
void() Slopes =
{
		makevectors(self.v_angle);
		local vector h_forward = v_forward;
		h_forward_z = 0;
		h_forward =normalize(h_forward);

	
		traceline(self.origin + h_forward*-10 + '0 0 -24', self.origin + h_forward*-10 + '0 0 -40', TRUE, self);	//check directly below player
		local float z1 = (self.origin_z - trace_endpos_z);
		  
		
		traceline(self.origin + '0 0 -24', self.origin + '0 0 -1200', TRUE, self);   //check 20 units in front
		local float z2 = (self.origin_z - trace_endpos_z);
		local float slope1 = (z2-z1)/10;		
		
		
		traceline(self.origin + h_forward*10 + '0 0 -24', self.origin  + h_forward*10 + '0 0 -2000', TRUE, self);	//check 40 units in front
		local float z3 = (self.origin_z - trace_endpos_z);
		local float slope2 = (z3-z2)/10;    

		
		if (slope2 == slope1)
		{
			self.front_slope = slope2;
			//bprint(ftos(slope2));
			//bprint(" slope\n");
		}
		
		if ((slope2 == slope1 && slope2 !=0) && (time - self.slope_time > 3 || self.slope_time ==0) && self.velocity_z < -250)    // are the two slopes the same?
		{
			self.slope_time = time;
			//bprint(" slope_time\n");
		}
		
		if(slope2 > 0.55 && (time - self.slope_time <=3 && self.slope_time !=0))
		{
			//if (self.flags & FL_ONGROUND) self.flags = self.flags - self.flags & FL_ONGROUND;
		}

		
		
		
		
		self.slope_vec = normalize((self.origin + h_forward*40 + '0 0 z3') - (self.origin  + '0 0 z1'));

}
*/