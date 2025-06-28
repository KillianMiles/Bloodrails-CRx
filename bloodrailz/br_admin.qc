
//  R E Q U E S T  S E T  M O D E
//
//  Request to change to the mode indicated by 'newmode':
//
//      0   -   normal
//      1   -   practice
//      2   -   pub ctf
//      3   -   match ctf
//      4   -   pub tdm
//      5   -   match tdm

void () admin_request_set_mode =
{
    self.use = SUB_Null;
    if (self.finaldest_z > 0)
    {
        local float newmode = self.finaldest_z - 1;
        local string mode;
        mode = strings_get_mode(newmode);
        if (newmode == utils_get_mode())
        {
            if (self == world)
                cprint3("Already in ", mode, " mode\n");
            else
                sprint3(self, "Already in ", mode, " mode\n");
            return;
        }

        if ((crx_playmode & MATCH_MODE) &&
            (crx_state & STATE_TIMER_STARTED))
        {
            if (self == world)
                cprint("Cannot change mode while match is in progress\n");
            else
                sprint(self, "Timer has started; cannot change mode\n");
            return;
        }

  if (newmode > 5)                          //per buck
        {
            sprint(self, "Invalid selection.\n");
            return;
        }


        // Do it right away if we're an administrator, otherwise vote
        if (self.style & STYLE_ADMINISTRATOR)
        {
            request_mode = newmode;
            admin_set_mode();
        }
        else if (crx_playmode & MODE_VOTE)
        {
            if (vote_init("change mode to ", mode, admin_set_mode))
            {
                request_mode = newmode;
                vote_yes();
            }
        }
        else
            sprint(self, "Mode voting has been disabled\n");
    }
    else
    {
        sprint(self, "Canceled\n");
    }
};

void () admin_set_dm1 =
{
	localcmd("deathmatch 1\n");
	announce("deathmatch changed to 1");
};

void () admin_set_dm3 =
{
	localcmd("deathmatch 3\n");
	announce("deathmatch changed to 3");
};

///////////////////////////////////////////////////////////////////////////////////////////////////////

void () admin_set_physics =
{
	if (crx_server_physics == 3)
	{
		cvar_set("sys_ticrate", ".016666667");
		announce("60Hz tic enabled");
	}
	
	else if (crx_server_physics == 2)
	{
		cvar_set("sys_ticrate", "0.01388889");
		announce("72Hz tic enabled");
	}
	else if (crx_server_physics == 1)
	{
		cvar_set("sys_ticrate", ".015625");
		announce("64Hz tic enabled");
	}
	else
	{
		cvar_set("sys_ticrate", ".016666667");
		announce("60Hz tic enabled");
	}
};

void () admin_toggle_physics =
{
	crx_server_physics = crx_request_physics;
	admin_set_physics();
};


////////////////// START SHUFFLE TEAMS///////////////////////////////////////////////////

void () admin_shuffle_teams =
{
    Shuffle_Teams();
};


void () admin_request_shuffle_teams =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & STYLE_ADMINISTRATOR)
        {
		Shuffle_Teams();
		bprint("Shuffle teams\n");
		cprint("Shuffle teams\n");
	}
        
	else
	{
		if (vote_init("Shuffle ", " teams", admin_shuffle_teams)) 	vote_yes();
	}
};



void () admin_rebalance_teams =
{
	Rebalance_Teams();
};


void () admin_request_rebalance_teams =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        {
		Rebalance_Teams();
		bprint("Rebalance teams\n");
		cprint("Rebalance teams\n");
	}
        
    else
    {
        if (vote_init("Re-balance ", " teams", admin_rebalance_teams))		vote_yes();
    }
};





////////  SETHOOK  ///////////////////////////////////////////////////////////////////////////////////////////////



void () admin_enable_hook =
{
	if (!(self.items & IT_HOOK))
	{
		self.items = self.items | IT_HOOK;
	}
};

void () admin_disable_hook =
{
    if (self.items & IT_HOOK)
    {
        UnHookPlayer();
        self.items = self.items - IT_HOOK;
        self.hook_out = FALSE;
    }
};


