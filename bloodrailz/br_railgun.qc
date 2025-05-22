void() update_railpop =
{

	makevectors(self.owner.v_angle);
	local vector src = self.owner.origin + v_forward*21 + v_right*2 + '0 0 18';
	setorigin(self, src);
	
	
		if(self.weapon ==0) self.alpha += 0.06;
		else if(self.weapon ==1) self.alpha -= 0.044;
		if(self.alpha >= 0.3 && self.weapon ==0) self.weapon =1;
	
	if(self.ammo_cells == 1)
	{
		self.frame = self.frame -1;
		if(self.frame <=0) self.frame = 0;
	}
	
	if (self.alpha <= 0.03 && self.weapon ==1) 
	{
		self.think = SUB_Remove;
	}
	else
	{
		self.ammo_cells +=1;
		if(self.ammo_cells>1) self.ammo_cells=0;
	}
	
	
	 self.nextthink = time + 0.01;
}


void() make_railpop =
{
	
	makevectors(self.v_angle);

	
	local vector src = self.origin + v_forward*21 + v_right*2 + '0 0 16';
	local vector dir = aim (self, 10000);
	
	dir =normalize(dir);
	
	local entity impact;


	
	impact = spawn();
	setmodel (impact, "mdl/ef_railpop.mdl");
	
	
	if (self.height == elohim_team1) impact.skin = 1;   //red
	else if (self.height == elohim_team2) impact.skin = 0;   //blue
	else impact.skin = 0;   //blue
	
	
	
	
	impact.frame = 4;
	impact.weapon = 0;
	impact.ammo_cells =0;
	impact.angles = vectoangles(dir);
	setorigin(impact, src);
	impact.movetype = MOVETYPE_NOCLIP;
	impact.solid = SOLID_NOT;
	impact.classname = "impact";
	setsize (impact, 0,0);
	impact.alpha = 0.001;
	impact.owner = self;
	impact.nextthink = time + 0.01;
	impact.think = update_railpop;
	
	
	
}



void(vector org, entity attacker, float radius, entity ignore) Rail_push =                //Area throw effect function for axe splash damage
    {
    
    
	local entity head = findradius(org, radius);

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
						sound (attacker, CHAN_AUTO, "weap/br_plasm2.wav",1,ATTN_NORM);
						
						if (self.height == elohim_team1) head.skin = 6;   //red
						else if (self.height == elohim_team2) head.skin = 5;   //blue
						else
						{
							if(head.skin == 5) head.skin = 6; 
							else if(head.skin == 6) head.skin = 5; 
						} 
				}
				if (head.classname == "player" || head.classname == "dummy")           
				{
								T_DamageOrg (head, self, self, 57, self.origin);	//NOVEM increased damage from 21 to 57
								//if(head.flags & FL_ONGROUND) head.flags = head.flags - FL_ONGROUND;
								dir = head.origin - (self.absmin + self.absmax) * 0.5;     
								

								
								head.velocity = head.velocity + 750*(normalize(dir));
								head.velocity_z = head.velocity_z + 200;
				}
				
				if (head.classname == "smoke")           
				{
						if(!head.speed) head.weaponframe = 1000;       //weaponframe = speed_plasma
						
						head.speed = 750;
						dir = head.origin - (self.absmin + self.absmax) * 0.5;              
						dir = normalize(dir);
						head.velocity = head.velocity + 750*dir + v_up*125;
				}
					
					
							
			
		}
		head = head.chain;
	}
    }












void() rail_fade = {
	
	local float rand;
	rand = random();
	
		
	self.think = rail_fade;
	self.nextthink = time + 0.1;
	
	
	
			local entity head = findradius(self.origin, 121);
			while (head)
			{
					if (head.classname == "smoke")
					{				
			
						local vector dir4 = self.origin - self.owner.origin;     
						local float accel = 220*random() + 133;         
						head.velocity = head.velocity + accel*(normalize(dir4));
					}
										
					head = head.chain;
			}
	

	if (self.cnt == 6)
	{
		self.alpha = self.alpha - 0.19;
		if(self.alpha <= 0) self.alpha = 0.01;
		self.frame = 1;
	}
	else if (self.cnt == 5)
	{
		self.frame = 1;
		if (rand < 0.06)          //randomly deleting segments  .02 -> .01
			{
				self.cnt = self.cnt - 1;
				self.think = SUB_Remove;
				self.nextthink = time + 0.05;
				
				return;
			}
		
		
		self.alpha = self.alpha - 0.19;
		if(self.alpha <= 0) self.alpha = 0.01;
	}	
	else if (self.cnt == 4)
	{
			self.frame = 1;
			if (rand < 0.07)          //randomly deleting segments
			{
				self.cnt = self.cnt - 1;
				self.think = SUB_Remove;
				self.nextthink = time + 0.05;
				
				return;
			}
		
		self.alpha = self.alpha - 0.19;
		if(self.alpha <= 0) self.alpha = 0.01;
	}
	else if (self.cnt == 3)
	{
		self.frame = 2;
			if (rand < 0.09)          //randomly deleting segments
			{
				self.cnt = self.cnt - 1;
				self.think = SUB_Remove;
				self.nextthink = time + 0.05;
				
				return;
			}
		if(self.alpha == 0.01) self.alpha = 0.01;
		else self.alpha = 0.08;
		
	}
	else if (self.cnt == 2)
	{	
		self.frame = 2;
			if (rand < 0.10)          //randomly deleting segments
			{
				self.cnt = self.cnt - 1;
				self.think = SUB_Remove;
				self.nextthink = time + 0.05;
				
				return;
			}
			if(self.alpha == 0.01) self.alpha = 0.01;
			else self.alpha = 0.05;
	}
	else if (self.cnt == 1) 
	{
		self.frame = 2;
		self.alpha = 0.02;
		self.think = SUB_Remove;
		self.nextthink = time + 0.05;
		return;
		
	}	
	self.cnt = self.cnt - 1;
};







