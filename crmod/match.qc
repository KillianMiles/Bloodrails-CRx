// Function declarations
void () SUB_regen;
void () GibPlayer;
void () match_timer_think2;
void () match_enter_ghost_code;
void (entity ghostent) match_restore_ghost;
void() admin_disable_item;

//
//  S H O W  T I M E L I M I T
//
//  Set the console variable 'timelimit' to show relevant match
//  information.
//
void () match_show_timelimit =
{
    local string temp;

    localcmd("timelimit \"");
    if (!(crx_state & STATE_TIMER_STARTED))
    {
        if (crx_state & STATE_MATCH_OVER)
        {
            localcmd("Final Score is ");
            temp = ftos(crx_teamfrags1);
            if (crx_teamfrags1 < 0)
                localcmd("<");
            localcmd(temp);
            if (crx_teamfrags1 < 0)
                localcmd(">");
            localcmd(" - ");
            temp = ftos(crx_teamfrags2);
            if (crx_teamfrags2 < 0)
                localcmd("<");
            localcmd(temp);
            if (crx_teamfrags2 < 0)
                localcmd(">");
            localcmd("\"\n");
        }
        else
        {
            temp = ftos(crx_timelimit);
            localcmd2(temp, " : Waiting for teams\"\n");
        }
    }
    else if (!(crx_state & STATE_MATCH_STARTED))
    {
        temp = ftos(crx_timelimit);
        localcmd2(temp, " : Match Starting\"\n");
    }
    else
    {
        temp = ftos(crx_match_timer.lip);
        localcmd2(temp, "\"\n");
    }
};

//
//  I T E M  R E S E T
//
//  Prevent an item from respawning.
//
void () match_item_reset =
{
    self.nextthink = -1;
};

//
//  I N I T  P L A Y E R
//
//  Initialize a player in match mode and make him an observer.
//
void () match_init_player =
{
    self.style = self.style - (self.style & STYLE_READY);
    self.finaldest_x = time; // So we don't get autokickedd!!
    observer_start();
};

//
//  U N R E A D Y  P L A Y E R
//
void () match_unready_player =
{
    self.style = self.style - (self.style & STYLE_READY);
};

//
//  R E S E T
//
void () match_reset =
{
    // crx_team1 = 4;
    // crx_team2 = 13;
    // crx_team3 = 12;
    // crx_team4 = 3;
    crx_teamsize1 = 0;
    crx_teamsize2 = 0;
    // crx_teamsize3 = 0;
    // crx_teamsize4 = 0;
    crx_matchteams = 0;

    crx_state = crx_state - (crx_state & STATE_MATCH_WAIT);

    // prevent items from respawning
    utils_do_items(match_item_reset);

    // remove all backpacks
    utils_do_item(SUB_Remove, "item_backpack");

    // unready all players
    utils_do_players(match_unready_player);

    // remove all ghosts
    utils_do_item(SUB_Remove, "crx_ghost");

    bprint("No teams present\n");

    if (self.classname == "crx_match_timer")
        remove(self);
};

//
//  G I B  P L A Y E R
//
//  Gib players; set observers to colour 0.  Called at start
//  and end of match.
//
void () match_gib_player =
{
    if (self.style & STYLE_OBSERVER)
        setcolor2(self, 0, 0);
    else if (!(self.style & STYLE_READY))
        observer_start();
    else
    {
        self.health = -99;
        GibPlayer();
        self.deadflag = DEAD_DYING;
        self.think = respawn;
        self.nextthink = time + 1;
        if (crx_state & STATE_MATCH_STARTED)
        {
            //start of match
            self.frags = 0;
            self.dmg_tally = 0;
        }
        else
        {
            // end of match
            self.owner = world;
        }
    }
};

//
//  B P R I N T  S C O R E
//
void () match_bprint_score =
{
    local string score;
    local string teamname;
    local string temp;

    teamname = strings_get_teamname(crx_team1);
    score = ftos(crx_teamfrags1);
    temp = strings_plural(crx_teamfrags1);
    bprint6("The ", teamname, " has ", score, " frag", temp);
    teamname = strings_get_teamname(crx_team2);
    score = ftos(crx_teamfrags2);
    temp = strings_plural(crx_teamfrags2);
    bprint6("The ", teamname, " has ", score, " frag", temp);
};

//
//  M A T C H  B P R I N T  T I M E
//
void () match_bprint_time =
{
    local string temp;

    temp = ftos(crx_match_timer.lip);
    bprint3("Time remaining:  ", temp, ":");
    temp = ftos(crx_match_timer.count);
    if (crx_match_timer.count < 10)
        bprint("0");
    bprint2(temp, "\n");
};

