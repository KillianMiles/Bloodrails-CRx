//
// Options.qc
//
// This is purely bells and whistles, and wouldn't even be here if I
// wan't bored one night when I was waiting for my girlfriend to call.
//
// All code by J.P. Grossman unless otherwise commented.
//
// fields used:
//
// .delay    - time to update display (shared with observer.qc)
//
// .pos1_x    - timelimit
// .pos1_y    - fraglimit/overtime
// .pos1_z    - mode
// .pos2_x    - gibs
// .pos2_y    - teamplay
// .pos2_z    - noexit
// .worldtype - sys_ticrate
// .aflag     - pausable/quad/pent/ring/mode vote
// .t_length  - which option is currently selected
//



// constants
float OPTIONS_PAUSABLE = 1;




//
//  G E T  M O D E
//
//  Returns the current mode.
//
float () options_get_mode =
{
    // if (elohim_playmode & RACE_MODE && !(elohim_playmode & CLANRING_CTF_MODE))
    //     return ADMIN_CTF_PRACTICE_MODE;
    if (elohim_playmode & DM_PUBLIC_MODE)
        return ADMIN_DM_PUBLIC_MODE;
    if (elohim_playmode & RACE_MODE)
        return ADMIN_RACE_MODE;
    if (elohim_playmode & ELOHIM_MATCH_MODE && !(elohim_playmode & CLANRING_CTF_MODE))
        return ADMIN_MATCH_MODE;
    if (elohim_playmode & ELOHIM_MATCH_MODE)
        return ADMIN_CTF_MATCH_MODE;
    if (elohim_playmode & CLANRING_CTF_MODE)
        return ADMIN_CTF_PUBLIC_MODE;
    return ADMIN_NORMAL_MODE;
};



//
//  S T A R T  S E T T I N G
//
//  Called from Admin.qc when the options command is entered.
//
void () options_start_setting =
{
    if (self.style & ELOHIM_SETTING_OPTIONS)
    {
        // cancel
        stuffcmd(self, "play misc/menu2.wav\n");
        self.style = self.style - ELOHIM_SETTING_OPTIONS;
        centerprint(self, " ");
        return;
    }

    // Initialize stuff
    self.t_length = 0;
    self.style = self.style | ELOHIM_SETTING_OPTIONS;

    // get values
    if (elohim_playmode & ELOHIM_MATCH_MODE)
    {
        self.pos1_x = elohim_timelimit;
        self.pos1_y = elohim_overtime;
    }
    else
    {
        self.pos1_x = cvar("timelimit");
        self.pos1_y = cvar("fraglimit");
    }

    self.pos1_z = options_get_mode();

    self.pos2_y = teamplay;
    if (!(teamplay == 0 || teamplay == 1 || teamplay == 2))
        self.pos2_y = 0;

    self.pos2_z = cvar("noexit");
    if (!(self.pos2_z == 0 || self.pos2_z == 1 || self.pos2_z == 2))
        self.pos2_z = 0;

    if (cvar("pausable"))
        self.aflag = OPTIONS_PAUSABLE;
    else
        self.aflag = 0;
    self.aflag = self.aflag | (elohim_playmode &
        (ELOHIM_NO_ARMOR | ELOHIM_NO_QUAD | ELOHIM_NO_PENT | ELOHIM_NO_RING | ELOHIM_MODE_VOTE));    //added ELOHIM_NO_ARMOR

    self.worldtype = cvar("sys_ticrate");

    // show choice

    // play sound
    stuffcmd(self, "play misc/menu2.wav\n");
};

