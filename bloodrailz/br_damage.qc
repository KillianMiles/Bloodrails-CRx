void() info_player_start;
void(entity targ, entity attacker, float damage) ClientObituary;
void (entity client, float fragval) client_frag; // ELOHIM_MOD  --moved from client.qc for CAx



float(entity targ, entity inflictor) CanDamage =       //Returns true if the inflictor can directly damage the target.  Used for explosions and melee attacks.
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)   return TRUE;
		if (trace_ent == targ)     return TRUE;
		return FALSE;
	}
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;

	return FALSE;
};


void(entity inflictor, entity attacker, float damage, entity ignore, vector damage_origin) T_RadiusDamage =     //only used in Projectile railgun setting
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < damage)
				{
					points = damage - points;
					if (head == attacker) points = points * 0.8;
					if (CanDamage (head, inflictor)) T_DamageOrg (head, inflictor, attacker, points, damage_origin);
				}
			}
		}
		head = head.chain;
	}
};


void(entity targ, entity inflictor, entity attacker, float damage, vector dmg_origin) T_DamageOrg =
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save, take; //  rox_damage;
	local 	string 	temp;
	
	//bprint(ftos(damage));
	//bprint("\n");
	if(damage ==9) attacker = smoke_owner;
	
	if (!targ.takedamage) return;
		
	if (elohim_playmode & RACE_MODE && !(mapname !="tut1" || mapname !="tut2" || mapname !="tut3" || mapname !="tut4" || mapname !="tut5" || mapname !="tut6" || mapname !="tut7")) return;  //dont deal damage if in racing mode
	
	// HorrorScope deathmatch camera - store players last enemy entity
	if (attacker.flags & FL_CLIENT)
		if (targ.flags & FL_CLIENT)
			if (damage < targ.health)
				attacker.last_enemy = targ;
	
	
	if (elohim_playmode & PROJECTILES && inflictor.classname == "missile")
	{

		if(attacker == targ && inflictor.classname == "missile") damage = damage/5;
	
		// save damage based on the target's armor level
		save = ceil(targ.armortype*damage);

		if (save >= targ.armorvalue)
		{
			save = targ.armorvalue;
			targ.armortype = 0;	// lost all armor
			targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		}
	
		targ.armorvalue = targ.armorvalue - save;
		take = ceil(damage-save);
	}
	
	


	// figure momentum add
	if ( (inflictor.classname == "missile") && (targ.movetype == MOVETYPE_WALK) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}
	
	
	
	// ELOHIM_MOD - stats
	if (attacker.classname == "player" && targ != attacker)
	{
		attacker.crmod_inflicted = targ;  // CRMOD - to see who attacker attacked
		attacker.crmod_did_damage = time;  // CRMOD keep track of last time they hurt someone
	
		if (targ.classname != "player" || attacker.team != targ.team || !teamplay)
		{
			if (inflictor == attacker)
			{
				if (attacker.weapon == IT_SHOTGUN || attacker.weapon == IT_RAILGUN)
				{
					if (!(elohim_playmode & ELOHIM_MATCH_MODE) || (elohim_state & ELOHIM_MATCH_STARTED)) attacker.dest2_x = attacker.dest2_x + damage;
				}
				else if (attacker.weapon == IT_LIGHTNING)
				{
					if (attacker.waterlevel <= 1) attacker.dest2_z = attacker.dest2_z + damage;
				}
			}
			else if (inflictor.classname == "missile" && targ.classname == "player")
			{
				attacker.dest_y = attacker.dest_y + damage;
				inflictor.dmg = TRUE; // flag missile as having done damage
			}
			else if (inflictor.classname == "spike") attacker.dest2_y = attacker.dest2_y + damage;
		}
	}                        
  

	// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

	

	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}



	else if (elohim_playmode & CLANRING_CTF_MODE && !(elohim_playmode & RACE_MODE))
	{
		if ((attacker.classname == "player") && (targ.flag_carrier) && (attacker.team != targ.team))
		{
			attacker.last_hurt_carrier = time;
		}
	}

	// ELOHIM_MOD - print info for practice mode; check for pre-match
	if (elohim_playmode & RACE_MODE)
	{
		if (targ.classname == "player" && attacker.classname == "player" && targ != attacker)
		{
			temp = ftos(damage);
			centerprint4(attacker, targ.netname, ": ", temp, "\n\n\n\n\n\n\n\n");
			attacker.delay = time + 1;
		}
	}
	
	if (mode_is_prewar() == TRUE)
	{
		if (attacker.classname == "player" && targ != attacker)
		{
			attacker.dmg_tally += damage;
			if (attacker.dmg_tally >= 300)
			{
				attacker.frags += 1;
				attacker.dmg_tally = attacker.dmg_tally % 300;
			}
		}
		
		else	return;
	}
   

	if(damage != 485 && attacker.classname == "player") attacker.plasma_frag = 0;



	// check for godmode or invincibility
	if (targ.flags & FL_GODMODE) return;
	

		if (targ.items & IT_INVULNERABILITY)
		{
			if (self.invincible_sound < time)
			{
				sound (targ, CHAN_ITEM, "item/br_protec3.wav", 1, ATTN_NORM);
				self.invincible_sound = time + 2;
			}
			return;
		}



	
		
		// team play damage avoidance

	
		if((elohim_playmode & ELOHIM_WRAITH) && targ.wraith ==1 && attacker.weapon == IT_RAILGUN && targ.airborn_pos < 40)    //WRAITH MODE - if wraith - cant be damaged by rail
				{
					make_spawnprotect(targ);	 //shield visual
					sound (targ, CHAN_VOICE, "weap/br_armorhit.wav", 1, ATTN_NORM);    //SHIELD SOUND
					stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //rail momentum add
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*800;
					return;
				}
	
		
		
		//SHIELD
		
		if (targ.shields_up == 1 && targ != attacker)
		{
				if(attacker.weapon == IT_AXE)
				{
					sound (targ, CHAN_VOICE, "weap/br_armorhit.wav", 1, ATTN_NORM);
					stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //axe and Hook TEAM  momentum adds
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*300;
					attacker.velocity = attacker.velocity + dir*(-400);
				}
				
				if(attacker.weapon == IT_HOOK)
				{
					sound (targ, CHAN_VOICE, "weap/br_armorhit.wav", 1, ATTN_NORM);
					//stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //axe and Hook TEAM  momentum adds
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*400;
				}
				
				if(attacker.weapon == IT_RAILGUN)
				{
					sound (targ, CHAN_VOICE, "weap/br_armorhit.wav", 1, ATTN_NORM);    //SHIELD SOUND
					stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //rail momentum add
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*400;
					//targ.blocked_rail +=1;
				}

				return;
		}		
		
		//SHIELD END
		
		
		
		

		
		
		
		
		if ((teamplay == 1 || teamplay == 4 || (mode_is_public_ctf()))  && !(damage ==40 || damage ==400.5 || damage ==9 || damage ==2 || damage ==30 || damage ==5.5 || damage ==19)   )     //9-24-23
		{
			if (targ.team == attacker.team && targ != attacker )
			{
				if(attacker.weapon == IT_AXE || attacker.weapon == IT_HOOK)
				{
					sound (targ, CHAN_VOICE, "body/br_meathit.wav", 0.59, ATTN_NORM);
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //axe and Hook TEAM  momentum adds
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*300;
				}
				
				if(attacker.weapon == IT_RAILGUN && damage == 9000)
				{
					
					//localsound(attacker, "ctf/br_sameteam.wav");  // on your team sound
					ex_localsound(attacker, "ctf/br_sameteam.wav");  // on your team sound
					//sound (attacker, CHAN_AUTO, "ctf/br_sameteam.wav", 1, ATTN_NONE, 100, 256);       //SOUNDFLAG_UNICAST is just 256
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //rail momentum add
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*300;
				}
			

				return;
			}
		}
		

		

			
			
	if ((elohim_playmode & ELOHIM_NO_PENT) && self.airborn_pos < 50)
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*250; 
		
		if (attacker.weapon == IT_HOOK || attacker.weapon == IT_AXE) sound (self, CHAN_AUTO, "body/br_meathit.wav", 0.59, ATTN_NORM); 
		else if (attacker.weapon == IT_RAILGUN) sound (self, CHAN_AUTO, "weap/br_explo.wav", 1, ATTN_NORM);

		return;   
	}
          
         
	if (attacker.weapon == IT_AXE) 	sound (self, CHAN_AUTO, "body/br_meathit.wav", 0.59, ATTN_NORM);	  //sound axehit_flesh when hitting with axe
	
	if (damage == 403 && vlen(attacker.origin - targ.origin) > 85) return;  //NOVEM backstop for long axe bug

	
	
	if (damage == 9000)              //HITSCAN RAILGUN
	{
		//bprint(ftos(targ.armorvalue)); //FEBRUARY
		//bprint(" armor_value\n");
		
		if (targ.armorvalue >= 100)      //every 100 units of armor deflect one (hitscan) rail hit
		{
			targ.armorvalue = targ.armorvalue - 100;
			targ.health = targ.health - 25;
         
			dir = targ.origin - attacker.origin;   //throw
			dir = normalize(dir);
					
			if ( !(targ.flags & FL_ONGROUND)) targ.velocity = targ.velocity + dir*400;  //throw
			
			if (targ.flags & FL_ONGROUND)
			{
				makevectors (targ.v_angle);
				targ.velocity = targ.velocity + dir*300 + v_up*200;  //throw	
				//sprint(attacker, "ground throw");
			}
	 
			sound (targ, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit
			stuffcmd(targ,"bf\n"); 
			sound (attacker, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit 
			//targ.blocked_rail +=1;
					
			if(targ.ammo_cells == 1)      //ammo_cells = spawn_protected
			{
				make_spawnprotect(targ); //spawn protect shield visual
				sound (targ, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
			}
					
					
			if (  ((attacker.player_flag & PF_ITEM_RUNE2_FLAG) && (attacker.rail_was_curved != 1 && damage != 1000)) ||  (attacker.super_damage_finished > time) || targ.health <=0)    // FEBRUARY power rune doesnt ignore armor if curved shot
			{
				targ.health = -99;
				Killed (targ, attacker, dmg_origin, 9000);           
			}
			return;
		}
		
		targ.health = -99;
		Killed (targ, attacker, dmg_origin, 9000);
		
		return;
	}
	
	if(damage == 57 && targ.armorvalue >= 30)		//NOVEM railpush armor take
	{
		targ.armorvalue = targ.armorvalue - 30;
	}
	
	
	if (damage > 999 && damage < 8995 && (attacker.weapon == IT_RAILGUN))              //HANDICAP RAILGUN (FireBullets)
	{
			if (targ.armorvalue >= 100)      //every 100 units of armor deflect one (hitscan) rail hit
			{
				targ.armorvalue = targ.armorvalue - 100;
				targ.health = targ.health - 25;
         
				dir = targ.origin - attacker.origin;   //throw
				dir = normalize(dir);
				if ( !(targ.flags & FL_ONGROUND)) targ.velocity = targ.velocity + dir*400;  //throw
				
				if (targ.flags & FL_ONGROUND)
				{
					makevectors (targ.v_angle);
					targ.velocity = targ.velocity + dir*300 + v_up*200;  //throw	
					//sprint(attacker, "ground throw");
				}
	 
				sound (targ, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit
				stuffcmd(targ,"bf\n"); 
				sound (attacker, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit 
				//targ.blocked_rail +=1;
					
				if(targ.ammo_cells == 1)      //ammo_cells = spawn_protected
				{
					make_spawnprotect(targ); //spawn protect shield visual
					sound (targ, CHAN_AUTO, "weap/br_shield.wav", 1, ATTN_NORM);
				}
					
				if (  ((attacker.player_flag & PF_ITEM_RUNE2_FLAG)  ||  (attacker.super_damage_finished > time)) && damage != 8994 || targ.health <=0)
				{
					targ.health = -99;
					Killed (targ, attacker, dmg_origin, damage);           
				}
				return;
			}
		
		targ.health = -99;        //    Handicap kills DO gib
		Killed (targ, attacker, dmg_origin, damage);
		
		return;
	}
	
	
	if (damage == 51 && targ.armorvalue >= 100)      //    //DEATH AURA ARMOR DAMAGE
	{
			targ.armorvalue = targ.armorvalue - 100;
			targ.health = targ.health - 25;
         
			dir = targ.origin - attacker.origin;   //throw
			dir = normalize(dir);
			if ( !(targ.flags & FL_ONGROUND)) targ.velocity = targ.velocity + dir*400;  //throw
			if (targ.flags & FL_ONGROUND)
			{
				makevectors (targ.v_angle);
				targ.velocity = targ.velocity + dir*400 + v_up*180;  //throw	
				attacker.velocity = attacker.velocity + dir*(-180);
				//sprint(attacker, "ground throw");
			}
			
			sound (targ, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit
			stuffcmd(targ,"bf\n"); 
			//sound (attacker, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit )  
			
			if(targ.health <=0)
			{
				targ.health = -99;
				Killed (targ, attacker, dmg_origin, 51);           
			}
			
			return;
	}
	
	
	if (targ.armorvalue >= 100 && damage !=8.7 && damage !=4.7 && targ !=attacker)      //FEBRUARY sound armorhit if armor hit with axe
        {
		sound (targ, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit
		stuffcmd(targ,"bf\n"); 
        }
        
        if (targ.armorvalue >=11 && (damage ==8.7 || damage ==4.7))   
        {
		targ.armorvalue -= 11;
		if(targ.armorvalue <0) targ.armorvalue=0;
        }
	
	
	
	
	if (damage == 485 && targ.armorvalue >= 100)      //every 100 units of armor deflect one (hitscan) rail hit    //PLASMA ARMOR DAMAGE    //NOVEM changed plasma from 85 to 485 damage
	{
			targ.armorvalue = targ.armorvalue - 100;
			targ.health = targ.health - 25;
			dir = targ.origin - attacker.origin;   //throw
			dir = normalize(dir);
			if ( !(targ.flags & FL_ONGROUND)) targ.velocity = targ.velocity + dir*400;  //throw
			
			if (targ.flags & FL_ONGROUND)
			{
				makevectors (targ.v_angle);
				targ.velocity = targ.velocity + dir*400 + v_up*180;  //throw	
				//attacker.velocity = attacker.velocity + dir*(-180);
				//sprint(attacker, "ground throw");
			}
	 
			sound (targ, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit
			stuffcmd(targ,"bf\n"); 
			sound (attacker, CHAN_AUTO, "weap/br_armorhit.wav", 1, ATTN_NORM);   //play sound when armored target is hit )  
			
			if(targ.health <=0)
			{
				targ.health = -99;
				Killed (targ, attacker, dmg_origin, 485);           
			}
			
			return;
	}
	
	
	
	
	if(damage == 485) attacker.plasma_frag = attacker.plasma_frag +1;
	
	if(time - targ.spawn_protect_time < 1)             // 1 second of spawn protection against FIRE CLOUD, GRAVITY WELL and REPULSOR
	{
		if(damage == 5.5 || damage == 19 || damage == 30 || damage == 2 || damage == 9) return;
	}
	
	
	//Do damage
	
	if (inflictor.classname == "missile")  targ.health = targ.health - take;
	else targ.health = targ.health - damage;
			
	if (targ.health <= 0)
	{
		if(damage == 51) 
		{
			attacker.death_aura_frag = 1;
			death_aura_counter = 0;
		}
		
		// ELOHIM_MOD - print info for practice mode
		if (elohim_playmode & RACE_MODE)
		{
			if (targ.classname == "player" && attacker.classname == "player" && targ != attacker)
			{
				temp = ftos(attacker.health);
				centerprint5(targ, "\n\n\n\n", attacker.netname, " has ", temp, " health");
				sprint5(targ, "\n\n\n\n", attacker.netname, " has ", temp, " health\n");
			}
		}
		targ.health = -99;
		Killed (targ, attacker, dmg_origin, damage);        //register frag
		return;
	}

	
	// react to the damage
	oldself = self;
	
	self = targ;


	if (self.th_pain)
	{
		self.th_pain ();
	}

	self = oldself;
	
};


void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local vector dmg_org = '0 0 0';
	T_DamageOrg(targ, inflictor, attacker, damage, dmg_org);
};