//
//  S P R I N T  S T A T U S
//
//  Print the time remaining and the score.
//
void () match_sprint_status =
{
    local float team1, team2;

    if (crx_state & STATE_MATCH_STARTED)
    {
        team1 = crx_team1;
        team2 = crx_team2;
    }
    else
    {
        if (crx_state & STATE_MATCH_OVER)
        {
            team1 = crx_lastteam1;
            team2 = crx_lastteam2;
        }
        else
        {
            sprint(self, "Match has not started yet\n");
            return;
        }
    }

    if (crx_state & STATE_MATCH_OVER)
        sprint(self, "Match over\n");
    else
    {
        local string temp;
    
        temp = ftos(crx_match_timer.lip);
        sprint3(self, "Time remaining:  ", temp, ":");
        temp = ftos(crx_match_timer.count);
        if (crx_match_timer.count < 10)
            sprint(self, "0");
        sprint2(self, temp, "\n");
    }

    local string score;
    local string teamname;
    local string temp2;

    teamname = strings_get_teamname(team1);
    score = ftos(crx_teamfrags1);
    temp2 = strings_plural(crx_teamfrags1);
    sprint6(self, "The ", teamname, " has ", score, " frag", temp2);
    teamname = strings_get_teamname(team2);
    score = ftos(crx_teamfrags2);
    temp2 = strings_plural(crx_teamfrags2);
    sprint6(self, "The ", teamname, " has ", score, " frag", temp2);
};

//
//  E N D
//
//  Called to end the match when the timer runs out or an administrator
//  aborts the match.
//
void () match_end =
{
    local string teamname;
    float aborted = 0;

    if (self.classname == "crx_match_timer")
    {
        // Regular match end (timer ran out)
        if ((crx_teamfrags1 == crx_teamfrags2) && crx_overtime)
        {
            // go into overtime
            bprint("Match tied - Overtime!!\n");
			self.lip = crx_overtime;
			self.count = 0;
            self.think = match_timer_think2;
            match_timer_think2();
            return;
        }
    }
    else
    {
        // Administrator aborted the match
        if (!(crx_state & STATE_MATCH_STARTED))
            return;
    
        if (crx_state & STATE_MATCH_PAUSED) // if administrator aborts match
        {
            WriteByte(MSG_ALL, SVC_CENTERPRINT);
            WriteShort(MSG_ALL,1);
            WriteString(MSG_ALL, " ");
            crx_state = crx_state - STATE_MATCH_PAUSED;
        }

        aborted = 1;
    }

    if (crx_state - STATE_MATCH_STARTED)
        crx_state = crx_state - STATE_MATCH_STARTED;
    if (crx_state & STATE_TIMER_STARTED)
        crx_state = crx_state - STATE_TIMER_STARTED;
    crx_state = crx_state | STATE_MATCH_OVER | STATE_MATCH_WAIT;

    utils_do_players(match_gib_player); 
    match_show_timelimit();       
    bprint("The match is over\n");
    match_bprint_score();
    teamname = strings_get_teamname(crx_winning_team);

    if (crx_teamfrags1 == crx_teamfrags2)
        bprint("Tie game!\n");
    else
        bprint3("The ", teamname, " has won\n");

    // remember teams so that 'score' will continue to work
    crx_lastteam1 = crx_team1;
    crx_lastteam2 = crx_team2;

    crx_match_timer.think = match_reset;
    crx_match_timer.nextthink = time + 5;

	score_update_time();

};

//
//  T I M E R  T H I N K 2
//
//  Match timer think function.
//
//  self.count gives the number of seconds remaining in the match.
//
void () match_timer_think2 =
{
    local string temp;

	self.count = self.count - 1;
	if (self.count < 0)
	{
		self.count = 59;
		self.lip = self.lip - 1;
	}
    self.nextthink = time + 1;

	score_update_time();

	if (self.lip)
	{
		if (self.count)
				return;
		if (self.lip > 1)
		{
			temp = ftos(self.lip);
			match_show_timelimit();
			bprint3("Match ends in ", temp, " minutes\n");
			if (self.lip == 5 * floor(self.lip / 5))
				match_bprint_score();
		}
		else
		{
			match_show_timelimit();
			bprint("Match ends in 1 minute\n");
			match_bprint_score();
		}
	}
    else if (self.count == 30)
    {
        bprint("Match ends in 30 seconds\n");
        if (crx_overtime)
        {
            temp = ftos(crx_overtime);
            bprint2(temp, " minute overtime in case of tie\n");
        }
    }
	else if (self.count > 10)
		return;
    else if (self.count > 1)
    {
        if (self.count == 10)
            bprint("Match ends in T minus\n");
        local string temp2;
        temp2 = ftos(self.count);
        bprint3("  ", temp2, " seconds\n");
    }
    else
    {
        bprint("  1 second\n");
        self.think = match_end;
    }
};

