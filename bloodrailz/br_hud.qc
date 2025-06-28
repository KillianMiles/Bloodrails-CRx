/////////  HUD  ///////////////////////////////////////////////////////////////////////////////////////////////////////////



void() update_rhud =
{
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	setorigin(self, '0 8.75 -22.05');
	
	if(self.owner.rail_HUD ==2)
	{
		setmodel (self, "mdl/hud_r1.mdl");
		self.rail_HUD = time;
		self.owner.rail_HUD =1;
	}
	
	if(time - self.rail_HUD > 0.13)
	{
			setmodel (self, "mdl/hud_r.mdl");
	}
	
			

	self.alpha = 0.7;
    
	if(mapname == "tut1")
	{
		if(time - self.owner.mag_recharge_time  < 0.2) self.skin = 0;
		else if(time - self.owner.mag_recharge_time  < 0.4) self.skin = 1;
		else if(time - self.owner.mag_recharge_time  < 0.6) self.skin = 2;
		else if(time - self.owner.mag_recharge_time  < 0.8) self.skin = 3;
		else if(time - self.owner.mag_recharge_time  < 1.0) self.skin = 4;
		else if(time - self.owner.mag_recharge_time  < 1.2) self.skin = 5;
		else if(time - self.owner.mag_recharge_time  < 1.4) self.skin = 6;
		else if(time - self.owner.mag_recharge_time  < 1.6) self.skin = 7;
		else if(time - self.owner.mag_recharge_time  < 1.8) self.skin = 8;
		else if(time - self.owner.mag_recharge_time  < 2) self.skin = 9;
		else if(time - self.owner.mag_recharge_time  >= 2) self.skin = 10;
		
	}
	else
	{
		if(time - self.owner.mag_recharge_time  < 2.1) self.skin = 0;
		else if(time - self.owner.mag_recharge_time  < 4.2) self.skin = 1;
		else if(time - self.owner.mag_recharge_time  < 6.3) self.skin = 2;
		else if(time - self.owner.mag_recharge_time  < 8.4) self.skin = 3;
		else if(time - self.owner.mag_recharge_time  < 10.5) self.skin = 4;
		else if(time - self.owner.mag_recharge_time  < 12.6) self.skin = 5;
		else if(time - self.owner.mag_recharge_time  < 14.7) self.skin = 6;
		else if(time - self.owner.mag_recharge_time  < 16.8) self.skin = 7;
		else if(time - self.owner.mag_recharge_time  < 18.9) self.skin = 8;
		else if(time - self.owner.mag_recharge_time  < 21) self.skin = 9;
		else if(time - self.owner.mag_recharge_time  >= 21) self.skin = 10;
	}
	
	if(self.owner.mag_recharge_time == 0) self.skin = 10;
	
	if(intermission_running)
	{
		self.alpha =0.001;
	}
	
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if (self.owner.style & STYLE_OBSERVER) self.alpha =0.001;    //021824
	
	if ((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.items2 & IT2_SIGIL2)) 
	{
		self.skin = 0; //DECEM no sidewinder with Power
		self.alpha = 0.2;
	}
	
	
	//self.nextthink = time + 0.08;
	self.nextthink = time + my_ticrate*25;  //DECEM
}


void() Rail_HUD =  
{
	if ((crx_playmode & RACE_MODE) && mapname != "tut1") return;
	if(self.rail_HUD == 0)
	{
		self.rail_HUD = 1;
		local entity r_hud;
		r_hud = spawn();
		setmodel (r_hud, "mdl/hud_r.mdl");
		r_hud.skin = 0;

		setorigin(r_hud, '0 0 0');
		r_hud.movetype = MOVETYPE_NOCLIP;
		r_hud.solid = SOLID_NOT;
		r_hud.classname = "r_hud";
		setsize (r_hud, 0,0);
		
		//r_hud.effects = r_hud.effects | EF_NODEPTHTEST;
		
		r_hud.owner = self;
		r_hud.nextthink = time + 0.05;
		r_hud.think = update_rhud;
	}
    
}



