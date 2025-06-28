void () score_update_frags;
void () score_restore_scoreboard;

//
//  I N I T
//
//  Reset the score stuff at the start of a match
//
void () score_init = 
{
	crx_winning_teamname = STRING_TIED;
	crx_score_number = 0;
	crx_teamname1 = strings_get_teamname_bronze(crx_team1);
	crx_teamname2 = strings_get_teamname_bronze(crx_team2);
};

//
//  I N I T  W O R L D
//
void () score_init_world = 
{
	STRING_TIED = "            Tied at ";
};

//
//  F R A G
//
//  Update the team frag count and the winning teamname if necessary
//
void (float teamnum, float fragval) score_frag =
{
	// update the team score
	if (teamnum == crx_team1)
	{
		crx_teamfrags1 = crx_teamfrags1 + fragval;
	}
	else
	{
		crx_teamfrags2 = crx_teamfrags2 + fragval;
	}

	if (crx_winning_teamname == STRING_TIED)
	{
		// just broke a tie
		if (crx_teamfrags1 > crx_teamfrags2)
			crx_winning_team = crx_team1;
		else
			crx_winning_team = crx_team2;

		crx_winning_teamname = strings_get_teamname_up_by(crx_winning_team);
		crx_score_number = 1;
	}
	else
	{
		if (teamnum == crx_winning_team)
			crx_score_number = crx_score_number + fragval;
		else
			crx_score_number = crx_score_number - fragval;

		if (crx_score_number == 0)
		{
			// just created a tie
			crx_winning_teamname = STRING_TIED;
			crx_score_number = crx_teamfrags1;
		}
	}

	if (crx_score_count)
		utils_make_scheduled_event(score_update_frags, 0.1);
};

//
//  W R I T E  N A M E
//
//  Update the given client's name to msg_entity
//
void (float client, string name) score_write_name =
{
	WriteByte(MSG_ONE, SVC_UPDATENAME);
	WriteByte(MSG_ONE, client);
	WriteString(MSG_ONE, name);
};

//
//  W R I T E  F R A G S
//
//  Update the given client's frags to msg_entity
//
void (float client, float fragval) score_write_frags =
{
	WriteByte(MSG_ONE, SVC_UPDATEFRAGS);
	WriteByte(MSG_ONE, client);
	WriteShort(MSG_ONE, fragval);
};

//
//  W R I T E  C O L O U R
//
//  Update the given client's colour to msg_entity
//
void (float client, float colour) score_write_colour =
{
	WriteByte(MSG_ONE, SVC_UPDATECOLORS);
	WriteByte(MSG_ONE, client);
	WriteByte(MSG_ONE, colour);
};

//
//  W R I T E  T I M E
//
//  Update 'time remaining" to msg_entity in the given slot
//
void (float client) score_write_time = 
{
	WriteByte(MSG_ONE, SVC_UPDATENAME);
	WriteByte(MSG_ONE, client);
	if (crx_state & STATE_MATCH_OVER)
		WriteString(MSG_ONE, "Match Over");
	else
	{
        //local float timeleft;
        local float minutes;
        local float seconds;
		local float temp;
    
        minutes = crx_match_timer.lip;
        seconds = crx_match_timer.count;
		
		if (minutes > 10)
		{
			temp = floor(minutes / 10);
			minutes = minutes - temp * 10;
			WriteByte(MSG_ONE, 48 + temp);
		}
		WriteByte(MSG_ONE, 48 + minutes);
		WriteByte(MSG_ONE, 58);
		temp = floor(seconds / 10);
		seconds = seconds - temp * 10;
		WriteByte(MSG_ONE, 48 + temp);
		WriteByte(MSG_ONE, 48 + seconds);
		WriteString(MSG_ONE, " remaining");
	}
};

//
//  F I X  C O N N E C T
//
void () score_fix_connect = 
{
	// find all players looking at scores, and fix the scoreboard
	msg_entity = find(world, classname, "player");
	while(msg_entity)
	{
		if (msg_entity.style & STYLE_SCOREBOARD)
		{
			if (msg_entity.style & STYLE_CONNECTED)
			{
				if (self.colormap == msg_entity.scoreboard_z)
					score_write_time(msg_entity.scoreboard_z);
				else
					score_write_name(self.colormap, "");
			}
		}
		msg_entity = find(msg_entity, classname, "player");
	}	
	remove(self);
};

//
//  C L I E N T  C O N N E C T
//
//  If someone's looking at teamscores we might need to patch up their scoreboard
//
void () score_client_connect = 
{
	if (!crx_score_count)
		return;

	local entity e;

	e = utils_make_scheduled_event(score_fix_connect, 0.1);
	e.colormap = self.colormap - 1;
};

//
//  F I X  D I S C O N N E C T
//
void () score_fix_disconnect = 
{
	// find all players looking at scores, and fix the scoreboard
	msg_entity = find(world, classname, "player");
	while(msg_entity)
	{
		if (msg_entity.style & STYLE_SCOREBOARD)
		{
			if (msg_entity.style & STYLE_CONNECTED)
			{
				if (self.colormap == msg_entity.scoreboard_x)
				{
					score_write_name(msg_entity.scoreboard_x, crx_teamname1);
					score_write_colour(msg_entity.scoreboard_x, 17 * crx_team1);
				}
				else if (self.colormap == msg_entity.scoreboard_y)
				{
					score_write_name(msg_entity.scoreboard_y, crx_teamname2);
					score_write_colour(msg_entity.scoreboard_y, 17 * crx_team2);
				}
				else if (self.colormap == msg_entity.scoreboard_z)
					score_write_time(msg_entity.scoreboard_z);
			}
		}
		msg_entity = find(msg_entity, classname, "player");
	}	
	remove(self);
};

