.vector dmg_origin;
.float nogib_death;




void(entity targ, entity attacker, vector damage_origin, float damage) Killed =
{
	if(targ.classname == "dummy") 
	{
		tut_gib_time =time;
		dummy_spawned = 0;
	}
	
	
	if(targ.frags == top_score_global && crown_out ==1 && targ.hascrown == 1 && crown_ent.classname == "crown")
	{
		remove(crown_ent);
		targ.hascrown = 0;
		crown_out = 0;
	}
	
	
	local entity oself;
	
	oself = self;
	self = targ;
	
	
	
	if((elohim_playmode & ELOHIM_WRAITH) && self.wraith == 0 && total_players_global >= 4)
	{
		if(self.height == elohim_team1 && ghost_red == 0)
		{
			self.wraith =1;
			ghost_red=1;
		}
		else if(self.height == elohim_team2 && ghost_blue == 0)
		{
			self.wraith =1;
			ghost_blue=1;
		}
	}
	else if((elohim_playmode & ELOHIM_WRAITH) && self.wraith == 1 && total_players_global >= 4) 
	{
		self.wraith =0;
		if(self.height == elohim_team1) ghost_red =0;
		else if(self.height == elohim_team2) ghost_blue =0;
	}
	else if((elohim_playmode & ELOHIM_WRAITH) && total_players_global < 4) 
	{
		if(self.wraith == 0) self.wraith =1;
		else if(self.wraith == 1) self.wraith =0;
	}
	
	
	
	//set where killing damage came from
	self.dmg_origin = damage_origin;
	if(damage ==9) self.nogib_death = 1; //set value IF player was killed by fire (this is so we can change gib sequence to conserve entities)
	
	if (self.health < -99) self.health = -99;	


	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;
	
	
	
	ClientObituary(self, attacker, damage);
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
	self.th_die ();


	self = oself;
	oself = self;
	self = attacker;
	
	if(attacker == world) self = targ;
	
	//bprint(ftos(damage));
	
	if ((attacker.last_fragged_carrier + 1) > time && targ.frags == top_score_global) 	make_icon(self,4, damage);  //Flag carrier king
	else if (attacker == targ || attacker == world) 					make_icon(self,7, damage);  //TK's
	else if(targ.frags == top_score_global) 						make_icon(self,2, damage);   //King
	else if((attacker.last_fragged_carrier + 1) > time)					make_icon(self,3, damage);   //Flag carrier
	else 											make_icon(self,1, damage); 

	
	
	self = oself;
	
};




vector(float dm, float inair) VelocityForDamage =
{
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 125 * random();
	
	if(inair ==1) v_z = v_z/4;  //FEBRUARY
	else v_z = v_z/1.5;
	
	if (dm > -50)
	{
//		dprint ("level 1\n");
		v = v * 0.7;
	}
	else if (dm > -200)
	{
//		dprint ("level 3\n");
		v = v * 2;
	}
	else
		v = v * 4;
		

	//apply directional damage multiplier
	local vector dir = self.origin - self.dmg_origin;
	v = v + normalize(dir)*((random()*500)+425);
		
	return v;
};


void() update_gib =
{
	self.alpha = self.alpha -0.025;
	if(self.alpha <= 0.025) self.think = SUB_Remove;
	
	self.nextthink = time + 0.01;
}


void(string gibname, float dm, float inair) ThrowGib =
{
	
	
	local	entity new;
	
	new = spawn();
	
	/*
	local vector unit = normalize(self.origin - self.dmg_origin);
	unit_x = unit_x + random()*0.5;
	unit_y = unit_y + random()*0.5;
	unit = normalize(unit);
	*/
	
	//new.origin = self.origin + '0 0 18';
	local float rand = random();
	if (rand< 0.25) new.origin = self.origin + '0 0 8';
	else if (rand< 0.5) new.origin = self.origin + '0 0 20';
	else if (rand< 0.75) new.origin = self.origin + '0 0 30';
	else if (rand<= 1) new.origin = self.origin + '0 0 40';
	
	new.velocity = VelocityForDamage (dm, inair);
	
	new.origin = new.origin + normalize(new.velocity)*45;
	
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.classname = "giblets";
	
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_TRIGGER;  // _NOT -> _TRIGGER
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;

	new.alpha =0.8;
	new.owner = self;
	new.think = update_gib;
	new.ltime = time;

        new.nextthink = time + 2.0 + random()*2.0;

	new.frame = 0;
	new.flags = 0;
};

