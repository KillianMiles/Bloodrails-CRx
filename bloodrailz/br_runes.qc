//
// Rune functions
//
// threewave resources commented

void() respawn;

const string SOUND_PICKUP_RUNE = "item/br_runegr.wav";      //custom made for BR
const string SOUND_RUNE_RESIST = "item/br_protec3.wav"; //librequake
const string SOUND_RUNE_STREN = "item/br_dmg2.wav";    //librequake
//const string SOUND_RUNE_HASTE = "misc/basekey.wav";   //changed haste rune noise ftom boss1/sight1.wav to misc/basekey.wav 
const string SOUND_RUNE_REGEN = "item/br_regen.wav"; //librequake

const string MODEL_RUNE_RESIST = "mdl/br_rune1.mdl";
const string MODEL_RUNE_STREN = "mdl/br_rune2.mdl";
const string MODEL_RUNE_HASTE = "mdl/br_rune3.mdl";
const string MODEL_RUNE_REGEN = "mdl/br_rune4.mdl";

void () runes_precache =
{
	precache_sound (SOUND_PICKUP_RUNE);
	precache_sound (SOUND_RUNE_RESIST); //resist rune
	precache_sound (SOUND_RUNE_STREN); //strength
	//precache_sound (SOUND_RUNE_HASTE); //haste
	precache_sound (SOUND_RUNE_REGEN);		// health box/(enviro/regen/radio) heal	
	precache_model (MODEL_RUNE_RESIST);
	precache_model (MODEL_RUNE_STREN);
	precache_model (MODEL_RUNE_HASTE);
	precache_model (MODEL_RUNE_REGEN);
};

 

//regeneration Plasma hook rune function

void () rune_regen =
{
	local float any, m;

	if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG)) 
	{
		if (self.runetime > time)	return;
   
		self.runetime = time + 2;

		any = 0;

		m = 100;

		if (self.armorvalue < m)
		{
			any = 1;
			self.armorvalue = self.armorvalue + 10;
			if (self.armorvalue > m)	self.armorvalue = m;
		}

		if (any)	sound (self, CHAN_AUTO, SOUND_RUNE_REGEN, 0.7, ATTN_NORM);
	}
};


entity () rune_select_spawn_point =
{
	if(elohim_playmode & RACE_MODE && mapname == "tut1")
	{
	
		runespawn = find(runespawn, classname, "info_player_start");
		if (runespawn == world)
		{
			runespawn = find(runespawn, classname, "info_player_start");
		}
		if (runespawn == world)
		{
			error ("no info_player_deathmatch to spawn rune");
		}
	}
	else
	{
		runespawn = find(runespawn, classname, "info_player_deathmatch");
		if (runespawn == world)
		{
			runespawn = find(runespawn, classname, "info_player_deathmatch");
		}
		if (runespawn == world)
		{
			error ("no info_player_start to spawn rune");
		}
	}
	return (runespawn);
};

