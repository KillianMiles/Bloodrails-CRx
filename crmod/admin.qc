//
// Admin.qc
//
// Administrative functions for the Elohim server mod.
//
// Fields used:
//
// .count           - used for entering password
//
// Written by J.P. Grossman, modified by bucksh0t, modified by kilomiles
//

// function declarations
void () admin_cancel_kick;
void () admin_confirm_kick;
void () admin_do_kick;
void (float warpnum) admin_show_episodes;
void () admin_select_episode;
void () admin_select_episode2;
void () admin_select_episode3;
void () options_start_setting;
float () options_get_mode;

// global variables
string request_mapname;     // Used for requesting a new level
float request_timelimit;    // Used for requesting a new time limit
float request_gibs;         // Used to set gib level
//float request_mode;         // Used to request a new mode
entity kick_target;         // Player to kick

void () stuff_aliases1 =
{
	

	stuffcmd(self, "alias +rail \"impulse 3; +attack\"\n");  
	stuffcmd(self, "alias -rail -attack\n");
    
	stuffcmd(self, "alias +axe \"impulse 1; +attack\"\n");  
	stuffcmd(self, "alias -axe -attack\n");
	
	stuffcmd(self, "alias +dash \"impulse 43; wait; wait; impulse 1; +jump; wait; wait; +attack\"\n");  
	stuffcmd(self, "alias -dash \"impulse 44; -jump; -attack\"\n");  
  
	stuffcmd(self, "alias +hook \"impulse 22; +attack\"\n");       //+hook alias
	stuffcmd(self, "alias -hook -attack\n");
    
	stuffcmd(self, "alias droprune impulse 40\n");


    
    // toggle extended obits
	//stuffcmd(self, "alias obits impulse 211\n");

    // timelimit aliases
    //stuffcmd(self, "alias timelimit5 impulse 215\n");
    stuffcmd(self, "alias timelimit10 impulse 216\n");
    stuffcmd(self, "alias timelimit15 impulse 217\n");
    stuffcmd(self, "alias timelimit20 impulse 218\n");
    stuffcmd(self, "alias timelimit25 impulse 219\n");
    stuffcmd(self, "alias timelimit30 impulse 220\n");

    // fraglimit aliases
    stuffcmd(self, "alias fraglimit50 impulse 252\n");
    stuffcmd(self, "alias fraglimit120 impulse 253\n");
    stuffcmd(self, "alias fraglimit15 impulse 254\n");

    // Rocket Arena max wins
  //  stuffcmd(self, "alias setrounds impulse 251\n");

    // Quad, Pent, Ring, Rune aliases
    stuffcmd(self, "alias setpowerups impulse 221\n");
    stuffcmd(self, "alias setatx impulse 222\n");
    
    stuffcmd(self, "alias setarmor impulse 224\n");      //no armor setting
    stuffcmd(self, "alias setrunes impulse 255\n");
    stuffcmd(self, "alias sethook impulse 209\n");
    stuffcmd(self, "alias setrail impulse 227\n");       //no railgun setting
    
    stuffcmd(self, "alias shuffle impulse 223\n");
    stuffcmd(self, "alias rebalance impulse 226\n");       //spawn with 100 armor
    
    stuffcmd(self, "alias set200 impulse 225\n");       //spawn with 200 armor
  
  

    // playmode aliases
    stuffcmd(self, "alias force impulse 130\n");

    // number aliases
    stuffcmd(self, "alias 0 impulse 230\n");
    stuffcmd(self, "alias 1 impulse 231\n");
    stuffcmd(self, "alias 2 impulse 232\n");
    stuffcmd(self, "alias 3 impulse 233\n");
    stuffcmd(self, "alias 4 impulse 234\n");
    stuffcmd(self, "alias 5 impulse 235\n");
    stuffcmd(self, "alias 6 impulse 236\n");
    stuffcmd(self, "alias 7 impulse 237\n");
    stuffcmd(self, "alias 8 impulse 238\n");
    stuffcmd(self, "alias 9 impulse 239\n");
    stuffcmd(self, "alias 10 impulse 240\n");
    stuffcmd(self, "alias 11 impulse 241\n");
    stuffcmd(self, "alias 12 impulse 242\n");
    stuffcmd(self, "alias 13 impulse 243\n");
    stuffcmd(self, "alias 14 impulse 244\n");
    stuffcmd(self, "alias 15 impulse 245\n");
};

//
//  S E N D  A L I A S E S 1
//
//  Stuffs aliases for votable commands and numbers.
//
void () admin_send_aliases1 =
{
    local entity temp;

    temp = self;
    self = self.owner;

    stuff_aliases1();

    self = temp;
    remove(self);
};

//
//  S E N D  A L I A S E S 2
//
//  Stuffs admin-only aliases into the administrators console.  Called
//  when a player becomes an administrator.
//
void () admin_send_aliases2 =
{
	// Qsmack commands
	stuffcmd(self, "alias qsmack impulse 37\n");

    // kick a player
    stuffcmd(self, "alias kick! impulse 213\n");
    stuffcmd(self, "alias skick impulse 213\n");

    // stop match
    stuffcmd(self, "alias abort impulse 214\n");

    // list ghosts
    stuffcmd(self, "alias ghostlist impulse 212\n");

    // help
    stuffcmd(self, "alias help-admin impulse 200\n");

    // enable/disable mode voting
    stuffcmd(self, "alias modevote impulse 228\n");

    // set options
    //stuffcmd(self, "alias options impulse 229\n");

    // spawn point editing
    stuffcmd(self, "alias nextspawn impulse 246\n");
    stuffcmd(self, "alias makespawn impulse 247\n");
    stuffcmd(self, "alias nextcam impulse 248\n");
    stuffcmd(self, "alias makecam impulse 249\n");
    stuffcmd(self, "alias spot impulse 250\n");
};

//
//  C R E A T E
//
//  Turn 'self' into an administrator.
//
void () admin_create =
{
    self.style = self.style | ELOHIM_ADMINISTRATOR;
    self.use = SUB_Null;
    centerprint(self, "You are now an administrator");
    bprint2(self.netname, " has become an administrator\n");
    cprint3("\"", self.netname, " has become an administrator\"\n");
    admin_send_aliases2();

    if (!(elohim_playmode & ELOHIM_MODE_VOTE))
        elohim_playmode = elohim_playmode | ELOHIM_MODE_VOTE;
};