void() update_splat=
{
	//self.customizeentityforclient = splat_customize;
	self.frame +=1;
	
	if(self.frame==1) 
	{
		Splat3();
		if(self.owner.nogib_death == 0)
		{
			Splat5();
			Splat5();
		}
	}
	if(self.frame==2 && total_players_global < 9 && smoke_ent_number < 8) Splat4();
	if(self.frame==3) Splat2();
	
	if(self.frame==13) self.think = SUB_Remove;
	self.nextthink = time + 0.05;
}


void()Splat =
{
	local	entity new;
	
	new = spawn();
	
	
	setsize (new, '0 0 0', '0 0 0');
	new.scale = 0.125;
	
	local vector unit = normalize(self.origin - self.dmg_origin);
	new.origin = self.origin + '0 0 24' + unit*21;
	
		if(random()<0.7) setmodel (new, "progs/bloodrailz/s_blood_1024.spr");
	else 
	{
		setmodel (new, "progs/bloodrailz/s_blood_512xv.spr");
		new.scale = 0.25;
	}

	new.classname = "splat";
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;


	new.alpha =0.9;
	new.owner = self;
	
	//new.customizeentityforclient = splat_customize;
	
	new.think = update_splat;
	new.ltime = time;
        new.nextthink = time + 0.04;

	new.frame = 0;
	new.flags = 0;
};


void() update_splat2=
{
	//self.customizeentityforclient = splat_customize;
	
	if(self.frame==13) self.think = SUB_Remove;
	self.frame +=1;
	self.nextthink = time + 0.05;
}


void()Splat2 =
{
	local	entity new;
	new = spawn();
	
	
	setsize (new, '0 0 0', '0 0 0');
	new.scale = 0.125;
	
	local vector unit = '0 0 0';
	
	local float rand = random()-0.5;
	if (rand<0.3 && rand >0) rand = 0.3;
	else if (rand>-0.3 && rand <0) rand = -0.3;
	
	local float randy = random()-0.5;
	if (randy<0.25 && randy >0) randy = 0.25;
	else if (randy>-0.25 && randy <0) randy = -0.25;
	
	unit_x = rand;
	unit_y = randy;
	
	local vector vertical = '0 0 0';
	vertical_z = 25*rand;

	new.origin = self.origin + unit*(45);
	new.origin = new.origin + vertical;
	
	if(random()<0.59) setmodel (new, "progs/bloodrailz/s_blood_1024.spr");
	else 
	{
		setmodel (new, "progs/bloodrailz/s_blood_512xv.spr");
		new.scale = 0.25;
	}

	
	new.classname = "splat";
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	new.alpha =0.9;
	new.owner = self.owner;
	
	//new.customizeentityforclient = splat_customize;
	
	new.think = update_splat2;
	new.ltime = time;
        new.nextthink = time + 0.05;

	new.frame = 0;
	new.flags = 0;
};

void() update_splat3=
{
	//self.customizeentityforclient = splat_customize;
	
	if(self.frame==13) self.think = SUB_Remove;
	self.frame +=1;
	self.nextthink = time + 0.05;
}