void() rune_touch =
{
	if(other.classname == "item_rune")
	{
		if(self.flags & FL_ONGROUND) self.flags = self.flags - (self.flags & FL_ONGROUND);
		if(other.flags & FL_ONGROUND) other.flags = other.flags - (other.flags & FL_ONGROUND);
		
		if(vlen(other.velocity) < 400 && vlen(self.velocity) < 400) 
		{
			other.velocity = other.velocity + normalize(other.origin - self.origin)* 7 + '0 0 15';
			self.velocity = self.velocity + normalize(self.origin - other.origin)* 7 + '0 0 15';

		}
		return;
	}


	tracebox(self.origin + '0 0 -4', '-16 -16 -4', '16 16 0', self.origin + '0 0 -5', 1, self);
	if(trace_startsolid == TRUE  && other.classname != "player" && other.classname != "hook_entity" && other.classname != "plasma" && other.classname != "item_rune")    
	{
		if(time - self.ltime < 2) 
		{
			setorigin(self, self.origin + '0 0 3');
			//bprint(" rUP!\n");
		}
	}

	if (elohim_playmode & ELOHIM_MATCH_MODE && !(elohim_state & ELOHIM_MATCH_STARTED))
	{
		return;
	}
	if(time - self.ltime < 1.00) return;	//10/8/23  cant pick up the rune before 1s after drop
	
	if (other.classname != "player") return;
	
	//if((other.player_flag & PF_ITEM_RUNE1_FLAG)) bprint("rune1 yes "); //rune1 debug

	if (other.runetime >= time && !(other.player_flag & PF_ITEM_RUNE1_FLAG)) return;
	
	

	if (other.health <= 0) return;

	if ((self.style & ELOHIM_OBSERVER) || (other.style & ELOHIM_OBSERVER) || (other.deadflag == DEAD_DEAD) || (other.deadflag == DEAD_DYING) )  return;

	if ((other == self.owner) && (self.nextthink > time + 119)) return;
	
	//if(time%1.10<0.7 && (other.player_flag & PF_ITEM_RUNE_MASK)) // ((time * 1000) % (500 * 2) < 500)  500ms on,  500 off
	if(((time * 1000) % (400 * 2) < 400) && (other.player_flag & PF_ITEM_RUNE_MASK)) // ((time * 1000) % (500 * 2) < 500)  500ms on,  500 off
	{
		//if(mapname != "tut1") centerprint(other, "already got a rune\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
		//if(mapname == "tut1") other.have_rune_center =1;
		other.have_rune_center =1;
	}

	if ((other.player_flag & PF_ITEM_RUNE_MASK)) // || rune1_plasma >0) // <- the rune1_plasma clause is apparently there cos without it, it doesnt display the "already have a rune" text for PLASMA HOOK specifically
	{
		//centerprint(other, "You already have a rune.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
		//centerprint(other, "already got a rune\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
		return;
	}

	other.player_flag |= PF_ITEM_RUNE_MASK;
	other.player_flag = (other.player_flag | self.player_flag);
	
	if (other.player_flag & PF_ITEM_RUNE1_FLAG)//Rune 1 - Plasma Hook (Fire Cloud)
	{
		other.rune_bang =10;
		other.items2 = (other.items2 | IT2_SIGIL1);
		sprint(other,"Plasma hook rune - Hook shoots plasma, armor regenerates slowly\n");   //rune descriptions
		
		 if (other.armorvalue < 30)   // 200 -> 30
                    {
			other.items = other.items | IT_ARMOR1;
			other.armorvalue  	= 30;
			other.armortype   	= 40.001;
                    }
                    
	}
	else
	{
		if (other.player_flag & PF_ITEM_RUNE2_FLAG)//Power (strength)
		{
			other.rune_bang =20;
			other.items2 = (other.items2 | IT2_SIGIL2);			
			sprint(other,"[Power] - Railgun deals splash damage - Shoot at the floor\n"); //rune descriptions
		}
		else
		{
			if (other.player_flag & PF_ITEM_RUNE3_FLAG)
			{
				other.rune_bang =30;
				other.items2 = (other.items2 | IT2_SIGIL3);
				
				other.ammo_slugs +=1;
				if(other.ammo_slugs >7) other.ammo_slugs =7;   //9-24=23
				
				sprint(other,"[Haste] - Increases rate of fire\n"); //rune descriptions
            }
			else
			{
				if (other.player_flag & PF_ITEM_RUNE4_FLAG)//Death Aura(regeneration)
				{
					other.rune_bang =40;
					other.items2 = (other.items2 | IT2_SIGIL4);	
					sprint(other,"[Death Aura] - Deals damage to anything in your proximity\n ");  //rune descriptions
				}
			}
		}
	}
	
	sound (other, CHAN_AUTO, SOUND_PICKUP_RUNE, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	remove(self);
};


void(float flag) do_rune_drop;

void() rune_respawn =
{
	local entity oself;
	
	
	oself = self;
	self = rune_select_spawn_point ();
	do_rune_drop (oself.player_flag);
	remove(oself);
};

void() rune_clear_player_flags = 
{
    if (self.player_flag & PF_ITEM_RUNE1_FLAG)
        self.player_flag -= PF_ITEM_RUNE1_FLAG;
    if (self.player_flag & PF_ITEM_RUNE2_FLAG)
        self.player_flag -= PF_ITEM_RUNE2_FLAG;
    if (self.player_flag & PF_ITEM_RUNE3_FLAG)
        self.player_flag -= PF_ITEM_RUNE3_FLAG;
    if (self.player_flag & PF_ITEM_RUNE4_FLAG)
        self.player_flag -= PF_ITEM_RUNE4_FLAG;

    if (self.items2 & IT2_SIGIL1)
        self.items2 -= IT2_SIGIL1;
    if (self.items2 & IT2_SIGIL2)
        self.items2 -= IT2_SIGIL2;
    if (self.items2 & IT2_SIGIL3)
        self.items2 -= IT2_SIGIL3;
    if (self.items2 & IT2_SIGIL4)
        self.items2 -= IT2_SIGIL4;

    self.max_health = 100;

    if (self.player_flag & PF_ITEM_RUNE_MASK)
        self.player_flag -= PF_ITEM_RUNE_MASK;
};


void() update_smoke =
{
	if(self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
	
	local float zoff = random();
	local float frand;
	local vector zoffset = '0 0 0';
	local vector zoffset2 = '0 0 0';
	
	zoffset_z = (2.0+0.61*random())*zoff;
	zoffset_x = 2.1*1.25*2*(random() - 0.5);
	zoffset_y = 2.1*1.25*2*(random() - 0.5);
	
	zoffset2_z = (2.0 + 0.61*random())*1.55*zoff;
	zoffset2_x = 2.1*1.25*2*(random() - 0.5);
	zoffset2_y = 2.1*1.25*2*(random() - 0.5);
	
	if(self.skin ==22) 
	{
		zoffset_z = zoffset_z -0.45;
		zoffset2_z = zoffset_z -0.45;
	}
	
	if(zoffset_z > 1.50) self.alpha = self.alpha + .0042;
	
	if(zoff <= 0.33) frand = 4;
	else if(zoff <= 0.67) frand = 5;
	else if(zoff <= 1) frand = 6;	

	//makevectors(self.owner.owner.v_angle);   //DECEM
	
	if(self.alpha <= 0.04 && time - smoke_time < 40) 
	{
		if (self.effects & EF_RED) self.effects   = self.effects - EF_RED;
		if(time - smoke_time < 40 && !(self.is_over_sky ==1 && self.flags & FL_ONGROUND))  //DECEM
			{
				if(first_smoke == 1) make_smoke(smoke_origin, smoke_radius, 0);
			}
	}
	else if((self.alpha <= 0.04 && time - smoke_time >= 40) ||(self.classname == "ground_smoke" && time - smoke_time >= 40) ) //blahnew
	{
		self.think = SUB_Remove;
		if(self.classname == "ground_smoke") ground_smoke_number -= 1;
		if(ground_smoke_number<0) ground_smoke_number =0;
		smoke_generated =0;
		smoke_ent_number -=1;
		if(smoke_ent_number<0) smoke_ent_number =0;
	}
	
	
	if(self.weapon ==1)
	{
		self.alpha = self.alpha - (0.0008*2+(.00325*random()));
		if(self.skin == 28) self.alpha = self.alpha + .00027;
	}
	else
	{
		self.alpha = self.alpha - (0.0008*2+(.00325*random()))*1.25;
		if(self.skin == 28) self.alpha = self.alpha + .00027;
	}
	
	self.weapon +=1;
	
	if(self.weapon%7 ==0) if(self.alpha < 0.33) self.frame = frand;
	if(self.weapon >= 40) self.weapon = 0;

	
	local vector dist = self.origin - self.owner.origin;	
	if ((pointcontents(self.origin) == CONTENT_SOLID || vlen(dist) >= smoke_ceiling+13) || self.airborn_pos > 250) self.alpha = self.alpha -.0003;
	//else if(vlen(dist) >= smoke_ceiling) self.alpha = self.alpha -.0003;
		
	if(self.tarzan_time ==1) 
	{
		//self.movetype = MOVETYPE_FLY;
       		//self.solid = SOLID_NOT;
	}
	else if(self.classname == "smoke")
	{
		
		if(self.weapon ==1) setorigin(self, self.origin + zoffset);
		else setorigin(self, self.origin + zoffset*1.5);
	
		if(self.speed == 0 && random()< 0.12) 
		{
			if(self.weapon ==1) setorigin(self, self.origin + zoffset2);
			else setorigin(self, self.origin + zoffset2*1.5);
			self.speed = 1;
		}
		//self.alpha =.001;
	}
	else if(self.classname == "ground_smoke")
	{
		if(self.origin_z > smoke_origin_z +40) 
		{
			if(first_smoke == 1) make_smoke(smoke_origin, smoke_radius, 0);
			//make_smoke(smoke_origin, smoke_radius, 0);
		}
		else setorigin(self, self.origin + zoffset);
		self.alpha =.3;
	}
	
	
	if(vlen(self.origin - smoke_origin) > 250)
	{
				if(vlen(self.origin - smoke_origin) > 300) 
				{
					setmodel(self, "mdl/ef_smoke1.mdl");
				}
				
				local entity head = findradius(self.origin, 48);
				while (head)
				{
					if (head != world)
					{

						if (head.takedamage || head.classname == "dummy")
						{				
							if (CanDamage (head, self) || head.classname == "dummy")
							{	

								if(self.done_damage ==0)
								{
									if(head.shields_up !=1) 
									{
										T_DamageOrg (head, self, self.owner, 9, self.origin);
										
										if(head.armorvalue >0) head.armorvalue -= 3;
										if(head.armorvalue <=0) head.armorvalue =0;
										self.done_damage = 0;
									}
								}
								else self.done_damage +=1;
								
							
							
							}			
						}
					}
					head = head.chain;
				}
	}

	if(self.classname =="ground_smoke") 
	{
		if(random()<0.5) self.nextthink = time + my_ticrate*23;
		else self.nextthink = time + my_ticrate*29;
	}
		
	else if(self.weapon ==1) self.nextthink = time + my_ticrate*2;
	else self.nextthink = time + my_ticrate*3;
}
		



void(vector origin1, float radius, float steam) make_smoke =
{
	//static float smokenum;
	
	local float frand;
	local vector randomizer = '0 0 0';
	local vector check;
	randomizer_x = radius*2*(random() - 0.5);
	randomizer_y = radius*2*(random() - 0.5);
	randomizer_z = -20*random();
	if(steam ==1) randomizer_z = radius*2*(random() - 0.5);
	
	origin1_z = origin1_z - 7;
	
	if(random() <= 0.33) frand = 6;
	else if(random() <= 0.75) frand = 7;
	else if(random() <= 1) frand = 8;	
	
	check = origin1 + randomizer;
	
	if(steam ==0) check_z = origin1_z;
	
	local vector dir = origin1 - check;
	
	traceline(origin1 + '0 0 7', check + '0 0 7', TRUE, self);
	

	
	
	if(trace_fraction <0.8) 
	{
		//bprint("dont spawn in wall\n");
		self.smoke_offset = self.smoke_offset + normalize(dir);
		self.smoke_offset_counter +=1;
		if(self.smoke_offset_counter == 2)
		{
			local vector new_origin = smoke_origin + normalize(dir)*80;
			traceline(smoke_origin+ '0 0 20', new_origin + '0 0 20', TRUE, self);
			if(trace_fraction ==1) smoke_origin = smoke_origin + normalize(dir)*33;
			self.smoke_offset_counter = 0;
			//bprint("move origin\n");
		}
		return;
	}
	
	
	traceline(origin1 + '0 0 7', origin1 + '0 0 270', TRUE, self);
	
	local vector dir2 = origin1 - trace_endpos;
	if(trace_fraction <1) 
	{
		//bprint("height ");
		//bprint(ftos(vlen(dir2)));
		//bprint("height ");
		
		if(vlen(dir2) > smoke_ceiling) smoke_ceiling = vlen(dir2);
		
		if(self.smoke_height_is_adjusted ==0)
		{
			//bprint("adjust height\n");
			//smoke_ceiling = vlen(dir2);
			
			if(smoke_ceiling < 110)
			{
				smoke_radius = 215;
				self.smoke_rate = 4;
			}
			else if(smoke_ceiling < 150)
			{
				smoke_radius = 210;
				self.smoke_rate = 3;
			}
			else if(smoke_ceiling < 190)
			{
				smoke_radius = 195;
				self.smoke_rate = 2;
			}
			
			
			self.smoke_height_is_adjusted =1;
		}
	}
	
	
	if(smoke_ent_number < 59.75 && time - smoke_time < 40)
	{
		smoke_generated +=1;
		//bprint(ftos(smoke_generated));
		//bprint("\n");
		
		local entity smoke;
		smoke = spawn();
		
		
		if(random() < 0.33 && ground_smoke_number < 15) 
		{
			ground_smoke_number +=1;
			setmodel (smoke, "mdl/ef_smoke2.mdl");
			smoke.classname = "ground_smoke";
		}
		else if(smoke_ent_number < 22)
		{
			setmodel (smoke, "mdl/ef_smoke2.mdl");
			smoke.classname = "smoke";
			smoke.weapon =1;
		}
		else
		{
			setmodel (smoke, "mdl/ef_smoke2.mdl");
			smoke.classname = "smoke";
			smoke.weapon =0;
		}
			
		setorigin(smoke, origin1 + randomizer + '0 0 -10');
		smoke.frame = frand;
		smoke.movetype = MOVETYPE_FLY;
		smoke.solid = SOLID_TRIGGER;
		setsize (smoke, 0,0);
		
		//if(random()<0.4) smoke.avelocity = '-50 -50 -325'; //500 -> 300
		//else smoke.avelocity = 0;
		smoke.avelocity = '-50 -50 -325'; //500 -> 300
		
		smoke.velocity = '0 0 0';
		
		smoke.tarzan_time = 0;
		smoke.speed = 0;
		
		setsize (smoke, '-16 -16 -8', '16 16 8');
	
		smoke_ent_number +=1;
	
	
		if((pointcontents(origin1 + '0 0 20') == CONTENT_WATER || pointcontents(origin1 + '0 0 20') == CONTENT_SLIME) || steam == 1)
		{
			if(random() <= 0.3) smoke.skin = 13; //blue
			else if(random() <= 0.50) smoke.skin = 15;  //darker blue
			else if(random() <= 1) smoke.skin = 18;  // teal
		}
		else
		{
			if(random() <= 0.5) smoke.skin = 28; //lightest gray
			else if(random() <= 0.64) smoke.skin = 22;  //11->2
			else if(random() <= 1) smoke.skin = 12;  //10 ->0
		}
	
	
		smoke.alpha = random();
		if(smoke.alpha < 0.1 || smoke.alpha > 0.50) smoke.alpha = 0.3;
	
		if(smoke.skin ==12 && smoke.alpha >0.28) smoke.alpha = 0.28;
		if(smoke.skin ==10) smoke.alpha = 0.33;
	
		if(steam ==1) smoke.alpha = smoke.alpha +0.09;
	
		if(random() < 0.08 && smoke.classname == "smoke") smoke.effects = EF_RED;
		else if(random() < 0.04 && smoke.classname == "ground_smoke") smoke.effects = EF_RED;
	
		if(smoke.skin == 28) smoke.alpha = 0.23;
	
		smoke.owner = self.owner;
		smoke.nextthink = time + my_ticrate;
		smoke.think = update_smoke;
	}
	else if((self.classname == "smoke" || self.classname == "ground_smoke") && time - smoke_time < 40) 
	{

		setorigin(self, origin1 + randomizer + '0 0 -10');
		self.frame = frand;
		self.movetype = MOVETYPE_FLY;
		self.solid = SOLID_TRIGGER;
		
		//self.avelocity = '-50 -50 -325'; //500 -> 300
		
		self.tarzan_time = 0;
		self.speed = 0;
		
		self.velocity = '0 0 0';

	
	
		if((pointcontents(origin1 + '0 0 20') == CONTENT_WATER || pointcontents(origin1 + '0 0 20') == CONTENT_SLIME) || steam == 1)
		{
			if(random() <= 0.3) self.skin = 13; //blue
			else if(random() <= 0.50) self.skin = 15;  //darker blue
			else if(random() <= 1) self.skin = 18;  // teal
		}
		else
		{
			if(random() <= 0.5) self.skin = 28; //lightest gray
			else if(random() <= 0.64) self.skin = 22;  //11->2
			else if(random() <= 1) self.skin = 12;  //10 ->0
		}
	
	
		self.alpha = random();
		if(self.alpha < 0.1 || self.alpha > 0.50) self.alpha = 0.3;
	
		if(self.skin ==12 && self.alpha >0.28) self.alpha = 0.28;
		if(self.skin ==10) self.alpha = 0.33;
	
		if(steam ==1) self.alpha = self.alpha +0.09;
	
		if(random() < 0.08) self.effects = EF_RED;
	
		if(self.skin == 28) self.alpha = 0.23;
	
		self.owner = smoke_owner;
		self.nextthink = time + my_ticrate;
		self.think = update_smoke;
	}
}
		
		
		






void() update_aura1=
{
			local float radius =30 * random();
			local vector randomizer = '0 0 0';
			randomizer_x = radius*2*(random() - 0.5);
			randomizer_y = radius*2*(random() - 0.5);
			randomizer_z = 0.5*random();
	
	
	
	
	if(self.weapon == 3)       //GRAVITY WELL
	{
		if(time - gravity_time > 21) 
		{
			self.think = SUB_Remove;
			make_power(self.origin + '0 0 2', 0.7, 6);
			sound (self, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
		}
		
		self.skin =10;  //6 red
		if(self.speed %12 == 0) self.frame = 7;
		else if(self.speed %3 == 0) self.frame = 8;
		self.alpha = 0.03;
		setorigin(self, self.owner.origin + randomizer);
		
		if(random() < 0.27) self.frame = 8;
		else if(random() < 0.4) self.frame = 9;
		self.speed +=1;
		if(self.speed > 4000) self.speed = 0;
		
		if(self.speed %27 == 0 || random() < 0.40) self.frame = 9;
		else if(self.speed %48 == 0 || random() < 0.5) self.frame = 8;
		self.speed +=1;
		if(self.speed > 4000) self.speed = 0;
		
		if(time - gravity_flash_time < 1.8 && gravity_flash_time !=0) 
		{
			self.skin =6;
			self.alpha = 0.10;
		}
		

		
	
	}
	else if(self.weapon == 4)        //Death AURA push
	{
		if(time - quasar_time > 30)
		{
			self.think = SUB_Remove;
			make_power(self.origin + '0 0 2', 0.7, 6);
			sound (self, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
		}
		
		self.skin =11;
		self.frame = 8;
		self.alpha = 0.03;
		setorigin(self, self.owner.origin);
		
		if(self.speed %21 == 0 || random() < 0.2) self.frame = 9;
		else if(self.speed %42 == 0) self.frame = 8;
		self.speed +=1;
		//else if(self.speed %30 == 0) self.frame = 6;
		
		if(time - quasar_flash_time < 2 && quasar_flash_time !=0) 
		{
			self.skin =6;
			self.alpha = 0.1;
		}
		
	}
	if(time - self.ltime >=120)  self.think = SUB_Remove;
	
	 self.nextthink = time + 0.05;
 }






void() bangs =
{
		self.classname = "item_rune";
		local entity aura1;
		local entity head;
		local vector dir5;
		
			local float radius =19 * random();
			local vector randomizer = '0 0 0';
			randomizer_x = radius*2*(random() - 0.5);
			randomizer_y = radius*2*(random() - 0.5);
			randomizer_z = 5*(0.5+2*(random() - 0.5));
		
		if (self.weapon ==1)         				 // FIRE CLOUD
		{
			smoke_owner = self.owner;
			setmodel (self, "mdl/ef_aura1.mdl");
			self.skin = 26; //23;
			self.frame = 6;
			self.alpha =0.55;
			
			if((pointcontents(self.origin + '0 0 20') == CONTENT_WATER || pointcontents(self.origin + '0 0 20') == CONTENT_SLIME))
			{
				setmodel (self, "mdl/ef_smoke2.mdl");
				self.skin = 18; //23;
				self.alpha =0.4;
			}
			
			
			
			if(first_smoke ==0)
			{
				smoke_radius = 190;
				self.owner.smoke_rate = 1;
				smoke_origin = self.origin;
				self.owner.smoke_height_is_adjusted = 0;
				smoke_origin = self.origin;
				self.owner.smoke_offset = '0 0 0';
				self.owner.smoke_offset_counter = 0;
				smoke_ceiling = 10000;
				first_smoke = 1;
				
				self.is_over_sky =0;				//DECEM
				local vector start 	= self.origin;
				local vector end 	= start;
				end_z 	= self.origin_z - 9000;
				traceline (start, end, TRUE, self);	
				if(pointcontents(trace_endpos) == CONTENT_SKY) self.is_over_sky =1;
			}
			
			if(!(self.flags & FL_ONGROUND))
			{
				smoke_origin = self.origin;
			}
			
			self.origin = smoke_origin;
			self.solid = SOLID_NOT;
			if(time - smoke_time < 40 && !(self.is_over_sky ==1 )) //&& self.flags & FL_ONGROUND))  //DECEM
			{
			
				if(smoke_ent_number < 59.75)   //70 ->60
				{
					self.smoke_counter +=1;
					if(self.smoke_counter%4 || random() < 0.1)
					{
						make_smoke(smoke_origin, smoke_radius, 0);
						//bprint(ftos(smoke_ceiling));
						if(self.owner.smoke_rate ==2) 
						{
							if(random() < 0.28) make_smoke(smoke_origin, smoke_radius, 0);
						}
						else if(self.owner.smoke_rate ==3) 
						{
							if(random() < 0.19) make_smoke(smoke_origin, smoke_radius, 0);
							if(random() < 0.19) make_smoke(smoke_origin, smoke_radius, 0);
						}
						else if(self.owner.smoke_rate ==4) 
						{
							if(random() < 0.18) make_smoke(smoke_origin, smoke_radius, 0);
							if(random() < 0.18) make_smoke(smoke_origin, smoke_radius, 0);
							if(random() < 0.18) make_smoke(smoke_origin, smoke_radius, 0);
						}
					}
				}
			
					head = findradius(smoke_origin, 240);
					while (head)
					{
						if (head != world)
						{

							if (head.takedamage)
							{				
								if (CanDamage (head, self))
								{	
									//local vector dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
									//dir5 = normalize(dir5);
							
								
									if(self.done_damage ==0 || self.done_damage%2 ==0)
									{
										if(head.shields_up !=1) 
										{
											T_DamageOrg (head, self, self.owner, 9, self.origin);
										
											if(head.armorvalue >0) head.armorvalue -= 5;
											if(head.armorvalue <=0) head.armorvalue =0;
										}
										
									}
									self.done_damage +=1;
									if(self.done_damage ==70) self.done_damage =0;
								
							
							
								}			
							}
						}
						head = head.chain;
					}
			}
			else
			{
					self.alpha = 0.001;
					if(mapname == "tut1") 
					{
						if(time - self.ltime >=3) self.think = rune_respawn;
					}
					else if(time - self.ltime >=125) 
					{
						self.think = rune_respawn;
						//bprint("respawn call . . .");
					}
					//bprint(ftos(time - self.ltime));
					//bprint("  ");
					//bprint(ftos(rune1_plasma));
					//bprint("  ");
	
			}
			
			
		}
		else if (self.weapon ==2)          // THROWABLE THOR 
		{
			self.alpha = 0.001;
			if(self.thor_time< 1) 
			{
				
				areaTHROW(self, self.origin, self, 500, 150, self);
				areaTHROW(self, self.origin, self, 300, 200, self);
				areaDMG(self, self.origin, self.owner, 300, 40, self);      
				areaDMG(self, self.origin, self.owner, 200, 400.5, self);    
				
			
			
			
				make_impact('0 0 18', 1);
				self.thor_time = self.thor_time +1;
				if(self.thor_slam >1) self.thor_time = 1;
				
				local vector dir_gravity = normalize(gravity_origin1 - self.origin);     //make explo throw origins of grav and quasar off   9-17-23
				//local float old_z = gravity_origin_z;
				dir_gravity_z = 0;
				
				//bprint(ftos(vlen(self.origin - gravity_origin1)));
				local vector oldorigin_gravity = gravity_origin;
			
				if(vlen(self.origin - gravity_origin) < 125)
				{
					//bprint(ftos(gravity_origin_z));
					gravity_origin = gravity_origin + dir_gravity*400*1.5;
					gravity_time -=10;
					gravity_flash_time = time;
				}
				else if(vlen(self.origin - gravity_origin1) < 175)
				{
					//bprint(ftos(gravity_origin_z));
					gravity_origin = gravity_origin + dir_gravity*325*1.5;
					gravity_time -=9;
					gravity_flash_time = time;
				}
				else if(vlen(self.origin - gravity_origin1) < 250)
				{
					//bprint(ftos(gravity_origin_z));
					gravity_origin = gravity_origin + dir_gravity*275*1.5;
					gravity_time -=7;
					gravity_flash_time = time;
				}
				else if(vlen(self.origin - gravity_origin) < 325)
				{
					//bprint(ftos(gravity_origin_z));
					gravity_origin = gravity_origin + dir_gravity*250*1.5;
					gravity_time -=5;
					gravity_flash_time = time;
				}
				else if(vlen(self.origin - gravity_origin) < 400)
				{
					//bprint(ftos(gravity_origin_z));
					gravity_origin = gravity_origin + dir_gravity*190*1.5;
					gravity_time -=5;
					gravity_flash_time = time;
				}
				
				//if (pointcontents(gravity_origin) == CONTENT_SOLID) gravity_origin_z = gravity_origin_z+ 70;

				traceline(oldorigin_gravity, gravity_origin, TRUE, self);
				if(trace_fraction< 1) gravity_origin = trace_endpos - dir_gravity*40;
				
				traceline(gravity_origin, gravity_origin + '0 0 -100', TRUE, self);
				if(trace_fraction< 1) gravity_origin = trace_endpos + '0 0 20';
				
				
				
				local vector dir_quasar = normalize(quasar_origin1 - self.origin);     //make explo throw origins of quasar off   9-17-23
				//local float old_z = quasar_origin_z;
				dir_quasar_z = 0;
				
				//bprint(ftos(vlen(self.origin - quasar_origin1)));
				local vector oldorigin_quasar = quasar_origin;
			
				if(vlen(self.origin - quasar_origin) < 125)
				{
					//bprint(ftos(quasar_origin_z));
					quasar_origin = quasar_origin + dir_quasar*330;
					quasar_time -=10;
					quasar_flash_time = time;
				}
				else if(vlen(self.origin - quasar_origin1) < 175)
				{
					//bprint(ftos(quasar_origin_z));
					quasar_origin = quasar_origin + dir_quasar*300;
					quasar_time -=9;
					quasar_flash_time = time;
				}
				else if(vlen(self.origin - quasar_origin1) < 250)
				{
					//bprint(ftos(quasar_origin_z));
					quasar_origin = quasar_origin + dir_quasar*270;
					quasar_time -=7;
					quasar_flash_time = time;
				}
				else if(vlen(self.origin - quasar_origin) < 325)
				{
					//bprint(ftos(quasar_origin_z));
					quasar_origin = quasar_origin + dir_quasar*230;
					quasar_time -=5;
					quasar_flash_time = time;
				}
				
				else if(vlen(self.origin - quasar_origin) < 400)
				{
					//bprint(ftos(quasar_origin_z));
					quasar_origin = quasar_origin + dir_quasar*190;
					quasar_time -=5;
					quasar_flash_time = time;
				}
				
				if (pointcontents(quasar_origin) == CONTENT_SOLID) quasar_origin_z = quasar_origin_z+ 70;

				traceline(oldorigin_quasar, quasar_origin, TRUE, self);
				if(trace_fraction< 1) quasar_origin = trace_endpos - dir_quasar*40;
				
				traceline(quasar_origin, quasar_origin + '0 0 -100', TRUE, self);
				if(trace_fraction< 1) quasar_origin = trace_endpos + '0 0 20';
				
				
				
				
				head = findradius(self.origin, 480);
				while (head)
				{
					if (head != world)
					{
						
						if (head.takedamage || head.classname == "plasma" || head.classname == "smoke")
						{				
							if (CanDamage (head, self) || head.classname == "plasma" || head.classname == "smoke")
							{	
								//local vector dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
								//dir5 = normalize(dir5);
								//head.velocity = head.velocity + 2200*dir5;
								//if(head.weapon ==3) gravity_pushed =1;
								//else if(head.weapon ==4) quasar_pushed =1;

								if(head.classname == "player") 
								{
									head.blast_time =time;         //disable steering
									//stuffcm(head, "cl_forwardspeed 0\n");
									//stuffcm(head, "cl_sidespeed 0\n");
									stuffcmd(head, "spd00\n");
								}
							
								dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
								if(vlen(dir5) < 50) head.velocity = head.velocity + 1000*(normalize(dir5));
								else if(vlen(dir5) < 100) head.velocity = head.velocity + 950*(normalize(dir5));
								else if(vlen(dir5) < 200) head.velocity = head.velocity + 850*(normalize(dir5));
								else if(vlen(dir5) < 300) head.velocity = head.velocity + 750*(normalize(dir5));
								else if(vlen(dir5) < 400) head.velocity = head.velocity + 650*(normalize(dir5));
								else if(vlen(dir5) < 500) head.velocity = head.velocity + 550*(normalize(dir5));
							}			
						}
					}
					head = head.chain;
				}
					
			}
			
			self.movetype = MOVETYPE_NOCLIP;
			self.solid = SOLID_NOT;
			
			setorigin(self, self.origin + '0 0 50');
			if(mapname == "tut1") 
			{
				if(time - self.ltime >=1.5) self.think = rune_respawn;
			}
			else if(time - self.ltime >=25) self.think = rune_respawn;
	
			
		}
		else if (self.weapon ==3) //haste // GRAVITY WELL
		{
				gravity_owner = self.owner;
				
				if(self.rune_displayed ==0)
				{
					self.rune_displayed =1;
					aura1 = spawn();
					setmodel (aura1, "mdl/ef_aura1.mdl");
					//setorigin(aura1, self.origin + '0 0 8');
					//setorigin(aura1, self.origin);
					//setorigin(aura1, self.origin + randomizer);
					aura1.movetype = MOVETYPE_NOCLIP;
					aura1.solid = SOLID_NOT;
					aura1.frame = 6;
					aura1.ltime = time;
					aura1.classname = "aura1";
					setsize (aura1, 0,0);
					aura1.alpha = 0.3;
					aura1.owner = self;
					aura1.weapon = 3;
					aura1.nextthink = time + 0.01;
					aura1.avelocity = '-50 -100 -50';
					aura1.weapon = 3;
					aura1.think = update_aura1;
					
				}
			
			
			setmodel (self, "mdl/ef_aura1.mdl");
			self.skin = 3;
			self.frame = 1;
			
			
			if(time - gravity_time < 21)
			{
				if(self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
				local vector dynamic_origin = self.origin;
				//dynamic_origin_z = 0;
				local vector dirx = gravity_origin-dynamic_origin;
				self.avelocity = '-50 -50 -50';
				
				gravity_origin1 = self.origin;
			
				if(gravity_counter ==12)
				{
					//setorigin(self, self.origin + '0 0 0.9');
					self.velocity_x = 210*2*(random() - 0.5);
					self.velocity_y = 210*2*(random() - 0.5);
					self.velocity_z = 13*(0.59 +2*(random() - 0.5));
			
					if(vlen(dirx) > 190) self.velocity = normalize(dirx)*190;
					gravity_counter =0;
				}
				else if(random()<0.12) 
				{
					self.velocity_x = 240*2*(random() - 0.5);
					self.velocity_y = 240*2*(random() - 0.5);
				
			
					if(vlen(dirx) > 180) self.velocity = normalize(dirx)*180;
					gravity_counter =0;
				}
				else gravity_counter +=1;
			
		
		
				if((gravity_counter ==10 || random() < 0.05) && (time - gravity_time < 28.5))
				{
					if(random() < 0.5) sound(self, CHAN_AUTO, "weap/br_grav1.wav", 0.7, ATTN_NORM);
					else if(random() <=1) sound(self, CHAN_AUTO, "weap/br_grav2.wav", 0.7, ATTN_NORM);
				}

				
				
				//self.movetype = MOVETYPE_NOCLIP;
				//self.movetype = MOVETYPE_FLYMISSILE;
				self.solid = SOLID_NOT;

				if(time - gravity_time <= 20.4)
				{
					if (!(self.effects & EF_BLUE)) self.effects   = self.effects | EF_BLUE;
				}
				
				if(time - gravity_time > 20.4)
				{
					if (self.effects & EF_BLUE) self.effects   = self.effects - EF_BLUE;
				}
			
		
				//if(time - self.ltime >=120) self.think = rune_respawn;
				
				head = findradius(self.origin, 420);
				while (head)
				{

					
					if (head != world && head != self)
					{
						
						
						if (head.takedamage || head.classname == "plasma" || head.classname == "smoke" || head.classname == "dummy" || head.classname == "vials" || head.classname == "giblets")
						{				
							
							if (CanDamage (head, self) || head.classname == "plasma" || head.classname == "smoke" || head.classname == "dummy" || head.classname == "vials" || head.classname == "giblets")
							{	
								//local vector dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
								//dir5 = normalize(dir5);
								//head.velocity = head.velocity + 2200*dir5;
								if(head.classname == "smoke") head.tarzan_time = 1;
							
								dir5 = (self.absmin + self.absmax) * 0.5 - head.origin;              
								if(vlen(dir5) < 50) head.velocity = head.velocity + 1*(normalize(dir5));
								else if(vlen(dir5) < 100) head.velocity = head.velocity + 25*(normalize(dir5));
								else if(vlen(dir5) < 200) head.velocity = head.velocity + 50*(normalize(dir5));
								else if(vlen(dir5) < 300) head.velocity = head.velocity + 100*(normalize(dir5));
								else if(vlen(dir5) < 400) head.velocity = head.velocity + 180*(normalize(dir5));
								else if(vlen(dir5) < 420) head.velocity = head.velocity + 100*(normalize(dir5));
								
								if(head.classname == "vials") 
								{
									if(time - gravity_time < 20.75)
									{
										head.velocity = head.velocity + 75*(normalize(self.origin - head.origin));
										head.velocity = head.velocity + '0 0 13';
									}
									else 
									{
										head.velocity = head.velocity + 270*(normalize(head.origin - self.origin));
										head.velocity = head.velocity + '0 0 95';
									}
								}
								
								if(head.classname == "giblets") 
								{
									if(time - gravity_time < 20.75)
									{
										head.velocity = head.velocity + (40+ 20*random())*(normalize(self.origin - head.origin));
										head.velocity = head.velocity + '0 0 19';
									}
									else 
									{
										head.velocity = head.velocity + (210+ 50*random())*(normalize(head.origin - self.origin));
										head.velocity = head.velocity + '0 0 95';
									}
								}
								
							
								if(vlen(dir5) < 250 && vlen(head.velocity)> 1200) head.velocity = head.velocity*0.95;
								
								if(head.classname == "dummy" && head.origin_z < 2600) 
								{
									if (head.flags & FL_ONGROUND) head.flags = head.flags - (head.flags & FL_ONGROUND);
									head.velocity = head.velocity + '0 0 48';
								}
								
								if(head.classname == "plasma" || head.classname == "smoke") head.owner = self;  //10/5/23
								
								if(gravity_counter%3 ==0) 
								{
									if(head.shields_up !=1) 
									{
										T_DamageOrg (head, self, self.owner, 2, self.origin);
									
										if(head.armorvalue >0) head.armorvalue -= 2;
										if(head.armorvalue <=0) head.armorvalue =0;
									}
								}
							
						
							}
							if(head.classname == "plasma") head.plasma_time = time; 
							
							if(head.shields_up !=1 && (head.classname == "player" || head.classname == "dummy") && vlen(head.origin - self.origin) < 75)
							{
									T_DamageOrg (head, self, self.owner, 30, self.origin);
									if(head.armorvalue >0) head.armorvalue -= 10;
									if(head.armorvalue <=0) head.armorvalue =0;
							}
									
						}
					}
					head = head.chain;
				}
			
			
			}
			else
			{
				self.alpha = 0.001;
				gravity_origin1 = '0 0 0';
				if(mapname == "tut1") 
				{
					if(time - self.ltime >=3) self.think = rune_respawn;
				}
				else if(time - self.ltime >=120) self.think = rune_respawn;
			}
			
			
		}
		else if (self.weapon ==4)   //Death AURA push
		{		
				quasar_owner = self.owner;
				
				if(self.rune_displayed ==0)
				{
					self.rune_displayed =1;
					aura1 = spawn();
					setmodel (aura1, "mdl/ef_aura1.mdl");
					setorigin(aura1, self.origin + '0 0 8');
					aura1.movetype = MOVETYPE_NOCLIP;
					aura1.solid = SOLID_NOT;
					aura1.frame = 6;
					aura1.ltime = time;
					aura1.classname = "aura1";
					setsize (aura1, 0,0);
					aura1.alpha = 0.3;
					aura1.owner = self;
					aura1.weapon = 3;
					aura1.nextthink = time + 0.01;
					aura1.think = update_aura1;
					aura1.weapon = 4;
					aura1.avelocity = '-50 -100 -50';

				}
			
			if((pointcontents(quasar_origin1 + '0 0 -10') == CONTENT_WATER || pointcontents(self.origin + '0 0 -10') == CONTENT_SLIME))
			{
			
				if(random() < 0.5)
				{
					make_smoke(quasar_origin1 + '0 0 -1', 80, 1);
					//bprint(ftos(smoke_ceiling));
					if(self.owner.smoke_rate ==2) 
					{
						if(random() < 0.24)make_smoke(quasar_origin1 +  + '0 0 -1', 80, 1);
					}
					else if(self.owner.smoke_rate ==3) 
					{
						if(random() < 0.18)make_smoke(quasar_origin1 + '0 0 -1', 80, 1);
						if(random() < 0.18)make_smoke(quasar_origin1 + '0 0 -1', 80, 1);
					}
					else if(self.owner.smoke_rate ==4) 
					{
						if(random() < 0.16)make_smoke(quasar_origin1, 80, 1);
						if(random() < 0.16)make_smoke(quasar_origin1, 80, 1);
						if(random() < 0.16)make_smoke(quasar_origin1, 80, 1);
					}
				}
			}
			
			
			setmodel (self, "mdl/ef_aura1.mdl");
			self.skin = 6;
			self.frame = 3;
			//self.velocity = '0 0 0';
			//setorigin(self, self.origin + '0 0 1.0');
			
			//self.movetype = MOVETYPE_FLYMISSILE;
			
			if(time - quasar_time < 30)
			{
				if(self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
				local vector dynamic_origin1 = self.origin;
				//dynamic_origin1_z = 0;
				local vector dirx1 = quasar_origin-dynamic_origin1;
				self.avelocity = '-50 -50 -50';
				
				quasar_origin1 = self.origin;
			
				if((quasar_buzz_counter ==10 || random() < 0.12) && time - quasar_time < 28.3)
				{
		
					if(random() < 0.5) sound(self, CHAN_AUTO, "weap/br_quas1.wav", 0.55, ATTN_NORM);
					else sound(self, CHAN_AUTO, "weap/br_quas2.wav", 0.55, ATTN_NORM);
					quasar_buzz_counter =0;
				}
				quasar_buzz_counter +=1;
				
				if(quasar_counter ==7)
				{
					//bprint("blah\n");
					//setorigin(self, self.origin + '0 0 0.9');
					self.velocity_x = 240*2*(random() - 0.5);
					self.velocity_y = 240*2*(random() - 0.5);
					self.velocity_z = 125*(0.55 +2*(random() - 0.5));
					//self.velocity_z = 7*(0.59 +2*(random() - 0.5));
			
					if(vlen(dirx1) > 180) self.velocity = normalize(dirx1)*130;
					quasar_counter =0;
				}
				else if(random()<0.12) 
				{
					self.velocity_x = 240*2*(random() - 0.5);
					self.velocity_y = 240*2*(random() - 0.5);
					self.velocity_z = 125*(0.55 +2*(random() - 0.5));
					//self.velocity_z = 7*(0.59 +2*(random() - 0.5));
			
					if(vlen(dirx1) > 180) self.velocity = normalize(dirx1)*180;
					quasar_counter =0;
				}
				//if(quasar_pushed ==1)    bprint("head\n");
				//if(quasar_pushed ==1 && quasar_counter == 30) quasar_pushed =0;
			
				else quasar_counter +=1;
				

				
			
				//self.movetype = MOVETYPE_NOCLIP;
				//self.movetype = MOVETYPE_FLYMISSILE;
			
				self.solid = SOLID_NOT;
				
				if(time - quasar_time <= 29.4)
				{
					if (!(self.effects & EF_RED)) self.effects   = self.effects | EF_RED;
				}

				
				if(time - quasar_time > 29.4)
				{
					if (self.effects & EF_RED) self.effects   = self.effects - EF_RED;
				}
		
			
				head = findradius(self.origin, 330);
				while (head)
				{
					if (head != world && head != self)
					{

						if (head.takedamage || head.classname == "plasma" || head.classname == "smoke" || head.classname == "vials" || head.classname == "giblets")
						{				
							if (CanDamage (head, self) || head.classname == "plasma" || head.classname == "smoke" || head.classname == "vials" || head.classname == "giblets")
							{	
								dir5 = head.origin - (self.absmin + self.absmax) * 0.5;              
								dir5 = normalize(dir5);
								head.velocity = head.velocity + 220*dir5 + v_up*125;
								
								if(head.classname == "vials") 
								{
									head.velocity = head.velocity + 110*(normalize(head.origin - self.origin));
									head.velocity = head.velocity + '0 0 85';
								}
								
								if(head.classname == "giblets") 
								{
									head.velocity = head.velocity + 70*(normalize(head.origin - self.origin));
									head.velocity = head.velocity + '0 0 85';
								}
								
								if(head.classname == "plasma" || head.classname == "smoke") head.owner = self;  //10/5/23
								
								if(quasar_push_sound ==0) 
								{
									sound(self, CHAN_AUTO, "weap/br_quas3.wav", 1, ATTN_NORM); //quasar_push noise
									quasar_push_sound = time;
								}
								else if(quasar_push_sound !=0 && time - quasar_push_sound > 0.8) 
								{
									sound(self, CHAN_AUTO, "weap/br_quas3.wav", 1, ATTN_NORM); //quasar_push noise
									quasar_push_sound =time;
								}
							
						
							}	
							if(head.shields_up !=1 && head.classname == "player") 
							{
								if(vlen(head.origin - self.origin) > 175)
								{
									T_DamageOrg (head, self, self.owner, 5.5, self.origin);
									if(head.armorvalue >0) head.armorvalue -= 4;
									if(head.armorvalue <=0) head.armorvalue =0;
								}
								else
								{
									T_DamageOrg (head, self, self.owner, 19, self.origin);
									if(head.armorvalue >0) head.armorvalue -= 9;
									if(head.armorvalue <=0) head.armorvalue =0;
								}
							}
									
						}
					}
					head = head.chain;
				}
			
			
				//quasar_push_sound =0;
				
				
			}
			else
			{
				self.alpha = 0.001;
				quasar_origin1 = '0 0 0';
				if(mapname == "tut1") 
				{
					if(time - self.ltime >=3) self.think = rune_respawn;
				}
				else if(time - self.ltime >=120) self.think = rune_respawn;
			}
	}
		

    self.nextthink = time + 0.05;
};



void() rune_bang_think =
{
	if(self.owner.rune_bang ==11) self.shot_time =1;
	else if(self.owner.rune_bang ==22) self.shot_time =2;
	else if(self.owner.rune_bang ==33) self.shot_time =3;
	else if(self.owner.rune_bang ==44) self.shot_time =4;
	
	if((self.weapon ==1 && self.owner.rune_bang == 11) || (self.weapon ==2 && self.owner.rune_bang == 22) || (self.weapon ==3 && self.owner.rune_bang == 33) || (self.weapon ==4 && self.owner.rune_bang == 44))
	{
		self.solid = SOLID_NOT;
		
		if(self.health == 3) self.alpha = 0.02;
		else if(self.health == 5) self.alpha = 1;
		self.health +=1;
		if(self.health == 6) self.health =0;
		
	}
	
	if(time - self.ltime >=1.5)
	{
		self.solid = SOLID_TRIGGER;
		self.alpha = 1;
		//self.owner.rune_bang =0;
	}
	
	//if(self.owner.rune_bang == 11 && self.weapon ==1 && time - self.ltime >1.3 && time - self.ltime <1.5 && !(elohim_playmode & ELOHIM_NO_THROWABLES) && self.solid == SOLID_NOT)
	if((self.owner.rune_bang == 11 || self.shot_time ==1) && self.weapon ==1 && time - self.ltime >1.3 && time - self.ltime <1.5 && !(elohim_playmode & ELOHIM_NO_THROWABLES) && self.solid == SOLID_NOT)
	{	
		self.alpha = 1;
		self.owner.rune_bang =0;
		self.shot_time =0;
		
		self.velocity = self.velocity + '0 0 300';
		setorigin(self, self.origin + '0 0 20');
		make_power(self.origin + '0 0 2', 0.7, 6);
		sound (self, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
		
		first_smoke = 0;
		smoke_time = time;	
		
		self.think = bangs;
	}
	
	else if((self.owner.rune_bang == 22 || self.shot_time ==2) && self.weapon == 2 && time - self.ltime >0.5 && time - self.ltime <1.5 && !(elohim_playmode & ELOHIM_NO_THROWABLES) && self.solid == SOLID_NOT)
	{	
		self.alpha = 1;
		self.owner.rune_bang =0;
		self.shot_time =0;
		
		self.velocity = self.velocity + '0 0 300';
		setorigin(self, self.origin + '0 0 20');
		make_power(self.origin + '0 0 2', 0.7, 6);
		
		self.think = bangs;
	
	}
	
	else if((self.owner.rune_bang == 33 || self.shot_time ==3) && self.weapon ==3 && time - self.ltime >1.3 && time - self.ltime <1.5 && !(elohim_playmode & ELOHIM_NO_THROWABLES) && self.solid == SOLID_NOT)
	{	
		self.alpha = 1;
		self.owner.rune_bang =0;
		self.shot_time =0;
		
		self.velocity = self.velocity + '0 0 300';
		setorigin(self, self.origin + '0 0 20');
		make_power(self.origin + '0 0 2', 0.7, 6);
		sound (self, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
		
		self.movetype = MOVETYPE_FLY;
		self.avelocity = '-50 -50 -500';
		self.speed = 0;
		self.velocity = '0 0 0';
		gravity_origin = self.origin;
		//gravity_origin_z = 0;
		gravity_time =time;
		
		self.think = bangs;
	}
	
	else if((self.owner.rune_bang == 44 || self.shot_time ==4) && self.weapon ==4 && time - self.ltime >1.3 && time - self.ltime <1.5 && !(elohim_playmode & ELOHIM_NO_THROWABLES) && self.solid == SOLID_NOT)
	{	
		self.alpha = 1;
		self.owner.rune_bang =0;
		self.shot_time =0;
		
		self.velocity = self.velocity + '0 0 300';
		setorigin(self, self.origin + '0 0 20');
		make_power(self.origin + '0 0 2', 0.7, 6);
		sound (self, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
		
		self.movetype = MOVETYPE_FLY;
		self.avelocity = '-50 -50 -500';
		self.speed = 0;
		self.velocity = '0 0 0';
		quasar_origin = self.origin;
		//quasar_origin_z = 0;
		quasar_time =time;
		
		self.think = bangs;
	}
	
	

	
	else if(time - self.ltime > 60) 
	{
		self.solid = SOLID_TRIGGER;
		self.movetype = MOVETYPE_TOSS;
		self.think = rune_respawn;
	}

	self.nextthink = time + 0.05;
};




void(float flag) do_rune_drop =
{
	
	//self.rune_bang =0;
	local entity item;

	item = spawn();
	item.owner = item;
	
	item.health = 0;
	makevectors (self.v_angle);
	
	item.origin = (self.origin - '0 0 24');	
	
	
	
	
	item.player_flag = flag;

	
		item.velocity_z = 300;
		item.velocity_x = (-330 + (random () * 640));
		item.velocity_y = (-330 + (random () * 640));
	
	if (self != world && self.player_flag & PF_ITEM_RUNE_MASK) 
	{
		item.owner = self;
		
		traceline(self.origin, self.origin + v_forward*33, TRUE, self);
		if(trace_fraction < 1) 
		{
			setorigin(item, self.origin + '0 0 16' +v_forward*(-2));   //1->16	
		}
		else 
		{
			if (pointcontents(self.origin + v_forward*45) == CONTENT_SOLID) setorigin(item, self.origin + '0 0 10' +v_forward*-2);   //1->10
			else if (pointcontents(self.origin + v_forward*45 + v_right*16) == CONTENT_SOLID || pointcontents(self.origin + v_forward*45 + v_right*8) == CONTENT_SOLID) 
			{
				//bprint(" right 16 solid yes!!!\n");
				setorigin(item, self.origin + '0 0 10' +v_forward*12 + v_right*-9);   
			}
			else if (pointcontents(self.origin + v_forward*45 + v_right*(-16)) == CONTENT_SOLID || pointcontents(self.origin + v_forward*45 + v_right*(-8)) == CONTENT_SOLID) 
			{
				//bprint(" left 16 solid yes!!!\n");
				setorigin(item, self.origin + '0 0 10' +v_forward*12 + v_right*9);  
			}
			else setorigin(item, self.origin + '0 0 1' +v_forward*33);
		}		
		
		
		


		 
		
		item.velocity = self.velocity*0.5 + v_forward*800 + v_up*275;
	}
	
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	
	

	if (flag == PF_ITEM_RUNE1_FLAG)
	{
		setmodel (item, MODEL_RUNE_RESIST);
		item.weapon = 1; //smoke
		smoke_teammate_frags =0;
		smoke_enemy_frags =0;

	}
	else
	{
		if (flag == PF_ITEM_RUNE2_FLAG)
		{
			setmodel (item, MODEL_RUNE_STREN);
			item.weapon = 2; //power
			power_teammate_frags =0;
			power_enemy_frags =0;
			
		
		}
		else
		{
			if (flag == PF_ITEM_RUNE3_FLAG)
			{
				setmodel (item, MODEL_RUNE_HASTE);
				item.weapon = 3; //haste
				gravity_teammate_frags =0;
				gravity_enemy_frags =0;
		
			}
			else
			{
				if (flag == PF_ITEM_RUNE4_FLAG)
				{
					setmodel (item, MODEL_RUNE_REGEN);
					item.weapon = 4; //aura
					quasar_teammate_frags =0;
					quasar_enemy_frags =0;
			
				}
			}
		}
	}
	setsize (item, '-16 -16 -4', '16 16 50');
	
	//item.shot_time =time;
	
	item.touch = rune_touch;
	item.classname = "item_rune";
	//item.nextthink = (time + 60);
	//item.think = rune_respawn;
	item.ltime = time;
	item.nextthink = (time + 0.01);
	item.think = rune_bang_think;
};
//void() RuneRotHealthThink;

void() rune_drop =
{
//	local entity e;

	if (self.player_flag & PF_ITEM_RUNE1_FLAG)
	{
		do_rune_drop (PF_ITEM_RUNE1_FLAG);
	}
	else if (self.player_flag & PF_ITEM_RUNE2_FLAG)
	{
		do_rune_drop (PF_ITEM_RUNE2_FLAG);
	}
	else if (self.player_flag & PF_ITEM_RUNE3_FLAG)
	{
		do_rune_drop (PF_ITEM_RUNE3_FLAG);
	}
	else if (self.player_flag & PF_ITEM_RUNE4_FLAG)
	{		
		do_rune_drop (PF_ITEM_RUNE4_FLAG);
	}
	
    rune_clear_player_flags();
    sound (self, CHAN_AUTO, "item/br_runedr.wav", 1, ATTN_NORM);
    self.runetime = time + 0.8;
};

void() rune_spawn_all =
{
	local entity oself;
	local float i;

	oself = self;
	

		i = (random() * 10);
		while (i > 0)
		{
			self = rune_select_spawn_point ();
			i = i - 1;
		}
		self = rune_select_spawn_point ();
		do_rune_drop (PF_ITEM_RUNE1_FLAG);

    i = (random() * 10);
	while (i > 0)
	{
		self = rune_select_spawn_point ();
		i = i - 1;
	}
	self = rune_select_spawn_point ();
	do_rune_drop (PF_ITEM_RUNE2_FLAG);

    i = (random() * 10);
	while (i > 0)
	{
		self = rune_select_spawn_point ();
		i = i - 1;
	}
	self = rune_select_spawn_point ();
	do_rune_drop (PF_ITEM_RUNE3_FLAG);

    i = (random() * 10);
	while (i > 0)
	{
		self = rune_select_spawn_point ();
		i = i - 1;
	}
	self = rune_select_spawn_point ();
	do_rune_drop (PF_ITEM_RUNE4_FLAG);
	remove(oself);
};

void() do_rune_spawn_start =
{
	local entity rspawn;

	rspawn = spawn();
	rspawn.nextthink = time + 0.1;
	rspawn.think = rune_spawn_all;
};

void() rune_spawn_start =
{
	utils_do_item(admin_disable_item, "item_rune");//?
	do_rune_spawn_start ();
	remove(self);
};






void() rune_toss =
{
	local entity item;
//	local entity e;

	if (self.style & ELOHIM_OBSERVER)
		return;
	
	if ((self.player_flag & PF_ITEM_RUNE_MASK) == FALSE)
		return;

	item = spawn();
	//item.owner = self;
    item.owner = world;
	makevectors (self.v_angle);
	//setorigin(item, (self.origin + '0 0 20'));
    setorigin (item, self.origin + v_forward*8 + '0 0 16'); 
    
    
	item.velocity = aim (self, 1000);
	item.velocity = (item.velocity * 600);
    item.velocity_z	= 300;
    //item.velocity_x	= 400*(random() - 0.5);
    //item.velocity_y	= 400*(random() - 0.5);
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	
	if (self.player_flag & PF_ITEM_RUNE1_FLAG)
	{
		item.player_flag = PF_ITEM_RUNE1_FLAG;
		setmodel (item, MODEL_RUNE_RESIST);
	}
	else
	{
		if (self.player_flag & PF_ITEM_RUNE2_FLAG)
		{
			item.player_flag = PF_ITEM_RUNE2_FLAG;
			setmodel (item, MODEL_RUNE_STREN);
		}
		else
		{
			if (self.player_flag & PF_ITEM_RUNE3_FLAG)
			{
				item.player_flag = PF_ITEM_RUNE3_FLAG;
				setmodel (item, MODEL_RUNE_HASTE);
			}
			else
			{
				if (self.player_flag & PF_ITEM_RUNE4_FLAG)
				{
					item.player_flag = PF_ITEM_RUNE4_FLAG;
					setmodel (item, MODEL_RUNE_REGEN);
					//self.max_health = 100;
				}
			}
		}
	}

    rune_clear_player_flags();

    setsize (item, '-16 -16 0', '16 16 56');
	item.touch = rune_touch;
	item.nextthink = (time + 120);
	item.think = rune_respawn;
    // if (self.player_flag & PF_ITEM_RUNE_MASK) self.player_flag -= PF_ITEM_RUNE_MASK;
	item.classname = "item_rune";

};




void() rune_check =
{
	if (self.player_flag & PF_ITEM_RUNE1_FLAG && rune1_plasma <2)
	{
		rune1_plasma += 1;
		self.rune_bang = 10;
	}
	else rune1_plasma =0;
	
	if (self.player_flag & PF_ITEM_RUNE2_FLAG && rune2_power <2)
	{
		rune2_power += 1;
		self.rune_bang = 20;
	}
	else rune2_power =0;
	
	if (self.player_flag & PF_ITEM_RUNE3_FLAG && rune3_haste <2)
	{
		rune3_haste += 1;
		self.rune_bang = 30;
	}
	else rune3_haste =0;
	
	if (self.player_flag & PF_ITEM_RUNE4_FLAG && rune4_aura <2)
	{		
		rune4_aura += 1;
		self.rune_bang = 40;
	}
	else rune4_aura =0;
	
	
				local entity toRemove = world;
				local entity head = find(head, classname, "item_rune");
				while (head)
				{
					if(head.classname != "player")
					{
						if (head.weapon ==1 && rune1_plasma == 2)
						{
							toRemove = head;
						}
					
						else if (head.weapon ==2 && rune2_power == 2)
						{
							toRemove = head;
							//bprint("debug01\n");
						}
					
						else if (head.weapon ==3 && rune3_haste == 2)
						{
							toRemove = head;
						}
					
						else if (head.weapon ==4 && rune4_aura == 2)
						{
							toRemove = head;
						
						}
					}
					head = head.chain;
					
					
					if (toRemove)
					{
						remove(toRemove);
						toRemove = world;
					}

				}
}