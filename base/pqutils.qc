void (float to, float f) WriteBytePQ =
{	
	WriteByte(to, (16 + (f / 16)));
	WriteByte(to, (16 + (f & 15)));
};
void (float to, float f)WriteShortPQ =
{	
	local float i;

	i = floor(f / 4096);
	WriteBytePQ (to, i * 16 + (f & 3840 / 256));
	WriteBytePQ (to, f & 255);	
};

float MOD_PROQUAKE = 1;
float PQC_NOP = 1;
float PQC_NEW_TEAM = 2;
float PQC_ERASE_TEAM = 3;
float PQC_TEAM_FRAGS = 4;
float PQC_MATCH_TIME = 5;
float PQC_MATCH_RESET = 6;
float PQC_PING_TIMES = 7;
float MSG_MULTICAST = 4;
float MULTICAST_ONE = 6;
float MULTICAST_ONE_R = 7;
void(vector where, float set) multicast = #82;




void (float tm, float tf) pqc_team_frags_self =   //used for QSSM scoreboard
{
    if (self.style & STYLE_CONNECTED)
    {
		if (tf < 0) tf = tf + 65536;
		msg_entity = self;				
		WriteByte (MSG_ONE, SVC_STUFFCMD);
		WriteByte (MSG_ONE, MOD_PROQUAKE);
		WriteByte (MSG_ONE, PQC_TEAM_FRAGS);
		WriteByte (MSG_ONE, 16 + tm);	// team
		WriteShortPQ (MSG_ONE, tf);	// frags
		WriteString (MSG_ONE, string_null);
    }
};


void (float tm, float tf) pqc_team_frags =
{	
	if (!tm || !tf) return;
	local entity oldself;

    oldself = self;
    self = find(world, classname, "player");

    while (self)
    {
        pqc_team_frags_self(tm, tf);
        self = find(self, classname, "player");
    }
    self = oldself;
};


void(float m, float s)pqc_match_time =     //send match time for QSSM matchclock
{
	local entity oldself;

    oldself = self;
    self = find(world, classname, "player");
    while (self)
    {
        if (self.style & STYLE_CONNECTED)
        {
            msg_entity = self;
            WriteByte(MSG_MULTICAST , SVC_STUFFCMD);
            WriteByte(MSG_MULTICAST , MOD_PROQUAKE);
            WriteByte(MSG_MULTICAST , PQC_MATCH_TIME);
            WriteBytePQ(MSG_MULTICAST , m);
            WriteBytePQ(MSG_MULTICAST , s);
            WriteString(MSG_MULTICAST , string_null);
            multicast('0 0 0', MULTICAST_ONE);
		}
        self = find(self, classname, "player");
    }
    self = oldself;
};