void()Splat3 =
{
	local	entity new;
	new = spawn();
	

	new.scale = 0.1;
	setsize (new, '0 0 0', '0 0 0');
	
	local vector unit = '0 0 0';
	
	local float rand = random()-0.5;
	if (rand<0.3 && rand >0) rand = 0.3;
	else if (rand>-0.3 && rand <0) rand = -0.3;
	
	local float randy = random()-0.5;
	if (randy<0.25 && randy >0) randy = 0.25;
	else if (randy>-0.25 && randy <0) randy = -0.25;
	
	unit_x = rand;
	unit_y = randy;
	
	//local vector vertical = '0 0 0';
	//vertical_z = 25*rand;

	new.origin = self.origin + unit*(55);
	new.origin = new.origin + '0 0 15';

	if(random()<0.55) setmodel (new, "progs/bloodrailz/s_blood_1024.spr");
	else
	{
		setmodel (new, "progs/bloodrailz/s_blood_512xv.spr");
		new.scale = 0.25;
	}
	
	
	
	new.classname = "splat";
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	
	new.alpha = 0.9;
	
	new.owner = self.owner;
	
	//new.customizeentityforclient = splat_customize;
	
	new.think = update_splat3;
	new.ltime = time;
        new.nextthink = time + 0.05;

	new.frame = 0;
	new.flags = 0;
};

void() update_splat4=
{
	//self.customizeentityforclient = splat_customize;
	
	if(self.frame==13) self.think = SUB_Remove;
	self.frame +=1;
	self.nextthink = time + 0.04;
}


void()Splat4 =
{
	local	entity new;
	new = spawn();
	
	
	setsize (new, '0 0 0', '0 0 0');
	new.scale = 0.125;
	
	local vector unit = '0 0 0';
	
	local float rand = random()-0.5;
	if (rand<0.25 && rand >0) rand = 0.25;
	else if (rand>-0.25 && rand <0) rand = -0.25;
	
	local float randy = random()-0.5;
	if (randy<0.25 && randy >0) randy = 0.25;
	else if (randy>-0.25 && randy <0) randy = -0.25;
	
	unit_x = rand;
	unit_y = randy;
	//unit = normalize(unit);
	
	local vector vertical = '0 0 0';
	vertical_z = 25*rand;

	new.origin = self.origin + unit*(rand*70);
	new.origin = new.origin +vertical;
	

	setmodel (new, "progs/bloodrailz/s_blood_1024.spr");
	
	
	new.classname = "splat";
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	new.alpha =0.9;
	
	new.owner = self.owner;
	
	//new.customizeentityforclient = splat_customize;
	
	new.think = update_splat4;
	new.ltime = time;
        new.nextthink = time + 0.05;

	new.frame = 0;
	new.flags = 0;
};

void() update_splat5=
{
	//self.customizeentityforclient = splat_customize;
	if(self.frame==13) self.think = SUB_Remove;
	self.frame +=1;
	self.nextthink = time + 0.05;
}


void()Splat5 =
{
	local	entity new;
	new = spawn();
	
	
	setsize (new, '0 0 0', '0 0 0');
	new.scale = 0.1;
	
	local vector unit = '0 0 0';
	
	local float rand = random()-0.5;
	if (rand<0.3 && rand >0) rand = 0.3;
	else if (rand>-0.3 && rand <0) rand = -0.3;
	
	local float randy = random()-0.5;
	if (randy<0.25 && randy >0) randy = 0.25;
	else if (randy>-0.25 && randy <0) randy = -0.25;
	
	unit_x = rand;
	unit_y = randy;
	
	local vector vertical = '0 0 0';
	vertical_z = 25*rand;

	new.origin = self.origin + unit*(70);
	new.origin = new.origin +vertical;

	if(random()<0.60) setmodel (new, "progs/bloodrailz/s_blood_1024.spr");
	else 
	{
		setmodel (new, "progs/bloodrailz/s_blood_512xv.spr");
		new.scale = 0.25;
	}
	
	new.classname = "splat";
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	//new.alpha =0.9;
	new.alpha = 0.40 + random();
	if(new.alpha > 1) new.alpha = 0.9;
	
	new.owner = self.owner;
	
	//new.customizeentityforclient = splat_customize;
	
	new.think = update_splat5;
	new.ltime = time;
        new.nextthink = time + 0.05;

	new.frame = 0;
	new.flags = 0;
};

