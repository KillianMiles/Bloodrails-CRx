

void(entity targ, entity attacker, float damage) ClientObituary =
{
	local float rnum, flag_radius, flag_carrier_radius;
	local string s = "";
	local entity p;
	rnum = random();
	
	local vector horiz_vel = attacker.velocity;
	horiz_vel_z = 0;
	
	if (attacker.classname == "player" && attacker.weapon != IT_RAILGUN) attacker.rails_in_a_row = 0;
	if (attacker.classname == "player" && attacker.weapon != IT_AXE) attacker.axes_in_a_row = 0;
	
	
	if (targ.classname == "player") 
	{
		targ.shield_time = 0;   //shield cool down resets when one dies
		targ.shield_recharge_time = 1;
		
	}

	
	if (attacker != world) 
	{
		if (attacker.classname == "player") 
		{
			targ.dmg_inflictor = attacker;
			targ.ammo_rockets = 0;    // //ammo_rockets = killedbyworld
		}
	}
        if (attacker.classname != "player")  targ.ammo_rockets = 1;   //ammo_rockets = killedbyworld
        
	
	
	if (targ.classname == "player" || targ.classname == "dummy")
	{
		if(targ.classname == "dummy") targ.netname = "Dummy";
		
		if (targ.flag_carrier)
		{
			//flag carrier dead, so reset hurt times
			p = find(world, classname, "player");
			while (p != world)
			{
				if (p.team != targ.team)
				{
					p.last_hurt_carrier = -10;
				}
				p = find(p, classname, "player");
			}
		}
		if (attacker.classname == "teledeath")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			if ( (teamplay == 2) && (targ.team > 0) && (targ.team == attacker.owner.team) )
			{
				// attacker.owner killed teammate
				client_frag(attacker.owner, -1);
			}
			else
			{
				// targ was killed by enemy
				client_frag(attacker.owner, 1);
			}
			return;
		}

 

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self

				client_frag(attacker, -1);
				bprint (targ.netname);
				
				if (damage == 9)
				{
					if (rnum < 0.5) bprint (" fans the flames\n");
					else if (rnum <= 1) bprint(" learns not to play with matches\n");
				}
				else if (damage == 20)
				{
					bprint(" forgot about the power");
					bprint ("\n");
				}
				else if (damage == 35)
				{
					bprint(" mis-handled his plasma ball");
					bprint ("\n");
				}
				else if (damage == 400.5 || damage == 40)
				{
					bprint(" discovers blast radius");
					if ((attacker.last_fragged_carrier + 1) > time) 
					{
						bprint(" \b[WORTH IT]\b ");
						attacker.tier1 +=1;
					}
					bprint ("\n");
				}
				else if (damage == 30 || damage == 2 )
				{
					bprint (" meets event horizon\n");
				}
				else if (damage == 5.5 || damage == 19)
				{
					bprint (" head-butts a Quasar\n");
				}
				return;
			}
			
			else if ( (teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team) )
			{
				// killed teammate
				
				bprint (attacker.netname);
				if (damage == 9)
				{
					if (rnum < 0.5) bprint (" gets a teammate burned");
					else if (rnum <= 1) bprint(" loses a friend in a fire");
					smoke_teammate_frags +=1;
					
					if(smoke_teammate_frags ==2 && smoke_owner == attacker) 
					{
						bprint(" \b[FREAK GASOLINE FIGHT ACCIDENT]\b ");  //10/5/23
						attacker.tier2 +=1;
					}
					bprint("\n");
					

				}
				else if (damage == 400.5 || damage == 40)
				{
					bprint(" blasts a teammate\n");
					power_teammate_frags +=1;
				}
				else if (damage == 30 || damage == 2)
				{
					bprint (" loses a friend to a black hole\n");
					gravity_teammate_frags +=1;
				}
				else if (damage == 5.5 || damage == 19)
				{
					bprint ("'s repulsor field disintegrates a teammate");
					quasar_teammate_frags +=1;
					
					if(quasar_teammate_frags + quasar_enemy_frags ==3) 
					{
						bprint(" \b[GROUP TATTOO REMOVAL]\b ");  //10/5/23
							attacker.tier2 +=1;
					}
					bprint("\n");	
				}
				else if (damage == 40.4)  //Hook chain damage
				{
					bprint (" clips a teammate");
				}
				
				return;
				
			}
			
			else
			{
				// killed enemy
				if (crx_playmode & CTF_MODE && !(crx_playmode & RACE_MODE))
				{
					flag_radius = 0;
					flag_carrier_radius = 0;
					if (attacker.team == TEAM_RED) s = ("\bRED\b");
					else if (attacker.team == TEAM_BLUE) s = ("\bBLUE\b");

					if((targ.flag_carrier) && (targ.team != attacker.team))
					{
						attacker.last_fragged_carrier = time;
						//bprint2(attacker.netname, " killed the flag carrier!\n");
						client_frag(attacker, 1);
						
						//if(targ.frags == top_score_global) make_icon(attacker, 4, damage);
						//else make_icon(attacker, 3, damage);
					}

					if ((((targ.last_hurt_carrier + 2) > time) && !(attacker.flag_carrier)))
					{
						client_frag (attacker, 1);
						flag_carrier_radius = 1;
						bprint4(attacker.netname," defends ",s,"'s flag carrier against an agressive enemy\n");
						//attacker.fcdefenses = attacker.fcdefenses + 1;
					}

					p = findradius (attacker.origin, 512);
					while (p)
					{
						if (p.classname == "player")
						{
							if ( ( ( ((p.team == attacker.team) && (p.flag_carrier)) && (p != attacker) ) && !flag_carrier_radius) )
							{
								client_frag (attacker, 1);
								flag_carrier_radius = 1;
								bprint4(attacker.netname," defends ",s,"'s flag carrier\n");
								//attacker.fcdefenses = (attacker.fcdefenses + 1);
							}
						}
						if (((p.classname == "item_flag_team1") || (p.classname == "item_flag_team2")))
						{
							if ((((attacker.team == TEAM_RED) && (p.classname == "item_flag_team1")) || ((attacker.team == TEAM_BLUE) && (p.classname == "item_flag_team2"))))
							{
								client_frag (attacker, 1);
								flag_radius = 1;
								bprint4(attacker.netname," defends the ",s," flag\n");
								//attacker.fdefenses = (attacker.fdefenses + 1);
							}
						}
						p = p.chain;
					}
					p = findradius (targ.origin, 512);
					while (p)
					{
						if ((p.classname == "player"))
						{
							if ( ( ( (p.team == attacker.team) && (p.flag_carrier) && (p != attacker)) && !flag_carrier_radius) )
							{
								client_frag (attacker, 1);
								flag_carrier_radius = 1;
								bprint4(attacker.netname," defends ",s,"'s flag carrier\n");
								//attacker.fcdefenses = (attacker.fcdefenses + 1);
							}
						}
						if (((((attacker.team == TEAM_RED) && (p.classname == "item_flag_team1")) || ((attacker.team == TEAM_BLUE) && (p.classname == "item_flag_team2"))) && !flag_radius))
						{
							client_frag (attacker, 1);
							flag_radius = 1;
							bprint4(attacker.netname," defends the ",s," flag\n");
							//attacker.fdefenses = (attacker.fdefenses + 1);
						}
						p = p.chain;
					}
				}
				
               
               
				if (damage == 9)
				{
					attacker.smoke_frags +=1;
					smoke_enemy_frags +=1;
					bprint (targ.netname);
					if (rnum < 0.5) bprint (" was torched by ");
					else if (rnum <= 1) bprint(" got burnt in ");
					bprint (attacker.netname);
					bprint("'s fire");
					if(attacker.smoke_frags == 3) 
					{
						bprint(" \b[ORANGE MOCHA FRAPPUCCINO]\b ");  //10/8/23
						attacker.smoke_frags =0;
					}
					else if(smoke_owner != attacker) 
					
					{
						bprint(" \b[PYROMANCER]\b ");    //10/5/23
						attacker.tier2 +=1;
					}
					
					
					bprint("\n");
					
					
					return;
				}
				if (damage == 400.5 || damage == 40)
				{
					power_enemy_frags +=1;
					bprint (targ.netname);
					bprint (" was blasted apart by ");
					bprint (attacker.netname);
					
					if(vlen(targ.velocity) >1150) 
					{
						bprint(" \b[SPEEDING TICKET]\b ");    //10/5/23
						attacker.tier2 +=1;
					}
						
					else if(targ.waterlevel ==3) 
					{
						bprint(" \b[DEPTH CHARGE!]\b ");
						attacker.tier2 +=1;
					}
					bprint("\n");
					
					return;
				}
				if (damage == 30 || damage == 2)
				{
					gravity_enemy_frags +=1;
					bprint (targ.netname);
					if (rnum < 0.5) bprint (" makes friends with ");
					else if (rnum <= 1) bprint(" joined the accretion disc of ");
					bprint (attacker.netname);
					bprint("'s gravity well\n");
					return;
				}
				if (damage == 5.5 || damage == 19)
				{
					quasar_enemy_frags +=1;
					bprint (targ.netname);
					if (rnum < 0.5) bprint (" was disintegrated by ");
					else if (rnum <= 1) bprint(" ripped apart by ");
					bprint (attacker.netname);
					bprint("'s quasar");
					
					if(quasar_teammate_frags + quasar_enemy_frags ==3) 
					{
						bprint(" \b[GROUP TATTOO REMOVAL]\b ");  //10/5/23
							attacker.tier2 +=1;
					}
					bprint("\n");	
					
					
					return;
				}
				if (damage == 40.4)  //Hook chain damage
				{
					bprint (targ.netname);
					bprint (" was sliced by ");
					bprint (attacker.netname);
					bprint("'s hook chain");
					
					
					if(attacker.skiing_on ==1 || attacker.skiing_on ==2)
					{
						bprint(" \b[AB ORDO CACAO]\b");	  //10/5/23
						attacker.tier1 +=1;
					}
					else if (attacker.angles_not_zero ==1) 
					{
						bprint(" \b[MOLLY MILLIONS]\b");   //10/5/23
						attacker.tier2 +=1;
					}
					else
					{
						bprint(" \b[RAZOR WIRE]\b");
						attacker.tier1 +=1;
					}
					
					bprint("\n");
					return;
				}
               
               
               
               
               
			client_frag(attacker, 1);

			if(attacker.death_aura_frag == 1)
			{
					if (rnum < 0.5)
					{
						bprint (targ.netname);
						bprint (" was zapped by ");
						bprint (attacker.netname);
						bprint ("'s Death Aura");
						
					}
					else
					{
						bprint (targ.netname);
						bprint (" was vaporized by ");
						bprint (attacker.netname);
						bprint ("'s Death Aura");
					}
						
					if (vlen(horiz_vel) > 990) 
					{
						bprint(" \b[MAD MAX]\b");
						attacker.tier1 +=1;
					}
					else if (attacker.airborn_pos > 70 && targ.airborn_pos > 70) 
					{
						bprint(" \b[AIRBORNE SUNBURN]\b");
						attacker.tier1 +=1;
					}
					bprint ("\n");	
					attacker.death_aura_frag =0;
			}
		
			else if(attacker.plasma_frag >0)
			{
					if (rnum < 0.5)
					{
						bprint (targ.netname);
						bprint (" was melted by ");
						bprint (attacker.netname);
						bprint ("'s plasma");
						
					}
					else
					{
						bprint (targ.netname);
						bprint (" was plasma-balled by ");
						bprint (attacker.netname);
					}
                
                
					if(attacker.pushed_plasma ==1) 
					{
						bprint(" \b[DODGEBALL]\b ");
						attacker.tier2 +=1;
					}
					if (attacker.airborn_pos > 70 && targ.airborn_pos > 70) 
					{
						bprint(" \b[PURPLE COBRA]\b");
						attacker.tier1 +=1;
					}
					if (attacker.plasma_frag == 3) 
					{
						bprint(" \b[FELIZ TRINIDAD]\b");
						attacker.tier1 +=1;
					}
					else if (attacker.plasma_frag == 5) 
					{
						bprint(" \b[PLASMAGEDDON]\b");
						attacker.tier2 +=1;
					}
					else if (attacker.plasma_frag == 8) 
					{
						bprint(" \b[SCORCHED EARTH MOTHERFUCKER!]\b");
						attacker.tier2 +=1;
					}
					
					
					bprint ("\n");		
			}
			else if(damage ==35)
			{
				attacker.plasma_frag = attacker.plasma_frag +1;
				if (rnum < 0.5)
					{
						bprint (targ.netname);
						bprint (" was torn apart ");
						bprint (attacker.netname);
						bprint ("'s plasma blast");
						
					}
					else
					{
						bprint (targ.netname);
						bprint (" was plasma-blasted by ");
						bprint (attacker.netname);
					}
					bprint ("\n");
			}
                
			else if ((attacker.weapon == IT_AXE && attacker.thor_slam == 1) || damage == 400) //added condition if damage is 400 (thor)
			{
				attacker.thor_slam = 0;
			
				attacker.total_kills = attacker.total_kills +1;
				self.total_deaths = self.total_deaths +1;
				
				/*	
				if(targ.frags == top_score_global && (teamplay || (crx_playmode & CTF_MODE) || (crx_playmode & MATCH_MODE) || (crx_playmode & DM_PUBLIC_MODE) || mode_is_public_ctf()) )
				{
					client_frag(attacker, 1);
					bprint ("the king was stomped by ");
					bprint (attacker.netname);
					bprint("\n");
				} 
				*/
					
				if (rnum < 0.5)
				{
					bprint (targ.netname);
					bprint(" catches ");
					bprint (attacker.netname);
					bprint("'s comet");
				}
				else if (rnum <= 1)
				{
					bprint (attacker.netname);
					bprint(" smites ");
					bprint (targ.netname);
				}
					
					
				if (attacker.thor_frag_count == 0) 
				{
					bprint(" \b[THOR STOMP]\b ");
					attacker.tier1 +=1;
				}
				else if (attacker.thor_frag_count == 1) 
				{
					bprint(" \b[THOR SLAM!]\b ");
					attacker.tier1 +=1;
				}
				else if (attacker.thor_frag_count == 2) 
				{
					bprint(" \b[VALHALLA HOLLA]\b ");
					attacker.tier2 +=1;
				}
				else if (attacker.thor_frag_count == 3) 
				{
					bprint(" \b[TRINITY]\b ");
					attacker.tier3 +=1;
				}
				else if (attacker.thor_frag_count == 4) 
				{
					bprint(" \b[EXTINCTION EVENT]\b ");
					attacker.tier3 +=1;
				}
				if(attacker.thor_frag_count > 0 && attacker.thor_frag_count <= 4 && attacker.shields_up) bprint(" \b[ATOMIC TEABAG]\b ");
				
				
				if (targ.flags & FL_INWATER) 
				{
					bprint(" \b[FISHING WITH DYNAMITE]\b ");
					attacker.tier2 +=1;
				}
					
				//bprint(ftos(attacker.thor_frag_count));
				bprint("\n");
		
			}
                
                
                
			else if (attacker.weapon == IT_AXE && attacker.thor_slam == 0) 
			{
				
				targ.ammo_nails = 1;     //ammo_nails = killedwep
				
				attacker.axes_in_a_row = attacker.axes_in_a_row +1;
				if(attacker.axes_in_a_row <=1) 
				{
					attacker.axe_record_timer = time;
				}
					
				if(time - attacker.axe_record_timer >= 3.3) attacker.axes_in_a_row = 0;
				
				
				 attacker.total_kills = attacker.total_kills +1;
				self.total_deaths = self.total_deaths +1;
				//k_AXE=attacker.kills_AXE;    
					
				if(targ.frags == top_score_global && (teamplay || (crx_playmode & CTF_MODE) || (crx_playmode & MATCH_MODE) || (crx_playmode & DM_PUBLIC_MODE) || mode_is_public_ctf()) )
				{
					client_frag(attacker, 1);
						
					bprint (attacker.netname);
					bprint (" took off the king's head\n");
						
					//deathstring2 = " took off the king's head\n";
				}
					
					
				if (rnum < 0.5)
				{
					bprint (targ.netname);
					bprint (" was axe-murdered by ");
					bprint (attacker.netname);
				}
				else
				{
					bprint (targ.netname);
					bprint (" was ran over by ");
					bprint (attacker.netname);
				}
					
					
					
				//bprint(ftos(attacker.axes_in_a_row));
				if (attacker.jump_flag < -190 && attacker.airborn_pos > 50 && targ.airborn_pos < 20) 
				{
					bprint(" \b[AXE FROM ABOVE]\b");
					attacker.tier1 +=1;
				}
				if (attacker.airborn_pos > 95 && targ.airborn_pos >= 95) 
				{
					bprint(" \b[MID-AIR AXE]\b");
					attacker.tier1 +=1;
				}
					
				if (attacker.angles_not_zero ==1 && vlen(attacker.velocity) > 775) 
				{
					bprint(" \b[APACHE]\b");   //10/5/23
						attacker.tier2 +=1;
				}
				else if (vlen(horiz_vel) > 900 && attacker.shields_up == 1) 
				{
					bprint(" \b[PORKCHOP EXPRESS]\b");
						attacker.tier1 +=1;
				}
				else if (vlen(horiz_vel) > 1000) 
				{
					bprint(" \b[HI-SPEED DECAP]\b");
						attacker.tier1 +=1;
				}
					
				if (attacker.flags & FL_INWATER && attacker.waterlevel > 1) 
				{
					bprint(" \b[COMMANDO]\b");
						attacker.tier1 +=1;
				}
				if (attacker.tarzan_time == 1 && vlen(attacker.velocity)> 800) 
				{
					bprint(" \b[APE SHIT!]\b");    //10/8/23
						attacker.tier3 +=1;
				}
					
				if ((attacker.skiing_on ==1 || attacker.skiing_on ==2) && vlen(attacker.velocity) <=550 && attacker.movement_x ==400) 
				{
					bprint(" \b[ZAMBONI]\b");  //10/5/23
						attacker.tier1 +=1;
				}
				else if ((attacker.skiing_on ==1 || attacker.skiing_on ==2) && vlen(attacker.velocity) >550 && attacker.movement_x ==400) 
				{
					bprint(" \b[MIDNIGHT TRAIN]\b");
						attacker.tier1 +=1;
				}
				else if ((attacker.skiing_on ==1 || attacker.skiing_on ==2) && vlen(attacker.velocity) <=550 && attacker.movement_x ==-400) 
				{
					bprint(" \b[MUGATU]\b");
						attacker.tier2 +=1;
				}
				else if ((attacker.skiing_on ==1 || attacker.skiing_on ==2) && vlen(attacker.velocity) >550 && attacker.movement_x ==-400) 
				{
					bprint(" \b[TOKYO DRIFT]\b");
						attacker.tier2 +=1;
				}
				
				if(attacker.axes_in_a_row >=2 && attacker.waterlevel >= 1 && targ.waterlevel >= 1) 
				{
					bprint(" \b[MER-MAN!]\b");
						attacker.tier1 +=1;
				}
				if(attacker.turn_speed > 112 || attacker.turn_speed <-112) 
				{
					bprint(" \b[REX KWON DO]\b");
						attacker.tier1 +=1;
				}
				if(attacker.axes_in_a_row > 3) 
				{
					bprint(" \b[GET TO THE CHOPPA!]\b");
						attacker.tier2 +=1;
				}
					
				
				
				if(attacker.axes_in_a_row >= 2.98 && time - attacker.axe_record_timer < 2.0) 
				{
					bprint(" \b[M34T GRINDER]\b");
						attacker.tier2 +=1;
				}
				
				makevectors(attacker.v_angle);
				if(v_forward_z >0.9 && targ.jump_flag < -300 && attacker.flags & FL_ONGROUND) 
				{
					bprint(" \b[THE ASSWARD SWORD]\b");
						attacker.tier2 +=1;
				}
				
				
				if(damage == 403.1)
				{
					bprint(" \b[IRON LOTUS]\b");
						attacker.tier3 +=1;
				}
				
					
				bprint("\n");			
			}
				
			else if (attacker.weapon == IT_HOOK && (damage == 20.2 || damage == 40.4 || damage == 10 || damage == 18)) 
			{
				targ.ammo_nails = 2;     //ammo_nails = killedwep
				//deathstring = " was hooked by ";
				//deathstring2 = "\n";
				self.total_deaths = self.total_deaths +1;   //count deaths by hook
				attacker.total_kills = attacker.total_kills +1;
					
				if(targ.frags == top_score_global && (teamplay || (crx_playmode & CTF_MODE) || (crx_playmode & MATCH_MODE) || (crx_playmode & DM_PUBLIC_MODE) || mode_is_public_ctf()) )
				{
					client_frag(attacker, 1);
							
					//bprint ("the king hangs on ");
					//bprint (attacker.netname);
					//bprint ("'s chain\n");	
				}
					
				bprint (targ.netname);
				bprint (" was hooked by ");
				bprint (attacker.netname);
					
					
				if (attacker.airborn_pos > 100 && targ.airborn_pos > 100) 
				{
					bprint(" \b[KUNG FU FUCKERY]\b");
						attacker.tier3 +=1;
				}
				else if (attacker.airborn_pos > 100  && targ.waterlevel >=1) 
				{
					bprint(" \b[FLYING HARPOON]\b");
						attacker.tier2 +=1;
				}
				else if (targ.airborn_pos > 100) 
				{
					bprint(" \b[CHAIN WHIP]\b");	//10/8/23
						attacker.tier1 +=1;
				}
				else 
				{
					bprint(" \b[DIRTY HOOKER]\b");
						attacker.tier1 +=1;
				}
					
				if (targ.flags & FL_INWATER && targ.waterlevel >= 2) 
				{
					bprint(" \b[MOBY DICK]\b");
						attacker.tier1 +=1;
				}
		
				if(attacker.skiing_on ==1 || attacker.skiing_on ==2)
				{
					bprint(" \b[SCORPION]\b");	  //10/5/23
					attacker.tier1 +=1;
				}
				if (attacker.angles_not_zero ==1) 
				{
					bprint(" \b[DRUNKEN MASTER]\b");   //10/5/23
						attacker.tier2 +=1;
				}
					
				bprint("\n");			
			}
				
				
			else if (attacker.weapon == IT_RAILGUN)
			{
				targ.ammo_nails = 3;     //ammo_nails = killedwep
				attacker.rails_in_a_row = attacker.rails_in_a_row +1;
				attacker.rail_frags +=1;
				
				if(attacker.rails_in_a_row <=1) 
				{
					attacker.rail_record_timer = time;
				}
					
				if(time - attacker.rail_record_timer >= 2.1) attacker.rails_in_a_row = 0;
					
				      
				attacker.total_kills = attacker.total_kills +1;
				self.total_deaths = self.total_deaths +1;
			
					
				//localsound(attacker, "misc/br_ding1.wav");  // rail ding sound
				if(random() < 0.5) 
				{
					ex_localsound(attacker, "misc/br_ding1.wav");  // rail ding sound
				}
				else if (random() <= 1.0) 
				{
					ex_localsound(attacker, "misc/br_ding2.wav");  // rail ding sound     
				}
					
				/*
				if(targ.frags == top_score_global && (teamplay || (crx_playmode & CTF_MODE) || (crx_playmode & MATCH_MODE) || (crx_playmode & DM_PUBLIC_MODE) || mode_is_public_ctf()) )
				{
					//attacker.frags += 1;
					client_frag(attacker, 1);
					//make_icon(attacker, 2, damage);
						
					bprint (attacker.netname);
					bprint (" is a kingslayer\n");
						
				}
				*/
				
				if(attacker.rail_was_curved == 0)
				{
					if (rnum < 0.5)
					{
						bprint (targ.netname);
						bprint(" was railed by ");         
						bprint (attacker.netname);
					}
					else
					{
						bprint (targ.netname);
						bprint(" was atomized by ");    
						bprint (attacker.netname);
					}
				}
				else if(attacker.rail_was_curved == 1)
				{
					{
						bprint (targ.netname);
						bprint(" was curve-railed by ");         
						bprint (attacker.netname);
					}
				}
				
				if(attacker.railjump_yes ==1) attacker.railjump_yes = 1.5;
				if(attacker.railjump_yes ==2.5) 
				{
					bprint(" \b[ILLEGAL NINJA MOVES]\b");  //10/5/23
					attacker.railjump_yes =0;
				}
					
				
				//bprint(ftos(attacker.rails_in_a_row));
				if(attacker.rail_shots > 20 && attacker.rail_shots < 100)
				{
					if(attacker.rail_frags/attacker.rail_shots >= 0.65) 
					{
						bprint(" \b[AIMBOT PERMABAN!]\b");
						attacker.rail_shots +=100;
						attacker.tier1 +=1;
					}
					else if(attacker.rail_frags/attacker.rail_shots >= 0.60) 
					{
						bprint(" \b[SEX PANTHER]\b");
						attacker.rail_shots +=100;
						attacker.tier2 +=1;
					}
					else if(attacker.rail_frags/attacker.rail_shots >= 0.50) 
					{
						bprint(" \b[HOT SHOTS: PART DEUX]\b");
						attacker.rail_shots +=100;
						attacker.tier1 +=1;
					}
				}
				
				if (attacker.airborn_pos > 310 && targ.airborn_pos > 310 && attacker.rail_was_curved == 0) 
				{
					bprint(" \b[ACE OF RAILS]\b");
					attacker.tier1 +=1;
				}
				if (attacker.airborn_pos > 250 && attacker.rail_was_curved == 1) 
				{
					bprint(" \b[SIDEWINDER]\b");
					attacker.tier1 +=1;
				}
				
				if (attacker.tarzan_time == 1) 
				{
					bprint(" \b[TARZAN]\b");
					attacker.tier2 +=1;
				}
				
				else if (attacker.tarzan_time == 1 && targ.flag_carrier) 
				{
					bprint(" \b[ALMOST MADE IT!]\b");
					attacker.tier2 +=1;
				}
				
				if(targ.KDR > 2.1 && targ.frags == top_score_global && attacker.rail_was_curved == 1) 
				{
					bprint(" \b[BLUE SHELL]\b");
					attacker.tier2 +=1;
				}
					
				
				if (attacker.airborn_pos > 110 && targ.airborn_pos > 110 && (attacker.airborn_pos - targ.airborn_pos > 500 || targ.airborn_pos - attacker.airborn_pos > 500)) 
				{
					bprint(" \b[HIGH AS FUCK]\b");
					attacker.tier1 +=1;
				}
				
				if(attacker.turn_speed > 97 || attacker.turn_speed <-97) 
				{
					bprint(" \b[BLUE STEEL]\b");	  //10/5/23
					attacker.tier1 +=1;
				}
				if((attacker.skiing_on ==1 || attacker.skiing_on ==2) && (attacker.turn_speed > 12 || attacker.turn_speed <-12))
				{
					bprint(" \b[ACTION!!]\b");	  //10/5/23
					attacker.tier1 +=1;
				}
				if ((attacker.skiing_on ==1 || attacker.skiing_on ==2) && attacker.movement_x ==-400) 
				{
					bprint(" \b[TAIL GUNNER]\b");
						attacker.tier2 +=1;
				}
				
				if (attacker.angles_not_zero ==1) 
				{
					bprint(" \b[OFF THE WALL]\b");   //10/5/23
						attacker.tier2 +=1;
				}
				//if((attacker.player_flag & PF_ITEM_RUNE2_FLAG) && targ.armorvalue >= 100 && attacker.airborn_pos > ) bprint(" \b[ANTI-ARMOR ROUND]\b");
				//else if((attacker.player_flag & PF_ITEM_RUNE2_FLAG) && targ.armorvalue >= 100 && attacker.rail_was_curved == 0) bprint(" \b[ANTI-ARMOR ROUND]\b");
					
				if(attacker.rails_in_a_row >= 2.98 && time - attacker.rail_record_timer < 2.4) 
				{
					bprint(" \b[THE WACO KID]\b");
					attacker.tier3 +=1;
				}
				
				bprint("\n");	
				attacker.rail_was_curved = 0;
			}

              
      
			else
			{
			// This should never happen.. but does it!?!?
			bprint (targ.netname);
			bprint(" was massacred by ");
			bprint (attacker.netname);
			bprint("\n");
			}
				
		}
			return;
	}
	else
	{
			// targ got himself killed
			client_frag(targ, -1);
			bprint (targ.netname);

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				if (rnum < 0.5)bprint(" blew up\n");
				else bprint (" exploded\n");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				if (rnum < 0.5) bprint (" was squished\n");
				else bprint (" was flattened\n");
				return;
			}
			

			// in-water deaths
			if (targ.watertype == -3)
			{
				if (rnum < 0.33) bprint (" sleeps with the fishes\n");
				else if (rnum < 0.66) bprint (" drowns\n");
				return;
			}
			else if (targ.watertype == -4)
			{
				if (rnum < 0.60) bprint (" gulped down some slime\n");
				else bprint (" picked a bad place to swim\n");
				return;
			}
			else if (targ.watertype == -5)
			{
				targ.total_deaths = targ.total_deaths +1;
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					return;
				}
				if (rnum < 0.5) bprint (" turned into hot slag\n");
				return;
			}

			// hell if I know; he's just dead!!!
			bprint (" died\n");
			if(crx_playmode & RACE_MODE)
			{
				countdown = 0;
				countdown_ct = 0;
			}
		}
	}

};