//
//  A D D  S P A W N
//
//  Turn this extra start point into a spawn point for the match start
//
void () match_add_spawn =
{
    self.mdl = "crx_start_point";
    self.classname = "info_player_deathmatch";
};

//
//  R E M O V E  S T A R T
//
//  Turn this extra start point back into a start point 2 seconds into
//  the match.
//
void () match_remove_start =
{
    if (self.mdl == "crx_start_point")
        self.classname = self.mdl;
};

//
//  R E M O V E  S T A R T S
//
//  2 seconds into the match all start points revert to start points.
//
void () match_remove_starts =
{
    utils_do_item(match_remove_start, "info_player_deathmatch");
    num_spawns = num_spawns - num_starts;
};

//
//  M A T C H  G E T  A C T I V E  T E A M S
//
// How many teams have a ready player
float () match_count_active_teams =
{
    local float activeteams = 0;
    if (crx_teamsize1 > 0)
        activeteams++;
    if (crx_teamsize2 > 0)
        activeteams++;
    // if (crx_teamsize3 > 0)
    //     activeteams++;
    // if (crx_teamsize4 > 0)
    //     activeteams++;
    return activeteams;
};

//
//  B E G I N
//
//  Gib all players and start the match.
//

void () match_begin =
{
    local string temp;
    
    match_start_time = time;

    crx_state = crx_state | STATE_MATCH_STARTED;
    utils_do_players(match_gib_player);
    utils_do_projectiles(SUB_Remove);

    // Set the team size so that unwanted A-holes can't join in
    crx_maxsize = utils_max(crx_teamsize1, crx_teamsize2);
    temp = ftos(crx_maxsize);
    bprint5("Match is ", temp, "v", temp, "\n");

    //set number of teams for match
    crx_matchteams = match_count_active_teams();

    temp = ftos(crx_timelimit);
    bprint2(temp, " minutes remaining\n");

    self.think = match_timer_think2;
    self.nextthink = time + 1;
    self.lip = crx_timelimit;
	self.count = 0;
    match_show_timelimit();

    // Temporarily turn the extra start points into spawn points if necessary
    if (crx_teamsize1 + crx_teamsize2 > num_spawns)
    {
        utils_do_item(match_add_spawn, "crx_start_point");
        num_spawns = num_spawns + num_starts;
        utils_make_scheduled_event(match_remove_starts, 2);
    }

	// Initialize the score module
	score_init();
};

//
//  T I M E R  T H I N K 1
//
//  Pre-match timer think function.
//
//  self.count gives the number of seconds until the match begins.
//
void () match_timer_think1 =
{
    local string temp;

    self.count = self.count - 1;

    if (self.count == 13)
    {
        crx_maxsize = utils_max(crx_teamsize1, crx_teamsize2);
        temp = ftos(crx_maxsize);
        bprint5("Match is currently ", temp, "v", temp, "\n");
    }
    else if (self.count == 11)
    {
        utils_do_items(SUB_regen);
        if (crx_playmode & MODE_NO_QUAD)
            utils_do_item(admin_disable_item, "item_artifact_super_damage");
        if (crx_playmode & MODE_NO_PENT)
            utils_do_item(admin_disable_item, "item_artifact_invulnerability");
        if (crx_playmode & MODE_NO_RING)
            utils_do_item(admin_disable_item, "item_artifact_invisibility");

        //TODO: Respawn runes?

        bprint("All items have respawned\n");
    }
    else if (self.count == 15)
    {
        sound (world, CHAN_AUTO, "item/br_protec2.wav", 1, ATTN_NONE);
    }
    else if (self.count <= 3)
    {
        sound (world, CHAN_AUTO, "trig/br_switch.wav", 1, ATTN_NONE);
        if (self.count < 2)
        {
            self.nextthink = time + 1;
            self.think = match_begin;
        }
    }

    if (self.count > 0)
        self.nextthink = time + 1;
};