void() vial_touch =
{

   	if (other.classname != "player") return;
	if (other.health <= 0) return;

	if ((self.style & ELOHIM_OBSERVER) || (other.style & ELOHIM_OBSERVER) ||
        (other.deadflag == DEAD_DEAD) || (other.deadflag == DEAD_DYING) )  
        return;


	if (self.skin ==1)   //BLUE
	{
		 sprint(other,"power shard\n");  
		if(other.mag_recharge_time >= 1.9) other.mag_recharge_time = other.mag_recharge_time -1.9;
		
		
		if(other.ammo_slugs<6) other.ammo_slugs = other.ammo_slugs +1;
		else if(other.ammo_slugs<= 0) other.ammo_slugs = 1;
		
		if(other.ammo_slugs > 7) other.ammo_slugs =7;
		
		other.rail_HUD = 2;
		
		
	}
	else if (self.skin ==4)   //RED
	{
		sprint(other,"shield shard\n");  
		if( !(other.items & IT_ARMOR1 && other.items & IT_ARMOR2 && other.items & IT_ARMOR3))  other.items = other.items | IT_ARMOR3;
		
		if(other.shield_recharge_time >= 3) other.shield_recharge_time = other.shield_recharge_time -3;
		if(other.shield_time >= 3) other.shield_time = other.shield_time -3;
		
		if (other.armorvalue < 200)
                {
			other.armorvalue  	= other.armorvalue + 20;
			if (other.armorvalue >200) other.armorvalue = 200;
                }      
                other.health  	= other.health + 15;
                if(other.health > 125) other.health = 125;

		
	}
	



	sound (other, CHAN_AUTO, "bloodrailz/items/br_loot.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	remove(self);
};


void () update_vial =
{
	
	if (self.flags & FL_ONGROUND) self.flags = self.flags - (self.flags & FL_ONGROUND);
	
	if(time - self.ltime > 10 + 10*self.cnt)
	{
		if(self.skin ==1 || self.skin ==6)   //BLUE
		{
			if(self.weapon > 32) self.alpha = self.alpha - 0.02;
		
			self.weapon = self.weapon + 1;
			if(self.weapon%11 == 0) self.skin = 6;
			if(self.weapon%22 == 0) self.skin = 1;
			//else self.skin = 1;
		
			if(self.weapon >= 2000) self.weapon = 0;
		
		
			if(self.alpha <= 0.01) self.think = SUB_Remove;
		}
	
		else if(self.skin ==4 || self.skin ==7)    //RED
		{
			if(self.weapon > 32) self.alpha = self.alpha - 0.02;
		
			self.weapon = self.weapon + 1;
			if(self.weapon%11 == 0) self.skin = 7;
			if(self.weapon%22 == 0) self.skin = 4;
			//else self.skin = 4;
		
			if(self.weapon >= 2000) self.weapon = 0;
		
			if(self.alpha <= 0.01) self.think = SUB_Remove;
		}
	

		else if(self.skin ==0) self.think = SUB_Remove;
	}
	
	local entity head = findradius(self.origin, 180);
	while (head)
	{
			if (head.classname == "player")
			{				
				if(self.health !=1) 
				{
					self.velocity = self.velocity + '0 0 100';
					self.health =1;
				}
					
	
				else
				{ 
					local vector dir2 = (head.absmin + head.absmax) * 0.5 - (self.absmin + self.absmax) * 0.5;              
					self.velocity = self.velocity + 75*(normalize(dir2));
				}
										
			}
			
			head = head.chain;
	}
	
	
	self.nextthink = time + 0.01;
}


void(float dm, float inair) ThrowVial =
{
	local	entity new1;

	
	new1 = spawn();
	
	if (random()< 0.25) setorigin(new1, self.origin + '0 0 5');
	else if (random()< 0.5) setorigin(new1, self.origin + '0 0 6');
	else if (random()< 0.75) setorigin(new1, self.origin + '0 0 7');
	else if (random()<= 1) setorigin(new1, self.origin + '0 0 8');
	
	setmodel (new1, "progs/bloodrailz/vial.mdl");
	setsize (new1, '-10 -10 -2', '10 10 16');
	new1.velocity = VelocityForDamage (dm, inair);
	new1.movetype = MOVETYPE_TOSS;
	new1.solid = SOLID_TRIGGER;
	new1.owner = self;
	new1.ltime = time;
	new1.cnt = random();
	new1.speed = 0;
	new1.classname = "vials";
	
	
	new1.ltime = time;
	new1.alpha = 0.55;
	
	new1.velocity = new1.velocity*0.3;
	new1.velocity_z = new1.velocity_z + random()*180 + 250;
	new1.velocity_x = new1.velocity_x + random()*80 + 40;
	new1.velocity_y = new1.velocity_y + random()*80 + 40;
	
	if(random()<= 0.5 && !(elohim_playmode & ELOHIM_CLASSIC)) 
	{
		new1.skin = 1;   //blue
		new1.frame = 1;
	}
	else if(random()<= 1.0 && !(elohim_playmode & ELOHIM_CLASSIC)) 
	{
		new1.skin = 4;   //red
		new1.frame = 2;
	}

	else 
	{
		new1.alpha = 0.001;
		new1.skin =0;
	}

	new1.flags = 0;
	new1.touch = vial_touch;
	
        new1.nextthink = time + 0.01;
        new1.think = update_vial;


};






////////////////////////////////////////////////////////////////////////////




void() GibPlayerChangeTeams =
{
       
        local float inair;
   	if(self.airborn_pos > 55) inair = 1; //FEBRUARY
        ThrowGib ("progs/bloodrailz/br_gib1.mdl", self.health, inair);
        ThrowGib ("progs/bloodrailz/br_gib2.mdl", self.health, inair);
            ThrowGib ("progs/bloodrailz/br_gib3.mdl", self.health, inair);
            ThrowGib ("progs/bloodrailz/br_gib3.mdl", self.health, inair);

	self.deadflag = DEAD_DYING;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "bloodrailz/player/br_gib.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound (self, CHAN_VOICE, "bloodrailz/player/br_gib.wav", 1, ATTN_NONE);
		return;
	}
		
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "bloodrailz/player/br_gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "bloodrailz/player/br_death.wav", 1, ATTN_NONE);
};