void() update_shud =
{
	self.effects = self.effects | EF_NODEPTHTEST;
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	setorigin(self, '0 8.75 -25.55');
	
	if(self.owner.shield_HUD ==2)
	{
		setmodel (self, "mdl/hud_s1.mdl");
		self.shield_HUD = time;
		self.owner.shield_HUD =1;
	}
	
	if(time - self.shield_HUD > 0.13)
	{
			setmodel (self, "mdl/hud_s.mdl");
	}
	
	
	self.alpha = 0.65;
	
	
	if(mapname == "tut1")
	{
		if(time - self.owner.shield_time  < 0.2) self.skin = 0;
		else if(time - self.owner.shield_time  < 0.4) self.skin = 1;
		else if(time - self.owner.shield_time  < 0.6) self.skin = 2;
		else if(time - self.owner.shield_time  < 0.8) self.skin = 3;
		else if(time - self.owner.shield_time  < 1.0) self.skin = 4;
		else if(time - self.owner.shield_time  < 1.2) self.skin = 5;
		else if(time - self.owner.shield_time  < 1.4) self.skin = 6;
		else if(time - self.owner.shield_time  < 1.6) self.skin = 7;
		else if(time - self.owner.shield_time  < 1.8) self.skin = 8;
		else if(time - self.owner.shield_time  < 2) self.skin = 9;
		else if(time - self.owner.shield_time  >= 2) self.skin = 10;
	}
	else
	{
		if(time - self.owner.shield_time  < 1.8) self.skin = 0;
		else if(time - self.owner.shield_time  < 3.6) self.skin = 1;
		else if(time - self.owner.shield_time  < 5.4) self.skin = 2;
		else if(time - self.owner.shield_time  < 7.2) self.skin = 3;
		else if(time - self.owner.shield_time  < 9) self.skin = 4;
		else if(time - self.owner.shield_time  < 10.8) self.skin = 5;
		else if(time - self.owner.shield_time  < 12.6) self.skin = 6;
		else if(time - self.owner.shield_time  < 14.4) self.skin = 7;
		else if(time - self.owner.shield_time  < 16.2) self.skin = 8;
		else if(time - self.owner.shield_time  < 18) self.skin = 9;
		else if(time - self.owner.shield_time  >= 18) self.skin = 10;
	}
	
	if(self.owner.shield_time == 0) self.skin = 10;
	
	if(intermission_running)
	{
		self.alpha =0.01;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if (self.owner.style & STYLE_OBSERVER) self.alpha =0.001;  
	
	if ((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.items2 & IT2_SIGIL3)) 
	{
		self.skin = 0; //DECEM no shield with haste
		self.alpha = 0.2;
	}
	
	//self.nextthink = time + 0.08;
	self.nextthink = time + my_ticrate*27;  //DECEM
	
}


void() Shield_HUD =  
{
	if ((crx_playmode & RACE_MODE) && mapname !="tut1") return;
	if(self.shield_HUD == 0)
	{
		self.shield_HUD = 1;
		local entity s_hud;
		s_hud = spawn();
		setmodel (s_hud, "mdl/hud_s.mdl");
		s_hud.skin = 0;

		setorigin(s_hud, '0 0 0');
		s_hud.movetype = MOVETYPE_NOCLIP;
		s_hud.solid = SOLID_NOT;
		s_hud.classname = "s_hud";
		setsize (s_hud, 0,0);
		
		//s_hud.effects = s_hud.effects | EF_NODEPTHTEST;
		
		s_hud.owner = self;
		s_hud.nextthink = time + 0.05;
		s_hud.think = update_shud;
		
	}
    
}

void() update_flag_status =
{
	local entity bflag;
	bflag = find(world, classname, "item_flag_team2");
	
	local entity rflag;
	rflag = find(world, classname, "item_flag_team1");
	
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	setorigin(self, '0  77 36');
	
	self.alpha = 0.9;
	self.skin = 0;
	
	if (!BLUE_FLAG_TAKEN && !(bflag.cnt == CTF_FLAG_DROPPED) && !RED_FLAG_TAKEN && !(rflag.cnt == CTF_FLAG_DROPPED)) self.skin = 0; //X-X
	
	if (BLUE_FLAG_TAKEN && !(bflag.cnt == CTF_FLAG_DROPPED) && RED_FLAG_TAKEN && !(rflag.cnt == CTF_FLAG_DROPPED)) self.skin = 6;  // T-T
	if (RED_FLAG_TAKEN && !BLUE_FLAG_TAKEN) self.skin = 8;  // X-T
	if (BLUE_FLAG_TAKEN && !RED_FLAG_TAKEN) self.skin = 7;   //T-X
	
	if (RED_FLAG_TAKEN && !(rflag.cnt == CTF_FLAG_DROPPED) && (bflag.cnt == CTF_FLAG_DROPPED)) self.skin = 1;  //T-D
	if (!RED_FLAG_TAKEN && (bflag.cnt == CTF_FLAG_DROPPED)) self.skin = 3;  //X-D
	
	if (BLUE_FLAG_TAKEN && (rflag.cnt == CTF_FLAG_DROPPED)) self.skin = 4;   //D-T
	if (!BLUE_FLAG_TAKEN && (rflag.cnt == CTF_FLAG_DROPPED)) self.skin = 5;   //D-X
	
	if ((bflag.cnt == CTF_FLAG_DROPPED) && (rflag.cnt == CTF_FLAG_DROPPED)) self.skin = 2;   //D-D
	
	if (!(crx_playmode & CTF_MODE) && !(crx_playmode & DM_PUBLIC_MODE) && !(crx_playmode & MATCH_MODE))
	{
		self.think = SUB_Remove;
		self.ctfhud = 0;
	}


	if(intermission_running)
	{
		setorigin(self, '0 0 0'+ '-45 165 138'); //159 -> 129
		self.skin = 0;
	}
		
	if (crx_playmode & DM_PUBLIC_MODE || crx_playmode & MATCH_MODE) self.skin = 0;
		
		
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	
	//self.nextthink = time + 0.12;
	self.nextthink = time + my_ticrate*13;  //DECEM
}



void() Flag_Status =
{

	if ((crx_playmode & CTF_MODE || crx_playmode & DM_PUBLIC_MODE || crx_playmode & MATCH_MODE) && self.ctfhud == 0)

	{
		self.ctfhud = 1;
		local entity flagstatus;
		flagstatus = spawn(); 
		setmodel (flagstatus, "mdl/flag_status.mdl");

		setorigin(flagstatus, '0 0 10');
		flagstatus.movetype = MOVETYPE_NOCLIP;
		flagstatus.solid = SOLID_NOT;
		flagstatus.classname = "haveflag";

		setsize (flagstatus, 0,0);
		flagstatus.owner = self;
		flagstatus.nextthink = time + 0.1;
		flagstatus.think = update_flag_status;
		
	}
}




void() update_You_Have_Flag =
{
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	setorigin(self, '0 93 35');
	
	self.alpha = 0.9;
	
	
	if(self.owner.flag_carrier == 0) 
	{
		self.think = SUB_Remove;
		self.owner.flag_displayed = 0;
	}

	if(intermission_running)
	{
		self.alpha =0.01;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD

	//self.nextthink = time + 0.1;
	self.nextthink = time + my_ticrate*19;  //DECEM
}



void() You_Have_Flag =
{
	if(self.flag_carrier && self.flag_displayed == 0)
	{
		self.flag_displayed = 1;
		local entity haveflag;
		haveflag = spawn();
		setmodel (haveflag, "mdl/flag_hud.mdl");
		
		haveflag.skin = 1;
		//self.effects = EF_RED;
		if (self.height == crx_team1) 
		{
			haveflag.skin = 0;
			//self.effects = EF_BLUE;
		}

		setorigin(haveflag, '0 0 0');
		haveflag.movetype = MOVETYPE_NOCLIP;
		haveflag.solid = SOLID_NOT;
		haveflag.classname = "haveflag";

		setsize (haveflag, 0,0);
		haveflag.owner = self;
		haveflag.nextthink = time + 0.1;
		haveflag.think = update_You_Have_Flag;
		
	}
}






void() update_tut_icon =
{

	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	
	
	if(self.weapon ==1) setorigin(self, '0 -78 95'); //bottom left
	else if(self.weapon ==2) setorigin(self, '0 -119 73'); //bottom center
	//setorigin(self, '0 -190 78'); // 77 -> 82
	
	self.alpha = 0.9;
	

	if (mapname != "tut1" || intermission_running)
	{
		self.think = SUB_Remove;
		if(self.weapon ==1) self.owner.tut_displayed1 = 0;
		else if(self.weapon ==1) self.owner.tut_displayed1 = 0;
	}
		
	if(self.weapon ==1 && self.owner.origin_z < 2400) 
	{
		self.think = SUB_Remove;
		self.owner.tut_displayed1 = 0;
	}
		
	else if(self.weapon ==2 && mapname != "tut1")
	{
		self.think = SUB_Remove;
		self.owner.tut_displayed2 = 0;
	}
	

	
	//if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD

	self.nextthink = time + my_ticrate*30;  //DECEM
}



void(float what_type) make_tut_icon =
{
	if (((what_type ==1 &self.tut_displayed1 == 0) || (what_type ==1 &self.tut_displayed1 == 0)) && mapname == "tut1")
	{
		if(what_type ==1) self.tut_displayed1 = 1;
		else if(what_type ==2) self.tut_displayed2 = 1;
		
		local entity tut;
		tut = spawn();
		
		setmodel (tut, "mdl/tut_icons.mdl");
		
		//if 	((self.player_flag & PF_ITEM_tut_MASK) && (self.player_flag & PF_ITEM_tut1_FLAG)) tut.skin =1;
		//else if ((self.player_flag & PF_ITEM_tut_MASK) && (self.player_flag & PF_ITEM_tut2_FLAG)) tut.skin =2;
		//else if ((self.player_flag & PF_ITEM_tut_MASK) && (self.player_flag & PF_ITEM_tut3_FLAG)) tut.skin =3;
		//else if ((self.player_flag & PF_ITEM_tut_MASK) && (self.player_flag & PF_ITEM_tut4_FLAG)) tut.skin =4;
		
		if(what_type == 1) tut.skin =1;
		else if(what_type == 2) tut.skin =2;
	

		//setorigin(tut, '0 0 0');
		tut.movetype = MOVETYPE_NOCLIP;
		tut.solid = SOLID_NOT;
		tut.classname = "tut";

		setsize (tut, 0,0);
		
		if(what_type ==1) tut.weapon =1;
		else if(what_type ==2) tut.weapon =2;
		
		tut.owner = self;
		tut.nextthink = time + 0.1;
		tut.think = update_tut_icon;
		
	}
}






void() update_You_Have_Rune =
{

	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	//setorigin(self, '0 -80 61'); //bottom left
	setorigin(self, '0 -159.5 78.9'); // 77 -> 82
	
	self.alpha = 0.9;
	
	

	if (!(self.owner.player_flag & PF_ITEM_RUNE_MASK))
	{
		self.think = SUB_Remove;
		self.owner.rune_displayed = 0;
	}

	if(intermission_running)
	{
		self.think = SUB_Remove;
		self.owner.rune_displayed = 0;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD

	//self.nextthink = time + 0.12;
	self.nextthink = time + my_ticrate*30;  //DECEM
}



void() You_Have_Rune =
{
	if (self.player_flag & PF_ITEM_RUNE_MASK && self.rune_displayed == 0)
	{
		self.rune_displayed = 1;
		local entity haverune;
		haverune = spawn();
		
		setmodel (haverune, "mdl/rune_icon.mdl");
		
		if 	((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG)) haverune.skin =1;
		else if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE2_FLAG)) haverune.skin =2;
		else if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE3_FLAG)) haverune.skin =3;
		else if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE4_FLAG)) haverune.skin =4;
	

		//setorigin(haverune, '0 0 0');
		haverune.movetype = MOVETYPE_NOCLIP;
		haverune.solid = SOLID_NOT;
		haverune.classname = "haverune";

		setsize (haverune, 0,0);
		haverune.owner = self;
		haverune.nextthink = time + 0.1;
		haverune.think = update_You_Have_Rune;
		
	}
}
