//
//  P U T  P L A Y E R  I N  T E A M
//
//  Try to put a player into the team that he has chosen.  Called
//  when a player enters 'ready' in the console.  Returns TRUE if
//  successful, FALSE otherwise.
//
float () match_put_player_in_team =
{
    local string teamname;
    local float create;

    if (self.team == 1)
    {
        //sprint(self, "Invalid pants color\n");
        return FALSE;
    }

    self.height = self.team - 1;
    create = 0;

    if (self.height == crx_team1)
    {
        // Add to team1 if possible
        if ((crx_state & STATE_MATCH_STARTED) &&
            (crx_teamsize1 == crx_maxsize))
        {
            sprint(self, "Team full.  Enter 'unlock' in console\n");
            sprint(self, "to request permission to join.\n");
            return FALSE;
        }
        self.player_flag |= PF_TEAM_RED;
        crx_teamsize1 = crx_teamsize1 + 1;
        if (crx_teamsize1 == 1)
            create = 1;
    }
    else if (self.height == crx_team2)
    {
        // Add to team2 if possible
        if ((crx_state & STATE_MATCH_STARTED) &&
            (crx_teamsize2 == crx_maxsize))
        {
            sprint(self, "Team full.  Administrator or match\n");
            sprint(self, "participant must enter 'unlock' in\n");
            sprint(self, "console to allow you to join.\n");
            return FALSE;
        }
        self.player_flag |= PF_TEAM_BLUE;
        crx_teamsize2 = crx_teamsize2 + 1;
        if (crx_teamsize2 == 1)
            create = 1;
    }
    else
    {
        sprint(self, "You must pick a valid pants color:\n");
        teamname = strings_get_teamname(crx_team1);
		sprint(self, teamname);
		teamname = ftos(crx_team1);
        sprint3(self, " (color ", teamname, ") or\n");
        teamname = strings_get_teamname(crx_team2);
		sprint(self, teamname);
		teamname = ftos(crx_team2);
        sprint3(self, " (color ", teamname, ")\n");

        //self.frags = -99;
        return FALSE;
    }

    self.frags = 0;
    self.dmg_tally = 0;
    teamname = strings_get_teamname(self.height);
    if (create)
        bprint2(teamname, " created\n");
    bprint4(self.netname, " has joined the ", teamname, "\n");
    if (!crx_team2)
        bprint("Only one team present\n");

    return TRUE;
};

//
//  A L L  R E A D Y
//
//  Returns TRUE if all non-observers are ready, FALSE otherwise.
//
float () match_all_ready =
{
    local entity player;

    player = find(world, classname, "player");
    while (player)
    {
        if (!(player.style & (STYLE_OBSERVER | STYLE_READY)) && 
            (player.style & STYLE_CONNECTED))
            return FALSE;
        player = find(player, classname, "player");
    }
    return TRUE;
};

//
//  S T A R T  T I M E R
//
//  Starts the timer.
//
void () match_start_timer =
{
    if ((crx_playmode & MATCH_MODE)) {
        crx_match_timer = spawn();
        crx_match_timer.classname = "crx_match_timer";
        crx_match_timer.think = match_timer_think1;
        crx_match_timer.nextthink = time + 2;
        crx_match_timer.count = 16;

        crx_teamfrags1 = 0;
        crx_teamfrags2 = 0;
        // crx_teamfrags3 = 0;
        // crx_teamfrags4 = 0;
        crx_state = crx_state | STATE_TIMER_STARTED;
        crx_state = crx_state - (crx_state & STATE_MATCH_OVER);
        match_show_timelimit();
        //bprint("Match begins in 1 minute\n");
        bprint("Timelimit is ");
        utils_bprint_float(crx_timelimit);
        bprint("Match begins in 15 seconds\n");
    }
};

//
//  F I N D  G H O S T
//
//  Finds a ghost from a ghost code; returns world if the ghost doesn't
//  exist.
//
entity (float code) match_find_ghost =
{
    local entity e;

    e = find(world, classname, "crx_ghost");
    while ((e != world) && (e.count != code))
        e = find(e, classname, "crx_ghost");
    return e;
};

//
//  M A K E  G H O S T
//
//  Create a ghost for the player (if does not already have one)
//  and tell him what his ghost code is.
//
void () match_make_ghost =
{
    // can't have two ghosts
    if (self.owner)
        remove(self.owner);

    // create ghost code
    local float ghostcode;
    ghostcode = 100 + floor(899.99 * random());
    while (match_find_ghost(ghostcode))
        ghostcode = 100 + floor(899.99 * random());

    // initialize ghost
    self.owner = spawn();
    self.owner.classname = "crx_ghost";
    self.owner.owner = self;
    self.owner.frags = 0;
    self.owner.dmg_tally = 0;
    self.owner.height = self.height;
    self.owner.count = ghostcode;

    sprint(self, "Your ghost code is ");
    utils_print_float(self.owner.count);
};

//
//  S H O W  G H O S T  C O D E
//
void () match_show_ghost_code =
{
    if (self.owner)
    {
        sprint(self, "Your ghost code is ");
        utils_print_float(self.owner.count);
    }
    else
        sprint(self, "You do not have a ghost\n");
};

//
//  R E Q U E S T  R E S T O R E  G H O S T
//
//  Request to be restored from a ghost.  The player is asked
//  to enter his three digit ghost code.
//
void () match_request_restore_ghost =
{
    if (!(crx_state & STATE_MATCH_STARTED))
    {
        sprint(self, "There is no match in progress\n");
        return;
    }

    // only uncomitted players can ghost themselves
    if (self.style & STYLE_READY)
    {
        sprint(self, "You are already in the match\n");
        return;
    }

    sprint(self, "Enter the first ghost code digit:\n");
    self.count = 0;
    self.use = match_enter_ghost_code;
};