void(vector start, vector end, vector myAngles, entity shooter) rail_make = 
{
	local vector vec,  loopsrc,  destination;
	local vector drawsrc;
	local entity thedude;
	local float traillen, segments;
	entity prj;
	local float rotation_amount;
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
	


	// now using drawsrc instead of src now, so we trace damage from eye position and trail from gun position
	traceline(drawsrc, destination, TRUE, self);
	traillen = vlen(trace_endpos - drawsrc);
	
	//bprint(ftos(traillen));
	//bprint(" trail length\n");
	
	
	if (traillen >= 4000 && (pointcontents(trace_endpos) == CONTENT_SKY)) traillen = traillen - 1100;
	//else if (traillen > 8000) traillen = traillen - 1500;




	if (shooter == self)
	{
			if (traillen < 50) segments = 1;		//short link
			else if (traillen < 75) segments = 2;		//short link
			else if (traillen < 150) segments = 3;		//short link
			else if (traillen < 200) segments = 4;		//short link
			
			else if (traillen < 250) segments = 2;
			else if (traillen < 300) segments = 2;
			else if (traillen < 400) segments = 2;
			else if (traillen < 600) segments = 3;
			else if (traillen < 800) segments = 4;
			else if (traillen < 1000) segments = 5;
			else if (traillen < 1250) segments = 6;
			else if (traillen < 1750) segments = 8;
			else if (traillen < 2000) segments = 12; 	 //4,7,10,          13  //5,10,13
			else if (traillen < 2500) segments = 13;         //4,7,10,13,       15  //5,10,13,15
			else if (traillen < 3000) segments = 15; //14    //4,7,10,13,       16  //5,10,13,16
			else if (traillen < 3500) segments = 17; //14    //4,7,10,13,       17  //5,10,13,17
			else if (traillen < 4000) segments = 19; //16    //4,7,10,13,16,    19  //5,10,13,16,19
			else if (traillen < 5000) segments = 20; //17    //4,7,10,13,16,    20  //5,10,13,16,20
			else if (traillen < 6000) segments = 21; //18    //4,7,10,13,16,19, 21  //5,10,13,16,21
			else if (traillen < 7000) segments = 22; //18    //4,7,10,13,16,19, 22  //5,10,13,16,19,22
			else if (traillen >=7000) segments = 22; //18    //4,7,10,13,16,19, 22  //5,10,13,16,19,22
			
			local float sky_shot =0;
			if(pointcontents(trace_endpos) == CONTENT_SKY && traillen >= 1000) sky_shot =1;  //rail hits SKY brush so we dont care if rail draws super long
			
			//
			//bprint(ftos(segments));
			//bprint(" nominal segments\n");
			//local float count_segs =0;
			//
			
			if((total_players_global > 8 || smoke_ent_number > 8) ) 
			{
				if(segments >= 22) segments = segments - 2;
				else if(segments >= 21) segments = segments - 2;
				else if(segments >= 20) segments = segments - 2;
			}
			
			
		
			local float old_seg = segments;
			spacing_long = floor(traillen / segments);
			
			
			local float sky_skip =0;
			if     (sky_shot ==1 && segments ==7) sky_skip=1;
			else if(sky_shot ==1 && segments ==8) sky_skip=1;
			else if(sky_shot ==1 && segments ==9) sky_skip=1;
			else if(sky_shot ==1 && segments ==10) sky_skip=1;
			else if(sky_shot ==1 && segments ==11) sky_skip=1;
			else if(sky_shot ==1 && segments ==12) sky_skip=1;
			else if(sky_shot ==1 && segments ==13) sky_skip=2;
			else if(sky_shot ==1 && segments ==14) sky_skip=2;
			else if(sky_shot ==1 && segments ==15) sky_skip=3;
			else if(sky_shot ==1 && segments ==16) sky_skip=3;
			else if(sky_shot ==1 && segments ==17) sky_skip=3;
			else if(sky_shot ==1 && segments ==18) sky_skip=4;
			else if(sky_shot ==1 && segments ==19) sky_skip=4;
			else if(sky_shot ==1 && segments ==20) sky_skip=4;
			else if(sky_shot ==1 && segments ==21) sky_skip=5;
			else if(sky_shot ==1 && segments ==22) sky_skip=5;

			
			local float skip =0;
			if(segments ==22 && sky_shot ==0) skip=4;
			else if(segments >16 && sky_shot ==0) skip=3;
			else if((segments ==16 || segments ==15 || segments ==14 || segments ==13 || segments==12) && sky_shot ==0) skip=2;
			else if((segments ==9 || segments ==10 || segments==11) && sky_shot ==0) skip=1;
			
			local float skip_go =0;
			local float sky_skip_go =0;
			
			//bprint(ftos(spacing_long));
			//bprint(" spacing\n");
			
			
		
		while (segments)
		{
			skip_go=0;
			sky_skip_go=0;
			
			if(skip ==0 || (skip==1 && (segments!=6)) || (skip==2 && (segments!=6 && segments!=11)) || (skip==3 && (segments!=6 && segments!=11 && segments!=16)) || (skip==4 && (segments!=6 && segments!=11 && segments!=16 && segments!=21)))
			{
				skip_go=1;
			}

			if(sky_skip ==0 || (sky_skip==1 && (segments!=6))|| (sky_skip==2 && (segments!=6 && segments!=11)) || (sky_skip==3 && (segments!=6 && segments!=11 && segments!=14)) || (sky_skip==4 && (segments!=6 && segments!=11 && segments!=14 && segments!=17)) || (sky_skip==5 && (segments!=6 && segments!=11 && segments!=14 && segments!=17 && segments!=20)))
			{
				sky_skip_go=1;
			}
			
			
			//if(skip ==0 || (skip==2 && (segments!=6 && segments!=11)) || (skip==3 && (segments!=6 && segments!=11 && segments!=16)) || (skip==4 && (segments!=6 && segments!=11 && segments!=16 && segments!=21)))
			if(skip_go==1 && sky_skip_go==1)
			{
				//count_segs +=1;
				
				vec = normalize(trace_endpos - drawsrc);
				prj = spawn ();
		
				prj.owner = shooter;
				prj.movetype = MOVETYPE_NOCLIP;
				prj.solid = SOLID_NOT;
				prj.angles = vectoangles(shootDir);
				
				prj.angles_z = (2*random()-1) * 25;
				
				prj.touch = SUB_Null;
				prj.classname = "railtrail";
			
				prj.frame =0;
		
			
				//if(segments == old_seg || segments == 1) setmodel (prj, "mdl/rail1.mdl");   //DRAW THE FIRST AND LAST SEGMENTS AS SHORT MODELS SO STUFF DOESNT POKE THRU WALLS
			

			
				
				setsize (prj, 0, 0);	
				if (self.height == elohim_team1) 
				{
					if(random() < 0.13) prj.skin = 3;   //Orange
					else if(random() > 0.87) prj.skin = 4;   //Dark-red
					else prj.skin = 1;    //red
				}
				else if (self.height == elohim_team2) 
				{
					if(random() < 0.13) prj.skin = 0;   //White-blue
					else if(random() > 0.87) prj.skin = 5;   //Dark-blue
					else prj.skin = 2;      //light blue	
				}
				else 
				{
					if(random() < 0.13) prj.skin = 2;   //Light-blue
					else if(random() > 0.87) prj.skin = 5;   //Dark-blue
					else prj.skin = 0;      //White blue
				}
		
				
				local float low_rotation=0;
				
				if (traillen < 200) setmodel (prj, "mdl/rail1.mdl");
				else if (traillen>=200) setmodel (prj, "mdl/rail1c.mdl");
			
				if(sky_shot==0)
				{
					if     (skip==4 && (segments ==5 || segments ==10 || segments==15 || segments==20)) 		{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
					else if(skip==3 && (segments ==5 || segments ==10 || segments==15)) 				{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
					else if(skip==2 && (segments ==5 || segments ==10)) 						{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
					else if(skip==1 && (segments ==5)) 								{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
				}
				else if(sky_shot==1)
				{
					if     (sky_skip==5 && (segments ==5 || segments ==10 || segments==13 || segments==16 || segments==19 || segments==old_seg)) 	{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
					else if(sky_skip==4 && (segments ==5 || segments ==10 || segments==13 || segments==16 || segments==old_seg))  			{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
					else if(sky_skip==3 && (segments ==5 || segments ==10 || segments==13 ||segments==old_seg)) 					{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
					else if(sky_skip==2 && (segments ==5 || segments ==10 || segments==old_seg))							{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
					else if(sky_skip==1 && (segments ==5 || segments==old_seg))									{setmodel (prj, "mdl/rail1c450.mdl"); low_rotation =1;}
				}
				
				if(traillen >= 200)
				{
					if(segments == 1 && spacing_long < 125) setorigin (prj, drawsrc + vec * 120);
					else if(segments == 1 && spacing_long < 200) setorigin (prj, drawsrc + vec * 170);
					else if(segments == 1 && spacing_long < 300) setorigin (prj, drawsrc + vec * 220);
					else if(segments == old_seg && sky_shot==0) setorigin (prj, drawsrc + vec*spacing_long*segments - vec*120);
					else setorigin (prj, drawsrc + vec * spacing_long * segments);
				}
				else setorigin (prj, drawsrc + vec * spacing_long * segments);
				
			
				prj.velocity = '0 0 0';	
		
				//teamred's magic
				alpha_rand = random();
				if (alpha_rand < 0.5) prj.alpha = 0.60;
				else prj.alpha = 1;
				//else if (alpha_rand < 0.44) prj.alpha = 0.8;
			
					
					prj.avelocity_x = random()-0.5;
					prj.avelocity_y = random()-0.5;
					prj.avelocity_z = random()-0.5;
		
					prj.avelocity = normalize(prj.avelocity);
					rotation_amount = 6.0;
				
					if(spacing_long >= 125 && sky_shot ==0 && low_rotation ==0) rotation_amount = 15.0;
					else if(spacing_long >= 100 && sky_shot ==0 && low_rotation ==0) rotation_amount = 15.0;
					else if(low_rotation ==1) rotation_amount = 6.0;
				
					prj.avelocity = prj.avelocity*rotation_amount;
					
					

			
			
				prj.cnt = 5;
				prj.frame = 4;	
				prj.think = rail_fade;
				prj.nextthink = time + 0.2 + (segments*0.008); //fade delay   //
			}
			
			segments = segments - 1;	
			
			//if(segments==0) { bprint(ftos(count_segs)); bprint(" actual segments\n");}
	
		}
	}
	

	
	if (shooter != self)
	{
	
	traillen = vlen(trace_endpos - drawsrc);
	segments = floor(traillen / 150);   //33->150
	local float seg_total;
	
	if(segments > 4) segments = 4;
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
		setmodel (prj, "mdl/rail1c.mdl");
				
		setsize (prj, 0, 0);	
		
		if (self.height == elohim_team1) 
		{
			if(random() < 0.13) prj.skin = 3;   //Orange
			else if(random() > 0.87) prj.skin = 4;   //Dark-red
			else prj.skin = 1;    //red
			
			if (segments ==1) prj.skin = 2;
			else if (segments ==2) prj.skin = 0;
			//else if (segments < ==3) prj.skin = 5;
			
		}
		else if (self.height == elohim_team2) 
		{
			if(random() < 0.13) prj.skin = 0;   //White-blue
			else if(random() > 0.87) prj.skin = 5;   //Dark-blue
			else prj.skin = 2;      //light blue	
			
			if (segments ==1) prj.skin = 1;
			else if (segments ==2) prj.skin = 3;
			//else if (segments ==3) prj.skin = 4;
			
		}
		
		else 
		{
			if(random() < 0.13) prj.skin = 2;   //Light-blue
			else if(random() > 0.87) prj.skin = 5;   //Dark-blue
			else prj.skin = 0;      //White blue
			
			if (segments ==1) prj.skin = 1;
			else if (segments ==2) prj.skin = 3;
			//else if (segments ==3) prj.skin = 4;
		}
		
		

		if(segments == 1) setorigin (prj, drawsrc + vec * 110);
		else if(segments == 2) setorigin (prj, drawsrc + vec * 250);
		else if(segments == 3) setorigin (prj, drawsrc + vec * 400);
		else if(segments == 4) setorigin (prj, drawsrc + vec * 650);
		
		
		prj.velocity = '0 0 0';	
		
		
			//alpha_rand = random();
			//if (alpha_rand < 0.7) prj.alpha = 0.30;
			//else prj.alpha = 0.4;
			
			
			prj.alpha = ( (1 + seg_total - segments)/seg_total ) * 0.6;
			
			if(prj.alpha <=0) prj.alpha = 0.01;
			
			
			if (seg_total - segments == 0)   // || seg_total - segments == 1) 
			{
				//sprint(self, "alpha ");
				prj.alpha = 0.01;
			}
		
		
		
		//teamred's magic
	
			prj.avelocity_x = random()-0.5;
			prj.avelocity_y = random()-0.5;
			prj.avelocity_z = random()-0.5;
		
			prj.avelocity = normalize(prj.avelocity);
			rotation_amount = 11.0;
			prj.avelocity = prj.avelocity*rotation_amount;

			
		prj.frame = 4;	
		prj.think = rail_fade;
		prj.nextthink = time + 0.2 + (segments*0.020); // delay fade time using segment number for neat effect (vf)
		segments = segments - 1;
		
		prj.cnt = 5;	
	
	}
	
	//sprint(self, "reflect ");
	}
	
	
};






void(vector start, vector p0, vector p1, vector p2, vector p3) DrawCurvedRail=
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
	
	local float min_distance = vlen(p3-p0);
	local float curvature = total_length - min_distance;
	
	float spacing = total_length/217;
	
	if(total_length < 100) pointCount = 4;
	else if (total_length < 200) pointCount = 5;
	else if (total_length < 300) pointCount = 6;
	else if (total_length < 400) pointCount = 7;
	else if (total_length < 500) pointCount = 9;
	else if (total_length < 600) pointCount = 10;
	else if (total_length < 700) pointCount = 12;
	else if (total_length < 800) pointCount = 13;
	else if (total_length < 1000) pointCount = 14;
	else if (total_length < 1400) pointCount = 11;
	else if (total_length < 1600) pointCount = 11;
	else if (total_length < 2000) pointCount = 12;
	else if (total_length < 3000) pointCount = 12;
	else if (total_length < 4000) pointCount = 13;
	else if (total_length < 5000) pointCount = 16;
	else if (total_length < 6000) pointCount = 17;
	else if (total_length < 7500)  pointCount = 18;
	else if (total_length >=7500)  pointCount = 19;
	
	
	if((total_players_global > 8 || smoke_ent_number > 8)) 
	{
		if(pointCount == 16) pointCount = pointCount - 2;
		else if(pointCount == 17) pointCount = pointCount - 2;
		else if(pointCount == 18) pointCount = pointCount - 2;
		else if(pointCount == 19) pointCount = pointCount - 2;
	}
	
	
	local float sky_long =0;

	if(pointcontents(p3) == CONTENT_SKY && total_length >= 4000) sky_long =2;
	else if(pointcontents(p3) == CONTENT_SKY && total_length >= 2000) sky_long =1;
	
	local float short_seg = 0;
	if(total_length < 1000) 
	{
		short_seg =1;
	}
	
	
	local float delta = (1.0 / pointCount) -.003;
	
	//bprint(ftos(total_length));
	//bprint("\n");
	
	


	
	while(t >= 0)
	{
		last_result = result;
		oneMinusT = 1-t;
		result = (oneMinusT*oneMinusT*oneMinusT) * p0 + 
			 (3*oneMinusT*oneMinusT*t)*p1 + 
			 (3*oneMinusT*t*t)*p2 + 
			 (t*t*t)*p3;
		if(t < 1)//-delta )
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
		
				if((short_seg == 1 && pointCount == 14) || (short_seg == 1 && pointCount >= 6 && count <(pointCount-4)))        setmodel (prj, "mdl/rail1.mdl");
				else if(short_seg == 1 && pointCount != 14) 									setmodel (prj, "mdl/rail0.mdl");
				else					   									setmodel (prj, "mdl/rail1c.mdl");  //blahnew
			
					
				setsize (prj, 0, 0);	
		
				if (self.height == elohim_team1) 
				{
					if(random() < 0.13) prj.skin = 3;   //Orange
					else if(random() > 0.87) prj.skin = 4;   //Dark-red
					else prj.skin = 1;    //red
			
				}
				else if (self.height == elohim_team2) 
				{
					if(random() < 0.13) prj.skin = 0;   //White-blue
					else if(random() > 0.87) prj.skin = 5;   //Dark-blue
					else prj.skin = 2;      //light blue	
				}
		
				else 
				{
					if(random() < 0.13) prj.skin = 2;   //Light-blue
					else if(random() > 0.87) prj.skin = 5;   //Dark-blue
					else prj.skin = 0;      //White blue
				}
		
		
				local float alpha_rand = random();
				if (alpha_rand < 0.5) prj.alpha = 0.60;
				else prj.alpha = 1;
		
			
				if(count ==(pointCount) && short_seg ==1) 
				{
					setorigin (prj, result + start*20);
					prj.alpha = 0.25;
				}
				else if(count ==(pointCount-1) && short_seg ==1) 
				{
					setorigin (prj, result + start*10);
					prj.alpha = 0.30;
				}
				else if(count ==(pointCount-1) && short_seg ==1) 
				{
					setorigin (prj, result + start*5);
					prj.alpha = 0.35;
				}
				else if(count ==(pointCount-1) && short_seg ==1) 
				{
					prj.alpha = 0.40;
				}
				else if(count ==(pointCount-1) && short_seg ==1) 
				{
					prj.alpha = 0.45;
				}
				else if(count ==(pointCount-1) && short_seg ==1) 
				{
					prj.alpha = 0.50;
				}
			
				else if(count ==pointCount && short_seg ==0)
				{
					if(short_seg ==0) setorigin (prj, p0 + start*110);  //blahnew
					prj.alpha = 0.15;
				}
				else if(count ==(pointCount-1) && short_seg ==0)
				{
					if(short_seg ==0) setorigin (prj, result);
					prj.alpha = 0.65;
					//prj.skin = 3;
				}

				else setorigin (prj, result);
		
			
				//if(count ==pointCount) prj.skin = 3;
				//if(count ==pointCount-1) prj.skin = 4;
				//if(count ==pointCount-2) prj.skin = 3;
			
				prj.velocity = '0 0 0';	
		
		
				if(vlen(dir) < 20) setmodel (prj, "mdl/rail_a.mdl");
				else if (vlen(dir) < 33) setmodel (prj, "mdl/rail_b.mdl");
				else if (vlen(dir) < 45) setmodel (prj, "mdl/rail_b1.mdl");
				else if (vlen(dir) < 75) setmodel (prj, "mdl/rail_c.mdl");
				else if (vlen(dir) < 120) setmodel (prj, "mdl/rail1c120.mdl");  //120 length	
				//else if (vlen(dir) < 240) setmodel (prj, "mdl/rail_e.mdl");  //232 length
				//else if (vlen(dir) < 295) setmodel (prj, "mdl/rail_f.mdl");  //289 length
				//else if (vlen(dir) < 400) setmodel (prj, "mdl/rail_g.mdl");  //376 length
		
		
		
				//teamred's magic
			
				
					local float rotation_amount;
					prj.avelocity_x = random()-0.5;
					prj.avelocity_y = random()-0.5;
					prj.avelocity_z = random()-0.5;
		
					prj.avelocity = normalize(prj.avelocity);
					rotation_amount = 13.0;
					prj.avelocity = prj.avelocity*rotation_amount;
				
				

				prj.frame = 4;	
				prj.think = rail_fade;
				prj.nextthink = time + 0.25 + (t*0.002); //fade delay 0.2 -> 0.25 so that curved rails hang a bit longer
				prj.cnt = 5;	
			}	
			sky_long -=1;
			if(sky_long <0) sky_long =0;
		}
		
		t = t - delta;
	}
}





void() FlickCurves=
{
	if(self.rail_powered == 0) return;

	local vector org = self.origin;
	local vector viewOffset = '0 0 22';
	local vector startPt = self.origin + viewOffset;
	makevectors(self.v_angle);
	local vector newFlick = self.origin + viewOffset + v_forward * 100 ; 
		
	if ( self.button0 )
	{
		local float divs = 100; // we break each mouse tick into this many sub movements/raycasts //6644 is the max number of loops
		local vector division = (newFlick - self.lastFlick) / divs;
		
		local vector lastNdPos = self.lastEndPos;

		if((self.lastFlick != VEC_ORIGIN) && (self.lastEndPos != VEC_ORIGIN))
		{
			local float i = 0; //pseudo for loop
			while( i < divs )
			{
				local vector dir = (self.lastFlick + i * division) - startPt;
				dir = normalize(dir);
				traceline (startPt, startPt + dir * 10000, FALSE, self);
				if (trace_ent.takedamage == DAMAGE_AIM)
				{
					self.flickEnt = trace_ent;
					self.flickTime = time;
					
					if(self.flickEnt.classname == "player" || self.flickEnt.classname == "dummy")
					{
						make_flick_marker();
					}
				}	
				
				lastNdPos = trace_endpos;
				
				i = i + 1;
			}
		}
		if(!self.lastButton0)
		{
			traceline (org+viewOffset, org+viewOffset + v_forward*10000, FALSE, self);
			lastNdPos = trace_endpos;
			self.lastMouseUp = trace_endpos;	
		}
		

		
		self.lastFlick = newFlick;
		self.lastEndPos = lastNdPos;
	
	} //end button 0 down
	else
	{
		player_shot1 ();
		//START // THIS HAPPENS IF NO TARGET IS FOUND
		
		self.mag_recharge_time = time;                                    
		self.rail_powered = 0;
		self.shot_time = time; //start regular railgun recharge timer
		
		self.weaponmodel = "mdl/v_rail_r.mdl";
		if (self.height == elohim_team2) self.weaponmodel = "mdl/v_rail_b.mdl";
		
		//END // THIS HAPPENS IF NO TARGET IS FOUND
		if(self.lastButton0)
		{
			local float flickingDurationSeconds = 1; //seconds

			if( self.flickEnt != world )   //did we hit something?
			{
				if(self.flickTime > time - flickingDurationSeconds)    //temporal duration of the flick ?
				{
					self.rail_was_curved = 1;
					
					
					
					local vector meToTarg = self.flickEnt.origin - self.origin;
					local float dist_to_target = vlen(meToTarg);
					
					local float dist_12 = dist_to_target * 0.125;
					local float dist_25 = dist_to_target * 0.25;
					local float dist_50 = dist_to_target * 0.50;
					local float dist_75 = dist_to_target * 0.75;
					local float dist_100 = dist_to_target * 1.00;
					local float dist_125 = dist_to_target * 1.25;
					
					local vector lastToOrgNorm = normalize(self.lastEndPos-self.origin);
					local vector controlPt_12 = self.origin +lastToOrgNorm *dist_12;
					local vector controlPt_25 = self.origin +lastToOrgNorm *dist_25;
					local vector controlPt_50 = self.origin +lastToOrgNorm *dist_50;
					local vector controlPt_75 = self.origin +lastToOrgNorm *dist_75;
					local vector controlPt_100 = self.origin +lastToOrgNorm *dist_100;
					local vector controlPt_125 = self.origin +lastToOrgNorm *dist_125;
					
					local vector controlPt;
					local float direct_endpos;
					local float distal_length;
						
					traceline (self.flickEnt.origin, controlPt_75, FALSE, self.flickEnt);
					direct_endpos = vlen(trace_endpos - self.flickEnt.origin);
					distal_length = vlen(controlPt_75 - self.flickEnt.origin);
					local float foundPath = FALSE;
					
					if ( foundPath == FALSE && direct_endpos >= distal_length) 
					{	
						traceline (org, org + v_forward*20000, FALSE, self);
						direct_endpos = vlen(trace_endpos - org);
						if(direct_endpos > dist_75)
						{
							foundPath = TRUE;
							controlPt = controlPt_75;
							//sprint(self, "75 \n");
						}
					}
					
					
					traceline (self.flickEnt.origin, controlPt_100, FALSE, self.flickEnt);
					direct_endpos = vlen(trace_endpos - self.flickEnt.origin);
					distal_length = vlen(controlPt_100 - self.flickEnt.origin);
					
					if ( foundPath == FALSE && direct_endpos >= distal_length) 
					{
						traceline (org, org + v_forward*20000, FALSE, self);
						direct_endpos = vlen(trace_endpos - org);
						if(direct_endpos >= dist_100)
						{
							controlPt = controlPt_100;
							foundPath = TRUE;
							//sprint(self, "100 \n");
						}
					}
					
					traceline (self.flickEnt.origin, controlPt_50, FALSE, self.flickEnt);
					direct_endpos = vlen(trace_endpos - self.flickEnt.origin);
					distal_length = vlen(controlPt_50 - self.flickEnt.origin);
					
					if ( foundPath == FALSE && direct_endpos >= distal_length) 
					{
							
						traceline (org, org + v_forward*20000, FALSE, self);
						direct_endpos = vlen(trace_endpos - org);
						if(direct_endpos > dist_50)
						{
							controlPt = controlPt_50;
							foundPath = TRUE;
							//sprint(self, "50 \n");
							
						}
					}
					
					traceline (self.flickEnt.origin, controlPt_25, FALSE, self.flickEnt);
					direct_endpos = vlen(trace_endpos - self.flickEnt.origin);
					distal_length = vlen(controlPt_25 - self.flickEnt.origin);
					
					if ( foundPath == FALSE && direct_endpos >= distal_length) 
					{
						traceline (org, org + v_forward*20000, FALSE, self);
						direct_endpos = vlen(trace_endpos - org);
						if(direct_endpos > dist_25)
						{
							controlPt = controlPt_25;
							foundPath = TRUE;

							//sprint(self, "   25 \n");
						}
					}
					
					traceline (self.flickEnt.origin, controlPt_125, FALSE, self.flickEnt);
					direct_endpos = vlen(trace_endpos - self.flickEnt.origin);
					distal_length = vlen(controlPt_125 - self.flickEnt.origin);
					
					if ( foundPath == FALSE && direct_endpos >= distal_length) 
					{
						traceline (org, org + v_forward*20000, FALSE, self);
						direct_endpos = vlen(trace_endpos - org);
						if(direct_endpos > dist_125)
						{
							controlPt = controlPt_125;
							foundPath = TRUE;

							//sprint(self, "125 \n");
						}
					}
					if ( foundPath == FALSE)
					{
						controlPt = controlPt_12;
						//sprint(self, "12 \n");
					}
					if (!(self.player_flag & PF_CLEANTRAIL)) DrawCurvedRail(v_forward, self.origin + '0 0 16' + v_forward*5, controlPt, controlPt , self.flickEnt.origin+'0 0 25');    // replaced viewOffset with '0 0 18'
					else clean_DrawCurvedRail(v_forward, self.origin + '0 0 16' + v_forward*5, controlPt, controlPt , self.flickEnt.origin+'0 0 25');
					
					T_DamageOrg(self.flickEnt, self, self, 1000, controlPt_50);
					self.ammo_slugs = self.ammo_slugs -1;

				}//end time
				
			}//end did hit?
			else
			{
				makevectors(self.v_angle);
				traceline (startPt, startPt+v_forward * 10000, FALSE, self);
				
				local vector t = trace_endpos - self.origin;
				t = t * 0.5;
				t = self.origin + t;
				if(self.health>0)
				{
					if (!(self.player_flag & PF_CLEANTRAIL)) DrawCurvedRail(v_forward, self.origin + '0 0 16'+ v_forward*5, t, t , self.lastMouseUp); 
					else clean_DrawCurvedRail(v_forward, self.origin + '0 0 16'+ v_forward*5, t, t , self.lastMouseUp); 
					
					self.ammo_slugs = self.ammo_slugs -1;
				
					local float randrail = random()*4;
    
					if (randrail <=1) sound (self, CHAN_AUTO, "weap/br_rail1.wav",1,ATTN_NORM);
					else
					if (randrail <=2) sound (self, CHAN_AUTO, "weap/br_rail2.wav",1,ATTN_NORM);
					else
					if (randrail <=3) sound (self, CHAN_AUTO, "weap/br_rail3.wav",1,ATTN_NORM);
					else
					if (randrail <=4) sound (self, CHAN_AUTO, "weap/br_rail4.wav",1,ATTN_NORM);
					
				}
			}
		}//end button up
		self.lastFlick = VEC_ORIGIN;
		self.lastEndPos = VEC_ORIGIN;
		self.flickEnt = world;

	}// end else
	self.lastButton0 = self.button0;
}











void() W_FireRailgun =
{
	
	if(infokey(self, "rail_cvar") =="1")
	{
		if(!(self.player_flag & PF_CLEANTRAIL)) self.player_flag = self.player_flag | PF_CLEANTRAIL;
	}
	else 
	{
		if(self.player_flag & PF_CLEANTRAIL) self.player_flag = self.player_flag - PF_CLEANTRAIL;
	}
	
	
	//bprint(ftos(self.origin_x));
	//bprint("\n");
	//bprint(ftos(self.origin_y));
	//bprint("\n");
	//bprint(ftos(self.origin_z));
	//bprint("\n");
	
	//bprint(ftos(self.origin_x));
	//bprint("\n");
	//bprint(ftos(self.origin_y));
	//bprint("\n");
	//bprint(ftos(v_forward_z));
	//bprint("\n");
	
	
	//make_icon(self, 1, 10);
	//make_icon(self, 4, 403);
	//make_icon(self, 4, 9000);
	//make_icon(self, 4, 30);
	//make_icon(self, 2, 400);
	//make_icon(self, 7, 0);
	//make_icon(self, 5, 1000);
	
	//maplist = cvar("saved4");
	//bprint(ftos(maplist));
	
	
	rail_jump();
	if(self.ammo_slugs == 0) return;
	
	self.ammo_slugs = self.ammo_slugs -1;
	self.rail_shots +=1;

	local vector dir, src; 
    
	local float hitscan_missed =0;
	local float rail_armor_hit = 0;
	local float hitscanrail =0;
	
	local float antilag_hit_for_curve =0;
	local vector adjusted_ent;
	local vector adjusted_endpos;
	
	makevectors(self.v_angle);             
	

	local float n = random()*4;
	if (n <= 1) 	sound (self, CHAN_WEAPON, "weap/br_ric1.wav",0.5,ATTN_NORM);
	else if (n <=2) sound (self, CHAN_WEAPON, "weap/br_ric2.wav",0.5,ATTN_NORM);
	else if (n <=3) sound (self, CHAN_WEAPON, "weap/br_ric3.wav",0.5,ATTN_NORM);
	else if (n <=4) sound (self, CHAN_AUTO, "weap/br_rail5.wav",0.75,ATTN_NORM);
    
    


	//////////////////////////////////////////////////////////////
		antilag_rewind_all(self.responsetime, world); //FEBRUARY
   
		dir = aim (self, 10000);
		src = self.origin + v_forward*8 + '0 0 16';
   
		traceline (src, src + v_forward*9000, FALSE, self);
 
		if (trace_ent.takedamage)
		{
			//src = self.origin + v_forward*8 + '0 0 16';
			hitscanrail = 1;  //RAIL 711
    	
			if (trace_ent.armorvalue >= 100 || trace_ent.classname == "dummy") 
			{
				local entity armored_ent;
				armored_ent = trace_ent;
				rail_armor_hit = 1;
				local vector railend = trace_endpos;	
				
			}
			
				
				//HEADSHOT DETECTION
				/*
				local vector end_ent = normalize(trace_endpos - src) * vlen(trace_ent.origin - src);
				local vector end_found = normalize(trace_ent.origin - src) * vlen(trace_ent.origin - src);
				
				if((end_ent_z > end_found_z+12 && end_ent_z < end_found_z+22 && trace_ent.frame == 0) || (end_ent_z > end_found_z+18 && trace_ent.frame == 0 && trace_ent.frame != 0))
				{
					
					
					end_ent_z   = 0; 
					end_found_z = 0;
					
					
					if(fabs(end_ent_x - end_found_x) < 8 && fabs(end_ent_y - end_found_y) < 8) ex_localsound(self, "misc/headshot.wav");  // headshot announcement
					
				}
				*/
				///////////////////////////////////
				
			
			local vector antilaged_trace_ent = trace_ent.origin;  //store antilagged position of target
			adjusted_endpos = trace_endpos;

			antilag_restore_all();  // antilag - anti lag
		//////////////////////////////////////////////////////////////////

			adjusted_ent = trace_ent.origin-antilaged_trace_ent;
			//adjusted_ent = antilaged_trace_ent + normalize(adjusted_ent)*vlen(trace_ent.origin-antilaged_trace_ent);
			adjusted_ent = adjusted_endpos + normalize(adjusted_ent)*vlen(trace_ent.origin-antilaged_trace_ent);
			

			//bprint(ftos(vlen(trace_ent.origin-antilaged_trace_ent)));
			//bprint(" adjust distance\n");
			
			if(vlen(trace_ent.origin-antilaged_trace_ent) > 18) // 33->20
			{
				antilag_hit_for_curve =1;
				//bprint(">30\n");
			}
			else
			{ 
				antilag_hit_for_curve =0;
				//bprint("<=30\n");
			}
			
			T_DamageOrg (trace_ent, self, self, 9000, self.origin); 
		}

		else if (!trace_ent.takedamage)
		{
			antilag_restore_all();  // 
			
			hitscan_missed =1;
		
			if (self.player_flag & PF_ITEM_RUNE_MASK)                                    
			{
				if (self.player_flag & PF_ITEM_RUNE2_FLAG)
				{
					if(random() > 0.5) 	sound(self, CHAN_AUTO, "item/br_dmg2.wav", 0.5, ATTN_NORM);
					make_power(trace_endpos, 0.7, 6);
				
					local entity head;
					head = findradius(trace_endpos, 90);   //JANUARY 85 -> 90

					while (head)
					{
						if (head == self) T_DamageOrg (self, self, self, 20, trace_endpos);   //NOVEM 			power rune splash deals 20hp damage to bearer if within radius
			
						if (head != self && (head.classname == "player" || head.classname == "dummy"))
						{
							if (head.takedamage)
							{				
								if (CanDamage (head, self))
								{	
									T_DamageOrg (head, self, self, 8994, trace_endpos);
									self.done_damage = 1;
								}			
							}
						}
		

					head = head.chain;
					}
				
				}
			
			}
	
		}

    

	if(hitscan_missed == 1)
	{
		local vector R33 = '0.033 0.033 0';
		local vector R25 = '0.025 0.025 0';
	        
	        if(vlen(trace_endpos - src) > 1500) 
		{
			R25 = '0.019 0.019 0';
			R33 = '0.025 0.025 0';
		}
		if(vlen(trace_endpos - src) > 3000) 
		{
			R25 = '0.013 0.013 0';
			R33 = '0.017 0.017 0';
		}
		if(vlen(trace_endpos - src) > 4000) 
		{
			R25 = '0.010 0.010 0';
			R33 = '0.013 0.013 0';
		}
   
	
		if(self.frags != top_score_global)
		{
			if (total_players_global <= 2)  	//NOVEM
			{
				if(self.KDR < 0.3 && self.total_deaths > 3) FireBullets (20, dir, R33);    //FIRE BULLETS
				else if(self.KDR < 0.5 && self.total_deaths > 3) FireBullets (20, dir, R25);    //FIRE BULLETS
			}
	
			if (total_players_global > 2)
			{
				if(self.KDR < 0.3 && self.total_deaths > 3) FireBullets (20, dir, R33);    //FIRE BULLETS
				else if(self.KDR < 0.5 && self.total_deaths > 3) FireBullets (20, dir, R25);    //FIRE BULLETS
			}
		}
    
	}

  
    


	if (rail_armor_hit == 1)
	{
		makevectors(self.v_angle);
		local vector start = self.origin + '0 0 16'+ v_forward*5;
		local vector mdir = aim(self, 10000);
		local vector end = railend;
	
		if(antilag_hit_for_curve == 0)
		{
			if (!(self.player_flag & PF_CLEANTRAIL)) rail_make(start, end, self.v_angle, self);
			else clean_rail_make(start, end, self.v_angle, self);
		}
		else if(antilag_hit_for_curve == 1)
		{
			local float ref_length = vlen(adjusted_ent - self.origin);
			local vector ref_controlPt = self.origin + v_forward*0.5*ref_length;
			if (!(self.player_flag & PF_CLEANTRAIL)) DrawCurvedRail(v_forward, self.origin + '0 0 16'+ v_forward*5, ref_controlPt, ref_controlPt , adjusted_ent);
			else clean_DrawCurvedRail(v_forward, self.origin + '0 0 16'+ v_forward*5, ref_controlPt, ref_controlPt , adjusted_ent);
			//bprint("adjusted\n");
		}
		
		
		start = end;
		makevectors(armored_ent.angles);
		
		mdir = aim(armored_ent, 10000);
		mdir = mdir+v_up*75*(0.2+(random()*0.5)) + v_right*125*(random()-0.5);
		end = start + (mdir * 750);
		
		if(antilag_hit_for_curve == 0)
		{
			if (!(self.player_flag & PF_CLEANTRAIL)) rail_make(start, end, armored_ent.angles, armored_ent);
			else clean_rail_make(start, end, armored_ent.angles, armored_ent);
		}
		if(antilag_hit_for_curve == 1)
		{
			start = adjusted_ent;
			mdir = mdir+v_up*75*(0.2+(random()*0.5)) + v_right*125*(random()-0.5);
			end = start + (mdir * 750);
			if (!(self.player_flag & PF_CLEANTRAIL)) rail_make(start, end, armored_ent.angles, armored_ent);
			else clean_rail_make(start, end, armored_ent.angles, armored_ent);
		}
	}
	else if (rail_armor_hit == 0)
	{
		makevectors(self.v_angle);
		start = self.origin + '0 0 16'+ v_forward*5;
		mdir = aim(self, 10000);
		end = start + (mdir * 9100);

		if(antilag_hit_for_curve == 0)
		{
			if (!(self.player_flag & PF_CLEANTRAIL)) rail_make(start, end, self.v_angle, self);
			else clean_rail_make(start, end, self.v_angle, self);
			//bprint("un-adjusted\n");
		}
		else if(antilag_hit_for_curve == 1)
		{
			local float length = vlen(adjusted_ent - self.origin);
			local vector controlPt = self.origin + v_forward*0.5*length;
			if (!(self.player_flag & PF_CLEANTRAIL)) DrawCurvedRail(v_forward, self.origin + '0 0 16'+ v_forward*5, controlPt, controlPt , adjusted_ent);
			else clean_DrawCurvedRail(v_forward, self.origin + '0 0 16'+ v_forward*5, controlPt, controlPt , adjusted_ent);
			//bprint("adjusted\n");
		}
		//sprint(self, "regular shot");
	}



}


void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100;  
	
	self.dmg = FALSE;  // ELOHIM_MOD - used to flag 0 damage rockets

		local	entity	head;
		head = findradius(self.origin, 130);
		while (head)
		{
			if (head.classname == "smoke")
					{				
			
						local vector dir4 = head.origin - self.origin;     
						local float accel = 440*random() + 440;         
						head.velocity = head.velocity + accel*(normalize(dir4));
					}
			
			head = head.chain;
		}


	if (other.health)
	{
  
		if (other == self.owner) damg = damg * 0.5;  // mostly immune

		T_DamageOrg (other, self, self.owner, damg, self.origin);
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 100, other, self.origin);

	



//	sound (self, CHAN_WEAPON, "weap/br_explo.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	if(other.classname == "player")
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);

		BecomeExplosion ();
	}
	else
	{
		if(vlen(self.origin - self.owner.origin) > 75) make_power(self.origin, 0.7, 6);
		remove(self);
		
	}
};



void() update_projectile =
{
		local	entity	head;
		local float hit_yes = 0;
		head = findradius(self.origin, 90);
		while (head)
		{
			if ((head.classname == "player" || head.classname == "dummy") && (head != self.owner) && head.airborn_pos > 80) //&& (!teamplay || (head.team != self.owner.team)))
			{
				T_DamageOrg (head, self, self.owner, 100, self.origin);
				make_power(self.origin, 0.7, 7);
				hit_yes =1;
			}
			
			if (head.classname == "smoke")
					{				
			
						local vector dir4 = self.origin - self.owner.origin;     
						local float accel = 220*random() + 133;         
						head.velocity = head.velocity + accel*(normalize(dir4));
					}
			
			head = head.chain;
		}
		
		if(hit_yes ==1)
		{
			remove(self);
			return;
		}
		
		//bprint(ftos(vlen(self.antilag_aim)));
		//bprint("antilag before\n");

		if(vlen(self.owner.antilag_aim) >= 5) setorigin (self, self.origin + normalize(self.owner.antilag_aim)*5);
		
		if(vlen(self.owner.antilag_aim) >= 5) self.owner.antilag_aim = normalize(self.owner.antilag_aim) * (vlen(self.owner.antilag_aim)-5);
		if(vlen(self.owner.antilag_aim) < 5) self.owner.antilag_aim = normalize(self.owner.antilag_aim) * 1;
		
		
		//bprint(ftos(vlen(self.owner.antilag_aim)));
		//bprint("antilag after\n");
		
		
		self.nextthink = time + my_ticrate*1;
}

void() W_FireProjectile =
{

	rail_jump();
	if(self.ammo_slugs == 0) return;
	
	self.ammo_slugs = self.ammo_slugs -1;
	self.rail_shots +=1;


	local	entity missile;
	
	
	
	local float n = random()*4;
	if (n <= 1) 	sound (self, CHAN_WEAPON, "weap/br_ric1.wav",0.5,ATTN_NORM);
	else if (n <=2) sound (self, CHAN_WEAPON, "weap/br_ric2.wav",0.5,ATTN_NORM);
	else if (n <=3) sound (self, CHAN_WEAPON, "weap/br_ric3.wav",0.5,ATTN_NORM);
	else if (n <=4) sound (self, CHAN_AUTO, "weap/br_rail5.wav",0.75,ATTN_NORM);

	//self.punchangle_x = -2;
	makevectors(self.v_angle);   
	
	


	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
// set missile speed	

	makevectors (self.v_angle);
	missile.velocity = aim(self, 2750);
	missile.velocity = missile.velocity * 2750;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_MissileTouch;
	
	local vector src_cur = self.origin + v_forward*8 + '0 0 16';

	antilag_rewind_all(self.responsetime, world);
		local vector src_adj = self.origin + v_forward*8 + '0 0 16';	
	antilag_restore_all(); 
	self.antilag_aim = src_adj - src_cur;
	
	//bprint(ftos(vlen(self.antilag_aim)));
	//	bprint(" spawn antilag_aim\n");
	
	
	// set missile duration
	missile.nextthink = time + my_ticrate*1;
	missile.think = update_projectile;

	setmodel (missile, "mdl/null_trail.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
	
	
	
	
	
	
};



///// /      RAIL JUMP        /////////////////////////////////////////////////////////////////////////////////////////////


void() rail_jump =
{
	self.shot_downward = 0;
	makevectors(self.v_angle);
	
	
	local vector src = self.origin + v_forward*8 + '0 0 16';
	local vector dir = aim (self, 10000);
	dir =normalize(dir);
	
	traceline (src, src + dir*7200, FALSE, self);
    

    
	local vector velo_norm;
	local vector face_norm;
	local vector v_ang;
	local vector xy_vel;
    
	//bprint(ftos(v_forward_z));
 
	v_ang = vectoangles (v_forward*(-1));
    
	velo_norm = normalize(self.velocity);                
	face_norm = normalize(v_forward);
    
    
	xy_vel = self.velocity;
	xy_vel_z = 0;
 
 
 
	if(self.ammo_slugs ==0)
	{
		Rail_push(src+v_forward*70, self, 84, self);
		make_railpop();
	}
	
	

	
 
	if(time - self.grind_time < 0.2)         /////////////////////////WALLRUN RAIL JUMP
	{
		local vector org = self.origin + '0 0 16'+ v_forward*5;
		local float traillen = vlen(trace_endpos - org);
		//bprint(ftos(traillen));
		if(traillen < 125) 
		{
			//bprint(ftos(traillen));
			local float stored_vel = vlen(self.velocity);
			local vector push_vel = v_forward;
			push_vel_z = 0;
			
			self.velocity = self.velocity - push_vel*290;
			self.velocity = normalize(self.velocity) * stored_vel;
			
			
			self.velocity = self.velocity - v_forward*625;
			self.velocity = self.velocity - v_up*50;
			//sprint(self, "wallrun boost\n");
			
			if(self.velocity_z > 480) self.velocity_z = 480;
			else if(self.velocity_z < 200) self.velocity_z = 200;
			
			if((self.velocity_x + self.velocity_y)/2 < 200)
			{
				//bprint(ftos(self.velocity_z));
				//bprint("\n");
				self.velocity = self.velocity*1.33;
				self.velocity_z = 400;
			}
			else if((self.velocity_x + self.velocity_y)/2 < 270)
			{
				//bprint(ftos(self.velocity_z));
				//bprint("\n");
				self.velocity = self.velocity*1.25;
				self.velocity_z = 400;
			}
			
			if(vlen(self.velocity) > 1250) self.velocity = normalize(self.velocity)*1280;
			//bprint(ftos(self.velocity_z));
			
			self.punchang =0;
			
			if(self.tilted ==1)
			{
				stuffcmd(self, "as30\n");
				stuffcmd(self, "an0\n");
				self.tilted=0;
			}
			
			self.grind_completed = 0;
			self.punchang = 0;
			self.anglestored = 0;
			self.angles_not_zero = 0;
			

			stuffcmd(self, "spd00\n");
			self.blast_time = time;
			
			
		}
		
	
	}
	
	else if (v_forward_z < -0.9 && vlen(trace_endpos - src) < 100 && self.flags & FL_ONGROUND && vlen(self.velocity) <= 300) //rail jump from standing still  9-17-23
	{
			//bprint(ftos(vlen(self.velocity)));
			self.flags = self.flags - FL_ONGROUND;
			self.velocity = self.velocity -dir*600;   //RAIL 711
			//bprint("\n");
			//bprint(ftos(vlen(self.velocity)));
			//bprint("\n");
			if (self.velocity_z > 330 && !(self.player_flag & PF_ITEM_RUNE3_FLAG) && self.shot_time > 1.1) self.shot_time = self.shot_time - 0.6;
			
	}	
	
	else if(v_ang_x > 60 && v_ang_x < 120)
	{
		self.shot_downward = 1;
	
		if(time - self.thor_time < 0.3) 
		{
			self.velocity = self.velocity - dir*750;   //THOR JUMP
			//sprint(self, "thor jump\n");
		}
			
		
		else if (vlen(trace_endpos - src) < 130 && self.flags & FL_ONGROUND  && vlen(self.velocity) > 300) 
		{
			self.velocity = self.velocity - dir*750;   //RAIL 711
			if (self.velocity_z > 330 && !(self.player_flag & PF_ITEM_RUNE3_FLAG) && self.shot_time > 1.1) self.shot_time = self.shot_time - 0.6;
			//sprint (self,"ground 750");
		}		
	
		else if ((self.airborn_pos < 100) && !(self.flags & FL_ONGROUND) && (self.jump_flag <= 0 && self.jump_flag > -300) )
		{
				self.velocity = self.velocity - dir*(600+((-1)*self.jump_flag));
				if (self.velocity_z > 330 && !(self.player_flag & PF_ITEM_RUNE3_FLAG) && self.shot_time > 1.1) self.shot_time = self.shot_time - 0.6;
				//sprint (self,"downward 600");
		}
		else if ((self.airborn_pos < 100) && !(self.flags & FL_ONGROUND) && self.jump_flag > 0) 
		{
				self.velocity = self.velocity - dir*600;  
				if (self.velocity_z > 330 && !(self.player_flag & PF_ITEM_RUNE3_FLAG) && self.shot_time > 1.1) self.shot_time = self.shot_time - 0.6;
				//sprint (self,"upward 600");
		}
	
		else if (!(self.flags & FL_ONGROUND)) 
		{
			self.velocity = self.velocity - dir*500; 
			if (self.velocity_z > 330 && !(self.player_flag & PF_ITEM_RUNE3_FLAG) && self.shot_time > 1.1) self.shot_time = self.shot_time - 0.6;
			//sprint (self,"in air 500 up");
		}
	}
   
	else if(velo_norm * face_norm<-0.25)                          //dont rail jump if facing the same direction as velocity vector   //7-16
	{
	
		if (!(self.flags & FL_ONGROUND))
		{
			self.velocity = self.velocity - dir*500;        //Rail jump
			if (self.velocity_z > 330 && !(self.player_flag & PF_ITEM_RUNE3_FLAG) && self.shot_time > 1.1) self.shot_time = self.shot_time - 0.6;
			//sprint (self,"non colinear 500");
		}

   
	}

	else if (velo_norm * face_norm<0 && vlen(self.velocity) > 550 && v_ang_x > 40 && v_ang_x < 140 && !(self.flags & FL_ONGROUND))
	{
		self.velocity = self.velocity - dir*500;        //Rail jump
		if (self.velocity_z > 330 && !(self.player_flag & PF_ITEM_RUNE3_FLAG) && self.shot_time > 1.1) self.shot_time = self.shot_time - 0.6;
		//sprint (self,"550vel and 40deg down and 90 deg dot product\n"); 
	}
	
	else 
	{
		self.railjump_yes =0;
		return;
	}
	
	
	if(self.railjump_yes ==0) self.railjump_yes +=1;
	if(self.ammo_slugs != 0 && vlen(self.velocity) > 400) 
	{
		self.ammo_slugs+=1;
		self.rail_shots -=1;
	}




}





void() Rail_Charge_Logic=
{
	//RAIL TIMING LOGIC
		if(elohim_playmode & ELOHIM_CLASSIC || self.ammo_slugs <= 0) return;
		
		
		if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.items2 & IT2_SIGIL2)) 
		{
			//sprint(self,"railgun charge unavailable with POWER RUNE\n");
			return; //DECEM no sidewinder with Power
		}
		
		
		
		local float RECHARGE = 21;   //cooldown time
		
		if(mapname == "tut1") RECHARGE = 2;
		
		
		local float CHARGE_DUR = 1;
		local float POWER_TIME = 1.1;
		
		if(self.KDR > 1.8 && self.frags == top_score_global) 
		{
			CHARGE_DUR = 1.1;
			POWER_TIME = 0.80;
		}
		
		else if(self.KDR > 2.7) 
		{
			CHARGE_DUR = 1.1;
			POWER_TIME = 0.80;
		}
		else
		{
			CHARGE_DUR = 1.1;
			POWER_TIME = 0.85;     //NOVEM
		}
		
		
		if (!(self.flags & FL_ONGROUND)) CHARGE_DUR = 0.59;
	
		if (time - self.rail_power_time > CHARGE_DUR && self.rail_power_time != 0 && self.rail_powered == 0)
		{
			
			
			if(time - self.mag_recharge_time > RECHARGE || self.mag_recharge_time == 0)
			{
				
				self.rail_powered = 1;
				self.rail_power_time = time;
				
				sound (self, CHAN_WEAPON, "weap/br_charged.wav", 1, ATTN_NORM);
				//sprint(self, "mag-field energized\n");
			
				self.weaponmodel = "mdl/v_rail_rr.mdl";
				if (self.height == elohim_team2) self.weaponmodel = "mdl/v_rail_bb.mdl";
				self.weaponframe = 0;
			}
			
			else if (time - self.mag_recharge_time <= RECHARGE && self.mag_recharge_time != 0)	
			{
				if (time - self.rail_power_time > CHARGE_DUR && time - self.rail_power_time < (CHARGE_DUR+1) && self.rail_power_time != 0 && self.rail_powered == 0) sound (self, CHAN_WEAPON, "misc/br_deplete.wav", 0.9, ATTN_NORM);
				if (time - self.rail_power_time > CHARGE_DUR && time - self.rail_power_time < (CHARGE_DUR+0.024) && self.rail_power_time != 0 && self.rail_powered == 0) sprint(self, "mag-field depleted\n");
			
			}
		}
	
	
		if (self.rail_powered == 1 && time - self.rail_power_time > POWER_TIME) //(CHARGE_DUR + 1.5))
		{
			self.rail_powered = 0;
			self.mag_recharge_time = time;
				
				
				sound (self, CHAN_AUTO, "weap/br_slowdn.wav", 0.7, ATTN_NORM);
				sprint(self, "mag-field depleted\n");
			
				self.weaponmodel = "mdl/v_rail_r.mdl";
				if (self.height == elohim_team2) self.weaponmodel = "mdl/v_rail_b.mdl";
				self.weaponframe = 0;
		}
	
	
	
		//END. RAIL TIMING LOGIC
		
}