void () admin_set_hook =
{
    if (crx_playmode & MODE_NO_HOOK)
    {
        utils_do_players(admin_enable_hook);
        announce("Hook enabled");
        crx_playmode = crx_playmode - MODE_NO_HOOK;
    }
    else
    {
        utils_do_players(admin_disable_hook);
        announce("Hook disabled");
        crx_playmode = crx_playmode | MODE_NO_HOOK;
    }
    utils_set_cvar("samelevel", crx_playmode);
};


void () admin_request_set_hook =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        admin_set_hook();
    else
    {
        local string newstate;
    
        if (crx_playmode & MODE_NO_HOOK)
            newstate = "enable";
        else
            newstate = "disable";
    
        if (vote_init(newstate, " hook", admin_set_hook))
            vote_yes();
    }
};



////////// SETRUNES ///////////////////////////////////////////////////////////////////////////////////////////////////////



void () admin_set_runes =
{
    if (!(crx_playmode & MODE_RUNES))
    {
		local entity stspawn;
		stspawn = spawn();
		stspawn.nextthink = time + 0.5;
		stspawn.think = rune_spawn_start;

        bprint("Runes enabled\n");
        cprint("Runes enabled\n");
        crx_playmode = crx_playmode | MODE_RUNES;
    }
    else
    {
		utils_do_players(rune_drop);
		utils_do_item(SUB_Remove, "item_rune");
        bprint("Runes disabled\n");
        cprint("Runes disabled\n");
        crx_playmode = crx_playmode - MODE_RUNES;
    }
    utils_set_cvar("samelevel", crx_playmode);
};

void () admin_request_set_runes =
{
    // Do it right away if we're an administrator, otherwise vote

    if (self.style & STYLE_ADMINISTRATOR)
        admin_set_runes();
    else
    {
        local string newstate;
    
        if (!(crx_playmode & MODE_RUNES))
            newstate = "enable";
        else
            newstate = "disable";
    
        if (vote_init(newstate, " runes", admin_set_runes))
            vote_yes();
    }
};






////// SET ARMOR ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//  S E T  A R M O R
//
//  Enable/disable ARMOR.
//
void () admin_set_armor =
{
    if (crx_playmode & MODE_NO_ARMOR)
    {
        utils_do_item(SUB_regen, "item_armor1"); 
        utils_do_item(SUB_regen, "item_armor2");
        utils_do_item(SUB_regen, "item_armorInv");    //?
        bprint("Armor enabled\n");
        cprint("Armor enabled\n");
        crx_playmode = crx_playmode - MODE_NO_ARMOR;
    }
    else
    {
        utils_do_item(admin_disable_item, "item_armor1"); 
        utils_do_item(admin_disable_item, "item_armor2");
        utils_do_item(admin_disable_item, "item_armorInv");    //?
        bprint("Armor disabled\n");
        cprint("Armor disabled\n");
        crx_playmode = crx_playmode | MODE_NO_ARMOR;
    }
    utils_set_cvar("samelevel", crx_playmode);
};

//
//  R E Q U E S T  S E T  A R M O R
//
//  Request to enable/disable Armor.
//
void () admin_request_set_armor =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        admin_set_armor();
    else
    {
        local string newstate;
    
        if (crx_playmode & MODE_NO_ARMOR)
            newstate = "enable";
        else
            newstate = "disable";
    
        if (vote_init(newstate, " ARMOR", admin_set_armor))
            vote_yes();
    }
};





////// SETPOWERUPS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//  S E T  P O W E R U P S
//
//  Enable/disable powerups.
//
void () admin_set_powerups =
{
    if (crx_playmode & MODE_NO_QUAD)
    {
        utils_do_item(SUB_regen, "item_artifact_super_damage");
        utils_do_item(SUB_regen, "item_artifact_invulnerability");
        utils_do_item(SUB_regen, "item_artifact_invisibility");
        
        bprint("Power-ups enabled\n");
        cprint("Power-ups enabled\n");
        crx_playmode = crx_playmode - MODE_NO_QUAD;
    }
    else
    {
        utils_do_item(admin_disable_item, "item_artifact_super_damage");
        utils_do_item(admin_disable_item, "item_artifact_invulnerability");
        utils_do_item(admin_disable_item, "item_artifact_invisibility");
        
        bprint("Power-ups disabled\n");
        cprint("Power-ups disabled\n");
        crx_playmode = crx_playmode | MODE_NO_QUAD;
    }
    utils_set_cvar("samelevel", crx_playmode);
};


