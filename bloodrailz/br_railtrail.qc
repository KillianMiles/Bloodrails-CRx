void() clean_rail_fade = 
{
	
	self.think = clean_rail_fade;
	self.nextthink = time + 0.10;
//if(self.alpha == 0.005) return;

	if (self.cnt == 6)
		self.alpha = 0.7;
	else if (self.cnt == 5)
		self.alpha = 0.4;
	else if (self.cnt == 4)
		self.alpha = 0.2;
	else if (self.cnt == 3)
		self.alpha = 0.1;
	else if (self.cnt == 2)
		self.alpha = 0.05;
	else if (self.cnt == 1) 
	{
		self.alpha = 0.01;
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
	local float alpha_rand;
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
			//else if(random() < 0.5) railcolor = 4;   //Dark-red
			else railcolor = 1;    //red
		}
		else if (self.height == elohim_team2) 
		{
			if(random() < 0.3) railcolor = 2;   //LIGHT-blue
			//else if(random() < 0.5) railcolor = 5;   //Dark-blue
			else railcolor = 0;      //White blue	
		}
		else 
		{
			if(random() < 0.2) railcolor = 2;   //Light-blue
			//else if(random() < 0.5) railcolor = 5;   //Dark-blue
			else railcolor = 0;      //White blue
		}
		

	// now using drawsrc instead of src now, so we trace damage from eye position and trail from gun position
	traceline(drawsrc, destination, TRUE, self);
	traillen = vlen(trace_endpos - drawsrc);

	if(pointcontents(trace_endpos) == CONTENT_SKY && shooter == self)
	{
		segments = 10;
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
			setmodel (prj, "progs/bloodrailz/rail5.mdl");  //  uncomment when engaging
		
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




	else
	{
		local float rail_model = 0;
		local float partial_segments = 0;
		local float whole_segments = 0;
		local float spacing = 0;
		
		if(traillen <= 360) rail_model = 1;
		else if(traillen > 360 && traillen < 3000) rail_model = 2;
		else if(traillen >= 3000) rail_model = 3;
		
		if(rail_model == 1) 
			{
				partial_segments = traillen % 60;
				whole_segments = (traillen - partial_segments) / 60;
			}
		else if(rail_model == 2) 
			{
				partial_segments = traillen % 180;
				whole_segments = (traillen - partial_segments) / 180;
			}
		else if(rail_model == 3) 
			{
				partial_segments = traillen % 360;
				whole_segments = (traillen - partial_segments) / 360;
			}
			
		segments = whole_segments * 2;
		spacing = floor(traillen/ segments);
		old_segments = segments;
		
		//segments = floor(traillen / 50);
		//sprint(self, ftos(segments));
		//sprint(self, "\n ");
		//sprint(self, ftos(traillen));
		//sprint(self, "\n ");
		
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
			
			
			if(rail_model == 1) setmodel (prj, "progs/bloodrailz/rail1_1.mdl");
			else if (rail_model == 2) setmodel (prj, "progs/bloodrailz/rail2_1.mdl");
			else if (rail_model == 3) setmodel (prj, "progs/bloodrailz/rail3_1.mdl");
				
			
			//if (rail_model == 3 && partial_segments < 250 && segments == old_segments) setmodel (prj, "progs/bloodrailz/rail2_1.mdl");
			//if (rail_model == 2 && partial_segments < 120 && segments == old_segments) setmodel (prj, "progs/bloodrailz/rail1_1.mdl");
			//if (rail_model == 1 && partial_segments < 15 && segments == old_segments) setmodel (prj, "progs/bloodrailz/rail0.mdl");
			
			if (rail_model == 3 && segments == old_segments) setmodel (prj, "progs/bloodrailz/rail2_1.mdl");
			if (rail_model == 2 && segments == old_segments) setmodel (prj, "progs/bloodrailz/rail1_1.mdl");
			if (rail_model == 1 && partial_segments < 15 && segments == old_segments) setmodel (prj, "progs/bloodrailz/rail0.mdl");
				
			setsize (prj, 0, 0);	

			setorigin (prj, drawsrc + vec * spacing * (segments - 1));
			
			prj.velocity = '0 0 0';	

			alpha_rand = random();
			if (alpha_rand < 0.5) prj.alpha = 0.60;
			else prj.alpha = 1;
		
			prj.frame = 4;	
			prj.think = clean_rail_fade;
			prj.nextthink = time + 0.12 + (segments*0.002); //fade delay
			segments = segments - 1;
			prj.cnt = 5;	
	
		}
	}


	
	if (shooter != self)
	{
		traillen = vlen(trace_endpos - drawsrc);
		segments = floor(traillen / 33);
		local float seg_total;
	
		if(segments > 21) segments = 21;
		seg_total = segments;
		//sprint(self, ftos(segments));
	
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
			setmodel (prj, "progs/bloodrailz/rail1.mdl");
				
			setsize (prj, 0, 0);	
		
		
			if (self.height == elohim_team1) 
			{
				if(random() < 0.2) prj.skin = 3;   //Orange
				else prj.skin = 1;    //red
			
				if (segments < 2) prj.skin = 2;
				else if (segments < 3) prj.skin = 0;
				else if (segments < 5) prj.skin = 5;
			
			}
			else if (self.height == elohim_team2) 
			{
				if(random() < 0.2) prj.skin = 2;   //light-blue
				else prj.skin = 0;      //white blue	
			
				if (segments < 2) prj.skin = 1;
				else if (segments < 3) prj.skin = 3;
				else if (segments < 5) prj.skin = 4;
			
			}
		
			else 
			{
				if(random() < 0.2) prj.skin = 2;   //Light-blue
				//else if(random() > 0.87) prj.skin = 5;   //Dark-blue
				else prj.skin = 0;      //White blue
			
				if (segments < 2) prj.skin = 1;
				else if (segments < 3) prj.skin = 3;
				else if (segments < 5) prj.skin = 4;
			}
		
		
			setorigin (prj, drawsrc + vec * 40 * (segments));
			prj.velocity = '0 0 0';	
		

			prj.alpha = ( (1 + seg_total - segments)/seg_total ) * 0.6;
			if(prj.alpha <=0) prj.alpha = 0.01;
			
			if (seg_total - segments == 0)   // || seg_total - segments == 1) 
			{
				//sprint(self, "alpha ");
				prj.alpha = 0.01;
			}
		
			prj.frame = 4;	
			prj.think = clean_rail_fade;
			prj.nextthink = time + 0.12 + (segments*0.025); // delay fade time using segment number for neat effect (vf)
			segments = segments - 1;
		
			prj.cnt = 5;	
	
		}
	}
}