//
//  E N T E R  G H O S T  C O D E
//
//  Enter another ghost code digit.  The digit is stored in
//  self.finaldest_z.
//
void () match_enter_ghost_code =
{
    if (self.finaldest_z > 9)
        return;
    self.count = self.count * 10 + self.finaldest_z;
    if (!self.count)
        return;

    if (self.count < 10)
        sprint(self, "Enter the second ghost code digit:\n");
    else if (self.count < 100)
        sprint(self, "Enter the third ghost code digit:\n");
    else
    {
        // ghost code has been entered
        local entity e;

        e = match_find_ghost(self.count);
        if (!e)
            sprint(self, "Ghost not found\n");
        else
        {
            // Check to make sure the client is gone
            if (e.owner.owner == e)
                sprint2(self, e.owner.netname, " owns this ghost\n");
            else
                match_restore_ghost(e);
        }
        self.use = SUB_Null;
    }
};

//
//  R E S T O R E  G H O S T
//
//  Restore a player from their ghost after they've entered their
//  ghost code.  Note that the only way for this function to be
//  called is if there is a match in progress and the player entering
//  the ghostcode is an uncommitted observer.
//
void (entity ghostent) match_restore_ghost =
{
    self.team = ghostent.height + 1;
    if (match_put_player_in_team())
    {
        local string temp;

        // Must ready before observer_end, or will be made observer again
        // Must observer_end before setting frags, or frags will be set to 0
        self.style = self.style | STYLE_READY;
        observer_end();
        self.frags = ghostent.frags;
        self.dest = ghostent.dest;
        self.dest1 = ghostent.dest1;
        self.dest2 = ghostent.dest2;
        self.mangle = ghostent.mangle;
        self.owner = ghostent;
        ghostent.owner = self;
        setcolor2(self, self.height, self.height);

        temp = ftos(self.frags);
        bprint4(self.netname, " restored from ghost\nwith ", temp, " frag");
        if (self.frags == 1)
            bprint("\n");
        else
            bprint("s\n");
    }    
};

//
//  R E A D Y
//
//  Called when a player enters 'ready' in the console.
//
void () match_ready =
{
    if (crx_state & STATE_MATCH_WAIT)
    {
        sprint(self, "Try again in 5 seconds\n");
        return;
    }
    if (self.style & STYLE_READY)
    {
        sprint(self, "You are already committed\n");
        return;
    }

    // can't commit while entering ghost code
    if (self.use == match_enter_ghost_code)
    {
        sprint(self, "Finish entering the ghost code\n");
        return;
    }


        // Try to add the player; color him white if unsuccessful
        if (!match_put_player_in_team())
        {
            setcolor2(self, 0, 0);
		self.alpha = 0.001;  //9-17-23  observer transparent
            return;
        }

        self.style = self.style | STYLE_READY;

        if (crx_playmode & MATCH_MODE && (crx_teamsize1 > 0 && crx_teamsize2 > 0 && crx_teamsize1 == crx_teamsize2)) 
        //if (crx_playmode & MATCH_MODE && (crx_teamsize1 > 0 || crx_teamsize2 > 0))   //match debug  021824
        {
            // check to see if we need to start the timer
            if (!(crx_state & STATE_TIMER_STARTED) && match_all_ready())
                match_start_timer();
        }

        // Give the player a ghost
        match_make_ghost();

        if (self.style & STYLE_OBSERVER)
            observer_end();
    

};

//
//  N O T  R E A D Y
//
//  Called when a player enters 'notready' in the console.
//
void () match_notready =
{

        local string teamname; 

        if (crx_state & STATE_MATCH_WAIT)
        {
            sprint(self, "Try again in 5 seconds\n");
            return;
        }
        if (!(self.style & STYLE_READY))
        {
            sprint(self, "You have not yet committed\n");
            return;
        }
        if (crx_state & STATE_MATCH_STARTED)
        {
            sprint(self, "Cannot uncommit during match\n");
            sprint(self, "Type 'observer' to leave match\n");
            return;
        }

        self.style = self.style - STYLE_READY;

        if (mode_is_public()) {
            self.player_flag = self.player_flag - (self.player_flag & PF_FIRST_SPAWN);
            self.player_flag = self.player_flag - (self.player_flag & PF_MIDGAME_JOIN);    

            teamname = strings_get_teamname(self.height);
            bprint4(self.netname, " has left the ", teamname, "\n");
        }
        else {
            bprint2(self.netname, " is not ready\n");
        }

        // He was ready but the match hadn't started, so remove his ghost
        remove(self.owner);
        self.owner = world;

        // Remove from team
        if (self.height == crx_team1)
        {
            crx_teamsize1 = crx_teamsize1 - 1;
            self.player_flag -= PF_TEAM_RED;
        }
        else if (self.height == crx_team2)
        {
            crx_teamsize2 = crx_teamsize2 - 1;
            self.player_flag -= PF_TEAM_BLUE;
        }

        if (crx_state & STATE_TIMER_STARTED)
        {
            bprint("Timer stopped\n");
            remove(crx_match_timer);
            crx_state = crx_state - STATE_TIMER_STARTED;
            match_show_timelimit();
        }
    
};