void() update_jumbo_blue =
{
	if (!(crx_playmode & CTF_MODE) && !(crx_playmode & DM_PUBLIC_MODE) && !(crx_playmode & MATCH_MODE))
	{
		self.think = SUB_Remove;
		self.owner.flagscores_red = 0;
	}
	
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	if(self.weapon == 1) setorigin(self, '0 76.6 41');
	if(self.weapon == 2) setorigin(self, '0 80.1 41');
	if(self.weapon == 3) setorigin(self, '0 83.6 41');
	
	//crx_teamfrags2 = 395;
	
	if(crx_teamfrags2 < 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = 10;
	}
	
	if(crx_teamfrags2/10 < 1 || crx_teamfrags2 == 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = crx_teamfrags2;
	}
	
	else if(crx_teamfrags2/10 >= 1 && crx_teamfrags2/100 < 1) 
	{
		if(self.weapon == 1)
		{
			self.skin = crx_teamfrags2 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = (crx_teamfrags2 - (crx_teamfrags2 % 10))/10;
		}
		if(self.weapon == 3) self.skin = 10;
	}
	
	else if (crx_teamfrags2/100 >= 1)
	{
		if(self.weapon == 1)
		{
			self.skin = crx_teamfrags2 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = ((crx_teamfrags2 - (crx_teamfrags2 % 10))/10) % 10;
		}
		if(self.weapon == 3) 
		{	
			local float tens = (crx_teamfrags2 - (crx_teamfrags2 % 10)) /10;
			self.skin = (tens - (tens % 10)) /10;
		}
	
	}
	
	
	if(intermission_running)
	{
		if(self.weapon == 1) setorigin(self, '0 -0.4 5'+ '-40 165 135'); //161
		if(self.weapon == 2) setorigin(self, '0 3.1 5' + '-40 165 135');
		if(self.weapon == 3) setorigin(self, '0 6.6 5' + '-40 165 135');
	}
	
	self.alpha = 0.9;
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD

	//self.nextthink = time + 0.1;
	self.nextthink = time + my_ticrate*24;  //DECEM

}




void() make_jumbo_blue =
{
	if ((crx_playmode & CTF_MODE || crx_playmode & DM_PUBLIC_MODE || crx_playmode & MATCH_MODE) && self.flagscores_blue == 0)
	{
		local entity prj;
		float digits = 3;
		self.flagscores_blue = 1;
		
		while (digits)
		{
	
		prj = spawn ();
		
		prj.owner = self;
		prj.movetype = MOVETYPE_NOCLIP;
		prj.solid = SOLID_NOT;
		prj.weapon = digits;
		
		prj.touch = SUB_Null;
		prj.classname = "digit_blue";
		setmodel (prj, "mdl/hud_digi_b.mdl");		
		setsize (prj, 0, 0);	
		setorigin (prj, '0 0 0');
		prj.velocity = '0 0 0';	
		prj.frame = 0;	
		prj.think = update_jumbo_blue;
		prj.nextthink = time + 0.1;
		digits = digits - 1;
		prj.cnt = 5;	
		}
	}
}





void() update_jumbo_red =
{
	if (!(crx_playmode & CTF_MODE) && !(crx_playmode & DM_PUBLIC_MODE) && !(crx_playmode & MATCH_MODE))
	{
		self.think = SUB_Remove;
		self.owner.flagscores_red = 0;
	}
	
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	if(self.weapon == 1) setorigin(self, '0 88.7 41');
	if(self.weapon == 2) setorigin(self, '0 92.2 41');
	if(self.weapon == 3) setorigin(self, '0 95.7 41');
	
	//crx_teamfrags1 = 395;
	
	if(crx_teamfrags1 < 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = 10;
	}
	
	if(crx_teamfrags1/10 < 1 || crx_teamfrags1 == 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = crx_teamfrags1;
	}
	
	else if(crx_teamfrags1/10 >= 1 && crx_teamfrags1/100 < 1) 
	{
		if(self.weapon == 1)
		{
			self.skin = crx_teamfrags1 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = (crx_teamfrags1 - (crx_teamfrags1 % 10))/10;
		}
		if(self.weapon == 3) self.skin = 10;
	}
	
	else if (crx_teamfrags1/100 >= 1)
	{
		if(self.weapon == 1)
		{
			self.skin = crx_teamfrags1 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = ((crx_teamfrags1 - (crx_teamfrags1 % 10))/10) % 10;
		}
		if(self.weapon == 3) 
		{	
			local float tens = (crx_teamfrags1 - (crx_teamfrags1 % 10)) /10;
			self.skin = (tens - (tens % 10)) /10;
		}
	
	}
	
	if(intermission_running)
	{
		if(self.weapon == 1) setorigin(self, '0 11.7 5' + '-40 165 135'); //161
		if(self.weapon == 2) setorigin(self, '0 15.2 5' + '-40 165 135');
		if(self.weapon == 3) setorigin(self, '0 18.7 5' + '-40 165 135');
		
		
	}	
	
	self.alpha = 0.9;
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD

	//self.nextthink = time + 0.1;
	self.nextthink = time + my_ticrate*22;  //DECEM
}




