/////////  HUD  ///////////////////////////////////////////////////////////////////////////////////////////////////////////



void() update_rhud =
{
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	setorigin(self, '0 0.59 0');
	
	if(self.owner.rail_HUD ==2)
	{
		setmodel (self, "progs/hud_r1.mdl");
		self.rail_HUD = time;
		self.owner.rail_HUD =1;
	}
	
	if(time - self.rail_HUD > 0.13)
	{
			setmodel (self, "progs/hud_r.mdl");
	}
	
			

	self.alpha = 0.8;
    
	if(time - self.owner.mag_recharge_time  < 1.1) self.skin = 0;
	else if(time - self.owner.mag_recharge_time  < 2.2) self.skin = 1;
	else if(time - self.owner.mag_recharge_time  < 3.3) self.skin = 2;
	else if(time - self.owner.mag_recharge_time  < 4.4) self.skin = 3;
	else if(time - self.owner.mag_recharge_time  < 5.5) self.skin = 4;
	else if(time - self.owner.mag_recharge_time  < 6.6) self.skin = 5;
	else if(time - self.owner.mag_recharge_time  < 7.7) self.skin = 6;
	else if(time - self.owner.mag_recharge_time  < 8.8) self.skin = 7;
	else if(time - self.owner.mag_recharge_time  < 9.9) self.skin = 8;
	else if(time - self.owner.mag_recharge_time  < 11) self.skin = 9;
	else if(time - self.owner.mag_recharge_time  >= 11) self.skin = 10;
	
	if(self.owner.mag_recharge_time == 0) self.skin = 10;
	
	if(intermission_running)
	{
		self.alpha =0.05;
	}
	
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if(self.owner.oflags & OBSERVER_FLY) self.alpha =0.001;  
	
	if ((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.items2 & IT2_SIGIL2)) self.skin = 0; //DECEM no sidewinder with Power
	
	//self.nextthink = time + 0.08;
	self.nextthink = time + my_ticrate*25;  //DECEM
}