//
//  U N L O C K
//
//  Allow new players to joing the match.
//
void () match_unlock =
{
    crx_maxsize = 16;
    bprint("Match has been unlocked\n");
    bprint("New players may join at will\n");
};

//
//  R E Q U E S T  U N L O C K
//
//  Request to allow new players to join the match.
//
void () match_request_unlock =
{
    if (!(crx_state & STATE_MATCH_STARTED))
    {
        sprint(self, "No match in progress\n");
        return;
    }
    if (crx_maxsize == 16)
    {
        sprint(self, "Match is already unlocked\n");
        return;
    }

    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        match_unlock();
    else if (self.style & STYLE_READY)
    {
        if (vote_init("allow new players to join", "", match_unlock))
            vote_yes();
    }
    else
    {
        sprint(self, "unlock comand available to match\n");
        sprint(self, "participants and administrators only\n");
   }
};

//
//  L O C K
//
//  Re-cap the team size.
//
void () match_lock =
{
    crx_maxsize = utils_max(crx_teamsize1, crx_teamsize2);

    bprint("Match has been locked\n");
    bprint("Max teamsize set to ");
    utils_bprint_float(crx_maxsize);
};

//
//  R E Q E S T  L O C K
//
//  Request to re-cap the team size.
//
void () match_request_lock =
{
    if (!(crx_state & STATE_MATCH_STARTED))
    {
        sprint(self, "No match in progress\n");
        return;
    }
    if (crx_maxsize == utils_max(crx_teamsize1, crx_teamsize2))
    {
        sprint(self, "Match is already locked\n");
        return;
    }

    // Do it right away if we're an administrator, otherwise vote
    if (self.style & STYLE_ADMINISTRATOR)
        match_lock();
    else if (self.style & STYLE_READY)
    {
        if (vote_init("lock the match", "", match_lock))
            vote_yes();
    }
    else
    {
        sprint(self, "lock comand available to match\n");
        sprint(self, "participants and administrators only\n");
   }
};

//
//  H E L P
//
void () match_help =
{
    sprint(self, "Match commands (for match mode only):\n");
    sprint(self, " timelimitXX - change timelimit\n");
    sprint(self, "         (XX = 5, 10, 15, 20, 25, 30)\n");
    sprint(self, " ready    - commit to a team\n");
    sprint(self, " notready - uncommit yourself\n");
    sprint(self, " ready?   - find out who is not ready\n");
    sprint(self, " unlock   - allow new players to join\n");
    sprint(self, " lock     - re-cap the team size\n");
    sprint(self, " timerstop  - pause the match\n");
    sprint(self, " timerstart - start/restart the timer\n");
    sprint(self, " ghostcode  - view your ghost code\n");
    sprint(self, " ghost - restore yourself from ghost\n");
    sprint(self, " score - show time left and score\n");
	sprint(self, " +teamscores - bind this to a key\n");
};

//
//  S H O W  N O T  R E A D Y
//
//  Prints a list of players who are not ready.
//
void () match_show_not_ready =
{
    if (match_all_ready())
    {
        if (crx_teamsize1 < 1 && crx_teamsize2 < 1)
            sprint(self, "No teams present\n");
        else
        {
            sprint(self, "All players are ready\n");

            if (match_count_active_teams() == 1)
                sprint(self, "Only one team present\n");
        }
    }
    else
    {
        local entity player;

        bprint("The following players are not ready:\n");

        player = find(world, classname, "player");
        while (player)
        {
            if (!(player.style & (STYLE_OBSERVER | STYLE_READY)) && 
				(player.style & STYLE_CONNECTED))
                bprint3(" ", player.netname, "\n");
            player = find(player, classname, "player");
        }
    }
};

//
//  P A U S E  I T E M
//
void () match_pause_item =
{
    self.nextthink = self.nextthink + 1000000;
};

//
//  S H O W  P A U S E
//
//  Centerprint "Paused" to all clients.
//
void () match_show_pause =
{
    WriteByte(MSG_ALL, SVC_CENTERPRINT);
    WriteString(MSG_ALL, "\nPAUSED\n");
    crx_match_timer.nextthink = time + 0.5;
    crx_match_timer.think = match_show_pause;
};

