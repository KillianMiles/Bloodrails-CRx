void() clean_rail_fade = 
{
	
	self.think = clean_rail_fade;
	self.nextthink = time + 0.10;
//if(self.alpha == 0.005) return;

	if (self.cnt == 6)
	{
		self.alpha = 0.85;
	}
	else if (self.cnt == 5)
	{
		if(self.alpha == 0.55) 
		{
			self.alpha = 0.35;
		}
		else self.alpha = 0.4;
	}
	else if (self.cnt == 4)
	{
		if(self.alpha ==0.35) self.alpha = 0.18;
		else self.alpha = 0.2;
	}
	else if (self.cnt == 3)
	{
		if(self.alpha == 0.18) self.alpha = 0.06;
		else self.alpha = 0.1;
	}
	else if (self.cnt == 2)
	{
		if(self.alpha ==0.06) self.alpha = 0.01;
		else self.alpha = 0.05;
	}
	else if (self.cnt == 1) 
	{
		if(self.alpha ==0.01) self.alpha = 0.01;
		else self.alpha = 0.01;
		self.think = SUB_Remove;
		self.nextthink = time + 0.05;
		
	}	
	self.cnt = self.cnt - 1;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




void(vector start, vector end, vector myAngles, entity shooter) clean_rail_make =
{
	local vector vec,  loopsrc,  destination;
	local vector drawsrc;
	local entity thedude;
	local float traillen, segments, old_segments, railcolor;
	entity prj;
	//local float alpha_rand;
	local float spacing_long;
	
	local vector shootDir = end-start;
	shootDir = normalize(shootDir);
	local vector forwardAngles = vectoangles(shootDir);
	makevectors(forwardAngles);

	drawsrc = start;

	destination = end ;
	
	loopsrc = drawsrc;
	thedude = self;
	
	
	if (self.height == elohim_team1) 
		{
			if(random() < 0.2) railcolor = 3;   //Orange
			else railcolor = 1;    //red
		}
		else if (self.height == elohim_team2) 
		{
			if(random() < 0.3) railcolor = 2;   //LIGHT-blue
			else railcolor = 0;      //White blue	
		}
		else 
		{
			if(random() < 0.2) railcolor = 2;   //Light-blue
			else railcolor = 0;      //White blue
		}
		

	traceline(drawsrc, destination, TRUE, self);
	traillen = vlen(trace_endpos - drawsrc);
	

	if(pointcontents(trace_endpos) == CONTENT_SKY && shooter == self)
	{
		segments = 2;
		spacing_long = floor(traillen / segments);
		while (segments)
		{
			vec = normalize(trace_endpos - drawsrc);
			prj = spawn ();
		
			prj.owner = shooter;
			prj.movetype = MOVETYPE_NOCLIP;
			prj.solid = SOLID_NOT;
			prj.angles = vectoangles(shootDir);
			prj.touch = SUB_Null;
			prj.classname = "railtrail";
			
			prj.skin = railcolor;
			setmodel (prj, "progs/bloodrailz/rail_long4600.mdl");  //  uncomment when engaging
		
			setorigin (prj, drawsrc + vec * spacing_long * (segments-1));
			prj.velocity = '0 0 0';	
			setsize (prj, 0, 0);	
			prj.frame = 4;	
			prj.think = clean_rail_fade;
			prj.nextthink = time + 0.15 + (segments*0.005); // delay fade time using segment number for neat effect (vf)
			segments = segments - 1;
			prj.cnt = 5;	
		}
	}
	else if (pointcontents(trace_endpos) != CONTENT_SKY && shooter == self)
	{
		//local float partial_segments = 0;
		//local float whole_segments = 0;
		local float spacing = 0;
		
		if(traillen < 80)
		{
			segments = 1;
		}

			
		if(traillen >=80) segments = 3;
		
		spacing = floor(traillen/ segments);
		old_segments = segments;
		
		
			//bprint(ftos(segments));
			//bprint(" segments\n");
			//bprint(ftos(traillen));
			//bprint(" traillen\n");
		
		while (segments)
		{
			vec = normalize(trace_endpos - drawsrc);
			prj = spawn ();
		
			prj.owner = self;
			prj.movetype = MOVETYPE_NOCLIP;
			prj.solid = SOLID_NOT;
			prj.angles = vectoangles(shootDir);
			prj.touch = SUB_Null;
			prj.classname = "railtrail";
			prj.skin = railcolor;
			
			
			
			if(traillen >= 3000) 
			{
				if(segments == 1)
				{
					setmodel (prj, "progs/bloodrailz/rail_long2400.mdl");
					setorigin (prj, drawsrc + vec * 20);
				}
				else if(segments == 2)
				{
					setmodel (prj, "progs/bloodrailz/rail_long2400.mdl");
					setorigin (prj, drawsrc + vec * (traillen-2400)*0.5);
				}
				else if(segments == 3)
				{
					setmodel (prj, "progs/bloodrailz/rail_long2400.mdl");
					setorigin (prj, drawsrc + vec * (traillen-2400));
				}
			}
			else if(traillen >= 1500) 
			{
				if(segments == 1)
				{
					setmodel (prj, "progs/bloodrailz/rail_long1200.mdl");
					setorigin (prj, drawsrc + vec * 20);
				}
				else if(segments == 2)
				{
					setmodel (prj, "progs/bloodrailz/rail_long1200.mdl");
					setorigin (prj, drawsrc + vec * (traillen-1200)*0.5);
				}
				else if(segments == 3)
				{
					setmodel (prj, "progs/bloodrailz/rail_long1200.mdl");
					setorigin (prj, drawsrc + vec * (traillen-1200));
				}
			}
			else if(traillen >= 900) 
			{
				if(segments == 1)
				{
					setmodel (prj, "progs/bloodrailz/rail_long600.mdl");
					setorigin (prj, drawsrc + vec * 20);
				}
				else if(segments == 2)
				{
					setmodel (prj, "progs/bloodrailz/rail_long600.mdl");
					setorigin (prj, drawsrc + vec * (traillen-600)*0.5);
				}
				else if(segments == 3)
				{
					setmodel (prj, "progs/bloodrailz/rail_long600.mdl");
					setorigin (prj, drawsrc + vec * (traillen-600));
					//prj.skin = 1;
				}
			}
			else if(traillen >= 425) 
			{
				
				if(segments == 1)
				{
					setmodel (prj, "progs/bloodrailz/rail_long300.mdl");
					setorigin (prj, drawsrc + vec * 20);
				}
				else if(segments == 2)
				{
					if(traillen > 700) 
					{
						setmodel (prj, "progs/bloodrailz/rail_long600.mdl");
						setorigin (prj, drawsrc + vec * (traillen-600)*0.5);
					}
					else 
					{
						setmodel (prj, "progs/bloodrailz/rail_long300.mdl");
						setorigin (prj, drawsrc + vec * (traillen-300)*0.5);
					}
				}
				else if(segments == 3)
				{
					setmodel (prj, "progs/bloodrailz/rail_long300.mdl");
					setorigin (prj, drawsrc + vec * (traillen-300));
					//prj.skin = 1;
				}
			}
			else if(traillen >= 175) 
			{
				if(segments == 1)
				{
					setmodel (prj, "progs/bloodrailz/rail_long150.mdl");
					setorigin (prj, drawsrc + vec * 20);
				}
				else if(segments == 2)
				{
					if(traillen > 700) 
					{
						setmodel (prj, "progs/bloodrailz/rail_long300.mdl");
						setorigin (prj, drawsrc + vec * (traillen-300)*0.5);
					}
					else 
					{
						setmodel (prj, "progs/bloodrailz/rail_long150.mdl");
						setorigin (prj, drawsrc + vec * (traillen-150)*0.5);
					}

				}
				else if(segments == 3)
				{
					setmodel (prj, "progs/bloodrailz/rail_long150.mdl");
					setorigin (prj, drawsrc + vec * (traillen-150));
					//prj.skin = 1;
				}
			}
			
			else if(traillen >= 80) 
			{
				if(segments == 1)
				{
					setmodel (prj, "progs/bloodrailz/rail_long60.mdl");
					setorigin (prj, drawsrc + vec * 20);
				}
				else if(segments == 2)
				{

					setmodel (prj, "progs/bloodrailz/rail_long60.mdl");
					setorigin (prj, drawsrc + vec * (traillen-60)*0.5);


				}
				else if(segments == 3)
				{
					setmodel (prj, "progs/bloodrailz/rail_long60.mdl");
					setorigin (prj, drawsrc + vec * (traillen-150));
					//prj.skin = 1;
				}
			}
				
				
			else 
			{
				if(traillen < 80) setmodel (prj, "progs/bloodrailz/rail_long60.mdl");
				setorigin (prj, drawsrc + vec * 2);
			}
			
			setsize (prj, 0, 0);
			//setmodel (prj, "progs/bloodrailz/s_blood_1024.spr");
			
			prj.velocity = '0 0 0';	

			//alpha_rand = random();
			//if (alpha_rand < 0.5) prj.alpha = 0.60;
			//else prj.alpha = 1;
			
			prj.alpha = 0.85;
		
			prj.frame = 4;	
			prj.think = clean_rail_fade;
			prj.nextthink = time + 0.12 + (segments*0.002); //fade delay
			//prj.nextthink = time + 5;
			segments = segments - 1;
			prj.cnt = 5;	
	
		}
	}


	
	else if (shooter != self)
	{
		traillen = vlen(trace_endpos - drawsrc);
		local float seg_total;
	
		segments = 2;
		seg_total = segments;
		
		
		//bprint(ftos(segments));
		//bprint(" segments\n");
	
		while (segments)
		{
			vec = normalize(trace_endpos - drawsrc);
			prj = spawn ();
			prj.owner = self;
			prj.movetype = MOVETYPE_NOCLIP;
			prj.solid = SOLID_NOT;
			prj.angles = vectoangles(shootDir);
			prj.touch = SUB_Null;
			prj.classname = "railtrail";
			setmodel (prj, "progs/bloodrailz/rail2_1.mdl");
				
			setsize (prj, 0, 0);	
		
		
			if (self.height == elohim_team1) 
			{
				if(random() < 0.2) prj.skin = 3;   //Orange
				else prj.skin = 1;    //red
			
				if (segments ==1) prj.skin = 2;
			}
			else if (self.height == elohim_team2) 
			{
				if(random() < 0.2) prj.skin = 2;   //light-blue
				else prj.skin = 0;      //white blue	
			
				if (segments ==1) prj.skin = 1;
			}
		
			else 
			{
				if(random() < 0.2) prj.skin = 2;   //Light-blue
				else prj.skin = 0;      //White blue
			
				if (segments ==1) prj.skin = 1;
			}
		
		
			if(segments == 1) setorigin (prj, drawsrc);
			else if(segments == 2) 
			{
				setorigin (prj, drawsrc + vec * 120);
				setmodel (prj, "progs/bloodrailz/rail3_1.mdl");
			}
		
			prj.velocity = '0 0 0';	
		

			prj.alpha = 0.85;
			
		
			prj.frame = 4;	
			prj.think = clean_rail_fade;
			prj.nextthink = time + 0.12 + (segments*0.018); // delay fade time using segment number for neat effect (vf)
			//prj.nextthink = time + 5;
			segments = segments - 1;
		
			prj.cnt = 5;	
	
		}
	}
}




void(vector start, vector p0, vector p1, vector p2, vector p3) clean_DrawCurvedRail=
{
	//local vector p0, p1, p2, p3;
	local float t = 1, count = 1;
	local float oneMinusT = 1-t;
	
	local vector last_result = '0 0 0';
	local vector result = '0 0 0';
	
	local float pointCount;
	
	local float seg1 = vlen(p3-p2);
	local float seg2 = vlen(p2-p1);
	local float seg3 = vlen(p1-p0);
	
	local float total_length = seg1+seg2+seg3;
	
	local float seg = 0;
	
	if(total_length < 50) pointCount = 2;
	else if(total_length < 60) pointCount = 3;
	else if(total_length < 80) pointCount = 4;
	else if(total_length < 100) pointCount = 5;	     //0
	
	else if (total_length < 150) pointCount = 4; 
	else if (total_length < 200) pointCount = 5; 
	else if (total_length < 300) pointCount = 7;
	else if (total_length < 400) pointCount = 8; //1
	
	else if (total_length < 500) pointCount = 9;
	else if (total_length < 600) pointCount = 10;
	else if (total_length < 650) pointCount = 11;
	else if (total_length < 750) pointCount = 12; //2
	
	else if (total_length < 800) pointCount = 13;
	else if (total_length < 900) pointCount = 14;
	else if (total_length < 1000) pointCount = 14;
	else if (total_length < 1200) pointCount = 15;
	else if (total_length < 1400) pointCount = 15;
	else if (total_length < 1750) pointCount = 16;//3
	
	else if (total_length < 2000) pointCount = 16;
	else if (total_length < 3000) pointCount = 17; //4
	
	else if (total_length < 4000) pointCount = 17;
	else if (total_length < 4500) pointCount = 18; //5
	
	else if (total_length < 5500) pointCount = 17;
	else if (total_length < 6000) pointCount = 18;
	else  			      pointCount = 19; //6
	
	
	if((total_players_global > 7 || smoke_ent_number > 8)) 
	{
		if(total_players_global <= 10)
		{
			if(pointCount == 17) pointCount = pointCount - 1;
			else if(pointCount == 18) pointCount = pointCount - 1;
			else if(pointCount == 19) pointCount = pointCount - 1;
		}
		if(total_players_global > 10)
		{
			if(pointCount == 17) pointCount = pointCount - 1;
			else if(pointCount == 18) pointCount = pointCount - 2;
			else if(pointCount == 19) pointCount = pointCount - 2;
		}
	}
	
	//bprint(ftos(total_length));
	//bprint("\n");
	//bprint(ftos(pointCount));
	//bprint(" segments\n");
	
	local float sky_long =0;
	

	if(pointcontents(p3) == CONTENT_SKY && total_length >= 3000) 
	{
		sky_long =2;
	}
	else if(pointcontents(p3) == CONTENT_SKY && total_length >= 1200) 
	{
		sky_long =1;
	}
	
	//self.curve_seg_count = pointCount;
	
	if(total_length < 100) 		seg = 0 ;
	else if(total_length < 400) 	seg = 1 ;
	else if(total_length < 750) 	seg = 2 ;
	else if(total_length < 1750)	seg = 3 ;
	else if(total_length < 3000) 	seg = 4 ;  //232
	else if(total_length < 4500) 	seg = 5 ;  //289
	else 				seg = 6 ;  //376
	
	local float delta = (1.0 / pointCount) -.001;
	

	while(t >= 0)
	{
		last_result = result;
		oneMinusT = 1-t;
		result = (oneMinusT*oneMinusT*oneMinusT) * p0 + 
			 (3*oneMinusT*oneMinusT*t)*p1 + 
			 (3*oneMinusT*t*t)*p2 + 
			 (t*t*t)*p3;
		if(t <= 1-delta )
		{
			count +=1;
			
			local vector dir = last_result - result;
			
			if(sky_long ==0)
			{
				local entity prj;
				
				
				prj = spawn ();
		
				prj.owner = self;
				prj.movetype = MOVETYPE_NOCLIP;
				prj.solid = SOLID_NOT;
				prj.angles = vectoangles(dir);
		
				prj.touch = SUB_Null;
				prj.classname = "railtrail";
		
			
				if(seg == 0) setmodel (prj, "progs/bloodrailz/rail_a.mdl");
				else if(seg == 1) setmodel (prj, "progs/bloodrailz/rail_b.mdl");
				else if(seg == 2) setmodel (prj, "progs/bloodrailz/rail_c.mdl");
				else if(seg == 3) setmodel (prj, "progs/bloodrailz/rail_d.mdl");
				else if(seg == 4) setmodel (prj, "progs/bloodrailz/rail_e.mdl");
				else if(seg == 5) setmodel (prj, "progs/bloodrailz/rail_f.mdl");
				else if(seg == 6) setmodel (prj, "progs/bloodrailz/rail_g.mdl");
			
			
				
				setsize (prj, 0, 0);	
		
				if (self.height == elohim_team1) 
				{
					if(random() < 0.25) prj.skin = 3;   //Orange
					//else if(random() > 0.87) prj.skin = 4;   //Dark-red
					else prj.skin = 1;    //red
			
				}
				else if (self.height == elohim_team2) 
				{
					prj.skin = 0;   //White-blue
					//if(random() < 0.13) prj.skin = 0;   //White-blue
					//else if(random() > 0.87) prj.skin = 5;   //Dark-blue
					//else prj.skin = 2;      //light blue	
				}
		
				else 
				{
					prj.skin = 0;      //White blue
					//if(random() < 0.13) prj.skin = 2;   //Light-blue
					//else if(random() > 0.87) prj.skin = 5;   //Dark-blue
					//else prj.skin = 0;      //White blue
				}
		
			
				local float alpha_rand = random();
				if (alpha_rand < 0.5) prj.alpha = 0.60;
				else prj.alpha = 1;
			
				/*
				if(count ==pointCount)
				{
					if(vlen(dir) < 20) setorigin (prj, p0 + normalize(dir)*10);  //blahnew
					else if(vlen(dir) < 33) setorigin (prj, p0 + normalize(dir)*15);
					else if(vlen(dir) < 45) setorigin (prj, p0 + normalize(dir)*22); 
					else if(vlen(dir) < 60) setorigin (prj, p0 + normalize(dir)*30); 
					else if(vlen(dir) < 120) setorigin (prj, p0 + normalize(dir)*60);
					else if(vlen(dir) < 240) setorigin (prj, p0 + normalize(dir)*115); 
					else if(vlen(dir) < 295) setorigin (prj, p0 + normalize(dir)*140); 
					else if(vlen(dir) < 400) setorigin (prj, p0 + normalize(dir)*175); 

					
					prj.alpha = 0.55;
				}
				
				else if(count ==2)
				{
					if(vlen(dir) < 20) setorigin (prj, result + normalize(dir)*10);  //blahnew
					else if(vlen(dir) < 33) setorigin (prj, result + normalize(dir)*15);
					else if(vlen(dir) < 45) setorigin (prj, result + normalize(dir)*22); 
					else if(vlen(dir) < 60) setorigin (prj, result + normalize(dir)*30); 
					else if(vlen(dir) < 120) setorigin (prj, result + normalize(dir)*60);
					else if(vlen(dir) < 240) setorigin (prj, result + normalize(dir)*115); 
					else if(vlen(dir) < 295) setorigin (prj, result + normalize(dir)*140); 
					else if(vlen(dir) < 400) setorigin (prj, result + normalize(dir)*175); 
	
					
					prj.alpha = 0.55;
					prj.skin = 3;
				}
				
				else 
				*/
				setorigin (prj, result);
			
				prj.velocity = '0 0 0';	
				
				

			
				if(count!=pointCount+1)
				{
					if(vlen(dir) < 20) setmodel (prj, "progs/bloodrailz/rail_a.mdl");
					else if (vlen(dir) < 33) setmodel (prj, "progs/bloodrailz/rail_b.mdl");
					else if (vlen(dir) < 45) setmodel (prj, "progs/bloodrailz/rail_b1.mdl");
					else if (vlen(dir) < 60) setmodel (prj, "progs/bloodrailz/rail_c.mdl");
					else if (vlen(dir) < 120) setmodel (prj, "progs/bloodrailz/rail_d.mdl");  //120 length	
					else if (vlen(dir) < 240) setmodel (prj, "progs/bloodrailz/rail_e.mdl");  //232 length
					else if (vlen(dir) < 295) setmodel (prj, "progs/bloodrailz/rail_f.mdl");  //289 length
					else if (vlen(dir) < 400) setmodel (prj, "progs/bloodrailz/rail_g.mdl");  //376 length
				}
				
				
				else if(count==pointCount+1)
				{
					
					if(vlen(dir) < 20) setmodel (prj, "progs/bloodrailz/rail_a.mdl");
					else if (vlen(dir) < 33) setmodel (prj, "progs/bloodrailz/rail_b.mdl");
					else if (vlen(dir) < 45) setmodel (prj, "progs/bloodrailz/rail_b1.mdl");
					else if (vlen(dir) < 60) setmodel (prj, "progs/bloodrailz/rail_c.mdl");
					else if (vlen(dir) < 120 && vlen(result-p0) >= 70) setmodel (prj, "progs/bloodrailz/rail_d.mdl");  //120 length	
					else if (vlen(dir) < 240 && vlen(result-p0) >= 110) setmodel (prj, "progs/bloodrailz/rail_e.mdl");  //232 length
					else if (vlen(dir) < 295 && vlen(result-p0) >= 135) setmodel (prj, "progs/bloodrailz/rail_f.mdl");  //289 length
					else if (vlen(dir) < 400 && vlen(result-p0) >= 160) setmodel (prj, "progs/bloodrailz/rail_g.mdl");  //376 length
					else if (vlen(dir) < 120 && vlen(result-p0) < 70) setmodel (prj, "progs/bloodrailz/rail_d_half.mdl");  //120 length	
					else if (vlen(dir) < 240 && vlen(result-p0) < 110) setmodel (prj, "progs/bloodrailz/rail_e_half.mdl");  //232 length
					else if (vlen(dir) < 295 && vlen(result-p0) < 135) setmodel (prj, "progs/bloodrailz/rail_f_half.mdl");  //289 length
					else if (vlen(dir) < 400 && vlen(result-p0) < 160) setmodel (prj, "progs/bloodrailz/rail_g_half.mdl");  //376 length
					
					//if (prj.model == "progs/bloodrailz/rail_g_half.mdl") bprint("rail_G_half\n");
					//else if (prj.model == "progs/bloodrailz/rail_f_half.mdl") bprint("rail_F_half\n");
					//else if (prj.model == "progs/bloodrailz/rail_e_half.mdl") bprint("rail_E_half\n");
					//else if (prj.model == "progs/bloodrailz/rail_d_half.mdl") bprint("rail_D_half\n");
					
					//prj.skin = 3;
				}


				//if(count==pointCount) prj.skin = 4;
				//if(count==pointCount+2) prj.skin = 4;
				
				//bprint(ftos(count-1));
				//bprint(" drawn\n");

				prj.frame = 4;	
				prj.think = clean_rail_fade;
				prj.nextthink = time + 0.25 + (t*0.002); //fade delay 0.2 -> 0.25 so that curved rails hang a bit longer
				prj.cnt = 5;	
			}
			
			sky_long -=1;
			if(sky_long <0) sky_long =0;
		}
		t = t - delta;
	}
}