void() update_bolt_sym =
{
	self.viewmodelforclient = self.owner;
	setorigin(self, '0 1.58 0');
	self.alpha = 0.8;
	
	if(intermission_running)
	{
		self.alpha =0.02;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if(self.owner.oflags & OBSERVER_FLY) self.alpha =0.001;  
	 
	//self.nextthink = time + 0.2;
	self.nextthink = time + my_ticrate*49;  //DECEM
}

void() Rail_HUD =  
{
	if(self.rail_HUD == 0)
	{
		self.rail_HUD = 1;
		local entity r_hud;
		r_hud = spawn();
		setmodel (r_hud, "progs/hud_r.mdl");
		r_hud.skin = 0;

		setorigin(r_hud, '0 0 0');
		r_hud.movetype = MOVETYPE_NOCLIP;
		r_hud.solid = SOLID_NOT;
		r_hud.classname = "r_hud";
		setsize (r_hud, 0,0);
		r_hud.owner = self;
		r_hud.nextthink = time + 0.05;
		r_hud.think = update_rhud;
		
		
		local entity r_hud1;
		r_hud1 = spawn();
		setmodel (r_hud1, "progs/hud_bolt_sym.mdl");
		r_hud1.skin = 0;

		setorigin(r_hud1, '0 0 0');
		r_hud1.movetype = MOVETYPE_NOCLIP;
		r_hud1.solid = SOLID_NOT;
		r_hud1.classname = "r_hud1";
		setsize (r_hud1, 0,0);
		r_hud1.owner = self;
		r_hud1.nextthink = time + 0.05;
		r_hud1.think = update_bolt_sym;
	}
    
}



void() update_shud =
{

	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	setorigin(self, '0 0.59 0');
	
	if(self.owner.shield_HUD ==2)
	{
		setmodel (self, "progs/hud_s1.mdl");
		self.shield_HUD = time;
		self.owner.shield_HUD =1;
	}
	
	if(time - self.shield_HUD > 0.13)
	{
			setmodel (self, "progs/hud_s.mdl");
	}
	
	self.alpha = 0.8;
	
	
	if(time - self.owner.shield_time  < 1.3) self.skin = 0;
	else if(time - self.owner.shield_time  < 2.6) self.skin = 1;
	else if(time - self.owner.shield_time  < 3.9) self.skin = 2;
	else if(time - self.owner.shield_time  < 5.2) self.skin = 3;
	else if(time - self.owner.shield_time  < 6.5) self.skin = 4;
	else if(time - self.owner.shield_time  < 7.8) self.skin = 5;
	else if(time - self.owner.shield_time  < 9.1) self.skin = 6;
	else if(time - self.owner.shield_time  < 10.4) self.skin = 7;
	else if(time - self.owner.shield_time  < 11.7) self.skin = 8;
	else if(time - self.owner.shield_time  < 13) self.skin = 9;
	else if(time - self.owner.shield_time  >= 13) self.skin = 10;
	
	if(self.owner.shield_time == 0) self.skin = 10;
	
	if(intermission_running)
	{
		self.alpha =0.01;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if(self.owner.oflags & OBSERVER_FLY) self.alpha =0.001;  
	
	if ((self.owner.player_flag & PF_ITEM_RUNE_MASK) && (self.owner.items2 & IT2_SIGIL3)) self.skin = 0; //DECEM no shield with haste
	
	//self.nextthink = time + 0.08;
	self.nextthink = time + my_ticrate*27;  //DECEM
	
}


void() Shield_HUD =  
{
	if(self.shield_HUD == 0)
	{
		self.shield_HUD = 1;
		local entity s_hud;
		s_hud = spawn();
		setmodel (s_hud, "progs/hud_s.mdl");
		s_hud.skin = 0;

		setorigin(s_hud, '0 0 0');
		s_hud.movetype = MOVETYPE_NOCLIP;
		s_hud.solid = SOLID_NOT;
		s_hud.classname = "s_hud";
		//s_hud.effects = s_hud.effects | EF_NODEPTHTEST;
		setsize (s_hud, 0,0);
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
	setorigin(self, '0 0 0');
	
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
	
	if (!(elohim_playmode & CLANRING_CTF_MODE) && !(elohim_playmode & DM_PUBLIC_MODE) && !(elohim_playmode & ELOHIM_MATCH_MODE))
	{
		self.think = SUB_Remove;
		self.ctfhud = 0;
	}


	if(intermission_running)
	{
		setorigin(self, '0 0 0'+ '-45 165 165');
		self.skin = 0;
	}
		
	if (elohim_playmode & DM_PUBLIC_MODE || elohim_playmode & ELOHIM_MATCH_MODE) self.skin = 0;
		
		
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	
	//self.nextthink = time + 0.12;
	self.nextthink = time + my_ticrate*13;  //DECEM
}



void() Flag_Status =
{

	if ((elohim_playmode & CLANRING_CTF_MODE || elohim_playmode & DM_PUBLIC_MODE || elohim_playmode & ELOHIM_MATCH_MODE) && self.ctfhud == 0)

	{
		self.ctfhud = 1;
		local entity flagstatus;
		flagstatus = spawn(); 
		setmodel (flagstatus, "progs/flag_status.mdl");

		setorigin(flagstatus, '0 0 0');
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
	setorigin(self, '0 0 0');
	
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
		setmodel (haveflag, "progs/flag_hud.mdl");
		
		haveflag.skin = 1;
		//self.effects = EF_RED;
		if (self.height == elohim_team1) 
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













void() update_You_Have_Rune =
{

	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	setorigin(self, '595 475 -330');
	
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
		
		if 	((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE1_FLAG)) setmodel (haverune, "progs/br_rune1b.mdl");
		else if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE2_FLAG)) setmodel (haverune, "progs/br_rune2b.mdl");
		else if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE3_FLAG)) setmodel (haverune, "progs/br_rune3b.mdl");
		else if ((self.player_flag & PF_ITEM_RUNE_MASK) && (self.player_flag & PF_ITEM_RUNE4_FLAG)) setmodel (haverune, "progs/br_rune4b.mdl");
	

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
	if (!(elohim_playmode & CLANRING_CTF_MODE) && !(elohim_playmode & DM_PUBLIC_MODE) && !(elohim_playmode & ELOHIM_MATCH_MODE))
	{
		self.think = SUB_Remove;
		self.owner.flagscores_red = 0;
	}
	
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	if(self.weapon == 1) setorigin(self, '0 -0.4 5');
	if(self.weapon == 2) setorigin(self, '0 3.1 5');
	if(self.weapon == 3) setorigin(self, '0 6.6 5');
	
	//elohim_teamfrags2 = 395;
	
	if(elohim_teamfrags2 < 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = 10;
	}
	
	if(elohim_teamfrags2/10 < 1 || elohim_teamfrags2 == 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = elohim_teamfrags2;
	}
	
	else if(elohim_teamfrags2/10 >= 1 && elohim_teamfrags2/100 < 1) 
	{
		if(self.weapon == 1)
		{
			self.skin = elohim_teamfrags2 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = (elohim_teamfrags2 - (elohim_teamfrags2 % 10))/10;
		}
		if(self.weapon == 3) self.skin = 10;
	}
	
	else if (elohim_teamfrags2/100 >= 1)
	{
		if(self.weapon == 1)
		{
			self.skin = elohim_teamfrags2 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = ((elohim_teamfrags2 - (elohim_teamfrags2 % 10))/10) % 10;
		}
		if(self.weapon == 3) 
		{	
			local float tens = (elohim_teamfrags2 - (elohim_teamfrags2 % 10)) /10;
			self.skin = (tens - (tens % 10)) /10;
		}
	
	}
	
	
	if(intermission_running)
	{
		if(self.weapon == 1) setorigin(self, '0 -0.4 5'+ '-40 165 161');
		if(self.weapon == 2) setorigin(self, '0 3.1 5' + '-40 165 161');
		if(self.weapon == 3) setorigin(self, '0 6.6 5' + '-40 165 161');
	}
	
	self.alpha = 0.9;
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD

	//self.nextthink = time + 0.1;
	self.nextthink = time + my_ticrate*24;  //DECEM

}




void() make_jumbo_blue =
{
	if ((elohim_playmode & CLANRING_CTF_MODE || elohim_playmode & DM_PUBLIC_MODE || elohim_playmode & ELOHIM_MATCH_MODE) && self.flagscores_blue == 0)
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
		setmodel (prj, "progs/hud_digits_blue.mdl");		
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
	if (!(elohim_playmode & CLANRING_CTF_MODE) && !(elohim_playmode & DM_PUBLIC_MODE) && !(elohim_playmode & ELOHIM_MATCH_MODE))
	{
		self.think = SUB_Remove;
		self.owner.flagscores_red = 0;
	}
	
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	if(self.weapon == 1) setorigin(self, '0 11.7 5');
	if(self.weapon == 2) setorigin(self, '0 15.2 5');
	if(self.weapon == 3) setorigin(self, '0 18.7 5');
	
	//elohim_teamfrags1 = 395;
	
	if(elohim_teamfrags1 < 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = 10;
	}
	
	if(elohim_teamfrags1/10 < 1 || elohim_teamfrags1 == 0) 
	{
		if(self.weapon == 3) self.skin = 10;
		if(self.weapon == 2) self.skin = 10;
		if(self.weapon == 1) self.skin = elohim_teamfrags1;
	}
	
	else if(elohim_teamfrags1/10 >= 1 && elohim_teamfrags1/100 < 1) 
	{
		if(self.weapon == 1)
		{
			self.skin = elohim_teamfrags1 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = (elohim_teamfrags1 - (elohim_teamfrags1 % 10))/10;
		}
		if(self.weapon == 3) self.skin = 10;
	}
	
	else if (elohim_teamfrags1/100 >= 1)
	{
		if(self.weapon == 1)
		{
			self.skin = elohim_teamfrags1 % 10;
		}
		if(self.weapon == 2) 
		{	
			self.skin = ((elohim_teamfrags1 - (elohim_teamfrags1 % 10))/10) % 10;
		}
		if(self.weapon == 3) 
		{	
			local float tens = (elohim_teamfrags1 - (elohim_teamfrags1 % 10)) /10;
			self.skin = (tens - (tens % 10)) /10;
		}
	
	}
	
	if(intermission_running)
	{
		if(self.weapon == 1) setorigin(self, '0 11.7 5' + '-40 165 161');
		if(self.weapon == 2) setorigin(self, '0 15.2 5' + '-40 165 161');
		if(self.weapon == 3) setorigin(self, '0 18.7 5' + '-40 165 161');
	}	
	
	self.alpha = 0.9;
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD

	//self.nextthink = time + 0.1;
	self.nextthink = time + my_ticrate*22;  //DECEM
}




void() make_jumbo_red =
{
	if ((elohim_playmode & CLANRING_CTF_MODE || elohim_playmode & DM_PUBLIC_MODE || elohim_playmode & ELOHIM_MATCH_MODE) && self.flagscores_red == 0)
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
		setmodel (prj, "progs/hud_digits_red.mdl");		
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
	if (!(self.owner.player_flag & PF_OVERLAY))
	{
		self.think = SUB_Remove;
	}
	
	
	makevectors(self.owner.owner.v_angle);
    
	self.viewmodelforclient = self.owner;
	if(self.weapon == 1) setorigin(self, '-40 290 37');
	if(self.weapon == 2) setorigin(self, '-40 290 46');
	if(self.weapon == 3) setorigin(self, '-40 290 55');
	if(self.weapon == 4) setorigin(self, '-40 290 64');
	if(self.weapon == 5) setorigin(self, '-40 290 55');
	if(self.weapon == 6) setorigin(self, '-40 290 73');
	
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
		if (!(elohim_playmode & ELOHIM_WRAITH) || self.owner.wraith == 0)
		{
			if(!self.owner.button0) self.skin = 12;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_HOOK) self.skin = 13;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_RAILGUN && self.owner.button0) self.skin = 14;
			else if(self.owner.hook_out == 1 && self.owner.weapon == IT_AXE && self.owner.button0) self.skin = 15;
			else if(self.owner.hook_out == 0 && self.owner.weapon == IT_RAILGUN && self.owner.button0) self.skin = 16;
			else if(self.owner.hook_out == 0 && self.owner.weapon == IT_AXE && self.owner.button0) self.skin = 17;
		}
		else if ((elohim_playmode & ELOHIM_WRAITH) && self.owner.wraith == 1)
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
		else if (self.owner.turn_speed >= 17 && self.owner.turn_speed < 22) self.skin =20;
		
		else if (self.owner.turn_speed <= -3 && self.owner.turn_speed > -10) self.skin =21;
		else if (self.owner.turn_speed <= -10 && self.owner.turn_speed > -17) self.skin =22;
		else if (self.owner.turn_speed <= -17 && self.owner.turn_speed > -22) self.skin =23;
	}
	
	if(self.weapon == 6)
	{
		if (elohim_playmode & ELOHIM_WRAITH && self.owner.wraith == 1) self.skin =25;
		else self.skin =24;
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if(self.owner.oflags & OBSERVER_FLY) self.alpha =0.001;  

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
		setmodel (prj, "progs/press_move2.mdl");		
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
	
	
	if(vlen(self.owner.origin - self.owner.flickEnt.origin) < 1000) setmodel (self, "progs/marker.mdl");
	else if(vlen(self.owner.origin - self.owner.flickEnt.origin) < 3000) setmodel (self, "progs/marker150.mdl");
	
	else if(vlen(self.owner.origin - self.owner.flickEnt.origin) < 9000) 
	{
		setmodel (self, "progs/marker250.mdl");
		setorigin(self, self.owner.flickEnt.origin + dir*(200));
	}
		
	
	if (self.owner.height == elohim_team1) self.skin = 6;   //red
	else if (self.owner.height == elohim_team2) self.skin = 4;   //blue
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
		
		sound (self, CHAN_AUTO, "weapons/lockon.wav", 1, ATTN_NORM);

		
		self.marker_up =1;
		local entity marker;
		marker = spawn();
		setmodel (marker, "progs/marker.mdl");
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
	
	if (elohim_playmode & ELOHIM_NOAMMO)
	{
		self.think = SUB_Remove;
	}
	
	
	
	
	if(self.weapon ==2)
	{
		setorigin(self, '-44 55 45.8');
	
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

	}
	else if (self.weapon ==9)
	{
		setorigin(self, '-42 51.5 52.5');
		makevectors(self.owner.owner.v_angle);
		self.viewmodelforclient = self.owner;
		
		self.skin =12;
		if(self.owner.ammo_slugs >0) self.alpha =0.0001;
		else self.alpha = 0.59;
		
		if(time - self.owner.shot_time < 0.25 && self.owner.ammo_slugs <= 0) 
		{
			self.skin = 13;
		}
	}
	
	if(self.owner.player_flag & PF_HUD) self.alpha =0.001;   //NOHUD
	if(self.owner.oflags & OBSERVER_FLY) self.alpha =0.001;   

	//self.nextthink = time + 0.07;
	self.nextthink = time + my_ticrate*21;  //DECEM
}