//
//  P A U S E
//
//  Called after the request to pause has passed.
//
void () match_pause =
{
    crx_state = crx_state | STATE_MATCH_PAUSED;
    match_pause_time = time;
    utils_do_items(match_pause_item);
    bprint("Match paused\n");
    match_bprint_time();
    match_bprint_score();
    crx_match_timer.think1 = crx_match_timer.think;
    crx_match_timer.cnt = crx_match_timer.nextthink;
    match_show_pause();
};

//
//  R E Q U E S T  P A U S E
//
void () match_request_pause =
{
  
        if (!(crx_state & STATE_MATCH_STARTED))
        {
            sprint(self, "No match in progress\n");
            return;
        }
        if (crx_state & STATE_MATCH_PAUSED)
        {
            sprint(self, "Match is already paused\n");
            return;
        }

        // Do it right away if we're an administrator, otherwise vote
        if (self.style & STYLE_ADMINISTRATOR)
            match_pause();
        else if (vote_init("pause the match", (""), match_pause))
            vote_yes();
    
};

//
//  U N P A U S E  I T E M
//
void () match_unpause_item =
{
    self.nextthink = self.nextthink - 1000000 + match_pause_time;
};

//
//  U N P A U S E  P L A Y E R
//
void () match_unpause_player =
{
    if (self.super_damage_finished)
        self.super_damage_finished = self.super_damage_finished +
                                     match_pause_time;
    if (self.invisible_finished)
        self.invisible_finished = self.invisible_finished +
                                  match_pause_time;
    if (self.invincible_finished)
        self.invincible_finished = self.invincible_finished +
                                   match_pause_time;
    if (self.radsuit_finished)
        self.radsuit_finished = self.radsuit_finished +
                                match_pause_time;
    self.air_finished = self.air_finished + match_pause_time;
    self.pain_finished = self.pain_finished + match_pause_time;

	if ((self.style & STYLE_OBSERVER) || self.deadflag)
		return;

    self.last_hurt_carrier 	= (self.last_hurt_carrier + match_pause_time);
};

//
//  U N P A U S E
//
//  Called after the request to unpause has passed.
//
void () match_unpause =
{
    crx_state = crx_state - STATE_MATCH_PAUSED;
    match_pause_time = time - match_pause_time;
    utils_do_items(match_unpause_item);
    utils_do_players(match_unpause_player);
    bprint("Match unpaused\n");
    match_bprint_time();
    match_bprint_score();
    crx_match_timer.nextthink = crx_match_timer.cnt + match_pause_time;
    crx_match_timer.think = crx_match_timer.think1;
    WriteByte(MSG_ALL, SVC_CENTERPRINT);
    WriteShort(MSG_ALL,1);
    WriteString(MSG_ALL, " ");
};

//
//  R E Q U E S T  U N P A U S E
//
//  Request to start/restart the timer
//
void () match_request_unpause =
{

        if (!(crx_state & STATE_MATCH_STARTED))
        {
            if (crx_state & STATE_TIMER_STARTED)
            {
                sprint(self, "Timer has already started\n");
                return;
            }
            if (!crx_team2)
            {
                if (!crx_team1)
                    sprint(self, "There are no teams present\n");
                else
                    sprint(self, "There is only one team present\n");
                return;
            }
            // request to force the timer to start.
            // Do it right away if we're an administrator, otherwise vote
            if (self.style & STYLE_ADMINISTRATOR)
                match_start_timer();
            else if (vote_init("start the timer", "", match_start_timer))
                vote_yes();
            return;
        }
        if (!(crx_state & STATE_MATCH_PAUSED))
        {
            sprint(self, "Match is not paused\n");
            return;
        }

        // Do it right away if we're an administrator, otherwise vote
        if (self.style & STYLE_ADMINISTRATOR)
            match_unpause();
        else if (vote_init("unpause the match", "", match_unpause))
            vote_yes();
    
};

//
//  I M P U L S E
//
void () match_impulse =
{
    if (self.impulse == 129)
        match_help();
    else if (self.impulse == 128)
        match_sprint_status();
    else if (self.impulse == 120)
    {
        if (mode_is_public()) 
        {
            if (!(self.player_flag & PF_MIDGAME_JOIN))
                self.player_flag |= PF_MIDGAME_JOIN;
            match_ready();
            return;
        } 
        else if (!(crx_playmode & MATCH_MODE))
        {
            if (self.style & STYLE_OBSERVER)
                observer_end();
            else
                sprint(self, "You are not an observer\n");
            return;
        }
    }

    if (!(crx_playmode & MATCH_MODE))
    {
        sprint(self, "Command valid in match mode only\n");
        return;
    }
    // else if ((mode_is_public()) && self.impulse == 131)
    //     score_show_teamscores();
    // else if ((mode_is_public()) && self.impulse == 132)
    //     score_restore_scoreboard();

    if (self.impulse == 120)
        match_ready();
    else if (self.impulse == 121)
        match_notready();
    else if (self.impulse == 122)
        match_request_unlock();
    else if (self.impulse == 123)
        match_show_not_ready();
    else if (self.impulse == 124)
        match_request_pause();
    else if (self.impulse == 125)
        match_request_unpause();
    else if (self.impulse == 126)
        match_show_ghost_code();
    else if (self.impulse == 127)
        match_request_restore_ghost();
    else if (self.impulse == 130)
        match_request_lock();
	else if (self.impulse == 131)
		score_show_teamscores();
	else if (self.impulse == 132)
		score_restore_scoreboard();
};