//
//  C H A N G E
//
//  Called when attack is pressed for one of the options.
//
void () options_change =
{
    if (self.t_length == 0)
    {
        // change mode
        if (self.pos1_z == ADMIN_NORMAL_MODE)
        {
            self.pos1_z = ADMIN_RACE_MODE;
            if (elohim_playmode & RACE_MODE)
                self.pos1_x = cvar("timelimit");
            else
                self.pos1_x = 0;
        }
        else if (self.pos1_z == ADMIN_RACE_MODE)
        {
            self.pos1_z = ADMIN_MATCH_MODE;
            self.pos1_x = elohim_timelimit;
            self.pos1_y = elohim_overtime;
        }
        else
        {
            self.pos1_z = ADMIN_NORMAL_MODE;
            if (!(elohim_playmode & (RACE_MODE | ELOHIM_MATCH_MODE)))
                self.pos1_x = cvar("timelimit");
            else
                self.pos1_x = 30;
            self.pos1_y = cvar("fraglimit");
        }
    }
    else if (self.t_length == 1)
    {
        // change timelimit
        if (self.pos1_z == ADMIN_MATCH_MODE)
        {
            self.pos1_x = 5 * ceil(self.pos1_x / 5) + 5;
            if (self.pos1_x > 30)
                self.pos1_x = 5;
        }
        else
        {
            self.pos1_x = 10 * ceil(self.pos1_x / 10) + 10;
            if (self.pos1_x > 60)
                self.pos1_x = 0;
        }
    }
    else if (self.t_length == 2)
    {
        if (self.pos1_z == ADMIN_MATCH_MODE)
        {
            // change overtime
            if (self.pos1_y == 0)
                self.pos1_y = 10;
            else if (self.pos1_y == 10)
                self.pos1_y = 5;
            else
                self.pos1_y = self.pos1_y - 1;
        }
        else
        {
            // change fraglimit
            self.pos1_y = 10 * ceil(self.pos1_y / 10);
            if (self.pos1_y > 40)
                self.pos1_y = 0;
            else
                self.pos1_y = self.pos1_y + 10;
        }
    }
    else if (self.t_length == 3)
    {
	//used to be low gibs stuff
    }
    else if (self.t_length == 4)
    {
        // change teamplay
        if (self.pos2_y == 2)
            self.pos2_y = 0;
        else
            self.pos2_y = self.pos2_y + 1;
    }
    else if (self.t_length == 5)
    {
        //change noexit
        if (self.pos2_z == 2)
            self.pos2_z = 0;
        else
            self.pos2_z = self.pos2_z + 1;
        //self.pos2_z = 1;
    }
    else if (self.t_length == 6)
    {
        // change pausable
        if (self.aflag & OPTIONS_PAUSABLE)
            self.aflag = self.aflag - OPTIONS_PAUSABLE;
        else
            self.aflag = self.aflag + OPTIONS_PAUSABLE;
    }
    else if (self.t_length == 19)
    {
        // change ticrate
        self.worldtype = (ceil(self.worldtype * 100) + 1) / 100;
        if (self.worldtype > 0.1 || self.worldtype < 0.05)
            self.worldtype = 0.05;
    }
    else if (self.t_length == 20)
    {
        // change quad
        if (self.aflag & ELOHIM_NO_QUAD)
            self.aflag = self.aflag - ELOHIM_NO_QUAD;
        else
            self.aflag = self.aflag + ELOHIM_NO_QUAD;
    }
    else if (self.t_length == 21)
    {
        // change pent
        if (self.aflag & ELOHIM_NO_PENT)
            self.aflag = self.aflag - ELOHIM_NO_PENT;
        else
            self.aflag = self.aflag + ELOHIM_NO_PENT;
    }
    else if (self.t_length == 22)
    {
        // change ring
        if (self.aflag & ELOHIM_NO_RING)
            self.aflag = self.aflag - ELOHIM_NO_RING;
        else
            self.aflag = self.aflag + ELOHIM_NO_RING;
    }
    else if (self.t_length == 23)
    {
        // change mode vote
        if (self.aflag & ELOHIM_MODE_VOTE)
            self.aflag = self.aflag - ELOHIM_MODE_VOTE;
        else
            self.aflag = self.aflag + ELOHIM_MODE_VOTE;
    }
    
        else if (self.t_length == 24)
    {
        // change ARMOR
        if (self.aflag & ELOHIM_NO_ARMOR)
            self.aflag = self.aflag - ELOHIM_NO_ARMOR;
        else
            self.aflag = self.aflag + ELOHIM_NO_ARMOR;
    }

    // play sound
    stuffcmd(self, "play misc/br_deplete.wav\n");
};



