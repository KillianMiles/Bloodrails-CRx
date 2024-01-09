void() info_player_start;
void(entity targ, entity attacker, float damage) ClientObituary;
void (entity client, float fragval) client_frag; // ELOHIM_MOD  --moved from client.qc for CAx


/*
============
CanDamage -- Returns true if the inflictor can directly damage the target.  Used for explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
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




void(entity targ, entity inflictor, entity attacker, float damage, vector dmg_origin) T_DamageOrg =
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save, take; //  rox_damage;
	local 	string 	temp;


	if (!targ.takedamage) return;
		
	if (elohim_playmode & ELOHIM_PRACTICE_MODE) return;  //dont deal damage if in racing mode
	
	// HorrorScope deathmatch camera - store players last enemy entity
	if (attacker.flags & FL_CLIENT)
		if (targ.flags & FL_CLIENT)
			if (damage < targ.health)
				attacker.last_enemy = targ;
	
	
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



	else if (elohim_playmode & CLANRING_CTF_MODE && !(elohim_playmode & ELOHIM_PRACTICE_MODE))
	{
		if ((attacker.classname == "player") && (targ.flag_carrier) && (attacker.team != targ.team))
		{
			attacker.last_hurt_carrier = time;
		}
	}

	// ELOHIM_MOD - print info for practice mode; check for pre-match
	if (elohim_playmode & ELOHIM_PRACTICE_MODE || (elohim_playmode & CLAN_ARENA_MODE && !(elohim_playmode & AIR_ARENA_MODE)))
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
		else if ((targ.classname == "p_fish") || (targ.classname == "p_head") || (targ.classname == "p_tbaby"))
		{
			take = damage;
		}
		else	return;
	}
   

	if(damage != 485 && attacker.classname == "player") attacker.plasma_frag = 0;



	// check for godmode or invincibility
	if (targ.flags & FL_GODMODE) return;
	
	if ((elohim_playmode & AIR_ARENA_MODE) && (attacker.super_damage_finished > time))
	{
		sound (targ, CHAN_ITEM, "items/br_protect3.wav", 1, ATTN_NORM);
	}
	else
	{
		if (targ.items & IT_INVULNERABILITY)
		{
			if (self.invincible_sound < time)
			{
				sound (targ, CHAN_ITEM, "items/br_protect3.wav", 1, ATTN_NORM);
				self.invincible_sound = time + 2;
			}
			return;
		}

	}

	
		
		// team play damage avoidance

	
		if((elohim_playmode & ELOHIM_WRAITH) && targ.wraith ==1 && attacker.weapon == IT_RAILGUN && targ.airborn_pos < 40)    //WRAITH MODE - if wraith - cant be damaged by rail
				{
					make_spawnprotect(targ);	 //shield visual
					sound (targ, CHAN_VOICE, "weapons/armorhit.wav", 1, ATTN_NORM);    //SHIELD SOUND
					stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //Bloodrails - rail momentum add
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*800;
					return;
				}
	
		
		
		//SHIELD
		
		if (targ.shields_up == 1 && targ != attacker)
		{
				if(attacker.weapon == IT_AXE)
				{
					sound (targ, CHAN_VOICE, "weapons/armorhit.wav", 1, ATTN_NORM);
					stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //Bloodrails - axe and Hook TEAM  momentum adds
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*300;
					attacker.velocity = attacker.velocity + dir*(-400);
				}
				
				if(attacker.weapon == IT_HOOK)
				{
					sound (targ, CHAN_VOICE, "weapons/armorhit.wav", 1, ATTN_NORM);
					//stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //Bloodrails - axe and Hook TEAM  momentum adds
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*400;
				}
				
				if(attacker.weapon == IT_RAILGUN)
				{
					sound (targ, CHAN_VOICE, "weapons/armorhit.wav", 1, ATTN_NORM);    //SHIELD SOUND
					stuffcmd(targ,"bf\n"); 
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //Bloodrails - rail momentum add
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*400;
					//targ.blocked_rail +=1;
				}

				return;
		}		
		
		//SHIELD END
		
		
		
		
		if(attacker.misfire == 1)            //score leader with high KDR runs a chance of Railgun misfires (KDR misfire code)
		{
			attacker.misfire = 0;
			return;
		}
		
		
		
		
		if ((teamplay == 1 || teamplay == 4 || (mode_is_public_ctf()))  && !(damage ==40 || damage ==400.5 || damage ==9 || damage ==2 || damage ==30 || damage ==5.5 || damage ==19)   )     //9-24-23
		{
			if (targ.team == attacker.team && targ != attacker )
			{
				if(attacker.weapon == IT_AXE || attacker.weapon == IT_HOOK)
				{
					sound (targ, CHAN_VOICE, "player/axhit_flesh.wav", 0.59, ATTN_NORM);
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //Bloodrails - axe and Hook TEAM  momentum adds
					dir = normalize(dir);
					targ.velocity = targ.velocity + dir*300;
				}
				
				if(attacker.weapon == IT_RAILGUN && damage == 9000)
				{
					
					//localsound(attacker, "misc/sameteam.wav");  // on your team sound
					ex_localsound(attacker, "misc/sameteam.wav");  // on your team sound
					//sound (attacker, CHAN_AUTO, "misc/sameteam.wav", 1, ATTN_NONE, 100, 256);       //SOUNDFLAG_UNICAST is just 256
					dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;                  //Bloodrails - rail momentum add
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
		
		if (attacker.weapon == IT_HOOK || attacker.weapon == IT_AXE) sound (self, CHAN_AUTO, "player/axhit_flesh.wav", 0.59, ATTN_NORM); 
		else if (attacker.weapon == IT_RAILGUN) sound (self, CHAN_AUTO, "weapons/br_exp1.wav", 1, ATTN_NORM);

		return;   
	}
          
         
	if (attacker.weapon == IT_AXE) 	sound (self, CHAN_AUTO, "player/axhit_flesh.wav", 0.59, ATTN_NORM);	  //sound axehit_flesh when hitting with axe
	
	if (damage == 403 && vlen(attacker.origin - targ.origin) > 85) return;  //NOVEM backstop for long axe bug

	
	
	if (damage == 9000)              //Bloodrails - HITSCAN RAILGUN
	{
		if (targ.armorvalue >= 100)      //Bloodrails - every 100 units of armor deflect one (hitscan) rail hit
		{
			targ.armorvalue = targ.armorvalue - 100;
         
			dir = targ.origin - attacker.origin;   //throw
			dir = normalize(dir);
					
			if ( !(targ.flags & FL_ONGROUND)) targ.velocity = targ.velocity + dir*400;  //throw
			
			if (targ.flags & FL_ONGROUND)
			{
				makevectors (targ.v_angle);
				targ.velocity = targ.velocity + dir*300 + v_up*200;  //throw	
				//sprint(attacker, "ground throw");
			}
	 
			sound (targ, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit
			stuffcmd(targ,"bf\n"); 
			sound (attacker, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit 
			//targ.blocked_rail +=1;
					
			if(targ.ammo_cells == 1)      //ammo_cells = spawn_protected
			{
				make_spawnprotect(targ); //spawn protect shield visual
				sound (targ, CHAN_AUTO, "weapons/shield_pulse.wav", 1, ATTN_NORM);
			}
					
					
			if (  ((attacker.player_flag & PF_ITEM_RUNE2_FLAG) && attacker.rail_was_curved != 1) ||  (attacker.super_damage_finished > time))    //power rune doesnt ignore armor if curved shot
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
	
	
	if (damage > 999 && damage < 8995 && (attacker.weapon == IT_RAILGUN))              //Bloodrails - HANDICAP RAILGUN (FireBullets)
	{
			if (targ.armorvalue >= 100)      //Bloodrails - every 100 units of armor deflect one (hitscan) rail hit
			{
				targ.armorvalue = targ.armorvalue - 100;
         
				dir = targ.origin - attacker.origin;   //throw
				dir = normalize(dir);
				if ( !(targ.flags & FL_ONGROUND)) targ.velocity = targ.velocity + dir*400;  //throw
				
				if (targ.flags & FL_ONGROUND)
				{
					makevectors (targ.v_angle);
					targ.velocity = targ.velocity + dir*300 + v_up*200;  //throw	
					//sprint(attacker, "ground throw");
				}
	 
				sound (targ, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit
				stuffcmd(targ,"bf\n"); 
				sound (attacker, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit 
				//targ.blocked_rail +=1;
					
				if(targ.ammo_cells == 1)      //ammo_cells = spawn_protected
				{
					make_spawnprotect(targ); //spawn protect shield visual
					sound (targ, CHAN_AUTO, "weapons/shield_pulse.wav", 1, ATTN_NORM);
				}
					
				if (  ((attacker.player_flag & PF_ITEM_RUNE2_FLAG)  ||  (attacker.super_damage_finished > time)) && damage != 8994)
				{
					targ.health = -99;
					Killed (targ, attacker, dmg_origin, 0);           
				}
				return;
			}
		
		targ.health = -99;        //    Handicap kills DO gib
		Killed (targ, attacker, dmg_origin, 0);
		
		return;
	}
	
	
	if (damage == 51 && targ.armorvalue >= 100)      //Bloodrails - every 100 units of armor deflect one (hitscan) rail hit    //DEATH AURA ARMOR DAMAGE
	{
			targ.armorvalue = targ.armorvalue - 100;
         
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
	 
			sound (targ, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit
			stuffcmd(targ,"bf\n"); 
			sound (attacker, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit )  
			return;
	}
	
	
	if (targ.armorvalue >= 100 && damage !=8.7 && damage !=4.7)      //Bloodrails - sound armorhit if armor hit with axe
        {
		sound (targ, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit
		stuffcmd(targ,"bf\n"); 
        }
        
        if (targ.armorvalue >=11 && (damage ==8.7 || damage ==4.7))      //Bloodrails - sound armorhit if armor hit with axe
        {
		targ.armorvalue -= 11;
		if(targ.armorvalue <0) targ.armorvalue=0;
        }
	
	
	
	
	if (damage == 485 && targ.armorvalue >= 100)      //Bloodrails - every 100 units of armor deflect one (hitscan) rail hit    //PLASMA ARMOR DAMAGE    //NOVEM changed plasma from 85 to 485 damage
	{
			targ.armorvalue = targ.armorvalue - 100;
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
	 
			sound (targ, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit
			stuffcmd(targ,"bf\n"); 
			sound (attacker, CHAN_AUTO, "weapons/armorhit.wav", 1, ATTN_NORM);   //Bloodrails - play sound when armored target is hit )  
			return;
	}
	
	
	
	
	if(damage == 485) attacker.plasma_frag = attacker.plasma_frag +1;
	
	if(time - targ.spawn_protect_time < 1)             // 1 second of spawn protection against FIRE CLOUD, GRAVITY WELL and REPULSOR
	{
		if(damage == 5.5 || damage == 19 || damage == 30 || damage == 2 || damage == 9) return;
	}
	
	
	//Do damage

	targ.health = targ.health - damage;
			
	if (targ.health <= 0)
	{
		if(damage == 51) 
		{
			attacker.death_aura_frag = 1;
			death_aura_counter = 0;
		}
		
		// ELOHIM_MOD - print info for practice mode
		if (elohim_playmode & ELOHIM_PRACTICE_MODE || (elohim_playmode & CLAN_ARENA_MODE && !(elohim_playmode & AIR_ARENA_MODE)))
		{
			if (targ.classname == "player" && attacker.classname == "player" && targ != attacker)
			{
				temp = ftos(attacker.health);
				centerprint5(targ, "\n\n\n\n", attacker.netname, " has ", temp, " health");
				sprint5(targ, "\n\n\n\n", attacker.netname, " has ", temp, " health\n");
			}
		}
		targ.health = -99;
		Killed (targ, attacker, dmg_origin, damage);        //Bloodrails - register frag
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

