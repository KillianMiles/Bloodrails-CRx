
void() update_sparks =
{

	makevectors(self.owner.v_angle);
	
	local vector dir;
	dir = aim (self.owner, 1000);
	self.angles = vectoangles(dir);
	
	if(self.owner.grind_side_is !=0)
	{
		if (self.owner.grind_side_is == 1)  setorigin(self, self.owner.origin + '0 0 -25' + v_right*(-13)); //21 -:>? 13
		else  setorigin(self, self.owner.origin + '0 0 -25' + v_right*(13)); //21 -:>? 13.. 29 ->25
	}
	else 
	{
		setorigin(self, self.owner.origin + '0 0 13');
		//bprint("Setorigin yes ");
	}
    
	
		//bprint(ftos(self.owner.grind_side_is));
	
		if (self.owner.grind_completed != 2 && self.owner.shields_up ==0) 
		{
			self.think = SUB_Remove;
			self.owner.sparks_out = 0;
			//bprint("no sparks1  ");
		}

		else if (self.owner.shields_up ==1 && time - self.owner.shield_time > 0.70) 
		{
			self.think = SUB_Remove;
			self.owner.sparks_out = 0;
			//bprint("no sparks2  ");
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
		setmodel (sparks, "mdl/br_spark.mdl");

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


void() swoop =
{
	float old_vel = vlen(self.velocity) -2;
	makevectors (self.v_angle);    


	if((self.ski_button ==1) && !(self.hook_out) && ((self.airborn_pos > 230 && self.velocity_z < -450) || self.swoop_yes ==1))
	{
		
		if(self.swoop_yes ==0)
		{
			self.swoop_time = time;
			//if(self.is_over_sky) self.swoop_time = self.swoop_time + 10;
			self.swoop_yes =1;
			//sound (self, CHAN_AUTO, "misc/br_swoop.wav", 1, ATTN_NORM);
		}
		if(self.airborn_pos <330)
		{
			if (time - self.swoop_time > 4.0) self.swoop_yes =0;
			else if(time - self.swoop_time > 1.75) return;
		}
		else
		{
			if (time - self.swoop_time > 5.25) self.swoop_yes =0;
			else if(time - self.swoop_time > 3.3) return;
		}
		
		if(vlen(self.velocity) < 500 && self.airborn_pos > 300)
		{
			self.swoop_yes =0;
			self.swoop_time = self.swoop_time + 3.5;
		}
		
		if(self.swoop_yes ==1  && time - self.swoop_time > 0.3 ) //|| (pointcontents(self.origin + '0 0 -50') == CONTENT_WATER || pointcontents(self.origin + '0 0 -50') == CONTENT_LAVA)))   //added min time for swoop
		{
			if(time-self.swoop_time> 0.3 && time-self.swoop_time< 0.316) sound (self, CHAN_AUTO, "misc/br_swoop.wav", 1, ATTN_NORM);
			
			local vector for_hor = v_forward;
			
			if(v_forward_z < -0.5) for_hor_z = for_hor_z + 0.2;
			else for_hor_z = for_hor_z + 0.4;
			
			//for_hor_z = for_hor_z + 0.4;
			for_hor = normalize(for_hor);
			
			self.velocity_z = self.velocity_z +4;
			self.velocity = normalize(self.velocity + for_hor*24) *old_vel;
			
			if(self.airborn_pos < 75) self.velocity_z = self.velocity_z +11;  //if cloaw to ground - skim low
			
			
			if(self.waterlevel ==1) 
			{
				local float pre_splash_vel = vlen(self.velocity);
				
				if (self.velocity_z < 0) self.velocity_z =0;
				self.velocity = normalize(self.velocity)*pre_splash_vel*1.05;
				if(vlen(self.velocity)> 1250) self.velocity = normalize(self.velocity)*1250;
			}
			
			if(v_forward_z > 0.3) self.velocity_z = self.velocity_z +2; 
			if(v_forward_z > 0.4) self.velocity_z = self.velocity_z +2; 
			if(v_forward_z > 0.55) self.velocity_z = self.velocity_z +1.75; 
			if(v_forward_z > 0.7) self.velocity = self.velocity + v_forward*1.5;
			
			if(v_forward_z > 0.3 && self.airborn_pos > 300) self.velocity = self.velocity + v_forward*1.2;
			if(v_forward_z < 0.5 && self.airborn_pos > 300) self.velocity_z = self.velocity_z +1.25; 
			
			if(v_forward_z < -0.3 && self.airborn_pos > 300)    //if looking down
			{
				self.velocity_z = self.velocity_z -1.0; 
				self.velocity = self.velocity + v_forward*1.0;
			}

		
		
			if(vlen(self.velocity)> 2000) self.velocity = normalize(self.velocity)*2000;
		
			if(time - self.axe_time > 0.7) self.frame = 110;
			setsize (self, VEC_HULL_MIN, '16 16 20');
		}
	}
	else 
	{
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	}
	
}

/*
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
		if(self.stored_z1 !=1)
		{
			self.stored_z2 = time;
			self.stored_z1 =1;
		}
		if (time - self.stored_z2 > 4) self.stored_z1=0;
		else if(time - self.stored_z2 > 1.1) return;
	
		self.velocity_z = self.velocity_z +12;
		
		if(self.movement_x == 400) self.velocity = self.velocity + v_forward*7;
		else if(self.movement_x == -400) self.velocity = self.velocity + v_forward*(-7);
		
		if(vlen(self.velocity)> 1000) self.velocity = normalize(self.velocity)*1000;
		if(time - self.axe_time > 0.7)self.frame = 110;
		setsize (self, VEC_HULL_MIN, '16 16 20');
	}
	else 
	{
		self.grind_sound_counter1 = 55;
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	}
	
	if (self.grind_sound_counter1 >= 32)
	{
			if (random() < 0.34) sound (self, CHAN_AUTO, "misc/br_grind1.wav", 0.20, ATTN_NORM);
			else if (random() < 0.67) sound (self, CHAN_AUTO, "misc/br_grind2.wav", 0.20, ATTN_NORM);
			else sound (self, CHAN_AUTO, "misc/br_grind3.wav", 0.20, ATTN_NORM);
			self.grind_sound_counter1 = 0;	
	}
	else if (self.grind_sound_counter1 < 32) self.grind_sound_counter1 = self.grind_sound_counter1 +1;
}
*/






void() WallRun =
{		
	local vector start, end, velo; 
	local float trace_frac_plus, trace_frac_minus, trace_frac_plus_long, trace_frac_minus_long;

	local float minspeed = 410;
	
	if (!(self.button2))	self.grind_completed = 0;

	velo = self.velocity;
	velo_z = 0;
	makevectors (self.v_angle);        
	
	self.punchang = self.anglestored;  //set punchangle to stored value
	
	start = self.origin + v_right*10 + v_forward*190;              
	end   = start + v_right*(-100);  //110->100
	traceline (start, end, TRUE, self);
	trace_frac_minus_long = trace_fraction;
		
	start = self.origin + v_right*(-10) + v_forward*190;
	end   = start + v_right*(100); //110->100
	traceline (start, end, TRUE, self);
	trace_frac_plus_long = trace_fraction;

	start = self.origin;
		
	end = self.origin + v_right*(-90); //90->80
		
	traceline (start, end, TRUE, self);
	trace_frac_minus = trace_fraction;

	start = self.origin;
		
	end   = self.origin + v_right*(90); //90->80
		
	traceline (start, end, TRUE, self);
	trace_frac_plus = trace_fraction;
		
	local float grind_check = 0;
	local float tilt_check = 0;
	
	if ((trace_frac_plus > trace_frac_minus && trace_frac_minus_long == 1)) grind_check = 1;
	if ((trace_frac_minus > trace_frac_plus && trace_frac_plus_long == 1)) grind_check = 1;
		
	if (trace_frac_plus == 1 && trace_frac_minus == 1) tilt_check = 1;
		
	if (self.grind_completed == 0 || self.punchang ==0)  //JANUARY wallrun reset
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
		
			
			if (self.punchang < 4) self.punchang = self.punchang + 0.6;           //gradual lean for left-side (1) grind
			else if (self.punchang < 9) self.punchang = self.punchang + 0.8;
			else if (self.punchang < 11) self.punchang = self.punchang + 1.0;
			else if (self.punchang >= 11) self.punchang = self.punchang + 1.25;
			
			if (self.punchang >= 12) self.punchang = 12;
			
			
			if(self.punchang < 4 && self.run_tilt != 6) //staged tilt
			{
				stuffcmd(self, "as20p6\n");
				self.run_tilt = 6;
				//bprint("tilting 1 yes!\n");
				self.tilted =1;
			}
			else if(self.punchang < 12 && self.run_tilt != 12)
			{
				stuffcmd(self, "as25p12\n");
				self.run_tilt = 12;
				//bprint("tilting 2 yes!\n");
				self.tilted =1;
			}

			
			if (self.punchang >= 18)      self.angles_z = 20;
			else if (self.punchang >16) self.angles_z = 16;
			else if (self.punchang>12) self.angles_z = 12;
			else if (self.punchang>8) self.angles_z = 8;
			else if (self.punchang >4)  self.angles_z = 4;
			
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
			
			
			
			
			if (self.vel_before_wallrun <= 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(800);
			else if (self.vel_before_wallrun > 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(self.vel_before_wallrun);
			
			setorigin(self, self.origin + v_right*0.99);
		
			if (self.grind_sound_counter == 64 && self.skiing_on ==0)
			{	
				//sound (self, CHAN_VOICE, "misc/runsteps1.wav", 0.12, ATTN_NORM);
				if (random() < 0.25) 
				{
					sound (self, CHAN_VOICE, "misc/br_grind1.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps1.wav", 0.2, ATTN_NORM);
				}
				
				else if (random() < 0.50) 
				{
					sound (self, CHAN_AUTO, "misc/br_grind2.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps2.wav", 0.2, ATTN_NORM);
				}
				else if (random() < 0.75) 
				{
					sound (self, CHAN_VOICE, "misc/br_grind3.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps2.wav", 0.2, ATTN_NORM);
				}
			
				else 
				{
					sound (self, CHAN_VOICE, "misc/br_grind4.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps3.wav", 0.2, ATTN_NORM);
				}
				self.grind_sound_counter = 0;	
			}
			
			else if (self.grind_sound_counter < 64) self.grind_sound_counter = self.grind_sound_counter +1;
		
		}
		
		if (trace_frac_plus < trace_frac_minus && self.grind_side_is != 1 && (self.movement_y >= 400))     //RIGHT-SIDE GRIND
		{
			make_sparks();
			self.grind_side_is = 2;                                 //grind on right
		
			
			if (self.punchang > -4) self.punchang = self.punchang - 0.6;            //gradual lean for right-side (2) grind
			else if (self.punchang > -9) self.punchang = self.punchang - 0.8;
			else if (self.punchang > -11) self.punchang = self.punchang - 1.0;
			else if (self.punchang <= -11) self.punchang = self.punchang - 1.25;
			if (self.punchang <= -12) self.punchang = -12;
			
			
			if(self.punchang > -4 && self.run_tilt != -6) //staged tilt
			{
				stuffcmd(self, "as20n6\n");
				self.run_tilt = -6;
				//bprint("tilting 1 yes!\n");
				self.tilted =1;
			}
			else if(self.punchang > -12 && self.run_tilt != -12)
			{
				stuffcmd(self, "as25n12\n");
				self.run_tilt = -12;
				//bprint("tilting 2 yes!\n");
				self.tilted =1;
			}

			
			if (self.punchang <= -18)      self.angles_z = -20;
			else if (self.punchang <= -16) self.angles_z = -16;
			else if (self.punchang <= -12) self.angles_z = -12;
			else if (self.punchang <= -8)  self.angles_z = -8;
			else if (self.punchang <= -4)  self.angles_z = -4;
			
			
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
			
			
			if (self.vel_before_wallrun <= 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(800);
			else if (self.vel_before_wallrun > 800 && vlen(self.velocity) > 800) self.velocity = normalize(self.velocity)*(self.vel_before_wallrun);
			
			setorigin(self, self.origin + v_right*-0.99);
		
		
			if (self.grind_sound_counter == 64 && self.skiing_on ==0)
			{
				//sound (self, CHAN_AUTO, "misc/runsteps1.wav", 0.12, ATTN_NORM);
				if (random() < 0.25) 
				{
					sound (self, CHAN_VOICE, "misc/br_grind1.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps1.wav", 0.2, ATTN_NORM);
				}
				else if (random() < 0.50) 
				{
					sound (self, CHAN_VOICE, "misc/br_grind2.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps2.wav", 0.2, ATTN_NORM);
				}
				else if (random() < 0.75) 
				{
					sound (self, CHAN_VOICE, "misc/br_grind3.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps2.wav", 0.2, ATTN_NORM);
				}
				else 
				{
					sound (self, CHAN_VOICE, "misc/br_grind4.wav", 0.4, ATTN_NORM);
					//sound (self, CHAN_AUTO, "misc/runsteps3.wav", 0.2, ATTN_NORM);
				}
				self.grind_sound_counter = 0;	
			}
			
			else if (self.grind_sound_counter < 64) self.grind_sound_counter = self.grind_sound_counter +1;
		
		}
		
		
		if (pointcontents(self.origin + '0 0 59') == CONTENT_SOLID || pointcontents(self.origin + '0 0 64') == CONTENT_SOLID)   //Lets check head clearance to not get jammed up
		{
			self.velocity = self.velocity + '0 0 -15';   //add downward velocity if there is a ceiling above
		}
		
		
	}
	
	else	
		{
			self.grind_sound_counter = 55;
			
		
			if (self.grind_completed == 2) 
			{
				self.grind_completed = 1;
			}

			if (self.angles_not_zero == 0) 
			{
				self.grind_side_is = 0;
				return;
			}
			
			if(self.tilted ==1)
			{
				stuffcmd(self, "as30\n");
				stuffcmd(self, "an0\n");
				self.tilted =0;
			}

			
			if (self.punchang > 0) self.punchang = self.punchang - 1.15;
			else if (self.punchang < 0) self.punchang = self.punchang + 1.15;
			self.anglestored = self.punchang;
			
			if (self.punchang <= -18)      self.angles_z = -20;
			else if (self.punchang <= -16) self.angles_z = -16;
			else if (self.punchang <= -12) self.angles_z = -12;
			else if (self.punchang <= -8)  self.angles_z = -8;
			else if (self.punchang <= -4)  self.angles_z = -4;
			
			if (self.punchang >= 18)      self.angles_z = 20;
			else if (self.punchang >16) self.angles_z = 16;
			else if (self.punchang>12) self.angles_z = 12;
			else if (self.punchang>8) self.angles_z = 8;
			else if (self.punchang >4)  self.angles_z = 4;
			
			if (self.punchang >= -1.15 && self.punchang <= 1.15) 
			{
				self.punchang = 0;
				self.anglestored = 0;
				self.angles_not_zero = 0;
				sound (self, CHAN_VOICE, "trig/br_null.wav", 0.4, ATTN_NORM);
				return;
			}
					
		}	
		

	
}






/////////////////SKIING
void(float radius, float force) flag_homing_slide =
{

	local entity head;
	local vector old_vel, dir1;
	makevectors(self.v_angle);

	
				head = findradius(self.origin, radius);
				while (head)
				{

							if (head.classname == "item_flag_team1" && self.flag_carrier && self.height == crx_team1)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;
								
								//if((normalize(head.origin - self.origin)*v_forward > 0.59 && self.movement_x ==400) || self.movement_x ==-400)
								if(self.movement_x ==-400)
								{
									//bprint("yes\n");
								
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								}
								
							}

							else if (head.classname == "item_flag_team2" && self.flag_carrier && self.height == crx_team2)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;
								
								//if((normalize(head.origin - self.origin)*v_forward > 0.59 && self.movement_x ==400) || self.movement_x ==-400)
								if(self.movement_x ==-400)
								{
									//bprint("yes\n");
								
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								}
								
							}
							
							
							else if (head.classname == "item_flag_team1" && !self.flag_carrier && self.height == crx_team2)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;
								
								//if((normalize(head.origin - self.origin)*v_forward > 0.59 && self.movement_x ==400) || self.movement_x ==-400)
								if(self.movement_x ==-400)
								{
									//bprint("yes\n");
								
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								}
								
							}

							else if (head.classname == "item_flag_team2" && !self.flag_carrier && self.height == crx_team1)
							{	
								dir1 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir1 = normalize(dir1);
								old_vel = self.velocity;

								//if((normalize(head.origin - self.origin)*v_forward > 0.59 && self.movement_x ==400) || self.movement_x ==-400)
								if(self.movement_x ==-400)
								{	
									//bprint("yes\n");
									self.velocity = self.velocity + force*dir1;
									self.velocity = normalize(self.velocity)*vlen(old_vel);
								}
								
							}

									
						
					
					head = head.chain;
				}


}