//
//  F I N I S H  S E T T I N G
//
//  Called when 'done' is selected.
//
void () options_finish_setting =
{
    centerprint(self, " ");

    // play sound
    stuffcmd(self, "play misc/menu2.wav\n");

    // make requested changes
    if (self.pos1_z == ADMIN_MATCH_MODE)
    {
        // match mode
        if (self.pos1_x != elohim_timelimit)
            admin_request_set_timelimit(self.pos1_x);
        if (self.pos1_y != elohim_overtime)
            admin_request_set_overtime(self.pos1_y);
    }
    else if (self.pos1_z == ADMIN_CTF_PUBLIC_MODE)
    {
        if (cvar("fraglimit") != 120)
            elohim_set_fraglimit(120);
        if (cvar("timelimit") != 25)
            utils_set_cvar("timelimit", 25);
        // if (cvar("noexit") != 1)
        //     utils_set_cvar("noexit", 1);
    }
    else
    {
        // normal or practice mode
        if (self.pos1_x != cvar("timelimit"))
            utils_set_cvar("timelimit", self.pos1_x);
        if (self.pos1_y != cvar("fraglimit"))
        {
            elohim_set_fraglimit(self.pos1_y);
        }
        if (self.pos2_y != teamplay)
            admin_set_teamplay(self.pos2_y);
        if (self.pos2_z != cvar("noexit"))
            utils_set_cvar("noexit", self.pos2_z);
    }

    if ((self.aflag & OPTIONS_PAUSABLE) != cvar("pausable"))
    {
        // pausable has changed
        utils_set_cvar("pausable", self.aflag & OPTIONS_PAUSABLE);
        bprint("pausable changed to ");
        utils_bprint_float(self.aflag & OPTIONS_PAUSABLE);
    }
    if (self.worldtype != cvar("sys_ticrate"))
    {
        // ticrate has changed
        local string newtic;
        if (self.worldtype == 0.05)
            newtic = "0.05";
        else if (self.worldtype == 0.06)
            newtic = "0.06";
        else if (self.worldtype == 0.07)
            newtic = "0.07";
        else if (self.worldtype == 0.08)
            newtic = "0.08";
        else if (self.worldtype == 0.09)
            newtic = "0.09";
        else
            newtic = "0.1";
        cvar_set("sys_ticrate", newtic);
        bprint3("sys_ticrate changed to ", newtic, "\n");
    }
    if ((self.aflag & ELOHIM_NO_ARMOR) != (elohim_playmode & ELOHIM_NO_ARMOR))
        admin_set_armor(); // armor has changed
    if ((self.aflag & ELOHIM_NO_QUAD) != (elohim_playmode & ELOHIM_NO_QUAD))
        admin_set_powerups(); // quad has changed
    if ((self.aflag & ELOHIM_NO_PENT) != (elohim_playmode & ELOHIM_NO_PENT))
        admin_set_atx(); // ATX mode
    if ((self.aflag & ELOHIM_NO_RING) != (elohim_playmode & ELOHIM_NO_RING))
        admin_set_airwalk(); // ring has changed
    if ((self.aflag & ELOHIM_MODE_VOTE) != (elohim_playmode & ELOHIM_MODE_VOTE))
        admin_set_mode_vote(); // mode vote has changed
    if (self.pos1_z != options_get_mode())
        admin_init_set_mode();
        //admin_request_set_mode(self.pos1_z);

    self.style = self.style - ELOHIM_SETTING_OPTIONS;
    self.style = self.style - (self.style & ELOHIM_OK_TO_SHOOT);
};

//
//  P R E  T H I N K
//
//  Called from Client.qc while options are being set.
//
void () options_pre_think =
{
    if (!(self.flags & FL_JUMPRELEASED))
    {

        if (!self.button0 && !self.button2)
            self.flags = self.flags | FL_JUMPRELEASED;
    }
    else if (self.button2)
    {
        // go to the next option
        self.flags = self.flags - FL_JUMPRELEASED;
        self.t_length = (self.t_length & 127) + 1;
        if (self.t_length == 9)
            self.t_length = 0;
        if (self.t_length == 25)
            self.t_length = 19;
        if (self.pos1_z == ADMIN_MATCH_MODE)
        {
            if (self.t_length == 4)
                self.t_length = 6;
        }
    }
    else if (self.button0)
    {
        // change option
        self.flags = self.flags - FL_JUMPRELEASED;
        self.t_length = self.t_length & 127;
        if (self.t_length == 8)
        {
            options_finish_setting();
            return;
        }
        else if (self.t_length == 7)
        {
            self.t_length = 19; // go to next screen
            stuffcmd(self, "play misc/menu2.wav\n");
        }
        else if (self.t_length == 24)
        {
            self.t_length = 7;  // go back to main options
            stuffcmd(self, "play misc/menu2.wav\n");
        }
        else
            options_change();          
    }
    else
    {
        // just check to see if we need to update the display
        if (time >= self.delay)
        return;
    }
};