//  Request to enable/disable all powerups
//
void () admin_request_set_powerups =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        admin_set_powerups();
    else
    {
        local string newstate;
    
        if (crx_playmode & MODE_NO_QUAD)
            newstate = "enable";
        else
            newstate = "disable";
    
        if (vote_init(newstate, " power-ups", admin_set_powerups))
            vote_yes();
    }
};






//////// SETATX ///////////////////////////////////////////////////////////////////////////////////////////////////////////////


//  S E T  Air to Air mode
//
//  Enable/disable Air to Surface/Air mode.
//
void () admin_set_atx =
{
    
    if (!(crx_playmode & MODE_NO_PENT))
    {
        cvar_set ("sv_gravity", "650");
        announce("ATX mode enabled");
        crx_playmode = crx_playmode | MODE_NO_PENT;
    }
    else
    {
        cvar_set ("sv_gravity", "800");
        announce("ATX mode disabled");
        crx_playmode = crx_playmode - MODE_NO_PENT;
    }
    utils_set_cvar("samelevel", crx_playmode);
};

//
//  R E Q U E S T  SET ATX MODE
//
//  Request to enable/disable ATX mode.
//
void () admin_request_set_atx =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        admin_set_atx();
    else
    {
        local string newstate;
    
        if (crx_playmode & MODE_NO_PENT)
            newstate = "enable";
        else
            newstate = "disable";
    
        if (vote_init(newstate, " ATX mode", admin_set_atx))
            vote_yes();
    }
};







///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//SPAWN WITH 100 ARMOR - ONLY THROUGH SETMODE2 MENU

void () admin_enable_100 =                                  //spawns with 100 armor
{
	if (!(self.items & IT_ARMOR3))
	{
		self.items = self.items | IT_ARMOR3;
		self.armorvalue = 100;
	}
};

void () admin_disable_100 =
{
	if (self.items & IT_ARMOR3)
	{
		self.armorvalue = 0;
		self.items = self.items - IT_ARMOR3;
     
	}
};







///////////////////////////////////////////////////////////////////////////////////////////////////////



//FULLBRIGHT SKINS - ONLY THROUGH SETMODE2 MENU

void () admin_enable_fullbright =                                 
{
/*
local float rand;
rand = random();

        if(rand<0.2) self.skin = 5;
        else if(rand<0.4) self.skin = 6;
        else if(rand<0.6) self.skin = 7;
        else if(rand<=0.8) self.skin = 8;
        else if(rand<=0.8) self.skin = 9;
        */
};

void () admin_disable_fullbright =
{
	
return;
};



void () admin_set_fullbright =
{

    if (!(crx_playmode & CLASSIC_MODE))
    {
        utils_do_players(admin_enable_fullbright);
        announce("classic instagib enabled");
        crx_playmode = crx_playmode | CLASSIC_MODE;
    }
    else
    {
        utils_do_players(admin_disable_fullbright);
        announce("classic instagib disabled");
        crx_playmode = crx_playmode - CLASSIC_MODE;
    }
    utils_set_cvar("samelevel", crx_playmode);
};


void () admin_request_set_fullbright =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        admin_set_fullbright();
    else
    {
        local string newstate;
    
        if (crx_playmode & CLASSIC_MODE)
            newstate = "enable";
        else
            newstate = "disable";
    
        if (vote_init(newstate, " 200 armor spawn", admin_set_fullbright))
            vote_yes();
    }
};



///////////////////////////////////////////////////////////////////////////////////////////////////////


//FEATURE DISABLED

//  S E T  AIRWALK
//
//  Enable/disable AIRWALK mode
//
void () admin_set_airwalk =
{
    
    if (!(crx_playmode & MODE_NO_RING))
    {
        announce("Airwalk mode enabled");
        crx_playmode = crx_playmode | MODE_NO_RING;
    }
    else
    {
        announce("Airwalk mode disabled");
        crx_playmode = crx_playmode - MODE_NO_RING;
    }
    utils_set_cvar("samelevel", crx_playmode);
};