void() Skiing =
{
		local float slide_duration =12.1;  // flat adjustment
		local float already_jumped =0;

		
		if(!self.ski_button && self.impulse ==41) 
		{
			self.ski_button =1;
			self.ski_button_time = time;
		}
		if(self.ski_button && self.impulse ==42) 
		{
			self.ski_button =0;
		}
		
		if(self.swoop_yes==1) return;
		
					//bprint(ftos(self.airborn_pos));
					//bprint("altitude  ");
					if(self.skiing_on !=0 && self.turn_speed > 8 && self.airborn_pos <3)
					{
						if(self.ski_tilt !=-5)
						{
							stuffcmd(self, "as25n5\n");
							//bprint("tilting 2 yes!\n");
							self.ski_tilt=-5;
							self.tilted =1;
						}
					}
					else if(self.skiing_on !=0 && self.turn_speed < -8 && self.airborn_pos <3)
					{
						if(self.ski_tilt !=5)
						{
							stuffcmd(self, "as25p5\n");
							//bprint("tilting 2 yes!\n");
							self.ski_tilt=5;
							self.tilted =1;
						}
					}
					
					if(self.skiing_on !=0 && self.turn_speed >=-8 && self.turn_speed <= 8 && self.ski_button ==1 && self.tilted==1)
					{
						stuffcmd(self, "an0\n");
						self.ski_tilt=0;
						self.tilted=0;
					}
					else if(vlen(self.velocity) < 425 && self.skiing_on !=0) 
					{
						if(self.tilted ==1)
						{
							stuffcmd(self, "an0\n");
							self.ski_tilt=0;
							self.tilted=0;
							//bprint("badspam YES!\n"); 
						}
					}
			
		
		//if(v_forward_z < 0 && self.movement_x ==400) bprint(ftos(self.velocity_z)); 
		
		
		if(self.ski_button && self.flags & FL_ONGROUND && self.skiing_on ==0 && vlen(self.velocity) < 425 && self.velocity_z > -110) self.ski_button =0;
		
	//GRADUAL SLOW DOWN WHEN FINISHING SLIDE
		if(self.ski_button && (self.flags & FL_ONGROUND) ) //&& self.movement_x == 400) 
		{
			if(vlen(self.velocity) < 340) self.velocity = self.velocity;
			else
			{
				if(vlen(self.velocity) < 380) self.velocity = self.velocity + normalize(self.velocity)*7;
				else if(vlen(self.velocity) < 425) self.velocity = self.velocity + normalize(self.velocity)*8;
				else if(vlen(self.velocity) < 500) self.velocity = self.velocity + normalize(self.velocity)*8;
				else if(vlen(self.velocity) < 520) 
				{
					self.velocity = self.velocity + normalize(self.velocity)*8;
					//bprint("slow up ");
				}

			}
		}
		///////////////////////////
		
		if(pointcontents(self.origin + '0 0 12') != CONTENT_WATER && time-self.shark_time < 3) 
		{
			self.shark_time = self.shark_time - 0.12;
			//bprint(ftos(time-self.shark_time));
		}
		
		if(self.waterlevel > 1 && v_forward_z < -0.45 && self.velocity_z < -300 && pointcontents(self.origin + '0 0 30') != CONTENT_WATER) self.shark_time = time;
		
		
		if(mapname !="ctf_edge3_c2" && mapname !="ctf_edge3_c3" && mapname !="ctf_edge3_c4" && mapname !="ctf_edge3_c5" && mapname !="ctf_edge3_r1" && mapname !="ctf_edge3_r2" && mapname !="ctf_edge3_r3")
		{
			//if(vlen(self.velocity)< 675 && time - self.shark_time > 0.5) self.shark_time = self.shark_time -3; //stop dolphining if speed falls below certain value
			
			if(self.waterlevel > 2 && time-self.shark_time < 3 && self.movement_x ==400)			//APRIL Sharking Dolphin  
			{
				self.velocity = self.velocity + v_forward*80;
				if(vlen(self.velocity) > 870) self.velocity = normalize(self.velocity)*870;
				return;
			}
			
			else if((self.waterlevel>0 && self.waterlevel<2) && (time-self.shark_time > 0.8 && time-self.shark_time < 3))
			{
				self.velocity = self.velocity + '0 0 45';
				self.velocity = self.velocity + v_forward*45;
			}
		
		}
		
		else
		{	
			//if(vlen(self.velocity)< 200 && time - self.shark_time > 0.7) self.shark_time = self.shark_time -3;   //stop dolphining if speed falls below certain value
			
			if(self.waterlevel > 2 && time-self.shark_time < 3 && self.movement_x ==400)			//APRIL Sharking Dolphin
			{
				self.velocity = self.velocity + v_forward*80;
				if(vlen(self.velocity) > 500) self.velocity = normalize(self.velocity)*500;
				return;
			}
			else if((self.waterlevel>0 && self.waterlevel<2) && (time-self.shark_time > 0.8 && time-self.shark_time < 3))
			{
				self.velocity = self.velocity + '0 0 45';
				self.velocity = self.velocity + v_forward*45;
			}
			
		}
		
		if(self.impulse == 42 || (self.skiing_on ==0 && self.view_ofs_z < 22))
		{
			self.skiing_on =0;
			if(self.tilted==1)
			{
				stuffcmd(self, "an0\n");
				self.tilted=0;
			}
			sound (self, CHAN_VOICE, "trig/br_null.wav", 0.4, ATTN_NORM);
			self.view_ofs_z += 1;
			if(self.view_ofs_z >= 22) self.view_ofs_z = 22;
			
		}
	
	
		if((self.impulse == 42 || self.skiing_on ==3) && time-self.ski_time < slide_duration && self.view_ofs_z < 10 && self.airborn_pos < 18)// && trace_startsolid == TRUE)  //DECEM
		{
			
			//sound (self, CHAN_BODY, "body/br_boost.wav", 0.7, ATTN_NORM);
			
			if (random() < 0.6) sound (self, CHAN_BODY, "body/br_jmp1.wav", 0.57, ATTN_IDLE);   // 1 -> 0.9
			else if (random() < 0.8) sound (self, CHAN_BODY, "body/br_jmp2.wav", 0.57, ATTN_IDLE);  
			else sound (self, CHAN_BODY, "body/br_jmp3.wav", 0.57, ATTN_IDLE);   // alternative jump noise
			
			if(self.ski_tilt !=0) self.ski_tilt =0;
			
			if(self.velocity_z > 0) 
			{
				self.velocity_z = self.velocity_z + 255;
				//bprint("up 1\n");
			}
			else 
			{
				self.velocity_z = self.velocity_z + 310;
			}
	
			self.skiing_on =0;
			sound (self, CHAN_VOICE, "trig/br_null.wav", 0.4, ATTN_NORM);
			//sound (self, CHAN_VOICE, "misc/br_grind5.wav", 0.4, ATTN_NORM); //fade out
			already_jumped=1;
		}
		
		if (self.flags & FL_ONGROUND) self.boost_time = 0;
		
		if(self.impulse ==42 && self.airborn_pos >= 3 && self.skiing_on ==0 && already_jumped ==0 && !(self.style & STYLE_OBSERVER))
		{
			if(self.boost_time == 0 && self.angles_not_zero == 0)
			{
				if (!(self.flags & FL_ONGROUND) && self.airborn_pos > 25)
				{
					if(time - self.ski_button_time < 0.4)
					{
						self.boost_time = 1;
						if(self.velocity_z > -850) sound (self, CHAN_BODY, "body/br_boost.wav", 0.7, ATTN_NORM);
				
						if(self.velocity_z > 1000) self.velocity = self.velocity + '0 0 175';   //boost up
						else if(self.velocity_z > 800) self.velocity = self.velocity + '0 0 225'; 
						else if(self.velocity_z > 400) self.velocity = self.velocity + '0 0 275';  
						else if(self.velocity_z > 0) self.velocity = self.velocity + '0 0 325'; 
						else if(self.velocity_z > -250) self.velocity = self.velocity + '0 0 425';   
						else if(self.velocity_z > -475) self.velocity = self.velocity + '0 0 550';
						else if(self.velocity_z > -750) self.velocity = self.velocity + '0 0 700';
						else if(self.velocity_z > -850) self.velocity = self.velocity + '0 0 750';
					}
				}
			}
		}
		
		if(self.ski_button ==0) return;     //DECEM
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		makevectors(self.v_angle);

		

				traceline(self.origin, self.origin + normalize(self.velocity)*180, TRUE, self);	//APRIL
				local float fraction = trace_fraction;	



		
	tracebox(self.origin + '0 0 -45', '-18 -18 -45', '18 18 0', self.origin + '0 0 -47', 1, self);
	
	
	//INITIATE SLIDE
	if(self.ski_button ==1 && vlen(self.velocity) > 375 && self.view_ofs_z ==22 && self.skiing_on ==0 && self.angles_not_zero == 0)   //initiate crouch slide -- //impulse 41 -> ski_button MAY
	{		
		self.vel_before_wallrun = vlen(self.velocity);
		self.z_height = self.origin_z;
		self.ski_time=time;
		self.skiing_on =1;
		self.ski_sound_counter =59;
		//bprint("initiate slide\n");
	}
		////////////////////////////////////
	
	
	
	
	
	if(self.skiing_on ==1 && (trace_startsolid == TRUE))
	{
		if(self.movement_x !=400 && self.movement_x !=-400) return;
		
		local float old_water_level = self.origin_z;
		
	//REMOVE ON_GROUND FLAG IF IT'S ON
		if(self.flags & FL_ONGROUND ) self.flags = self.flags - FL_ONGROUND;
		///////////////////////////
		
		
	//LOWER VIEW OFFSET
		setorigin(self, self.origin + '0 0 0.8');
		self.view_ofs_z -=1;
		if(self.view_ofs_z <= 7) self.view_ofs_z = 7;
		////////////////////////////////////////
		
		
		
	//ADD SPEED IN THE LOOK DIRECTION
		if(self.movement_x ==400) self.velocity = self.velocity + v_forward*1;
		if(self.movement_x ==-400) self.velocity = self.velocity + v_forward*(-1);
		///////////////////////////////////////
		
		
	// SPEED CAPS
		if (self.vel_before_wallrun <= 800 && vlen(self.velocity) > 800) self.velocity = self.velocity + normalize(self.velocity)*-2.0;
		else if (self.vel_before_wallrun <= 850 && vlen(self.velocity) > 850) self.velocity = self.velocity + normalize(self.velocity)*-2.0;
		else if (self.vel_before_wallrun <= 900 && vlen(self.velocity) > 900) self.velocity = self.velocity + normalize(self.velocity)*-2.0;
		else if (self.vel_before_wallrun > 900 && vlen(self.velocity) > self.vel_before_wallrun) self.velocity = self.velocity + normalize(self.velocity)*-2.0;
		
		if(vlen(self.velocity) > 1050) self.velocity = self.velocity + normalize(self.velocity)*-2.5;
		if(vlen(self.velocity) > 1200) self.velocity = self.velocity + normalize(self.velocity)*-1.5;
		if(vlen(self.velocity) > 1250) self.velocity = self.velocity + normalize(self.velocity)*-1.00;
		if(vlen(self.velocity) > 1300) self.velocity = self.velocity + normalize(self.velocity)*-1.00;
		//////////////////////////////////
		
		
		
	//UP OR DOWN SLOPE
			local float accel_factor = (1+self.z_height - self.origin_z);
			if(accel_factor > 5) accel_factor =5.0;
			
			if(self.z_height > self.origin_z+1) 
			{
				self.velocity = self.velocity + normalize(self.velocity)*accel_factor;				//bprint(ftos(accel_factor));
				//bprint(" accel ");
			}
			else if(self.z_height +1 < self.origin_z) 
			{
				//self.velocity = self.velocity + normalize(self.velocity)*0.1;					//bprint(ftos(decel_factor));
			}
			else 
			{
				self.z_height = self.origin_z; 				//bprint(" no slope\n");
				if(vlen(self.velocity) > 900) self.velocity = self.velocity + normalize(self.velocity)*(-5.0);
				else if(vlen(self.velocity) > 750) self.velocity = self.velocity + normalize(self.velocity)*(-4);
				else if(vlen(self.velocity) > 500) self.velocity = self.velocity + normalize(self.velocity)*(-3);
				else if(vlen(self.velocity) >= 400) self.velocity = self.velocity + normalize(self.velocity)*(-2.5);
			}
			/////////////////////////////
		
		
		
	//BETTER DIRECTION CONTROL
		local vector look_xy = v_forward;
		look_xy_z = 0;  		//XY speed, no Z
		look_xy = normalize(look_xy);
		
		local vector velo = normalize(self.velocity);

		//bprint(ftos(-v_forward_z - velo_z));
		//bprint(" ");
		
		if(self.movement_x ==400)  //ALL OF THIS TO MAKE SURE YOU DONT FLY UP WHEN SKIING AND LOOKING UPWARD
		{
			if(v_forward_z - velo_z <0.33) self.velocity = vlen(self.velocity) * normalize(self.velocity + v_forward*27);  

			else self.velocity = vlen(self.velocity) * normalize(self.velocity + look_xy*27);  //APRIL     
		}
		else if(self.movement_x ==-400)
		{
			if(-v_forward_z - velo_z <0.33) self.velocity = vlen(self.velocity) * normalize(self.velocity + v_forward*-27);  //APRIL

			else self.velocity = vlen(self.velocity) * normalize(self.velocity + look_xy*-27);  //APRIL
		}
		////////////////////////////////
			
	//IF CEILING ABOVE, ADD SPEED DOWNWARD NOT TO HIT CEILING
		if(pointcontents(self.origin + '0 0 41') == CONTENT_SOLID || pointcontents(self.origin + '0 0 42') == CONTENT_SOLID || pointcontents(self.origin + '0 0 43') == CONTENT_SOLID || pointcontents(self.origin + '0 0 44') == CONTENT_SOLID) self.velocity = self.velocity + '0 0 -55';
		//////////////
		
		
		
	//CONDITION TO TURN SKIING TO >OFF<
		if(vlen(self.velocity) < 450 && self.velocity_z > -40) 
		{
			self.skiing_on =0;   //SKIING OFF
			self.ski_tilt=0;
			self.ski_button =0;
			sound (self, CHAN_VOICE, "trig/br_null.wav", 0.4, ATTN_NORM);
			//sound (self, CHAN_VOICE, "misc/br_grind5.wav", 0.4, ATTN_NORM); //fade out
		}
		/////////////////////////////////////


		
	//HOME TOWARD FLAG	
		flag_homing_slide(500, 55);
	/////////////////////////
		
		
		local vector vel_xy = self.velocity;
		vel_xy_z = 0;  		//XY speed, no Z
		

	//IF ABOUT TO HIT SOMETHING - ADD SPEED UPWARD, SO YOU DONT GET STUCK ON BOTTOMS OF SLIDES
			if (fraction < 1)  //APRIL
			{
				if(self.z_height > self.origin_z+1.5) 
				{
					if((self.velocity_z < -470 || vlen(vel_xy) > 470) && time - self.ski_time > 0.30)
					{
						self.velocity = self.velocity + '0 0 125';
						//bprint("downhill obstacle\n");
					}
				}
				else 
				{
					if(self.velocity_z < 500 && (pointcontents(self.origin + '0 0 48') !=CONTENT_SOLID || pointcontents(self.origin + '0 0 47') !=CONTENT_SOLID || pointcontents(self.origin + '0 0 46') !=CONTENT_SOLID)) 
					{
						if(self.airborn_pos < 200)
						{
							self.velocity = self.velocity + '0 0 45';
						}
					}
							
				}
			
			}
		
		////////////////////////////////////////////////
		
			self.z_height = self.origin_z; //record z_origin
		

		
	
		
	//PROBABLY HAS TO DO WITH WHAT ANIMATIONS TO PLAY WHILE SKIING
		if(vlen(self.velocity) > 400 && self.skiing_on !=0)
		{
			if(self.impulse !=41 && self.impulse !=42 && self.airborn_pos < 50) self.ski_time2 = time;
		}
		///////////////////////////////////////////
		
		
		
	//PLAY THE GRINDING NOISE WITH SOME SPACING	
		if(trace_startsolid == TRUE && (self.velocity_z < -470 || vlen(vel_xy) > 470))
		{
			
			
			if (self.ski_sound_counter >= 64 && time - self.ski_time > 0.12)
			{
				//bprint("ski yes\n");
				if(vlen(self.velocity) > 725)
				{
					if (random() < 0.25) 		sound (self, CHAN_VOICE, "misc/br_grind1.wav", 0.40, ATTN_NORM);
					else if (random() < 0.50) 	sound (self, CHAN_VOICE, "misc/br_grind2.wav", 0.40, ATTN_NORM);
					else if (random() < 0.75) 	sound (self, CHAN_VOICE, "misc/br_grind3.wav", 0.40, ATTN_NORM);
					else 				sound (self, CHAN_VOICE, "misc/br_grind4.wav", 0.40, ATTN_NORM);
				}
				else if(vlen(self.velocity) > 470)
				{
					if (random() < 0.25) 		sound (self, CHAN_VOICE, "misc/br_grind1.wav", 0.31, ATTN_NORM);
					else if (random() < 0.50) 	sound (self, CHAN_VOICE, "misc/br_grind2.wav", 0.31, ATTN_NORM);
					else if (random() < 0.75) 	sound (self, CHAN_VOICE, "misc/br_grind3.wav", 0.31, ATTN_NORM);
					else 				sound (self, CHAN_VOICE, "misc/br_grind4.wav", 0.31, ATTN_NORM);
				}
		

				self.ski_sound_counter = 0;	
			
			}
			else if (self.ski_sound_counter < 64) self.ski_sound_counter +=1;  //32 -> 64
		}
		////////////////////////
		
		
	//IF SLIDING ALONG WALL - BUMP AWAY FROM THE WALL EVERY FRAME SO YOU DONT GET STUCK
		traceline (self.origin, self.origin + v_right*(-59), TRUE, self);

		if(trace_fraction < 1) setorigin(self, self.origin + v_right*0.99);
		else
		{
			traceline (self.origin, self.origin + v_right*(59), TRUE, self);
			if(trace_fraction < 1) setorigin(self, self.origin + v_right*(-0.99));
		}
		//////////////////////////////////////////////////////
				
	}
	
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
		if(vlen(self.velocity) > 590 && self.bounce_on ==0 && v_forward_z >=-0.6) 
		{
			self.ski_time=time;
			self.bounce_on =1;
			self.ski_sound_counter =1;
			//bprint("primed\n");
		}
	}

	
	
	if((pointcontents(self.origin + '0 0 -47') == CONTENT_WATER || pointcontents(self.origin + '0 0 -47') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -47') == CONTENT_LAVA) && self.bounce_on !=0 && time-self.ski_time < slide_duration)
	{

		if(pointcontents(self.origin + '0 0 -24') == CONTENT_WATER || pointcontents(self.origin + '0 0 -24') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -24') == CONTENT_LAVA) 
		{
			if(self.bounce_on ==1) self.bounce_on =2;
		}
		
		if(self.bounce_on ==2 || self.bounce_on ==3 || self.bounce_on ==4)
		{
			if(pointcontents(self.origin + '0 0 -40') == CONTENT_WATER || pointcontents(self.origin + '0 0 -40') == CONTENT_SLIME || pointcontents(self.origin + '0 0 -40') == CONTENT_LAVA) 
			{
				if(self.velocity_z < -550) self.velocity_z = self.velocity_z*(-0.7);
				
				self.velocity = self.velocity + '0 0 70'; 
			
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*8;   //NOVEM 3 -> 8
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-8;   //NOVEM 3 -> 8
				
				self.ski_time -=0.05;
				
				
				if(self.bounce_on ==1 || self.bounce_on ==2) self.bounce_on =3;	
			}

			
			if(vlen(horiz_vel) < 325)
			{
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*12; //NOVEM 12 -> 18
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-12;
				//bprint("horizontal1\n");
			}
			else if(vlen(horiz_vel) < 525)
			{
				if(self.velocity_z > 100 && self.movement_x ==400) self.velocity = self.velocity + v_forward*24; 	//NOVEM 18 -> 27
				else if(self.velocity_z > 100 && self.movement_x ==-400) self.velocity = self.velocity + v_forward*-24;
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
			
	
		}
		
		if(self.bounce_on ==3)
		{
			if(vlen(self.velocity) > 500) sound (self, CHAN_AUTO, "misc/br_bounce.wav", 0.59, ATTN_NORM);
				if(vlen(self.velocity) > 400) sound (self, CHAN_AUTO, "misc/br_bubble.wav", 0.9, ATTN_NORM);
				self.bounce_on = 4;
		}
				
		
	}
	
	if(!self.button2 || self.waterlevel ==3)
	{
		self.bounce_on =0;
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