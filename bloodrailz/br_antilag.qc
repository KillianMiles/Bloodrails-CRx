
void (entity e, float rewindtime) antilag_rewind =
{
	vector rewindorigin;

	if (e.lastorigintime1 < rewindtime)
		rewindorigin = e.lastorigin1;
	else if (e.lastorigintime2 < rewindtime)
		rewindorigin = e.lastorigin2;
	else if (e.lastorigintime3 < rewindtime)
		rewindorigin = e.lastorigin3;
	else if (e.lastorigintime4 < rewindtime)
		rewindorigin = e.lastorigin4;
	else if (e.lastorigintime5 < rewindtime)
		rewindorigin = e.lastorigin5;
	else if (e.lastorigintime6 < rewindtime)
		rewindorigin = e.lastorigin6;
	else if (e.lastorigintime7 < rewindtime)
		rewindorigin = e.lastorigin7;
	else if (e.lastorigintime8 < rewindtime)
		rewindorigin = e.lastorigin8;
	else
		rewindorigin = e.lastorigin9;

  	setorigin(e, rewindorigin);
}

void (float pingtime, entity ignore) antilag_rewind_all =
{
	local entity player;

	float timestamp_we_want = ((time*1000) - pingtime);
  
	player = find(world, classname, "player");

	while (player)
	{
		if ((player.deadflag == DEAD_NO) && (player.style & STYLE_CONNECTED) && !(player.style & STYLE_OBSERVER))
		{
			player.hold_origin = player.origin;
			if (player != ignore)
			{
				antilag_rewind(player, timestamp_we_want);
			}
		}
		player = find(player, classname, "player");
	}
}

void () antilag_restore_all =
{
	local entity player;
  
	player = find(world, classname, "player");

	while (player)
	{
		if ((player.deadflag == DEAD_NO) && (player.style & STYLE_CONNECTED) && !(player.style & STYLE_OBSERVER))
		{
			setorigin(player, player.hold_origin);
		}
		player = find(player, classname, "player");
	}
}



void () client_ping_think =
{
    local entity client;


    client = find(world, classname, "player");
    while (client)
    {
		client.responsetime3 = client.responsetime2;
		client.responsetime2 = client.responsetime1;
		
		
			if (client.finaldest_y > self.finaldest_x)	client.responsetime1 = floor(client.finaldest_y - self.finaldest_x) - 16;
			else	client.responsetime1 = client.responsetime2;


		if (client.responsetime2 > 0)
		{
			if (client.responsetime3 > 0)
			{
				client.responsetime = ((client.responsetime1 + client.responsetime2 + client.responsetime3) / 3);
			}
			else
			{
				client.responsetime = ((client.responsetime1 + client.responsetime2) / 2);
			}
		}
		else
		{
			client.responsetime = client.responsetime1;
		}
	
        client = find(client, classname, "player");
    
	}
	remove(self);
};

void () client_responsetime_get_all =
{
    local entity ping;

    WriteByte(MSG_BROADCAST, SVC_STUFFTEXT);
    WriteString(MSG_BROADCAST, "impulse 38\n");

    ping = spawn();
    ping.classname = "client_ping";
    ping.owner = world;
    ping.nextthink = time + 2;
    ping.think = client_ping_think;
    ping.finaldest_x = (time * 1000);
};

void () client_responsetime_set =
{
    self.finaldest_y = (time * 1000);
};
	
	


//debug function to see response times and frames
void () client_responsetime_show =
{
    sprint3(self, "response time3: ", ftos(self.responsetime3), "\n");
    sprint3(self, "response time2: ", ftos(self.responsetime2), "\n");
    sprint3(self, "response time1: ", ftos(self.responsetime1), "\n");
    sprint3(self, "response time:  ", ftos(self.responsetime), "\n");
    sprint3(self, "current origin: ", vtos(self.origin), "\n");
    sprint5(self, "last frame1: ", vtos(self.lastorigin1), " ", ftos(self.lastorigintime1), "\n");
    sprint5(self, "last frame2: ", vtos(self.lastorigin2), " ", ftos(self.lastorigintime2), "\n");
    sprint5(self, "last frame3: ", vtos(self.lastorigin3), " ", ftos(self.lastorigintime3), "\n");
    sprint5(self, "last frame4: ", vtos(self.lastorigin4), " ", ftos(self.lastorigintime4), "\n");
    sprint5(self, "last frame5: ", vtos(self.lastorigin5), " ", ftos(self.lastorigintime5), "\n");
    sprint5(self, "last frame6: ", vtos(self.lastorigin6), " ", ftos(self.lastorigintime6), "\n");
    sprint5(self, "last frame7: ", vtos(self.lastorigin7), " ", ftos(self.lastorigintime7), "\n");
    sprint5(self, "last frame8: ", vtos(self.lastorigin8), " ", ftos(self.lastorigintime8), "\n");
    sprint5(self, "last frame9: ", vtos(self.lastorigin9), " ", ftos(self.lastorigintime9), "\n");
};

//rotate player positions
void () SetPositions =
{
	self.lastorigin9 = self.lastorigin8;
	self.lastorigintime9 = self.lastorigintime8;
	self.lastorigin8 = self.lastorigin7;
	self.lastorigintime8 = self.lastorigintime7;
	self.lastorigin7 = self.lastorigin6;
	self.lastorigintime7 = self.lastorigintime6;
	self.lastorigin6 = self.lastorigin5;
	self.lastorigintime6 = self.lastorigintime5;
	self.lastorigin5 = self.lastorigin4;
	self.lastorigintime5 = self.lastorigintime4;
	self.lastorigin4 = self.lastorigin3;
	self.lastorigintime4 = self.lastorigintime3;
	self.lastorigin3 = self.lastorigin2;
	self.lastorigintime3 = self.lastorigintime2;
	self.lastorigin2 = self.lastorigin1;
	self.lastorigintime2 = self.lastorigintime1;
	self.lastorigin1 = self.origin;
	self.lastorigintime1 = (time*1000);
};
	
	