void() make_jumbo_red =
{
	if ((crx_playmode & CTF_MODE || crx_playmode & DM_PUBLIC_MODE || crx_playmode & MATCH_MODE) && self.flagscores_red == 0)
	{
		local entity prj;
		float digits = 3;
		self.flagscores_red = 1;
		
		while (digits)
		{
	
		prj = spawn ();
		
		prj.owner = self;
		prj.movetype = MOVETYPE_NOCLIP;
		prj.solid = SOLID_NOT;
		prj.weapon = digits;
		
		prj.touch = SUB_Null;
		prj.classname = "digit_red";
		setmodel (prj, "mdl/hud_digi_r.mdl");		
		setsize (prj, 0, 0);	
		setorigin (prj, '0 0 0');
		prj.velocity = '0 0 0';	
		prj.frame = 0;	
		prj.think = update_jumbo_red;
		prj.nextthink = time + 0.1;
		digits = digits - 1;
		prj.cnt = 5;	
		}
	}
}







//////////////////////////////////////////////////////////////////////////////////////////







void() update_press_move =
{
	self.owner.suppress_hud =0;
	
	if (!(self.owner.player_flag & PF_OVERLAY))
	{
		self.think = SUB_Remove;
	}
	
		if(intermission_running)
	{
		self.think = SUB_Remove;
		self.button_press_display =0;
	}
	
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	//if(self.weapon == 1) setorigin(self, '-40 290 37');   //'-40 290 37');
	//if(self.weapon == 2) setorigin(self, '-40 290 46');
	//if(self.weapon == 3) setorigin(self, '-40 290 55');
	//if(self.weapon == 4) setorigin(self, '-40 290 64');
	//if(self.weapon == 5) setorigin(self, '-40 290 55');
	//if(self.weapon == 6) setorigin(self, '-40 290 73');
	
	if(self.weapon == 1) setorigin(self, '0 0 37');   //'-40 290 37');
	if(self.weapon == 2) setorigin(self, '0 0 46');
	if(self.weapon == 3) setorigin(self, '0 0 55');
	if(self.weapon == 4) setorigin(self, '0 0 64');
	if(self.weapon == 5) setorigin(self, '0 0 55');
	if(self.weapon == 6) setorigin(self, '0 0 73');
	
	self.alpha = 0.59;
	
	if(self.weapon == 1)
	{
		if (self.owner.button2 && self.owner.ski_button ==0) self.skin =1;
		else if (!self.owner.button2 && self.owner.ski_button ==0)self.skin =0;
		else if (self.owner.button2 && self.owner.ski_button ==1)self.skin =30;
		else if (!self.owner.button2 && self.owner.ski_button ==1)self.skin =31;
	}
	if(self.weapon == 2)
	{
		if (self.owner.movement_y <= -400 && self.owner.movement_x > -300) self.skin =4;
		else if (self.owner.movement_y >= 400 && self.owner.movement_x >-300) self.skin =3;
		else if (self.owner.movement_y >= 400 && self.owner.movement_x <= -300) self.skin =5;
		else if (self.owner.movement_y <= -400 && self.owner.movement_x <= -300) self.skin =6;
		else if (self.owner.movement_y == 0 && self.owner.movement_x > -300) self.skin =2;
		else if (self.owner.movement_y == 0 && self.owner.movement_x <= -300) self.skin =9;
	}
	if(self.weapon == 3)
	{
		if (self.owner.movement_x > 320) self.skin =11;
		else self.skin =10;
	}
	if(self.weapon == 4)
	{
		if (!(crx_playmode & MODE_WRAITH) || self.owner.wraith == 0)
		{
			if(!self.owner.button0) self.skin = 12;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_HOOK) self.skin = 13;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_RAILGUN && self.owner.button0) self.skin = 14;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_AXE && self.owner.button0) self.skin = 15;
			else if(self.owner.hook_out == 0 && self.owner.weapon == IT_RAILGUN && self.owner.button0) self.skin = 16;
			else if(self.owner.hook_out == 0 && self.owner.weapon == IT_AXE && self.owner.button0) self.skin = 17;
		}
		else if ((crx_playmode & MODE_WRAITH) && self.owner.wraith == 1)
		{
			if(!self.owner.button0) self.skin = 29;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_HOOK) self.skin = 27;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_AXE && self.owner.button0) self.skin = 28;
			else if(self.owner.hook_out == 0 && self.owner.weapon == IT_AXE && self.owner.button0) self.skin = 26;
		}

	}
	if(self.weapon == 5)
	{
		if (self.owner.turn_speed < 3 && self.owner.turn_speed > -3) self.skin =24;
		
		else if (self.owner.turn_speed >= 3 && self.owner.turn_speed < 10) self.skin =18;
		else if (self.owner.turn_speed >= 10 && self.owner.turn_speed < 17) self.skin =19;
		else if (self.owner.turn_speed >= 17) self.skin =20;
		
		else if (self.owner.turn_speed <= -3 && self.owner.turn_speed > -10) self.skin =21;
		else if (self.owner.turn_speed <= -10 && self.owner.turn_speed > -17) self.skin =22;
		else if (self.owner.turn_speed <= -17) self.skin =23;
	}
	
	if(self.weapon == 6)
	{
		if (crx_playmode & MODE_WRAITH && self.owner.wraith == 1) self.skin =25;
		else self.skin =24;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if (self.owner.style & STYLE_OBSERVER) self.alpha =0.001;   

	if(random() < 0.5) self.nextthink = time + my_ticrate*3;  //DECEM
	else self.nextthink = time + my_ticrate*4;  //DECEM
}




