string motd_top1;
string motd_top2;
string motd_bottom;

void () motd_init_world =
{
	motd_top1 = "\bBloodrailZ CRx\b\nby kilomiles\nwww.crxquake.com\n";
	motd_top2 = "\n\npress '\bf10\b' for help\n\n";
	motd_bottom =  "special thanks to\n\n bucksh0t\b|\bteamred\b|\bxstephx\b\n\bDERZIE\b|\b woods \b|\breki\n\n\n\n\n";
};

void () motd_think =
{
	if(mapname == "tut1" || mapname == "tut2") return;
	
	if ((self.count == 0) && (self.owner.style & STYLE_MOTD))
	{
		remove(self);
		return;
	}
	
	if (!(self.owner.style & STYLE_MOTD)) self.owner.style = self.owner.style | STYLE_MOTD;

	if (self.count < 119)
	{
		//dont print MOTD if tutorial map
		if(!(mapname =="tut1" || mapname =="tut2" || mapname =="tut3" || mapname =="tut4" || mapname =="tut5" || mapname =="tut6" || mapname =="tut7" || mapname =="tut8"))
		{
			centerprint4(self.owner, motd_top1, motd_top2, "\n", motd_bottom);
		}

		self.nextthink = time + 0.1;
		self.count = self.count + 1;

		//allow jump and attack to stop
		if (self.owner.button0 != 0 || self.owner.button2 != 0)	self.cnt = 5;

		if (self.cnt == 5)
		{
			self.owner.style = self.owner.style - STYLE_MOTD;
			centerprint(self.owner, " ");
			remove (self);
		}
		else
		{
			self.count = self.count + 1;
			self.nextthink = time + 0.1;
		}
	}
	else
	{
		self.owner.style = self.owner.style - STYLE_MOTD;
		centerprint(self.owner, " ");
		remove (self);
	}
};

void () motd_create =
{
    local entity intro;
    intro = utils_make_scheduled_event(motd_think, 1.2);
    intro.count = 0;
    intro.cnt = 0;
};