//
//  C L I E N T  D I S C O N N E C T
//
//  If someone's looking at teamscores we might need to patch up their scoreboard
//
void () score_client_disconnect = 
{
	if (!crx_score_count)
		return;

	local entity e;

	e = utils_make_scheduled_event(score_fix_disconnect, 0.1);
	e.colormap = self.colormap - 1;
};

//
//  S H O W  T E A M S C O R E S
//
void () score_show_teamscores = 
{
	local entity e;
	local float team1;
	local float team2;

	if (self.style & STYLE_SCOREBOARD)
		return;

    if (crx_state & STATE_MATCH_STARTED || (mode_is_public()))
    {
        team1 = crx_team1;
        team2 = crx_team2;
    }
    else if (crx_state & STATE_MATCH_OVER)
    {
        team1 = crx_lastteam1;
        team2 = crx_lastteam2;
    }
    else
		return;

	msg_entity = self;
	self.style = self.style | STYLE_SCOREBOARD;
	crx_score_count = crx_score_count + 1;

	// first erase the scoreboard and find slots
	self.scoreboard_x = self.scoreboard_y = self.scoreboard_z = -1;
	e = find(world, classname, "player");
	while(e)
	{
		if (e.style & STYLE_CONNECTED)
		{
			score_write_name(e.colormap - 1, "");
			if ((self.scoreboard_x == -1) && (e.height == team1))
				self.scoreboard_x = e.colormap - 1;
			else if ((self.scoreboard_y == -1) && (e.height == team2))
				self.scoreboard_y = e.colormap - 1;
			else if ((self.scoreboard_z == -1) && (e.style & STYLE_OBSERVER))
				self.scoreboard_z = e.colormap - 1;
		}
		else if (self.scoreboard_z == -1)
		{
			self.scoreboard_z = e.colormap - 1;
			score_write_colour(self.scoreboard_z, 0);
			score_write_frags(self.scoreboard_z, -99);
		}
		e = find(e, classname, "player");
	}

	// if we couldn't find slots then abort
	if ((self.scoreboard_x == -1) || (self.scoreboard_y == -1))
	{
		score_restore_scoreboard();
		return;
	}

	// make sure we have a slot for time
	if (self.scoreboard_z == -1)
	{
		if (crx_teamsize1 + crx_teamsize2 < 8)
		{
			// 7 is unused - grab it
			self.scoreboard_z = 7;
			score_write_colour(7, 0);
			score_write_frags(7, -99);
		}
		else
		{
			// oh well - take what we can get
			e = find(world, classname, "player");
			while (e)
			{
				local float c;

				c = e.colormap - 1;
				if ((c != self.scoreboard_x) && (c != self.scoreboard_y))
				{
					self.scoreboard_z = c;
					score_write_frags(c, -99);
					e = world;
				}
				else
					e = find(e, classname, "player");
			}
		}
	}
	
	// now send the team scores
	score_write_name(self.scoreboard_x, crx_teamname1);
	score_write_frags(self.scoreboard_x, crx_teamfrags1);
	score_write_name(self.scoreboard_y, crx_teamname2);
	score_write_frags(self.scoreboard_y, crx_teamfrags2);

	// now send the time
	score_write_time(self.scoreboard_z);
};

//
//  R E S T O R E  S C O R E B O A R D
//
//  Restore a client's scoreboard after they finish looking at team scores
//
void () score_restore_scoreboard = 
{
	local entity e;

	if (!(self.style & STYLE_SCOREBOARD))
		return;

	msg_entity = self;
	self.style = self.style - STYLE_SCOREBOARD;
	crx_score_count = crx_score_count - 1;

	// Clear time remaining seperately since it might not be a client
	score_write_name(self.scoreboard_z, "");

	e = find(world, classname, "player");
	while(e)
	{
		if (e.style & STYLE_CONNECTED)
		{
			score_write_name(e.colormap - 1, e.netname);
			score_write_frags(e.colormap - 1, e.frags);
		}
		e = find(e, classname, "player");
	}
};

//
//  U P D A T E  F R A G S
//
//  Update frags for everyone who's looking at teamscores
//
void () score_update_frags = 
{
	msg_entity = find(world, classname, "player");
	while(msg_entity)
	{
		if (msg_entity.style & STYLE_SCOREBOARD)
		{
			if (msg_entity.style & STYLE_CONNECTED)
			{
				score_write_frags(msg_entity.scoreboard_x, crx_teamfrags1);
				score_write_frags(msg_entity.scoreboard_y, crx_teamfrags2);
			}
		}
		msg_entity = find(msg_entity, classname, "player");
	}	
};

//
//  U P D A T E  T I M E
//
//  Update the time for everyone who's looking at teamscores
//
void () score_update_time = 
{
	if (!crx_score_count)
		return;

	msg_entity = find(world, classname, "player");
	while(msg_entity)
	{
		if (msg_entity.style & STYLE_SCOREBOARD)
		{
			if (msg_entity.style & STYLE_CONNECTED)
				score_write_time(msg_entity.scoreboard_z);
		}
		msg_entity = find(msg_entity, classname, "player");
	}	
};