void() GibPlayer =
{
   	local float inair;
   	if(self.airborn_pos > 55) inair = 1; //FEBRUARY
   	
   	if(self.nogib_death ==0)
   	{
		ThrowGib ("progs/bloodrailz/br_gib3.mdl", self.health, inair);
		ThrowGib ("progs/bloodrailz/br_gib1.mdl", self.health, inair);
		if(total_players_global <= 12 && smoke_ent_number < 8) ThrowGib ("progs/bloodrailz/br_gib2.mdl", self.health, inair);
		if(total_players_global <= 8 && smoke_ent_number < 8) ThrowGib ("progs/bloodrailz/br_gib3.mdl", self.health, inair);
		if(total_players_global < 8 && smoke_ent_number < 8) ThrowGib ("progs/bloodrailz/br_gib2.mdl", self.health, inair);
	}
	
	Splat();
           
        if(self.nogib_death != 2)
        {
		if(total_players_global > 8)
		{
			if(random()< 0.40) ThrowVial (-20, inair);
			//if(total_players_global <= 9 && smoke_ent_number < 8) if(random()< 0.40) ThrowVial (-30, inair);
			//if(total_players_global <= 9 && smoke_ent_number < 8) if(random()< 0.40) ThrowVial (-40, inair);
		}
		else
		{
			if(random()< 0.44) ThrowVial (-20, inair);
			if(smoke_ent_number < 8) if(random()< 0.44) ThrowVial (-30, inair);
			if(total_players_global <= 6 && smoke_ent_number < 8) if(random()< 0.42) ThrowVial (-40, inair);
		}
	}
            
	self.deadflag = DEAD_DYING;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "bloodrailz/player/br_gib.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound (self, CHAN_VOICE, "bloodrailz/player/br_gib.wav", 1, ATTN_NONE);
		return;
	}
		
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "bloodrailz/player/br_gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "bloodrailz/player/br_death.wav", 1, ATTN_NONE);
};