//
//  E N T E R  C O D E
//
//  Enter another code digit.
//  The digit being entered is stored in self.finaldest_z.
//  The digits that are entered are accumulated by self.count;
//  when self.count == elohim_password the client is made into an
//  administrator.
//
void () admin_enter_code = 
{
    if (self.finaldest_z > 9)
	return;

    self.count = self.count * 10 + self.finaldest_z;
    if (self.count >= 10000000)
    {
        sprint(self, "Invalid code\n");
        self.use = SUB_Null;
        return;
    }
    if (self.count == elohim_password)
        admin_create();
    else
        sprint(self, "Enter the next code digit:\n");
};

//
//  S T A R T  C O D E
//
//  Initiate the admin code sequence.
//
void () admin_start_code =
{
    if (elohim_password < 1000)
	{
    	sprint(self, "Administrator password disabled\n");
	    sprint(self, "Type 'exec crxmod.cfg' in server\n");
    	sprint(self, "console to set password.\n");
	    return;
	}

    if (self.style & ELOHIM_ADMINISTRATOR)
    {
        sprint(self, "You are already an administrator\n");
        return;
    }
    sprint(self, "Enter the first code digit:\n");
    self.count = 0;
    self.use = admin_enter_code;
};

//
//  C H A N G E  L E V E L
//
//  Called when a request to change level passses.  The level name is
//  stored in request_mapname.
//
void () admin_change_level =
{
   /*
    if (request_mapname == "start0")
    {
        serverflags = 0;
        changelevel("start");
    }
    else if (request_mapname == "start1")
    {
        serverflags = 15;
        changelevel("start");
    }
    else
    */
	rune_clear_player_flags();

        changelevel (request_mapname);
};

//
//  R E Q U E S T  C H A N G E  L E V E L
//
//  Called when a player requests a new level.
//
void (float warpnum) admin_request_change_level =
{
    local float level;
    local string newmap;

    self.use = SUB_Null;
    if (elohim_state & ELOHIM_MATCH_STARTED)
    {
        sprint(self, "Cannot change level while match is\nin progress.");
        return;
    }

    level = ((self.warp_episode * 15)-5) + (self.warp_map) + (240 * warpnum);
    newmap = strings_get_mapname(level);

	self.warp_episode=0;
	self.warp_map=0;

    if (newmap == "")
    {
        sprint(self, "No valid map selected.");
        return;
    }

    // Do it right away if we're an administrator, otherwise vote
    if (self.style & ELOHIM_ADMINISTRATOR)
    {
        request_mapname = newmap;
        admin_change_level();
    }
    else if (vote_init("change level to ", newmap, admin_change_level))
    {
        request_mapname = newmap;
        vote_yes();
    }
};