void() make_rail_ammo =
{
	if(self.ammo_slugs < 10 && elohim_playmode & ELOHIM_NOAMMO) self.ammo_slugs = 999;
	
	if(elohim_playmode & ELOHIM_NOAMMO) self.rail_ammo_displayed = 0;
	
	if(self.rail_ammo_displayed == 0 && !(elohim_playmode & ELOHIM_NOAMMO))
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
		setmodel (railammo, "progs/rail_ammo.mdl");		
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
		setmodel (noammo, "progs/rail_ammo.mdl");		
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
    if (self.hudspace > 7)
        return;

    local float cur_sec;
    local float cur_min;

	local vector xy_velocity;                //Bloodrails - speedometer
	xy_velocity = self.velocity;
	local float current_speed;
	current_speed = floor(vlen(xy_velocity));

        local float dist;                        //Bloodrails - altimeter
	local vector start, end;
	local string altimeter;
		
	start 	= self.origin;
	end 	= start;
	end_z 	= self.origin_z - 2048;
	
	traceline (start, end, TRUE, self);		
	
	dist = (self.absmin_z - trace_endpos_z);
	if(pointcontents(trace_endpos) == CONTENT_SKY) self.is_over_sky =1;
	else self.is_over_sky =0;

	if (dist < 1)	dist = 0;
		
	self.airborn_pos = floor(dist);
	
	altimeter = ftos(self.airborn_pos);
	

    if (mode_is_arena())
    {
        if (elohim_playmode & AIR_ARENA_MODE && boss.state == CA_MATCH_PLAYING)
        {
            cur_min = floor(boss.count / 60);
            cur_sec = boss.count - (cur_min * 60);
        }

        cur_sec = 0;
        cur_min = 0;
    }
    else if (elohim_state & ELOHIM_TIMER_STARTED)
    {
        cur_sec = elohim_match_timer.count;
        cur_min = elohim_match_timer.lip;
    }
    else if (timelimit != 0)
    {
        cur_sec = floor(timelimit - time) % 60;
        cur_min = floor(floor(timelimit - time) / 60);
    }
    else
    {
        cur_sec = floor(time) % 60;
        cur_min = floor(floor(time) / 60);
    }

    // Team scores if a match is in progress
    local string winning_team = "", flag_status = "", rune_status = "", str_time = "", red_score = "", blue_score = "", str_minute = "", str_second = "";
    local float winning_advantage;
    

    str_minute = get_minute_string(cur_min);
    str_second = get_second_string(cur_sec);
    
    pqc_match_time(cur_min, cur_sec);
    
    

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
    local string score_spacing = "";
    //local string score_spacing = "\x11                                        \n";
	//local string spacing_left = "                                        \n";
    // 1234567890 + 40 spaces   => 1234567890123456789012345678901234567890
    // [  Time  ]
    // [Team xxx]
    // R  B-RUNE-

 if (!(elohim_playmode & ELOHIM_PRACTICE_MODE) && ((elohim_state & ELOHIM_TIMER_STARTED) || (mode_is_public() == TRUE)))
    {
        //timer
        str_time = get_time_string(cur_min, cur_sec);

        //winning team and advantage
        if (elohim_teamfrags1 > elohim_teamfrags2)
        {
            winning_advantage = elohim_teamfrags1 - elohim_teamfrags2;
            if (winning_advantage > 99)
                winning_team = "\x10Red  ";
            else if (winning_advantage > 9)
                winning_team = "\x10Red   ";
            else
                winning_team = "\x10Red    ";                    
        }
        else if (elohim_teamfrags1 < elohim_teamfrags2)
        {
            winning_advantage = elohim_teamfrags2 - elohim_teamfrags1;
            if (winning_advantage > 99)
                winning_team = "\x10Blue ";
            else if (winning_advantage > 9)
                winning_team = "\x10Blue  ";
            else
                winning_team = "\x10Blue   ";    
        }
        else
        {
            if (elohim_teamfrags2 == 0)
                winning_team = "\x10        ";
            else
                winning_team = "\x10  Tied  ";
            winning_advantage = 0;
        }

        //flag status
        if (RED_FLAG_TAKEN && !BLUE_FLAG_TAKEN)
        {
            if (cvar("scr_usekfont") == 0) 
            {
                flag_status = "\s                                       \n";
            } 
            else
            {
                flag_status = "                                       \n";
            }
        }
        else if (!RED_FLAG_TAKEN && BLUE_FLAG_TAKEN)
        {
            if (cvar("scr_usekfont") == 0) 
            {
                flag_status = "  \s                                     \n";
            } 
            else 
            {
                flag_status = "                                       \n";
            }
        }
        else if (RED_FLAG_TAKEN && BLUE_FLAG_TAKEN)
        {
            if (cvar("scr_usekfont") == 0) 
            {
                flag_status = "\s                                       \n";
            } 
            else 
            {
                flag_status = "                                       \n";
            }
        }
        else
        {
            flag_status = "                                       \n";
        }

        score_spacing = "\x11";
    }
    else
    {
        str_time = get_time_string(cur_min, cur_sec);
        winning_team = "\x10        ";
        score_spacing = "\x11";
        flag_status = "    ";
    }

    //rune status
    if (self.player_flag & PF_ITEM_RUNE_MASK)
    {
        if (self.player_flag & PF_ITEM_RUNE1_FLAG)
        {
            rune_status = " Plasma hook                          \n\b Fire cloud\b                          \n";
        }
        else if (self.player_flag & PF_ITEM_RUNE2_FLAG)
        {
            rune_status = " Power                          \n\b Explosion\b                          \n";
        }
        else if (self.player_flag & PF_ITEM_RUNE3_FLAG)
        {
            rune_status = " Haste                          \n\b Gravity\b                          \n";
        }
        else if (self.player_flag & PF_ITEM_RUNE4_FLAG)
        {
            rune_status = " Death Aura                          \n\b Repulsor\b                          \n";
        }
        else
        {
            //just in case
            rune_status = "                                              \n"; //
        }
    }
    else
    {
        rune_status = "                                              \n";
    }
		
			local string bracket_spacer;
			if(current_speed >= 1000) bracket_spacer = "\x11                                \n";
			else if(current_speed >= 100) bracket_spacer = " \x11                                \n";
			else if(current_speed >= 10) bracket_spacer = "  \x11                              \n";
			else if(current_speed < 10) bracket_spacer = "   \x11                              \n";
			
	
	if (elohim_playmode & ELOHIM_MATCH_MODE || (mode_is_public() == TRUE))
	{
		if(self.print_killa == 0 && !(self.player_flag & PF_HUD)) centerprint5(self, spacing_top, "  \x10 \svel:", ftos(current_speed), bracket_spacer, rune_status);   //debug?   hud   //9-24-23
	}
	
	else if (elohim_playmode & ELOHIM_PRACTICE_MODE && !(self.player_flag & PF_HUD))
	{
		if(self.racing_on == 1) centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n\x10", utils_get_time(time - chrono_time), "\x11                              \n\x10\svel:", ftos(current_speed), bracket_spacer);   //debug?   hud 
		if(self.racing_on == 0) centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n\x10", utils_get_time(self.my_previous_time), "\x11                              \n\x10\svel:",    ftos(current_speed), bracket_spacer);   //debug?   hud 
	}

	else
	{
		if(self.print_killa == 0 && !(self.player_flag & PF_HUD)) centerprint5(self, spacing_top, rune_status, "VEL:", ftos(current_speed), "                                                      ");
	}
		
	if (self.print_killa == 1 && self.ammo_rockets == 0 && !(elohim_playmode & ELOHIM_PRACTICE_MODE))  //ammo_rockets = killedbyworld
	{
			if (self.dmg_inflictor)  //dmg_inflictor = killedby
			{
				if (self.dmg_inflictor.style & ELOHIM_CONNECTED)
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
		
	if(self.print_killa == 1 && self.ammo_rockets == 1 && !(elohim_playmode & ELOHIM_PRACTICE_MODE)) centerprint(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nkilled by ", "world");    //ammo_rockets = killedbyworld
		
	if(time - self.ammo_cells > 2) self.print_killa = 0; //ammo_cells = print_killa_time
		
	return;
};



