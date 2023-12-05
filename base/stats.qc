//
// Stats.qc
//
// Various routines for displaying statistics.
//
// All code by J.P. Grossman unless otherwise commented.
//

//
//  P R O T O T Y P E S
//
void (float frac, float tot) stats_print_percent3;


//
//  R E S E T  S T A T S
//
void () stats_reset =
{
    self.dest1 = self.dest2 = self.dest = self.mangle = '0 0 0';
	self.crmod_qdwep = self.crmod_qdkill = '0 0 0';
    self.crmod_did_damage = 0; // CRMOD moved here from put_client_in_server

    //self.dmg_given_round = 0;
};



//
//  S H O W  K I L L S T A T S
//
void () stats_show_killstats =
{
    local entity player;

    sprint(self, "opp - number of opponents killed\n");
    sprint(self, "slf - number of times killed self\n");
    sprint(self, "tm  - number of teammates killed\n");
    sprint(self, "kld - number of times killed by enemy\n");
    sprint(self, "\n");
    sprint(self, "frags|opp|slf|tm |kld|     name\n");
	sprint(self, "-----|---|---|---|---|---------------\n");

    player = find(world, classname, "player");
    while (player)
    {
        if ((player.style & ELOHIM_CONNECTED) &&
            !(player.style & ELOHIM_OBSERVER))
        {
            if (player == self)
            {
                sprint(self, "[");
                utils_print_int3(player.frags);
                sprint(self, "]|");
            }
            else
            {
                sprint(self, " ");
                utils_print_int3(player.frags);
                sprint(self, " |");
            }
            utils_print_int3(player.frags + player.mangle_x + player.mangle_y);
            sprint(self, "|");
            utils_print_int3(player.mangle_x);
            sprint(self, "|");
            utils_print_int3(player.mangle_y);
            sprint(self, "|");
            utils_print_int3(player.mangle_z);
            sprint3(self, "|", player.netname, "\n");
        }
        player = find(player, classname, "player");
    }
};

//
//  P R I N T  P E R C E N T 3
//
//  Helper function for stats_show_efficiency.  Prints the percentage
//  100 * (frac / tot) as a 3 character integer, or N/A if tot = 0.
//
void (float frac, float tot) stats_print_percent3 =
{
    if (tot)
    {
        local float n;
        local string temp;

        n = floor(100 * frac / tot);
        if (n < 10)
            sprint(self, " ");
        temp = ftos(n);
        sprint(self, temp);
        if (n < 100)
            sprint(self, "%");
    }
    else
        sprint(self, "N/A");
};

//
//  S H O W  E F F I C I E N C Y
//
//  Show the weapon efficiency for each player.
//
void () stats_show_efficiency =
{
    local entity player;
    local float tot_fired, tot_done;

    sprint(self, "bul - bullet efficiency\n");
    sprint(self, "nls - nail efficiency\n");
    sprint(self, "rox - rocket efficiency\n");
    sprint(self, "lg  - lightning gun efficiency\n");
    sprint(self, "\n");
    sprint(self, "bul|nls|rox|lg |total|     name\n");
    sprint(self, "---|---|---|---|-----|---------------\n");

    player = find(world, classname, "player");
    while (player)
    {
        if ((player.style & ELOHIM_CONNECTED) &&
            !(player.style & ELOHIM_OBSERVER))
        {
            stats_print_percent3(player.dest2_x, player.dest1_x);
            sprint(self, "|");
            stats_print_percent3(player.dest2_y, player.dest1_y);
            sprint(self, "|");
            stats_print_percent3(player.dest_y, player.dest_x);
            sprint(self, "|");
            stats_print_percent3(player.dest2_z, player.dest1_z);
            sprint(self, "|");

            tot_fired = player.dest1_x + player.dest1_y + player.dest1_z +
                        player.dest_x;
            tot_done = player.dest2_x + player.dest2_y + player.dest2_z +
                       player.dest_y;
            if (player == self)
            {
                sprint(self, "[");
                stats_print_percent3(tot_done, tot_fired);
                sprint(self, "]|");
            }
            else
            {
                sprint(self, " ");
                stats_print_percent3(tot_done, tot_fired);
                sprint(self, " |");
            }
            sprint2(self, player.netname, "\n");
        }
        player = find(player, classname, "player");
    }
};

//
//  S H O W  S U M M A R Y
//
//  Show kill and weapon efficiency for each player.
//
void () stats_show_summary =
{
    local entity player;
    local float wfrac, wtot, kfrac, ktot, doit, currteam;
    local string teamname;

    sprint(self, "kill  - kill efficiency\n");
    sprint(self, "weapn - weapon efficiency\n");
    sprint(self, "\n");
    if (elohim_state & ELOHIM_MATCH_STARTED)
    {
        sprint(self, "   team  |kill |weapn|     name\n");
        sprint(self, "---------|-----|-----|---------------\n");
        currteam = elohim_team1;
        doit = 2;
    }
    else
    {
        sprint(self, "kill |weapn|     name\n");
        sprint(self, "-----|-----|----------------\n");
        currteam = 0;
        doit = 1;
    }

    while (doit)
    {
        teamname = strings_get_teamname3(currteam);
        player = find(world, classname, "player");
        while (player)
        {
            if ((player.style & ELOHIM_CONNECTED) &&
                !(player.style & ELOHIM_OBSERVER) &&
                (!currteam || player.height == currteam))
            {
                if (currteam)
                    sprint2(self, teamname, "|");

                kfrac = player.frags + player.mangle_x + player.mangle_y;
                ktot = kfrac + player.mangle_x + player.mangle_y +
                       player.mangle_z;
                wtot = player.dest1_x + player.dest1_y + player.dest1_z +
                       player.dest_x;
                wfrac = player.dest2_x + player.dest2_y + player.dest2_z +
                        player.dest_y;
                if (player == self)
                {
                    sprint(self, "[");
                    stats_print_percent3(kfrac, ktot);
                    sprint(self, "]|[");
                    stats_print_percent3(wfrac, wtot);
                    sprint(self, "]|");
                }
                else
                {
                    sprint(self, " ");
                    stats_print_percent3(kfrac, ktot);
                    sprint(self, " | ");
                    stats_print_percent3(wfrac, wtot);
                    sprint(self, " |");
                }
                sprint2(self, player.netname, "\n");
            }
            player = find(player, classname, "player");
        }
        currteam = elohim_team2;
        doit = doit - 1;
    }
};

void () stats_show_all =
{
    sprint(self, "\n");
    sprint(self, "match statistics\n");
    sprint(self, "-------------------------------------\n");
    sprint(self, "summary\n");
    sprint(self, "\n");
    stats_show_summary();
    sprint(self, "\n");
    sprint(self, "-------------------------------------\n");
    sprint(self, "efficiency\n");
    sprint(self, "\n");
    stats_show_efficiency();
    sprint(self, "\n");
    sprint(self, "-------------------------------------\n");
    sprint(self, "kill stats\n");
    sprint(self, "\n");
    stats_show_killstats();
    if (mode_is_arena() == FALSE)
    {
        sprint(self, "\n");
        sprint(self, "-------------------------------------\n");
        sprint(self, "quad stats\n");
        sprint(self, "\n");
    }
    sprint(self, "\n");
};