//
void () admin_request_set_airwalk =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        admin_set_airwalk();
    else
    {
        local string newstate;
    
        if (crx_playmode & MODE_NO_RING)
            newstate = "enable";
        else
            newstate = "disable";
    
        if (vote_init(newstate, " airwalk mode", admin_set_airwalk))
            vote_yes();
    }
};



///////////////////////////////////////////////////////////////////////////////////////////////////////



//
//  R E Q U E S T  S E T  M O D E
//
//  Request to change to the mode indicated by 'newmode':
//
//      1   -   deathmatch 1
//      2   -   plasma hook rune
//      3   -   deathmatch 3 (weaponstay)
//      4   -   Projectile mode
//      5   -   set qe physics
//      6   -   set nq physics
//      7   -   set qw physics
//
void () admin_request_set_mode2 =
{
    self.use = SUB_Null;
    if (self.finaldest_z > 0)
    {
        local float newmode = self.finaldest_z;
        local string mode = "";

        if ((crx_playmode & MATCH_MODE) &&
            (crx_state & STATE_TIMER_STARTED))
        {
            if (self == world)
                cprint("Cannot change mode while match is in progress\n");
            else
                sprint(self, "Timer has started; cannot change mode\n");
            return;
        }

        if (!(self.style & STYLE_ADMINISTRATOR) && newmode > 4)
            return;

        void () dofunc = SUB_Null;
        if (newmode == 1 && self.style & STYLE_ADMINISTRATOR)
        {
             if (!(crx_playmode & MODE_NO_SHIELD))
		{
			announce("Pulse Shield disabled");
			crx_playmode = crx_playmode | MODE_NO_SHIELD;
		}
		else
		{
			announce("Pulse Shield enabled");
			crx_playmode = crx_playmode - MODE_NO_SHIELD;
		}
          
          
		utils_set_cvar("samelevel", crx_playmode);
        }
        else if (newmode == 2 && self.style & STYLE_ADMINISTRATOR)
        {
            if (!(crx_playmode & MODE_NO_THROWABLES))
		{
			announce("Throwable rune effects disabled");
			crx_playmode = crx_playmode | MODE_NO_THROWABLES;
		}
		else
		{
			announce("Throwable rune effects enabled");
			crx_playmode = crx_playmode - MODE_NO_THROWABLES;
		}
          
          
		utils_set_cvar("samelevel", crx_playmode);
        }
        else if (newmode == 3 && self.style & STYLE_ADMINISTRATOR)
        {
              if (!(crx_playmode & MODE_NO_SPAWN_PROTECT))
		{
			announce("Spawn protection disabled");
			crx_playmode = crx_playmode | MODE_NO_SPAWN_PROTECT;
		}
		else
		{
			announce("Spawn protection enabled");
			crx_playmode = crx_playmode - MODE_NO_SPAWN_PROTECT;
		}
          
          
		utils_set_cvar("samelevel", crx_playmode);
        }
        else if (newmode == 4)
        {
       
		if (!(crx_playmode & MODE_PROJECTILES))
		{
			announce("Projectile mode enabled");
			crx_playmode = crx_playmode | MODE_PROJECTILES;
		}
		else
		{
			announce("Projectile mode disabled");
			crx_playmode = crx_playmode - MODE_PROJECTILES;
		}
          
          
		utils_set_cvar("samelevel", crx_playmode); 
        }
        else if (newmode == 5)
        {
            dofunc = admin_toggle_physics;
            mode = "enable 60Hz tic";    //
            crx_request_physics = 0;
        }
        else if (newmode == 6)
        {
   
            dofunc = admin_toggle_physics;
            mode = "enable 64Hz tic";
            crx_request_physics = 1;
        }
        else if (newmode == 7)
        {
           if (!(crx_playmode & MODE_NOAMMO))
		{
			announce("Limited ammo disabled");
			crx_playmode = crx_playmode | MODE_NOAMMO;
			
		}
		else
		{
			announce("Limited ammo enabled");
			crx_playmode = crx_playmode - MODE_NOAMMO;
		}
          
          
		utils_set_cvar("samelevel", crx_playmode); 
        }
        else if (newmode == 8)
        {
		if (!(crx_playmode & MODE_WRAITH))
		{
			announce("Ghost mode enabled");
			crx_playmode = crx_playmode | MODE_WRAITH;
		}
		else
		{
			announce("Ghost mode disabled");
			crx_playmode = crx_playmode - MODE_WRAITH;
		}
          
          
		utils_set_cvar("samelevel", crx_playmode); 
        }
        
           else if (newmode == 9)
        {
	if (!(crx_playmode & CLASSIC_MODE))
		{
			announce("Classic instagib enabled");
			crx_playmode = crx_playmode | CLASSIC_MODE;
			if(!(crx_playmode & MODE_NOAMMO)) crx_playmode = crx_playmode | MODE_NOAMMO;
			if(!(crx_playmode & MODE_NO_SHIELD)) crx_playmode = crx_playmode | MODE_NO_SHIELD;
			
			utils_do_item(admin_disable_item, "item_armor1"); 
			utils_do_item(admin_disable_item, "item_armor2");
			utils_do_item(admin_disable_item, "item_armorInv");    //?
			if(!(crx_playmode & MODE_NO_ARMOR)) crx_playmode = crx_playmode | MODE_NO_ARMOR;
			
			utils_do_players(rune_drop);
			utils_do_item(SUB_Remove, "item_rune");
			if(crx_playmode & MODE_RUNES) crx_playmode = crx_playmode - MODE_RUNES;
		}
		else
		{
			announce("Classic instagib disabled");
			crx_playmode = crx_playmode - CLASSIC_MODE;
			if(crx_playmode & MODE_NOAMMO) crx_playmode = crx_playmode - MODE_NOAMMO;
			if(crx_playmode & MODE_NO_SHIELD) crx_playmode = crx_playmode - MODE_NO_SHIELD;
			
			 utils_do_item(SUB_regen, "item_armor1"); 
			utils_do_item(SUB_regen, "item_armor2");
			utils_do_item(SUB_regen, "item_armorInv");    //?
			if(crx_playmode & MODE_NO_ARMOR) crx_playmode = crx_playmode - MODE_NO_ARMOR;
			
			local entity stspawn;
			stspawn = spawn();
			stspawn.nextthink = time + 0.5;
			stspawn.think = rune_spawn_start;
			if(!(crx_playmode & MODE_RUNES)) crx_playmode = crx_playmode | MODE_RUNES;
		}
		
		
		utils_set_cvar("samelevel", crx_playmode); 

        }

        if (dofunc != SUB_Null)
        {
            if (self.style & STYLE_ADMINISTRATOR)
            {
                dofunc();
            }
            else if (crx_playmode & MODE_VOTE)
            {
                if (vote_init("", mode, dofunc))
                {
                    request_mode = newmode;
                    vote_yes();
                }
            }
            else
                sprint(self, "Mode voting has been disabled\n");
        }
    }
    else
    {
        sprint(self, "Canceled\n");
    }
};