//
//  V E R I F Y  T E A M
//
//  Called every frame to verify that a committed player hasn't tried
//  to change colour.
//
void (entity player) match_verify_team =
{
    if (!(crx_playmode & MATCH_MODE))
        return;

    if (!(player.style & STYLE_READY))
        return;

    if (player.height != player.team - 1)
    {
        setcolor2(player, player.height, player.height);
        player.team = player.height + 1;

        sprint(player, "You cannot change color after\n");
        sprint(player, "you have committed\n");
    }
};

//
//  D I S C O N N E C T  N O T I F Y
//
//  Called when a player disconnects from the server or enters
//  observer mode.
//
void (entity player) match_disconnect_notify =
{
    if (!(player.style & STYLE_READY) && (crx_playmode & MATCH_MODE))
    {
        // Check to see if we need to start the timer
        if (!(crx_state & STATE_MATCH_WAIT))
        {
            if (!(crx_state & STATE_TIMER_STARTED))
            {
                if ((crx_teamsize1 > 0 && crx_teamsize2 > 0))
                {
                    if (match_all_ready())
                        match_start_timer();
                }
            }
        }
        return;
    }


    if (player.style & STYLE_READY)
    {
        player.style = player.style - STYLE_READY;

        // Remove the player from the appropriate team
        if (player.height == crx_team1)
            crx_teamsize1 = crx_teamsize1 - 1;
        else if (player.height == crx_team2)
            crx_teamsize2 = crx_teamsize2 - 1;
        // else if (player.height == crx_team3)
        //     crx_teamsize3 = crx_teamsize3 - 1;
        // else if (player.height == crx_team4)
        //     crx_teamsize4 = crx_teamsize4 - 1;    
    }
    // Copy his info to his ghost
    if (self.owner)
    {
        self.owner.frags = self.frags;
        self.owner.dest = self.dest;
        self.owner.dest1 = self.dest1;
        self.owner.dest2 = self.dest2;
        self.owner.mangle = self.mangle;
    }

    // Check to see if we need to stop the match
    if (crx_state & STATE_MATCH_STARTED)
    {
        // if he's turned himself into an observer, then get rid of his
        // ghost
        if (self.style & STYLE_OBSERVER)
		{
			if (self.owner)
				remove(self.owner);
			else  // Sanity check added 5/15/98
				cprint("Internal error #1.  Please send mail to crbug@mpog.com\n");
		}
        self.owner = world;

        if (!crx_teamsize1 && !crx_teamsize2)
        {
            match_reset();
            bprint("Match aborted\n");
            remove(crx_match_timer);
            crx_state = crx_state - (crx_state & STATE_MATCH_PAUSED);
            if (crx_state & STATE_TIMER_STARTED)
                crx_state = crx_state - STATE_TIMER_STARTED;
            crx_state = crx_state - STATE_MATCH_STARTED;
            match_show_timelimit();
        }
        return;
    }
	
	// JP - 5/15/98
	// Bug fix for players falling out of map.
	// For the 5 seconds after a match ends, players are "ready" but they
	// have no ghost.  So let's return before we remove world, okay? :p
	// That's what was causing it!
	if (crx_state & STATE_MATCH_WAIT)
		return;

    // He was ready but the match hadn't started, so remove his ghost
	if (self.owner)
		remove(self.owner);
	else  // Sanity check added 5/15/98
		cprint("Internal error #2.  Please send mail to crbug@mpog.com\n");
    self.owner = world;

    // Check to see if we need to stop the timer
    if (mode_is_public())
    {
        return;
    }
    else 
    {
        if ((crx_state & STATE_TIMER_STARTED) && (match_count_active_teams() < crx_matchteams))
        {
            bprint("Need two teams to play\n");
            bprint("Timer stopped\n");
            remove(crx_match_timer);
            crx_state = crx_state - STATE_TIMER_STARTED;
            match_show_timelimit();
        }

        if (!crx_teamsize1 && !crx_teamsize2)
            bprint("No teams present\n");
    }
};