void() make_press_move =
{
	if(self.button_press_display == 0)
	{
		self.button_press_display =1;
		if(!(self.player_flag & PF_OVERLAY)) self.player_flag = self.player_flag | PF_OVERLAY;
		
		local entity prj;
		float lines = 6;
		
		while (lines)
		{
	
		prj = spawn ();
		
		prj.owner = self;
		prj.movetype = MOVETYPE_NOCLIP;
		prj.solid = SOLID_NOT;
		prj.weapon = lines;
		
		prj.touch = SUB_Null;
		prj.classname = "press_arrows";
		setmodel (prj, "mdl/inputs.mdl");		
		setsize (prj, 0, 0);	
		setorigin (prj, '0 0 0');
		prj.velocity = '0 0 0';	
		prj.frame = 0;	
		prj.think = update_press_move;
		prj.nextthink = time + 0.1;
		lines = lines - 1;
		prj.cnt = 5;	
		}
	}
}




////////////////////////////////////////////////////////////////////////////////////////////////////////



void() update_flick_marker =
{
	self.drawonlytoclient = self.owner;
	self.alpha = 0.7;
	setorigin(self, self.owner.flickEnt.origin + '0 0 7');
	//self.angles = self.owner.angles;
	
	makevectors(self.owner.owner.angles);
	
	local vector dir = normalize(self.owner.origin - self.owner.flickEnt.origin);
	
	self.angles = vectoangles(dir);
	
	
	if(vlen(self.owner.origin - self.owner.flickEnt.origin) < 1000) setmodel (self, "mdl/marker.mdl");
	else if(vlen(self.owner.origin - self.owner.flickEnt.origin) < 3000) setmodel (self, "mdl/marker1.mdl");
	
	else if(vlen(self.owner.origin - self.owner.flickEnt.origin) < 9000) 
	{
		setmodel (self, "mdl/marker2.mdl");
		setorigin(self, self.owner.flickEnt.origin + dir*(200));
	}
		
	
	if (self.owner.height == crx_team1) self.skin = 6;   //red
	else if (self.owner.height == crx_team2) self.skin = 4;   //blue
	else self.skin = 0;   //white	
	
	if(self.hanim ==0)
	{
		self.weapon = self.weapon + 1;
		if(self.weapon%4 == 0) self.frame = self.frame -1;
		if(self.weapon >=50 || self.frame <=4)
		{
			self.frame = 4;
			self.hanim = 1;
			self.weapon =0;
		}
	}
	
	if(!self.owner.button0 || self.owner.rail_powered == 0)
	{
		self.think = SUB_Remove;
		self.owner.marker_up = 0;
	}

	if (self.owner.deadflag != DEAD_NO) 
	{
		self.think = SUB_Remove;
		self.owner.marker_up = 0;
	}
	
	if (self.owner.flickEnt.deadflag != DEAD_NO) 
	{
		self.think = SUB_Remove;
		self.owner.marker_up = 0;
	}
    
	self.nextthink = time + 0.01;
}







void() make_flick_marker =
{
	if(self.marker_up == 0)
	{
		
		sound (self, CHAN_AUTO, "weap/br_lockon.wav", 1, ATTN_NORM);

		
		self.marker_up =1;
		local entity marker;
		marker = spawn();
		setmodel (marker, "mdl/marker.mdl");
		setorigin(marker, self.flickEnt.origin + '0 0 7');
		
		makevectors(self.v_angle);
		marker.angles = self.angles;
		
		marker.movetype = MOVETYPE_NOCLIP;
		marker.solid = SOLID_NOT;
		marker.classname = "marker";
		marker.weapon = 0;
		marker.frame = 8;
		marker.x_dist =0;
		setsize (marker, 0,0);
		marker.alpha = 0.7;
		marker.owner = self;
		
		marker.effects = marker.effects | EF_NODEPTHTEST;
		
		marker.nextthink = time + 0.01;
		marker.think = update_flick_marker;
	}
}








///////////////////////////////////////////////////////////////////////////////////////////////////////////////////



