string motd_top1;
string motd_top2;
string motd_bottom;

//  I N I T  W O R L D
//
//  Initialize the motd strings
//
void () motd_init_world =
{
	motd_top1 = "\bBloodrailZ CRx\b\nby kilomiles\nwww.crxquake.com\n";
	motd_top2 = "\n\npress '\bf10\b' for help\n\n";
	motd_bottom =  "special thanks to\n\n bucksh0t\b|\bteamred\b|\bxstephx\b\n\bDERZIE\b|\b woods \b|\breki\n\n\n\n\n";
};

void () motd_think =
{
	if(mapname == "tut1" || mapname == "tut2") return;
	
	if ((self.count == 0) && (self.owner.style & ELOHIM_MOTD))
	{
			remove(self);
			return;
	}
	
	//if (self.owner.suppress_hud ==1)
	//{
	//		remove(self);
	//		return;
	//}
	
	if (!(self.owner.style & ELOHIM_MOTD))			self.owner.style = self.owner.style | ELOHIM_MOTD;

	if (self.count < 119)
	{
			//nobody wants to read stuff, especially in match browser
			if(!(mapname =="tut1" || mapname =="tut2" || mapname =="tut3" || mapname =="tut4" || mapname =="tut5" || mapname =="tut6" || mapname =="tut7" || mapname =="tut8"))   //dont print MOTD if tutorial map
			{
				centerprint4(self.owner, motd_top1, motd_top2, "\n", motd_bottom);
			}

			self.nextthink = time + 0.1;
			self.count = self.count + 1;

			// CRMOD - so people can stop motd
			if (self.owner.button0 != 0 || self.owner.button2 != 0)		self.cnt = 5;
			// CRMOD END

			if (self.cnt == 5)
			{
				self.owner.style = self.owner.style - ELOHIM_MOTD;
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
			self.owner.style = self.owner.style - ELOHIM_MOTD;
			centerprint(self.owner, " ");
			remove (self);
	}
};

//
//  C R E A T E
//
//  Create an entity to display the MOTD for 10 seconds (plus a bit).
//
void () motd_create =
{
    local entity intro;
    intro = utils_make_scheduled_event(motd_think, 1.2);
    intro.count = 0;
    intro.cnt = 0;
};