void (float modenum) admin_show_modes =
{
    if (modenum == 0)
    {
        sprint(self, "1: Normal FFA\n");
        sprint(self, "2: BloodRace\n");
        sprint(self, "3: CTF - public\n");
        sprint(self, "4: CTF - match\n");
        sprint(self, "5: TDM - public\n");
        sprint(self, "6: TDM - match\n");
   
        sprint(self, "0: Cancel Mode Change\n");
        sprint(self, "\n");
        sprint(self, "Enter the mode number to change to:\n");
        
    }
    else
    {
        sprint(self, "1: pulse shield toggle\n");
        sprint(self, "2: throwable rune effects toggle\n");
        sprint(self, "3: spawn protection toggle\n");
        sprint(self, "4: projectile mode\n");
        sprint(self, "5: QE  (FTE)\n");
        sprint(self, "6: NQ  (FTE)\n");
        sprint(self, "7: Limited ammo\n");
        sprint(self, "8: Ghost mode\n");
        sprint(self, "9: classic instagib\n");
        sprint(self, "0: Cancel Mode Change\n");
        sprint(self, "\n");
        sprint(self, "Enter the mode number to set or toggle:\n");
    }
};

void () admin_init_set_mode =
{
    admin_show_modes(0);
    self.use = admin_request_set_mode;
};

void () admin_init_set_mode2 =
{
    admin_show_modes(1);
    self.use = admin_request_set_mode2;
};