void( vector p0, vector p1, vector p2, vector p3) clean_DrawCurvedRail=
{
	//local vector p0, p1, p2, p3;
	local float t = 1;
	local float oneMinusT = 1-t;
	
	local vector last_result = '0 0 0';
	local vector result = '0 0 0';
	
	local float pointCount;
	local float total_length = vlen(p3-p0);
	
	local float seg = 0;
	
	if(total_length < 100) pointCount = 8;
	else if (total_length < 250) pointCount = 16; // 0
	
	else if (total_length < 300) pointCount = 16;
	else if (total_length < 400) pointCount = 16;
	else if (total_length < 500) pointCount = 16;//1
	
	else if (total_length < 600) pointCount = 32;
	else if (total_length < 650) pointCount = 32;
	else if (total_length < 750) pointCount = 32;
	else if (total_length < 800) pointCount = 32;
	else if (total_length < 900) pointCount = 32;
	else if (total_length < 1000) pointCount = 32;
	else if (total_length < 1200) pointCount = 32;
	else if (total_length < 1400) pointCount = 32;//2
	
	else if (total_length < 1600) pointCount = 32;
	else if (total_length < 1800) pointCount = 32;//3
	
	else if (total_length < 2000) pointCount = 32;
	else if (total_length < 3000) pointCount = 32;
	else if (total_length < 3500) pointCount = 32;//4
	
	else if (total_length < 4000) pointCount = 32;
	else if (total_length < 5000) pointCount = 32;
	else if (total_length < 8000) pointCount = 32;
	else if (total_length < 30000) pointCount = 32;//4
	
	//sprint(self, ftos(total_length));
	//sprint(self, " ");
	//sprint(self, ftos(pointCount));
	//sprint(self, " \n");
	
	//self.curve_seg_count = pointCount;
	

	if(total_length <= 250) seg = 0 ;
	else if(total_length <= 500) seg = 1 ;
	else if(total_length < 900) seg = 2 ;
	else if(total_length < 1800) seg = 3 ;
	else if(total_length < 3500) seg = 4 ;
	else if(total_length < 10000) seg = 4 ;
	
	local float delta = 1.0 / pointCount;
	

	while(t >= 0)
	{
		last_result = result;
		oneMinusT = 1-t;
		result = (oneMinusT*oneMinusT*oneMinusT) * p0 + 
			 (3*oneMinusT*oneMinusT*t)*p1 + 
			 (3*oneMinusT*t*t)*p2 + 
			 (t*t*t)*p3;
		if(t < 1-delta )
		{
			local vector dir = last_result - result;
			//draw_line(last_result, result, 251, 15, TRUE);
			
			
			
			local entity prj;
			
			//if (t == 0) return; 
			
			prj = spawn ();
		
			prj.owner = self;
			prj.movetype = MOVETYPE_NOCLIP;
			prj.solid = SOLID_NOT;
			prj.angles = vectoangles(dir);
		
			prj.touch = SUB_Null;
			prj.classname = "railtrail";
		
			       // uncomment when engaging
			setmodel (prj, "progs/bloodrailz/rail_c.mdl");
			
			if(seg == 0) setmodel (prj, "progs/bloodrailz/rail_a.mdl");
			else if(seg == 1) setmodel (prj, "progs/bloodrailz/rail_b.mdl");
			else if(seg == 2) setmodel (prj, "progs/bloodrailz/rail_b.mdl");
			else if(seg == 3) setmodel (prj, "progs/bloodrailz/rail_b1.mdl");
			else if(seg == 4) setmodel (prj, "progs/bloodrailz/rail_e.mdl");
			
			
				
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
		
		
		
			setorigin (prj, result);
			prj.velocity = '0 0 0';	
		
	
			local float alpha_rand = random();
			if (alpha_rand < 0.5) prj.alpha = 0.60;
			else prj.alpha = 1;
		
			
			/*             uncomment when engaging
			if(vlen(dir) < 20) setmodel (prj, "progs/bloodrailz/rail_a.mdl");
			else if (vlen(dir) < 33) setmodel (prj, "progs/bloodrailz/rail_b.mdl");
			else if (vlen(dir) < 45) setmodel (prj, "progs/bloodrailz/rail_b1.mdl");
			else if (vlen(dir) < 60) setmodel (prj, "progs/bloodrailz/rail_c.mdl");
			else if (vlen(dir) < 120) setmodel (prj, "progs/bloodrailz/rail_d.mdl");
			else if (vlen(dir) < 240) setmodel (prj, "progs/bloodrailz/rail_e.mdl");
			*/
			
			if(t == 0)
			{
				//sprint(self, ftos(vlen(dir)));
				//sprint(self, "\n");
				
				//sprint(self, ftos(seg));
				//sprint(self, "\n");
				/*        uncomment when engaging
				if(vlen(dir) < 30) setmodel (prj, "progs/bloodrailz/rail0_1_30.mdl");
				else if(vlen(dir) < 45) setmodel (prj, "progs/bloodrailz/rail0_1.mdl");
				else if(vlen(dir) < 60) setmodel (prj, "progs/bloodrailz/rail1_1.mdl");
				else if(vlen(dir) < 90) setmodel (prj, "progs/bloodrailz/rail1_1_90.mdl");
				else setmodel (prj, "progs/bloodrailz/rail1_1_90.mdl");
				//prj.skin = 1;
				*/
			
			}

			prj.frame = 4;	
			prj.think = clean_rail_fade;
			prj.nextthink = time + 0.25 + (t*0.002); //fade delay 0.2 -> 0.25 so that curved rails hang a bit longer
			prj.cnt = 5;	
		}
		t = t - delta;
	}
}