void() update_rail_ammo =
{
	if (crx_playmode & MODE_NOAMMO)
	{
		self.think = SUB_Remove;
	}
	
	if(intermission_running)
	{
		self.think = SUB_Remove;
		self.rail_ammo_displayed =0;
	}
	
	
	
	if(self.weapon ==2)
	{
		setorigin(self, '0 197 40.8');
	
		makevectors(self.owner.owner.v_angle);
    
		self.viewmodelforclient = self.owner;
		self.alpha = 0.59;
	

		if (self.owner.ammo_slugs == 10) self.skin =10;
		else if (self.owner.ammo_slugs == 9) self.skin =9;
		else if (self.owner.ammo_slugs == 8) self.skin =8;
		else if (self.owner.ammo_slugs == 7) self.skin =7;
		else if (self.owner.ammo_slugs == 6) self.skin =6;
		else if (self.owner.ammo_slugs == 5) self.skin =5;
		else if (self.owner.ammo_slugs == 4) self.skin =4;
		else if (self.owner.ammo_slugs == 3) self.skin =3;
		else if (self.owner.ammo_slugs == 2) self.skin =2;
		else if (self.owner.ammo_slugs == 1) 
		{
			self.skin =1;
		}
		else if (self.owner.ammo_slugs <= 0)
		{
			self.skin =0;
		}


		if(time - self.owner.shot_time < 0.25 && self.owner.ammo_slugs <= 0) 
		{
			self.skin = 11;
		}
		
		if(self.owner.oflags & OBSERVER_FLY) self.alpha =0.001;   
	
		if(self.owner.height == 4 || self.owner.height == 13) 
		{
			if(self.weapon ==2) self.alpha =0.59;  
		}

	}
	else if (self.weapon ==9)
	{
		setorigin(self, '0 195.8 48.4'); // 51.5 -> 54
		makevectors(self.owner.owner.v_angle);
		self.viewmodelforclient = self.owner;
		
		self.skin =12;
		
		
		if(self.owner.oflags & OBSERVER_FLY) self.alpha =0.001;  
		
		if(self.owner.height == 4 || self.owner.height == 13) 
		{
			if(self.owner.ammo_slugs >0) self.alpha =0.0001;
			else self.alpha = 0.59;
		}
		
		if(time - self.owner.shot_time < 0.25 && self.owner.ammo_slugs <= 0) 
		{
			self.skin = 13;
		}
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	
	

	//self.nextthink = time + 0.07;
	self.nextthink = time + my_ticrate*21;  //DECEM
}




void() make_rail_ammo =
{
	if(self.ammo_slugs < 10 && crx_playmode & MODE_NOAMMO) self.ammo_slugs = 999;
	
	if(crx_playmode & MODE_NOAMMO) self.rail_ammo_displayed = 0;
	
	if(self.rail_ammo_displayed == 0 && !(crx_playmode & MODE_NOAMMO))
	{
		self.rail_ammo_displayed =1;
		self.ammo_slugs = 6;
		
		//if(!(self.player_flag & PF_OVERLAY)) self.player_flag = self.player_flag | PF_OVERLAY;
		
		local entity railammo;
	
		railammo = spawn ();
		
		railammo.owner = self;
		railammo.weapon =2;
		railammo.movetype = MOVETYPE_NOCLIP;
		railammo.solid = SOLID_NOT;
		
		railammo.touch = SUB_Null;
		railammo.classname = "railammo";
		setmodel (railammo, "mdl/ammo.mdl");		
		setsize (railammo, 0, 0);	
		setorigin (railammo, '0 0 0');
		railammo.velocity = '0 0 0';	
		railammo.frame = 0;	
		railammo.think = update_rail_ammo;
		railammo.nextthink = time + 0.1;	

		local entity noammo;
	
		noammo = spawn ();
		
		noammo.owner = self;
		noammo.weapon = 9;
		noammo.movetype = MOVETYPE_NOCLIP;
		noammo.solid = SOLID_NOT;
		
		noammo.touch = SUB_Null;
		noammo.classname = "railammo";
		setmodel (noammo, "mdl/ammo.mdl");		
		setsize (noammo, 0, 0);	
		setorigin (noammo, '0 0 0');
		noammo.velocity = '0 0 0';	
		noammo.frame = 0;	
		noammo.think = update_rail_ammo;
		noammo.nextthink = time + 0.1;	
	}
}





////////////////////////////////////PRINT HUD


// Update player HUD with match timer, current score, flag status and rune status
void hud_update() =
{  

   local string winning_team = "", flag_status = "", rune_status = "", red_score = "", blue_score = "";
    

    
    
    if (self.hudspace > 7)
        return;
        



	local vector xy_velocity;                //speedometer
	xy_velocity = self.velocity;
	local float current_speed;
	current_speed = floor(vlen(xy_velocity));
	if(self.health<=0) current_speed =0;  //DECEM zero out speedometer when dead

       
	
   
    
    

	local string spacing_top = "";
    switch (self.hudspace)
    {
        case 1:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            break;
        case 2:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            break;
        case 3:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            break;
        case 4:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            break;
        case 5:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            break;
        case 6:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            break;
        case 7:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            break;
        default:
            spacing_top = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
    }




	rune_status = "                                              \n";

		
			local string bracket_spacer;
			if(current_speed >= 1000) bracket_spacer = "                          \n";
			else if(current_speed >= 100) bracket_spacer = "                           \n";
			else if(current_speed >= 10) bracket_spacer = "                            \n";
			else if(current_speed < 10) bracket_spacer = "                             \n";

	
	if(mapname =="tut1") self.frags =0; //dont increment frags when on Tut map	
	
	if ((crx_playmode & MATCH_MODE || (mode_is_public() == TRUE)))
	{
		//if(self.print_killa == 0 && !(self.player_flag & PF_HUD) && !self.suppress_hud) centerprint5(self, spacing_top, "  \n \svel:", ftos(current_speed), bracket_spacer, rune_status);   //debug?   hud   //9-24-23
		if (mode_is_public() == TRUE)
		{
			if(self.print_killa == 0 && !(self.player_flag & PF_HUD) && !self.suppress_hud)
			{
				if(self.have_rune_center == 0) centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n", "                               \n\n       \svel:",    ftos(current_speed), bracket_spacer , "\n\n\n\n\n\n\n");   //debug?   hud 
				else if(self.have_rune_center == 1) centerprint5(self, "\n\n\nalready got a rune\n\n\n\n\n\n\n\n", "                               \n\n       \svel:",    ftos(current_speed), bracket_spacer , "\n\n\n\n\n\n\n");   //debug?   hud 
				self.have_rune_center =0;
			}
		}
		
		if (crx_playmode & MATCH_MODE)
		{
			if(!(crx_state & STATE_MATCH_STARTED) && !(crx_state & STATE_MATCH_PAUSED) && !(crx_state & STATE_TIMER_STARTED))
			{
				centerprint5(self, "NO MATCH IN PROGRESS\n\n\n\n\n\n\n\n\n\n\n", "                               \n\n       \svel:",    ftos(current_speed), bracket_spacer , "\n\n\n\n\n\n\n");   //debug?   hud 
			
			}
			else if(self.print_killa == 0 && !(self.player_flag & PF_HUD) && !self.suppress_hud)
			{
				if(self.have_rune_center == 0) centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n", "                               \n\n       \svel:",    ftos(current_speed), bracket_spacer , "\n\n\n\n\n\n\n");   //debug?   hud 
				else if(self.have_rune_center == 1) centerprint5(self, "\n\n\nalready got a rune\n\n\n\n\n\n\n\n", "                               \n\n       \svel:",    ftos(current_speed), bracket_spacer , "\n\n\n\n\n\n\n");   //debug?   hud 
				self.have_rune_center =0;
			}
				
		}
		
	}
	
	else if (crx_playmode & RACE_MODE && !(self.player_flag & PF_HUD) && !self.suppress_hud && (mapname !="tut1" && mapname !="tut2")  && self.classname == "player")
	{
		if(self.racing_on == 1) centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n\x10", utils_get_time(time - chrono_time), "\x11                              \n\x10\svel:", ftos(current_speed), bracket_spacer);   //debug?   hud 
		else if(self.racing_on == 0) centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n\x10", utils_get_time(self.my_previous_time), "\x11                              \n\x10\svel:",    ftos(current_speed), bracket_spacer);   //debug?   hud 
	}
	
	else if (crx_playmode & RACE_MODE && !(self.player_flag & PF_HUD) && !self.suppress_hud && (mapname =="tut1") && self.classname == "player")
	{
		if(self.have_rune_center == 0) centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n", "                               \n\n\svel:",    ftos(current_speed), bracket_spacer , "\n\n\n\n\n\n\n    \bF1\b: tutorial restart\n    \bF2\b: Combat practice\n    \bF3\b: Play demo");   //debug?   hud 
		else if(self.have_rune_center == 1) centerprint5(self, "\n\n\nalready got a rune\n\n\n\n\n\n\n\n", "                               \n\n\svel:",    ftos(current_speed), bracket_spacer , "\n\n\n\n\n\n\n    \bF1\b: tutorial restart\n    \bF2\b: Combat practice\n    \bF3\b: Play demo");   //debug?   hud 
		self.have_rune_center =0;
	}

	else
	{
		if(self.print_killa == 0 && !(self.player_flag & PF_HUD) && !self.suppress_hud) centerprint5(self, spacing_top, rune_status, "\bvel:\b", ftos(current_speed), "                                                      ");
	}
		
	
	
	
	
	if (self.print_killa == 1 && self.ammo_rockets == 0 && !(crx_playmode & RACE_MODE))  //ammo_rockets = killedbyworld
	{
			if (self.dmg_inflictor)  //dmg_inflictor = killedby
			{
				if (self.dmg_inflictor.style & STYLE_CONNECTED)
				{
					if(self.ammo_nails == 1) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\naxe-murdered by ", self.dmg_inflictor.netname);    //ammo_nails = killedwep //dmg_inflictor = killedby
					else if(self.ammo_nails == 2) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nhooked by ", self.dmg_inflictor.netname);     //ammo_nails = killedwep//dmg_inflictor = killedby
					else if(self.ammo_nails == 3) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nrailed by ", self.dmg_inflictor.netname);    //ammo_nails = killedwep//dmg_inflictor = killedby
				}
				else 
				{
					if(self.ammo_nails == 1) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\naxe-murdered by ", "[disconnected]");    //ammo_nails = killedwep
					else if(self.ammo_nails == 2) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nhooked by ", "[disconnected]");    //ammo_nails = killedwep
					else if(self.ammo_nails == 3) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nrailed by ", "[disconnected]");    //ammo_nails = killedwep
				}
			}
	} 
		
	if(self.print_killa == 1 && self.ammo_rockets == 1 && !(crx_playmode & RACE_MODE)) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n    killed by ", "world");    //ammo_rockets = killedbyworld
		
	if(time - self.ammo_cells > 2) self.print_killa = 0; //ammo_cells = print_killa_time
		
	return;
};

















void() update_icon =
{	
	makevectors(self.owner.owner.v_angle);
	self.viewmodelforclient = self.owner;
	
	if(self.icon_display == self.owner.icon_display) self.owner.icon_height = self.origin_z;
	

	if(self.weapon == 1) //regular frag
	{
		if (self.owner.height == crx_team1) self.skin = 8;   //red
		else if (self.owner.height == crx_team2) self.skin = 7;   //blue
		else self.skin = 7;   //blue
	}
	else if(self.weapon == 2) //killed point leader
	{
		if (self.owner.height == crx_team1) self.skin = 6;   //red
		else if (self.owner.height == crx_team2) self.skin = 5;   //blue
		else self.skin = 5; 
	}
	else if(self.weapon == 3)	//killed flag carrier
	{
		if (self.owner.height == crx_team1) self.skin = 10;   //red
		else if (self.owner.height == crx_team2) self.skin = 9;   //blue
		else self.skin = 9;
	}
	else if(self.weapon == 4)   //killed flag carrier/point leader
	{
		if (self.owner.height == crx_team1) self.skin = 12;   //red 
		else if (self.owner.height == crx_team2) self.skin = 11;   //blue
		else  self.skin = 11;
	}
	else if(self.weapon == 5)	//flag return
	{
		if (self.owner.height == crx_team1) self.skin = 4;   //red
		else if (self.owner.height == crx_team2) self.skin = 3;   //blue
		else self.skin = 3; 
	}
	else if(self.weapon == 6) //Flag Cap
	{
		if (self.owner.height == crx_team1) self.skin = 1;   //red
		else if (self.owner.height == crx_team2) self.skin = 2;   //blue
		else self.skin = 1;
	}
	else if(self.weapon == 7) //TK and self
	{
		if (self.owner.height == crx_team1) self.skin = 18;   //red
		else if (self.owner.height == crx_team2) self.skin = 17;   //blue
		else self.skin = 17;
	}
	
	
	///////////////////////
	if(self.health >0)
	{
		if(self.health == 9 || self.health == 485 || self.health == 35) self.skin = 13;  //FIRE
		else if(self.health == 40 || self.health == 400.5) self.skin = 14; 	//POWER explo
		else if(self.health == 5.5 || self.health == 19 || self.health == 51) self.skin = 15; //QUASAR
		else if(self.health == 2 || self.health == 30) self.skin = 16; //GRAV WELL	
		else if(self.health == 400) self.skin = 19; //THOR
		else if(self.health == 20.2 || self.health == 40.4 || self.health == 10 || self.health == 18) self.skin = 20; //HOOK
		else if(self.health == 1000) self.skin = 21; //SIDEWINDER
		else if(self.health == 403) self.skin = 22; //AXE
		else if(self.health == 9000 || self.health == 8994 || self.health == 1001) self.skin = 23; //RAILGUN
	}
	
	
	
	if(self.alpha < 0.95 && time - self.cnt < 0.7) 
	{
		//self.alpha +=0.03;
		self.alpha +=0.05;
		if(self.alpha >= 0.95) self.alpha = 0.95;
	}
	else if(time - self.cnt > 1.1) 
	{
		self.alpha -=0.025;
		if(self.alpha < 0.05 && self.classname == "icon") 
		{
			self.think = SUB_Remove;
			self.owner.icon_num -=1;
			if(self.owner.icon_num <=0) self.owner.icon_num =0;
		}
	}
	

	
	self.nextthink = time+my_ticrate*2;  //DECEM

}



void(entity scorer, float msg, float dmg) make_icon =
{

		scorer.icon_display +=1;
		scorer.icon_num +=1;
		
		local entity icon;
		local entity icon2;
		
			icon = spawn ();
		
			icon.owner = scorer;
			icon.movetype = MOVETYPE_NOCLIP;
			icon.solid = SOLID_NOT;
		
			icon.touch = SUB_Null;
			icon.classname = "icon";
			setmodel (icon, "mdl/score_icon.mdl");		
			setsize (icon, 0, 0);	
			
			icon.icon_display = scorer.icon_display;
			icon.icon_num = scorer.icon_num;
			
				local vector a = '0 -138.5 104';
				a_z = scorer.icon_height - 5;
				
				if(a_z < 104 && time - scorer.icon_time >2) a_z = 104;
			
				if(scorer.icon_height >=110 || scorer.icon_height < 20)	
				{
					setorigin(icon, '0 -138.5 104');
					scorer.icon_height = 104;
				}
				else	
				{
					setorigin(icon, a);
					scorer.icon_height = a_z;
				}
			
			
				if(scorer.icon_time != time) scorer.icon_time = time;
				else setorigin(icon, a);

			

		

			icon.velocity = '0 0 8.0';	
			icon.frame = 0;	
			icon.alpha = 0.001;
			
			icon.cnt = time;
			//icon.effects = icon.effects | EF_NODEPTHTEST;
			
				
			icon.weapon = msg;
			icon.think = update_icon;
			icon.nextthink = time;
			

			if(dmg > 0)
			{
				icon2 = spawn ();
		
				icon2.owner = scorer;
				icon2.movetype = MOVETYPE_NOCLIP;
				icon2.solid = SOLID_NOT;
		
				icon2.touch = SUB_Null;
				icon2.classname = "icon";
				setmodel (icon2, "mdl/score_icon.mdl");		
				setsize (icon2, 0, 0);	
			
				icon2.icon_display = scorer.icon_display;
				icon2.icon_num = scorer.icon_num;
				
				a_z = scorer.icon_height;
				if(a_z < 104 && time - scorer.icon_time >2) a_z = 104;
				
				
				setorigin(icon2, a);

					if(scorer.icon_time != time) scorer.icon_time = time;
					else setorigin(icon2, a);


				icon2.velocity = '0 0 8.0';	
				icon2.frame = 0;	
				icon2.alpha = 0.001;
				icon2.cnt = time;
				//icon2.effects = icon2.effects | EF_NODEPTHTEST;
					
				icon2.weapon = msg;
				icon2.health = dmg;
				
				icon2.think = update_icon;
				icon2.nextthink = time;
			}
			
			if(scorer.icon_time != time) scorer.icon_time = time;
				
}


void() update_armoricon =
{	
	makevectors(self.owner.owner.v_angle);
	self.viewmodelforclient = self.owner;
	
	
	if(self.owner.armorvalue < 200 && self.skin == 1 && self.owner.armor_change ==0)
	{
		self.owner.armor_change =2;
		self.alpha = 0.99;
		self.frame = 1;
	}
	else if(self.owner.armorvalue < 100 && self.skin == 0 && self.owner.armor_change ==0)
	{
		self.owner.armor_change =1;
		self.frame = 1;
		self.alpha = 0.99;
	}
	
	
	if(self.owner.armor_change !=0)
	{
		if (self.owner.armor_change ==1 && self.alpha > 0.01)
		{
			if(self.alpha <0.7) self.frame = 0;
			
			self.skin = 2;
			if(self.alpha > 0.4) self.alpha = self.alpha -0.07;
			else if(self.alpha <= 0.4) self.alpha = self.alpha -0.1;
		}
		else if(self.owner.armor_change ==1 && self.alpha <=0.01)
		{
			self.owner.armor_change =0;
			self.owner.armor_displayed =0;
		}
		
		if (self.owner.armor_change ==2 && self.alpha > 0.6)
		{
			if(self.alpha <0.8) self.frame = 0;
			
			if(self.alpha <0.7) self.skin = 0;
			else if(self.alpha <0.9) self.skin = 4;
			else self.skin = 3;

			self.alpha = self.alpha - 0.025;
		}
		else if(self.owner.armor_change ==2 && self.alpha <=0.6)
		{
			self.frame = 0;
			self.skin = 0;
			self.alpha = 0.8;
			self.owner.armor_change =0;
		}
	}

	else if(self.owner.armor_change ==0)
	{
		if(self.owner.armorvalue >= 200) //2x hit
		{
			self.skin = 1;
			self.alpha = 0.7;
		}
		else if(self.owner.armorvalue >= 100) //1x hit
		{
			self.skin = 0;
			self.alpha = 0.7;
		}
		else if(self.owner.armorvalue < 100)
		{
			self.owner.armor_displayed =0;
			self.owner.armor_change =0;
			self.think = SUB_Remove;
		}
	}
	
	if(self.owner.health <=0)
	{
		self.owner.armor_displayed =0;
		self.owner.armor_change =0;
		self.think = SUB_Remove;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;
	
	if(intermission_running)   //dont show during intermission
	{
		self.think = SUB_Remove;
		self.owner.armor_displayed =0;
		self.owner.armor_change =0;
	}
	
	self.nextthink = time+my_ticrate*3;  //DECEM

}

void() make_armoricon =
{
			if(self.armor_displayed ==0 && self.armorvalue >= 100)
			{
				self.armor_displayed =1;
				local entity icon;
		
				icon = spawn ();
		
				icon.owner = self;
				icon.movetype = MOVETYPE_NOCLIP;
				icon.solid = SOLID_NOT;
		
				icon.touch = SUB_Null;
				icon.classname = "armoricon";
				setmodel (icon, "mdl/armor_icon.mdl");		
				setsize (icon, 0, 0);	
			
			
				local vector a = '0 -146.8 70';
				setorigin(icon, a);

			
	
				icon.frame = 0;	
				icon.alpha = 0.7;
			
				icon.think = update_armoricon;
				icon.nextthink = time;
			}
							
}



void() update_reticule =
{	
	makevectors(self.owner.owner.v_angle);
	self.viewmodelforclient = self.owner;
	
	local float RECHARGE_r = 21;   //cooldown time
	if(mapname == "tut1") RECHARGE_r = 2;
	
	local float RECHARGE = 18;
	if(mapname == "tut1") RECHARGE = 2;
	
	
	if(!(self.owner.player_flag & PF_ITEM_RUNE2_FLAG) && !(self.owner.player_flag & PF_ITEM_RUNE3_FLAG))
	{
		if((time - self.owner.shield_recharge_time < RECHARGE && self.owner.shield_recharge_time != 0) && (time - self.owner.mag_recharge_time < RECHARGE_r && self.owner.mag_recharge_time != 0)) self.skin = 0;
		else if((time - self.owner.shield_recharge_time > RECHARGE || self.owner.shield_recharge_time == 0) && (time - self.owner.mag_recharge_time > RECHARGE_r || self.owner.mag_recharge_time == 0)) self.skin = 1;
		else if((time - self.owner.shield_recharge_time > RECHARGE || self.owner.shield_recharge_time == 0) && self.owner.mag_recharge_time != 0) self.skin = 3;
		else if((time - self.owner.mag_recharge_time > RECHARGE_r || self.owner.mag_recharge_time == 0) && self.owner.shield_recharge_time != 0) self.skin = 2;
	}
	else if(self.owner.player_flag & PF_ITEM_RUNE2_FLAG)
	{
		if((time - self.owner.shield_recharge_time < RECHARGE && self.owner.shield_recharge_time != 0)) self.skin = 0;
		else if((time - self.owner.shield_recharge_time > RECHARGE || self.owner.shield_recharge_time == 0)) self.skin = 3;

	}
	else if(self.owner.player_flag & PF_ITEM_RUNE3_FLAG)
	{
		if((time - self.owner.mag_recharge_time < RECHARGE_r && self.owner.mag_recharge_time != 0)) self.skin = 0;
		else if((time - self.owner.mag_recharge_time > RECHARGE_r || self.owner.mag_recharge_time == 0)) self.skin = 2;
	}
	

	
	//if(self.skin ==0) self.alpha = 0.10;
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	else if (self.owner.style & STYLE_OBSERVER) self.alpha =0.001;  
	else self.alpha =0.18;  
	
	if(intermission_running)   //dont show during intermission
	{
		self.think = SUB_Remove;
		self.owner.reticule_displayed =0;
	}
	
	self.nextthink = time+my_ticrate*3;  //DECEM

}

void() make_reticule =
{
			if(self.reticule_displayed ==0)
			{
				self.reticule_displayed =1;
				local entity icon;
		
				icon = spawn ();
		
				icon.owner = self;
				icon.movetype = MOVETYPE_NOCLIP;
				icon.solid = SOLID_NOT;
		
				icon.touch = SUB_Null;
				icon.classname = "reticule";
				setmodel (icon, "mdl/reticule.mdl");		
				setsize (icon, 0, 0);	
			
				local vector a = '0 0 0';
				setorigin(icon, a);
	
				icon.frame = 0;	
				icon.alpha = 0.18;
			
				icon.think = update_reticule;
				icon.nextthink = time;
			}
							
}