//
//  I N I T  W A R P
//
//  Called to initiate the warp.  The episode is entered first.
//  The level will be entered next; admin_request_change_level will be
//  called when it is.
//
void (float warpnum) admin_init_warp =
{
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change level while match is in progress.\n");
		sprint(self,"Canceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}

	if (!self.warp_episode)
	{
		admin_show_episodes(warpnum);
        if (warpnum == 0)
		    self.use=admin_select_episode;
        /*
        else if (warpnum == 1)
            self.use=admin_select_episode2;
        else
            self.use=admin_select_episode3;
            */
	}

	if (self.warp_map)
	{
		admin_request_change_level(warpnum);
	}
};

void(float episode) admin_show_maps =
{
    if (episode == 1)
    {
        sprint(self, "1: CTF_Takayama\n");
        sprint(self, "2: CTF_Dissocia\n");
        sprint(self, "3: CTF_Bridge\n");
        sprint(self, "4: CTF_Hanghigh\n");
        sprint(self, "5: CTF_Longest1\n");
        sprint(self, "6: CTF_Longest2\n");
        sprint(self, "7: CTF_Teardown\n");
        sprint(self, "8: CTF_Eyesout\n");
        sprint(self, "9: CTF_Relic2\n");
        sprint(self, "10: CTF_Rebirth\n");
        sprint(self, "11: CTF_Edge3\n");
        sprint(self, "12: CTF_Facing\n");
        sprint(self, "13: CTF_Sandstorm\n");
        sprint(self, "14: CTF_Lasertag1\n");
        sprint(self, "15: CTF_Lasertag2\n");
    }
    else if (episode == 2)
    {
        sprint(self, "1: CTF_Spongebob\n");
        sprint(self, "2: CTF_Doglyfe\n");
        sprint(self, "3: CTF_Dogrun\n");
        sprint(self, "4: CTF_Daywalker\n");
        sprint(self, "5: CTF_Volcano\n");
        sprint(self, "6: CTF_Fulcrum\n");
        sprint(self, "7: CTF_Albatross\n");
        sprint(self, "8: CTF_Firestorm\n");
        sprint(self, "9: CTF_Feral\n");
        sprint(self, "10: CTF_Gulch\n");
        sprint(self, "11: -empty-\n");
        sprint(self, "12: -empty-\n");
        sprint(self, "13: -empty-\n");
        sprint(self, "14: -empty-\n");
        sprint(self, "15: -empty-\n");
    }
    else if (episode == 3)
    {
        sprint(self, "1: Storm\n");
	sprint(self, "2: Relic\n");
        sprint(self, "3: Slug\n");
        sprint(self, "4: Widowmakr\n");
        sprint(self, "5: Shiro2\n");
        sprint(self, "6: Barrel\n");
        sprint(self, "7: Longest_yard\n");
        sprint(self, "8: Dranzdm8\n");
        sprint(self, "9: Endif\n");
        sprint(self, "10: Yunroot\n");
        sprint(self, "11: -empty-\n");
        sprint(self, "12: -empty-\n");
        sprint(self, "13: -empty-\n");
        sprint(self, "14: -empty-\n");
        sprint(self, "15: -empty-\n");
    }
    else if (episode == 4)
    {
        sprint(self, "1: race_Valley\n");
        sprint(self, "2: race_Orange\n");
        sprint(self, "3: race_Diss\n");
        sprint(self, "4: -empty-\n");
        sprint(self, "5: -empty-\n");
        sprint(self, "6: -empty-\n");
        sprint(self, "7: -empty-\n");
        sprint(self, "8: -empty-\n");
        sprint(self, "9: -empty-\n");
        sprint(self, "10: -empty-\n");
        sprint(self, "11: -empty-\n");
        sprint(self, "12: -empty-\n");
        sprint(self, "13: -empty-\n");
        sprint(self, "14: -empty-\n");
        sprint(self, "15: -empty-\n");
    }
    else if (episode == 5)
    {
        sprint(self, "1: dm1 - Place of Two Deaths\n");
        sprint(self, "2: dm2 - Claustrophobopolis\n");
        sprint(self, "3: dm3 - The Abandoned Base\n");
        sprint(self, "4: dm4 - The Bad Place\n");
        sprint(self, "5: dm5 - The Cistern\n");
        sprint(self, "6: dm6 - The Dark Zone\n");
        sprint(self, "7: dm7 - The Edge\n");
        sprint(self, "8: dm8 - Acrophobia\n");
        sprint(self, "9: \n");
    }
   
    sprint(self, "0: Cancel Warp\n");
    sprint(self, "\n");
	sprint(self, "Enter the number of the map to warp:\n");
};

void() admin_select_map =
{
	if (!(self.impulse >= 230) && (self.impulse <= 245)) return;

	if ((self.finaldest_z==0)&&(self.warp_map==0))
	{
		sprint(self,"Canceled\n");
		self.use=SUB_Null;
		self.warp_map=0;
		self.warp_episode=0;
	}
	else
	{
		self.use = SUB_Null;
		self.warp_map = self.finaldest_z;
		admin_init_warp(0);
	}
};

void(float episode) admin_show_maps2 =
{
    if (episode == 1)
    {
        sprint(self, "1: ctf1 - McKinley Base\n");
        sprint(self, "2: ctf2 - The Kiln\n");
        sprint(self, "3: ctf3 - DySpHoRiA\n");
        sprint(self, "4: ctf4 - The Forgotten Mines\n");
        sprint(self, "5: ctf5 - Da Ancient War Grounds\n");
        sprint(self, "6: ctf6 - Vertigo\n");
        sprint(self, "7: ctf7 - Tale of Two Cities\n");
        sprint(self, "8: ctf8 - The Strongbox\n");
        sprint(self, "9: ctf9\n");
    }
    else if (episode == 2)
    {
        sprint(self, "1: ctf2m1 - McKinley Station\n");
        sprint(self, "2: ctf2m2 - The Warzone\n");
        sprint(self, "3: ctf2m3 - Spill the Blood\n");
        sprint(self, "4: ctf2m4 - Ruins of NeoMinonk\n");
        sprint(self, "5: ctf2m5 - Disciple War Grounds\n");
        sprint(self, "6: ctf2m6 - The Two Towers\n");
        sprint(self, "7: ctf2m7 - Gloom Castles\n");
        sprint(self, "8: ctf2m8 - Capturephobolis\n");
        sprint(self, "9: ctf_start\n");
    }
    else if (episode == 3)
    {
        sprint(self, "1: ctf3m1 - Remix\n");
        sprint(self, "2: ctf3m2 - Red Alert\n");
        sprint(self, "3: ctf3m3 - Stop the Flow\n");
        sprint(self, "4: ctf3m4 - Nameless Mines\n");
        sprint(self, "5: ctf3m5 - Egyptian Pig Factory\n");
        sprint(self, "6: ctf3m6 - Terra Firma\n");
        sprint(self, "7: ctf3m7 - The Dark Age\n");
        sprint(self, "8: ctf3m8 - The Place of Two Bases\n");
        sprint(self, "9: ctf3m9 - The CHEAT Complex 2\n");
    }
    else if (episode == 4)
    {
        sprint(self, "1: boom\n");
        sprint(self, "2: kaboom\n");
        sprint(self, "3: pound\n");
        sprint(self, "4: pigremix\n");
        sprint(self, "5: mctf1\n");
        sprint(self, "6: rctf1\n");
        sprint(self, "7: rctf2\n");
        sprint(self, "8: rctf4\n");
        sprint(self, "9: rctf5\n");
    }
    else if (episode == 5)
    {
        sprint(self, "1: ctfgold7\n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    else if (episode == 6)
    {
        sprint(self, "1: \n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    else if (episode == 7)
    {
        sprint(self, "1: \n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    else if (episode == 8)
    {
        sprint(self, "1: \n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    else if (episode == 9)
    {
        sprint(self, "1: \n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    sprint(self, "0: Cancel Warp\n");
    sprint(self, "\n");
	sprint(self, "Now, enter the map number to start the warp:\n");
};

void() admin_select_map2 =
{
	if (!(self.impulse >= 230) && (self.impulse <= 245)) return;

	if ((self.finaldest_z==0)&&(self.warp_map==0))
	{
		sprint(self,"Canceled\n");
		self.use=SUB_Null;
		self.warp_map=0;
		self.warp_episode=0;
	}
	else
	{
		self.use = SUB_Null;
		self.warp_map = self.finaldest_z;
		admin_init_warp(1);
	}
};

void(float episode) admin_show_maps3 =
{
    if (episode == 1)
    {
        sprint(self, "1: 23ar-a\n");
        sprint(self, "2: 2pyramid\n");
        sprint(self, "3: 2towers\n");
        sprint(self, "4: arenarg2\n");
        sprint(self, "5: arenarg4\n");
        sprint(self, "6: arenarg5\n");
        sprint(self, "7: arenarg6\n");
        sprint(self, "8: arenax\n");
        sprint(self, "9: arenazap\n");
    }
    else if (episode == 2)
    {
        sprint(self, "1: arendm1a\n");
        sprint(self, "2: arenrg3a\n");
        sprint(self, "3: arma4\n");
        sprint(self, "4: barena1\n");
        sprint(self, "5: basarena\n");
        sprint(self, "6: bbarena2\n");
        sprint(self, "7: bunmoo3\n");
        sprint(self, "8: bunski\n");
        sprint(self, "9: chamber1\n");
    }
    else if (episode == 3)
    {
        sprint(self, "1: crandome\n");
        sprint(self, "2: dm2arena\n");
        sprint(self, "3: dom2_1ra\n");
        sprint(self, "4: egyptra\n");
        sprint(self, "5: football\n");
        sprint(self, "6: gear8\n");
        sprint(self, "7: gnurena\n");
        sprint(self, "8: hill20\n");
        sprint(self, "9: iarena2\n");
    }
    else if (episode == 4)
    {
        sprint(self, "1: id3\n");
        sprint(self, "2: lowgrav\n");
        sprint(self, "3: marena2\n");
        sprint(self, "4: marena3\n");
        sprint(self, "5: marena4\n");
        sprint(self, "6: mayan1\n");
        sprint(self, "7: nilsrar3\n");
        sprint(self, "8: pen2\n");
        sprint(self, "9: pitarena\n");
    }
    else if (episode == 5)
    {
        sprint(self, "1: ptucket\n");
        sprint(self, "2: ra_funkf\n");
        sprint(self, "3: rarena3\n");
        sprint(self, "4: rgarden\n");
        sprint(self, "5: soyarena\n");
        sprint(self, "6: terrain2\n");
        sprint(self, "7: uarena1\n");
        sprint(self, "8: unholy\n");
        sprint(self, "9: xarena3\n");
    }
    else if (episode == 6)
    {
        sprint(self, "1: yard1\n");
        sprint(self, "2: amphi\n");
        sprint(self, "3: povdmm4\n");
        sprint(self, "4: endif\n");
        sprint(self, "5: midair\n");
        sprint(self, "6: midair2\n");
        sprint(self, "7: midair3\n");
        sprint(self, "8: 420bowl_b2\n");
        sprint(self, "9: \n");
    }
    else if (episode == 7)
    {
        sprint(self, "1: \n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    else if (episode == 8)
    {
        sprint(self, "1: \n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    else if (episode == 9)
    {
        sprint(self, "1: \n");
        sprint(self, "2: \n");
        sprint(self, "3: \n");
        sprint(self, "4: \n");
        sprint(self, "5: \n");
        sprint(self, "6: \n");
        sprint(self, "7: \n");
        sprint(self, "8: \n");
        sprint(self, "9: \n");
    }
    sprint(self, "0: Cancel Warp\n");
    sprint(self, "\n");
	sprint(self, "Now, enter the map number to start the warp:\n");
};

void() admin_select_map3 =
{
	if (!(self.impulse >= 230) && (self.impulse <= 245)) return;

	if ((self.finaldest_z==0)&&(self.warp_map==0))
	{
		sprint(self,"Canceled\n");
		self.use=SUB_Null;
		self.warp_map=0;
		self.warp_episode=0;
	}
	else
	{
		self.use = SUB_Null;
		self.warp_map = self.finaldest_z;
		admin_init_warp(2);
	}
};

void (float warpnum) admin_show_episodes =
{
    if (warpnum == 0)
	{
        sprint(self, "1: Bloodrailz Maps CTF 1\n");
        sprint(self, "2: Bloodrailz Maps CTF 2\n");
        sprint(self, "3: Bloodrailz Maps FFA\n");
        sprint(self, "4: Bloodrace Maps\n");
        sprint(self, "5: -empty-\n");
	}

    sprint(self, "0: Cancel Warp\n");
    sprint(self, "\n");
    sprint(self, "Enter the episode number to see available maps:\n");
};

void() admin_select_episode =
{
	if ((self.finaldest_z==0)&&(self.warp_episode==0))
	{
		sprint(self,"Canceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}
	else
	{
		self.warp_episode = self.finaldest_z;
		self.use = admin_select_map;
		admin_show_maps(self.warp_episode);
	}
};

void() admin_select_episode2 =
{
	if ((self.finaldest_z==0)&&(self.warp_episode==0))
	{
		sprint(self,"Canceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}
	else
	{
		self.warp_episode = self.finaldest_z;
		self.use = admin_select_map2;
		admin_show_maps2(self.warp_episode);
	}
};

void() admin_select_episode3 =
{
	if ((self.finaldest_z==0)&&(self.warp_episode==0))
	{
		sprint(self,"Canceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}
	else
	{
		self.warp_episode = self.finaldest_z;
		self.use = admin_select_map3;
		admin_show_maps3(self.warp_episode);
	}
};

//
//  P H A T T E N  P L A Y E R
//
//  Phatten up players when entering practice or CA mode.
//
void () admin_phatten_player =
{
    self.items = IT_AXE | IT_HOOK | IT_RAILGUN | IT_ARMOR3;
    
    self.health = 100;
    self.armorvalue = 200;
    self.ammo_slugs = 999;
};


//
//  S E T  M O D E
//
//  Called when a request to set the mode passes.
//
void () admin_set_mode =
{
    if (elohim_playmode & ELOHIM_MATCH_MODE)
    {
        if (elohim_state & ELOHIM_TIMER_STARTED)
        {
            sprint(self, "Timer has started; cannot change mode\n");
            return;
        }
        elohim_playmode = elohim_playmode - (elohim_playmode & ELOHIM_MATCH_MODE);
    
        // Reset teamplay to 0
        cvar_set("teamplay", "0");
    
        // Get rid of observers
        utils_do_players(observer_end);
    }



    //set new mode
    utils_do_players(rune_drop);
    utils_do_item(SUB_Remove, "item_rune");

    elohim_playmode = elohim_playmode - (elohim_playmode & 
        (RACE_MODE | ELOHIM_MATCH_MODE | CLANRING_CTF_MODE | AIR_ARENA_MODE
            | CLAN_ARENA_MODE | ROCKET_ARENA_MODE | CLANRING_RUNES | ELOHIM_NO_HOOK | DM_PUBLIC_MODE));
   
    if (request_mode == ADMIN_RACE_MODE)
    {
        elohim_playmode = elohim_playmode | RACE_MODE;
        if(!(elohim_playmode & ELOHIM_NO_ARMOR)) elohim_playmode = elohim_playmode | ELOHIM_NO_ARMOR;
        utils_do_players(admin_phatten_player);
        //mapname = "race15";
        utils_set_cvar("timelimit", 0);
        cvar_set("hostname", ADMIN_RACE_MODE_STRING);
        //stuffcmd(self,"impulse 120; wait;wait;wait;wait;wait;impulse 120\n");
    }


    else if (request_mode == ADMIN_DM_PUBLIC_MODE)
    {
        elohim_maxsize = 16;
        elohim_teamsize1 = 0;
        elohim_teamsize2 = 0;
        elohim_playmode = elohim_playmode | DM_PUBLIC_MODE;
        //mapname = "mapname";
        utils_set_cvar("timelimit", elohim_timelimit);
        cvar_set("hostname", ADMIN_DM_PUBLIC_MODE_STRING);
    }

   
    else if (request_mode == ADMIN_MATCH_MODE)
    {
        elohim_playmode = elohim_playmode | ELOHIM_MATCH_MODE;
         elohim_playmode = elohim_playmode | CLANRING_RUNES;   //021824
        //mapname = "mapname";
        utils_set_cvar("timelimit", elohim_timelimit);
        cvar_set("hostname", ADMIN_MATCH_MODE_STRING);
    }
    else if (request_mode == ADMIN_CTF_MATCH_MODE)
    {
        elohim_playmode = elohim_playmode | ELOHIM_MATCH_MODE | CLANRING_CTF_MODE;
        elohim_playmode = elohim_playmode | CLANRING_RUNES;   //021824
        //mapname = "mapname";
        utils_set_cvar("timelimit", elohim_timelimit);
        cvar_set("hostname", ADMIN_CTF_MATCH_MODE_STRING);
    }
    else if (request_mode == ADMIN_CTF_PUBLIC_MODE)
    {
        elohim_maxsize = 16;
        elohim_teamsize1 = 0;
        elohim_teamsize2 = 0;
        elohim_playmode = elohim_playmode | CLANRING_CTF_MODE;   
        if (!(elohim_playmode & CLANRING_RUNES))
            elohim_playmode = elohim_playmode | CLANRING_RUNES;
        //mapname = "mapname";
        utils_set_cvar("timelimit", elohim_timelimit);
        cvar_set("hostname", ADMIN_CTF_PUBLIC_MODE_STRING);
    }
    else
    {
        //elohim_playmode = elohim_playmode | ELOHIM_NO_HOOK;
        //mapname = "mapname";
        utils_set_cvar("timelimit", 0);
        cvar_set("hostname", ADMIN_NORMAL_MODE_STRING);
    }

    gameover = 1;

    local string mode;
    mode = strings_get_mode(request_mode);
    bprint3("playmode set to '", mode, "'\n");
    cprint3("\"playmode set to '", mode, "'\"\n");
    utils_set_cvar("samelevel", elohim_playmode);
    changelevel(mapname);
};




//
//  S E T  T E A M P L A Y
//
//  Set teamplay to 'value' if playmode is not 'match'.
//
void (float value) admin_set_teamplay =
{
    if (elohim_playmode & ELOHIM_MATCH_MODE)
    {
        sprint(self, "Teamplay cannot be set in match mode.\n");
        return;
    }
    elohim_set_teamplay(value);
};

//
//  S E T  T I M E L I M I T
//
//  Called when a request to change the timelimit passes.  The new
//  timelimit is stored in the global variable request_timelimit.
//
void () admin_set_timelimit =
{
    local string temp;

    elohim_timelimit = request_timelimit;
    temp = ftos(elohim_timelimit);
    bprint3("Match length changed to ", temp, " minutes\n");
    if (elohim_playmode & ELOHIM_MATCH_MODE || (mode_is_public()))
        match_show_timelimit();
};

//
//  R E Q U E S T  S E T  T I M E L I M I T
//
//  Called when a player requests a new timelimit.
//
void (float newlimit) admin_request_set_timelimit =
{
    local string temp;

    if (elohim_state & ELOHIM_MATCH_STARTED)
    {
        sprint(self, "Cannot change time limit while match\nis in progress.");
        return;
    }

    // Do it right away if we're an administrator, otherwise vote
    if (self.style & ELOHIM_ADMINISTRATOR)
    {
        request_timelimit = newlimit;
        admin_set_timelimit();
    }
    else
    {
        temp = strings_ftos(newlimit);
        if (vote_init("change match length to ", temp, admin_set_timelimit))
        {
            request_timelimit = newlimit;
            vote_yes();
        }
    }
};

//
//  R E Q U E S T  S E T  O V E R T I M E
//
//  Currently this is only called from Options.qc
//
void (float overtime) admin_request_set_overtime =
{
    elohim_overtime = overtime;

    if (overtime)
    {
        local string temp;
        local string szplural;
        temp = ftos(overtime);
        szplural = strings_szplural(overtime);
        bprint4("Overtime changed to ", temp, " minute", szplural);
    }
    else
        bprint("Overtime disabled\n");

    utils_set_cvar("v_kicktime", overtime);
};

//
//  S E T  G I B S
//
//  Called when a request to set gibs passes.  The new setting for gibs
//  is specified by the global variable request_gibs.
//
void () admin_set_gibs =
{
    elohim_playmode = elohim_playmode -
	(elohim_playmode & (ELOHIM_NO_GIBS | ELOHIM_LOW_GIBS));
    if (request_gibs == 0)
    {
        elohim_playmode = elohim_playmode | ELOHIM_NO_GIBS;
        bprint("Gibs disabled\n");
        cprint("Gibs disabled\n");
    }
    else if (request_gibs == 1)
    {
        elohim_playmode = elohim_playmode | ELOHIM_LOW_GIBS;
        bprint("Gibs set to 'low'\n");
        cprint("\"Gibs set to 'low'\"\n");
    }
    else
	{
		bprint("Gibs set to 'high'\n");
		cprint("\"Gibs set to 'high'\"\n");
	}
    utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  G I B S
//
//  Called when a player requests a new setting for gibs.
//
void (float gibs) admin_request_set_gibs =
{
    if (elohim_playmode & ELOHIM_NO_GIBS)
    {
        if (gibs == 0)
        {
			if (self == world)
				cprint("Gibs already disabled\n");
			else
				sprint(self, "Gibs already disabled\n");
            return;
        }
    }
    else if (elohim_playmode & ELOHIM_LOW_GIBS)
    {
        if (gibs == 1)
        {
			if (self == world)
				cprint("\"Gibs already set to 'low'\"\n");
			else
				sprint(self, "Gibs already set to 'low'\n");
            return;
        }
    }
    else
    {
        if (gibs == 2)
        {
			if (self == world)
		        cprint("\"Gibs already set to 'high'\"\n");
			else
	            sprint(self, "Gibs already set to 'high'\n");
            return;
        }
    }

    // Do it right away if we're an administrator, otherwise vote
    if (self.style & ELOHIM_ADMINISTRATOR)
    {
        request_gibs = gibs;
        admin_set_gibs();
    }
    else
    {
        local string gibmode;
        if (gibs == 0)
            gibmode = "'disabled'";
        else if (gibs == 1)
            gibmode = "'low'";
        else
            gibmode = "'high'";
        if (vote_init("change gibs to ", gibmode, admin_set_gibs))
        {
            request_gibs = gibs;
            vote_yes();
        }
    }
};

//
//  D I S A B L E  I T E M
//
//  Used to disable quad/pent/ring.  Called with the item as 'self'.
//
void () admin_disable_item =
{
	self.model = string_null;
	self.solid = SOLID_NOT;
    self.nextthink = -1;
};




//
//  S E T  O B I T S
//
//  Enable/disable extended obituaries.
//
void () admin_set_obits =
{
    if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
    {
        bprint("Extended obituaries disabled\n");
        cprint("Extended obituaries disabled\n");
        elohim_playmode = elohim_playmode - ELOHIM_EXTENDED_OBITS;
    }
    else
    {
        bprint("Extended obituaries enabled\n");
        cprint("Extended obituaries enabled\n");
        elohim_playmode = elohim_playmode | ELOHIM_EXTENDED_OBITS;
    }
    utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  O B I T S
//
//  Request to enable/disable extended obituaries.
//
void () admin_request_set_obits =
{
    // Do it right away if we're an administrator, otherwise vote
    if (self.style & ELOHIM_ADMINISTRATOR)
        admin_set_obits();
    else
    {
        local string newstate;
    
        if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
            newstate = "disable";
        else
            newstate = "enable";
    
        if (vote_init(newstate, " extended obituaries", admin_set_obits))
            vote_yes();
    }
};

//
//  S E T  M O D E  V O T E
//
//  Enable/disable mode voting
//
void () admin_set_mode_vote =
{
    if (elohim_playmode & ELOHIM_MODE_VOTE)
    {
        bprint("Mode voting disabled\n");
        cprint("Mode voting disabled\n");
        elohim_playmode = elohim_playmode - ELOHIM_MODE_VOTE;
    }
    else
    {
        bprint("Mode voting enabled\n");
        cprint("Mode voting enabled\n");
        elohim_playmode = elohim_playmode | ELOHIM_MODE_VOTE;
    }
    utils_set_cvar("samelevel", elohim_playmode);
};




//
//  P R I N T  K I C K  C H O I C E
//
//  Display a choice of players to kick.
//
void () admin_print_kick_choice =
{
    local entity client;
    local float index;
    local string num;

    // Print the choice
    sprint(self, "Which player do you want to kick?\n");
    sprint(self, " 0  cancel\n");
    index = 1;
    while (index <= 15)
    {
        client = array_get_kick(index);
        if (client)
        {
            num = strings_ftos(index);
            sprint5(self, " ", num, " ", client.netname, "\n");
        }
        index = index + 1;
    }
};

//
//  S T A R T  K I C K
//
//  Get a list of players and ask the admin which one to kick.
//
void () admin_start_kick =
{
    if (elohim_state & ELOHIM_KICKING)
    {
        sprint(self, "There is already a kick in progress\n");
        return;
    }

    // Get the list of players
    local entity client;
    local float index;
    index = 1;
    client = find(world, classname, "player");
    while (client)
    {
        if (!(client.style & ELOHIM_ADMINISTRATOR) &&
            (client.style & ELOHIM_CONNECTED))
        {
            array_set_kick(index, client);
            index = index + 1;
        }
        client = find(client, classname, "player");
    }
    if (index == 1)
    {
        sprint(self, "There is no-one to kick\n");
        return;
    }
    while (index <= 15)
    {
        array_set_kick(index, world);
        index = index + 1;
    }

    // Print the choice
    admin_print_kick_choice();

    // Set up the kick
    local entity kick_timeout;
    self.use = admin_confirm_kick;
    kick_timeout = spawn();
    kick_timeout.movetarget = self;
    kick_timeout.classname = "elohim_kick_timeout";
    kick_timeout.think = admin_cancel_kick;
    kick_timeout.nextthink = time + 10;
    elohim_state = elohim_state | ELOHIM_KICKING;
};

//
//  C O N F I R M  K I C K
//
//  Ask for confirmation to kick the selected player.  The index of
//  the player to be kicked is stored in self.finaldest_z.
//
void () admin_confirm_kick =
{
    if (self.finaldest_z == 0)
    {
        // Cancel the kick
        local entity oself;
        oself = self;
        self = find(world, classname, "elohim_kick_timeout");
        admin_cancel_kick();
        self = oself;
        return;
    }

    kick_target = array_get_kick(self.finaldest_z);

    // sanity checks
    if (!kick_target)
    {
        sprint(self, "Invalid\n");
        admin_print_kick_choice();
        return;
    }
    if (kick_target.style & ELOHIM_ADMINISTRATOR)
    {
        sprint2(self, kick_target.netname, " is an administrator\n");
        admin_print_kick_choice();
        return;
    }

    // ask for confirmation
    sprint3(self, "kick ", kick_target.netname, "?\n");
    self.style = self.style | ELOHIM_KICK_CONFIRM;
};

//
//  C O N F I R M  K I C K  R E S P O N S E
//
//  Called when the administrator enters 'yes' or 'no' in
//  response to the confirmation request.
//  
void (float fDoKick) admin_confirm_kick_response =
{
    if (fDoKick)
        admin_do_kick();
    else
    {
        // Cancel the kick
        local entity oself;
        oself = self;
        self = find(world, classname, "elohim_kick_timeout");
        admin_cancel_kick();
        self = oself;
    }
};

//
//  D O  K I C K
//
//  Kick a player once the admin has confirmed.
//
void () admin_do_kick =
{
    //return;
    bprint2(kick_target.netname, " kicked by administrator\n");
    cprint3("\"", kick_target.netname, " kicked by administrator\"\n");
    elohim_kick_player(kick_target);

    // Clean up
    self.use = SUB_Null;
    kick_target = find(world, classname, "elohim_kick_timeout");
    remove(kick_target);
    elohim_state = elohim_state - ELOHIM_KICKING;
    self.style = self.style - ELOHIM_KICK_CONFIRM;
};

//
//  C A N C E L  K I C K
//
//  Called when the kick times out or is cancelled by the admin.
//
void () admin_cancel_kick =
{
    sprint(self.movetarget, "Kick cancelled\n");
    self.movetarget.use = SUB_Null;
    remove(self);
    elohim_state = elohim_state - ELOHIM_KICKING;
    self.movetarget.style = self.movetarget.style -
        (self.movetarget.style & ELOHIM_KICK_CONFIRM);
};

//
//  L I S T  G H O S T S
//
void () admin_list_ghosts =
{
    local entity e;
    e = find(world, classname, "elohim_ghost");
    if (!e)
    {
        sprint(self, "There are no ghosts\n");
        return;
    }
    sprint(self, "\ncode|   team   |frags|     name\n");
    sprint(self, "\n----|----------|-----|---------\n");
    while (e)
    {
        local string num, szTeam, pad;
        local float frag;
        num = ftos(e.count);
        sprint2(self, num, " |");
    
        szTeam = strings_get_teamname2(e.height);
        if (e.owner.owner == e)
            frag = e.owner.frags;
        else
            frag = e.frags;
        if (frag < -99)
            pad = "|";
        else if (frag < -9)
            pad = "| ";
        else if (frag < 0)
            pad = "|  ";
        else if (frag < 10)
            pad = "|   ";
        else if (frag < 100)
            pad = "|  ";
        else
            pad = "| ";
        num = ftos(frag);
        if (e.owner.owner == e)
            sprint6(self, szTeam, pad, num, " |", e.owner.netname, "\n");
        else
            sprint4(self, szTeam, pad, num, " | Disconnected\n");
    
        e = find(e, classname, "elohim_ghost");
    }
    sprint(self, "\n");
};

//
//  S H O W  S P O T  I N F O
//
//  Display the current position and angle.
//
void () admin_show_spot_info =
{
    local string temp;

    temp = vtos(self.origin + '0 0 22');
    sprint3(self, " origin: ", temp, "\n");
    temp = vtos(self.v_angle);
    sprint3(self, " angle: ", temp, "\n");
};

//
//  N E X T  S P A W N  P O I N T
//
//  If the admin is in walk or fly observer mode, move him to the
//  next spawn point.
//
void () admin_next_spawn_point =
{
    if (!(self.style & ELOHIM_OBSERVER) ||
        !(self.oflags & (OBSERVER_WALK | OBSERVER_FLY)))
    {
        sprint(self, "You must be in walk or fly mode\n");
        return;
    }
    utils_do_item(match_add_spawn, "elohim_start_point");
    self.owner = find(self.owner, classname, "info_player_deathmatch");
    if (!self.owner)
    {
        self.owner = find(self.owner, classname, "info_player_deathmatch");
        if (!self.owner)
        {
            sprint(self, "No spawn points found\n");
            return;
        }
    }
    utils_do_item(match_remove_start, "info_player_deathmatch");

	// setorigin will not actually set the origin if a bad origin is given.
	// Therefore, we first set the origin manually to ensure that the spot info
	// is displayed correctly.
	//
    self.origin = self.owner.origin;
    admin_show_spot_info();
    setorigin(self, self.owner.origin + '0 0 1');
    self.angles = self.owner.angles;
	self.fixangle = TRUE;           // turn this way immediately
    self.velocity = '0 0 0';
    makevectors(self.angles);
    observer_spawn_tfog(self.origin + v_forward*20);
};

//
//  M A K E  S P A W N  P O I N T
//
//  If the admin is in walk observer mode, standing on the ground and
//  not underwater, then create a new deathmatch spawn point at his
//  location.
//
void () admin_make_spawn_point =
{
    if (!(self.style & ELOHIM_OBSERVER) || !(self.oflags & OBSERVER_WALK))
    {
        sprint(self, "You must be in walk mode\n");
        return;
    }
    if (!(self.flags & FL_ONGROUND))
    {
        sprint(self, "You must be on the ground\n");
        return;
    }
    if (self.waterlevel)
    {
        sprint(self, "Cannot create underwater spawn point\n");
        return;
    }
    if (elohim_num_spawns >= 20)
    {
        sprint(self, "Max. number of spawn points reached\n");
        return;
    }

    self.owner = spawn();
    self.owner.owner = world;
    self.owner.solid = SOLID_NOT;
    self.owner.movetype = MOVETYPE_NONE;
    self.owner.takedamage = DAMAGE_NO;
    self.owner.fixangle = TRUE;
    self.owner.classname = "info_player_deathmatch";
    self.angles_x = 0;
    self.angles_z = 0;
    self.fixangle = TRUE;
    self.owner.angles = self.angles;
    self.owner.origin = self.origin;
    elohim_num_spawns = elohim_num_spawns + 1;
    sprint(self, "Spawn point created\n");
    admin_show_spot_info();
};

//
//  N E X T  C A M E R A
//
//  If the admin is in fly observer mode, move him to the next camera.
//
void () admin_next_camera=
{
    if (!(self.style & ELOHIM_OBSERVER) || !(self.oflags & OBSERVER_FLY))
    {
        sprint(self, "You must be in fly mode\n");
        return;
    }
    self.owner = find(self.owner, classname, "elohim_camera");
    if (!self.owner)
    {
        self.owner = find(self.owner, classname, "elohim_camera");
        if (!self.owner)
        {
            sprint(self, "No cameras found\n");
            return;
        }
    }

	// setorigin will not actually set the origin if a bad origin is given.
	// Therefore, we first set the origin manually to ensure that the spot info
	// is displayed correctly.
	//
    self.origin = self.owner.origin - '0 0 22';
    self.angles = self.v_angle = self.owner.angles;
    admin_show_spot_info();
    setorigin(self, self.owner.origin);
	self.fixangle = TRUE;           // turn this way immediately
    self.velocity = '0 0 0';
};

//
//  M A K E  C A M E R A
//
//  If the admin is in fly observer mode, create a new camera at his
//  location.
//
void () admin_make_camera =
{
    if (!(self.style & ELOHIM_OBSERVER) || !(self.oflags & OBSERVER_FLY))
    {
        sprint(self, "You must be in fly mode\n");
        return;
    }
    if (elohim_num_cameras >= 20)
    {
        sprint(self, "Max. number of cameras reached\n");
        return;
    }

    self.owner = spawn();
    self.owner.owner = world;
    self.owner.solid = SOLID_NOT;
    self.owner.movetype = MOVETYPE_NONE;
    self.owner.takedamage = DAMAGE_NO;
    self.owner.fixangle = TRUE;
    self.owner.classname = "elohim_camera";
    self.v_angle_z = 0;
    self.angles = self.v_angle;
    self.fixangle = TRUE;
    self.owner.angles = self.v_angle;
    self.owner.origin = self.origin + '0 0 22';
    elohim_num_cameras = elohim_num_cameras + 1;
    sprint(self, "Camera created\n");
    admin_show_spot_info();
};

//
//  S E T  F R A G  L I M I T
//
void (float pFraglimit) admin_set_fraglimit =
{
    if (fraglimit != pFraglimit)
        elohim_set_fraglimit(pFraglimit);
    else
        sprint3(self, "Fraglimit is already ", ftos(pFraglimit), "\n");
};


//
//  H E L P
//
void () admin_help =
{
    sprint(self, "Admin only commands:\n");
    sprint(self, " kick!    - kick a player\n");
    sprint(self, " modevote - enable/disable mode votes\n");
    sprint(self, " abort - abort current match\n");
    sprint(self, " ghostlist  - view list of ghosts\n");
	sprint(self, " setcharge  - ban practice discharges\n");
    sprint(self, " spot       - show location/angles\n");
    sprint(self, " nextspawn  - go to next spawn point\n");
    sprint(self, " makespawn  - add spawn point\n");
    sprint(self, " nextcam    - go to next camera\n");
    sprint(self, " makecam    - add camera\n");
};

//
//  I M P U L S E
//
//  Called by elohim_impulse in Elohim.qc
//
void () admin_impulse =
{
    // votable commands
    if (self.impulse >= 190 && self.impulse <= 192)
    {
        self.finaldest_z    = 0;
        self.warp_episode   = 0;
        self.warp_map       = 0;
        admin_init_warp(self.impulse - 190);
    }
    else if (self.impulse >= 193 && self.impulse <= 198)
    {
        //reserved for more warp menus
    }
    else if (self.impulse == 199)
    {
        stuff_aliases1();
    }
    else if (self.impulse == 208)
        admin_init_set_mode();
    else if (self.impulse == 209)
        admin_request_set_hook();
    else if (self.impulse == 210)
    {
        admin_init_set_mode2();
    }
    else if (self.impulse == 214)
    {
			if (self.style & ELOHIM_ADMINISTRATOR)	
			{
				match_end();
			}
			else
			{
				if (vote_init("abort", " match?", match_end))	vote_yes();
			}
    }
    else if (self.impulse == 251) {}
    	
    else if (self.impulse == 255)
		admin_request_set_runes();
    else if (self.impulse == 211)
		admin_request_set_obits();
    else if (self.impulse >= 215 && self.impulse <= 220)
        admin_request_set_timelimit(5 * (self.impulse - 214));
    else if (self.impulse == 221)
        admin_request_set_powerups();
    else if (self.impulse == 222)
        admin_request_set_atx();
    else if (self.impulse == 223)
        admin_request_shuffle_teams();
    else if (self.impulse == 224)          //armor mode
        admin_set_armor();     
   else if (self.impulse == 226)           //set 100 armor
        admin_request_rebalance_teams();
        

    else if (self.impulse >= 230 && self.impulse <= 245)
    {
        if (self.use)
        {
            self.finaldest_z = self.impulse - 230;
            self.use();
        }
    }

    if (!(self.style & ELOHIM_ADMINISTRATOR))
        return;

    // admin only commands
	if (self.impulse == 200)
		admin_help();
    else if (self.impulse == 212)
        admin_list_ghosts();
    else if (self.impulse == 213)
        admin_start_kick();

    else if (self.impulse == 228)
        admin_set_mode_vote();
    else if (self.impulse == 229)
    {
        sprint(self, "disabled");
        return;
        //options_start_setting();
    }
    else if (self.impulse == 246)
        admin_next_spawn_point();
    else if (self.impulse == 247)
        admin_make_spawn_point();
    else if (self.impulse == 248)
        admin_next_camera();
    else if (self.impulse == 249)
        admin_make_camera();
    else if (self.impulse == 250)
        admin_show_spot_info();
    else if (self.impulse == 252)
        admin_set_fraglimit(50);
    else if (self.impulse == 253)
        admin_set_fraglimit(120);
    else if (self.impulse == 254)
        admin_set_fraglimit(15);
};

//
//  D I S C O N N E C T  N O T I F Y
//
//  Remove this player from the list of kickable players.
//
void (entity player) admin_disconnect_notify = 
{
    local float index;

    index = 1;
    while (index < 16)
    {
		if (self == array_get_kick(index))
			array_set_kick(index, world);
		index = index + 1;
    }
};