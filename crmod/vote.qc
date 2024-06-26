//
// vote.qc
//
// This file contains code to implement voting.  All votes consist of an
// initial request followed by a 21 second vote.  elohim_request contains
// the request strings.
//
// For all requests .use points to a function which is called when
// the vote passes, and .th_die points to a function which is called when
// the vote dies.  The die function is optional; the pass function must
// be passed to vote_init.  Sample usage:
//
//    vote_init("change level to ", newmap, admin_change_level);
//    vote_yes();
//
// Written by J.P. Grossman, modified by bucksh0t.
//

// Function declarations
void () vote_repeat;
void () vote_accept;
void () vote_reject;
void () vote_clear;
float () vote_majority;
void () SUB_Null;

//
//  I N I T
//
//  Prints a message composed of strings s1 and s2 and initializes
//  a vote (if one is not already in progress).  'accept' is a
//  function that is called when the vote passes.
//
//  Returns TRUE if successful, FALSE otherwise.
//
float (string s1, string s2, void () accept) vote_init =
{
    // Check to see if there's already a vote in progress
    if (elohim_request)
    {
        sprint(self, "There is already a vote in progress\n");
        return FALSE;
    }

    elohim_request = spawn();
    elohim_request.classname = "elohim_request";
    elohim_request.th_die = SUB_Null;
    elohim_request.think = vote_repeat;
    elohim_request.use = accept;
    elohim_request.wad = s1;
    elohim_request.map = s2;
    elohim_request.count = 0;
    utils_do_players(vote_clear);

    // If there's only one voter then it will pass as soon as that
    // person votes yes; not need to print the request.
    if (!vote_majority())
        vote_repeat();

    return TRUE;
};

//
//  C L E A R
//
void () vote_clear =
{
    self.style = self.style - (self.style & ELOHIM_YES);
};

//
//  Y E S
//
//  Called when a player votes yes.
//
void () vote_yes =
{
    if (self.style & ELOHIM_ADMINISTRATOR)
    {
        // accept immediately
        vote_accept();
        return;
    }

    if (self.style & ELOHIM_YES)
    {
        sprint(self, "\nWise man say: \"Vote early, vote often\"\n");
        return;
    }

    self.style = self.style | ELOHIM_YES;
    if (vote_majority())
        vote_accept();
};

//
//  N O
//
//  Called when a player votes no.
//
void () vote_no =
{
    if (self.style & ELOHIM_ADMINISTRATOR)
    {
        // reject immediately
        vote_reject();
        return;
    }

    vote_clear();
};

//
//  M A J O R I T Y
//
//  Return TRUE if the majority of players have responded 'yes',
//  FALSE otherwise.  Observers only get x% of a vote based on number of players.
//
float () vote_majority =
{
    local entity player;
    local float vote_count, players;

    players = vote_count = 0;

    player = find(world, classname, "player");
    while (player)
    {
        if ((player.style & ELOHIM_CONNECTED) && (!(player.style & CRMOD_QSMACK)))
        {
            players = players + 1;
        }
        player = find(player, classname, "player");
    }

    if (players < 2)
        return TRUE;

    player = find(world, classname, "player");
    while (player)
    {
        if ((player.style & ELOHIM_CONNECTED) && (!(player.style & CRMOD_QSMACK)))        // CRMOD don't count qsmack
        {
            if (player.style & ELOHIM_YES || player == self)
                vote_count = vote_count + 1;
        }
        player = find(player, classname, "player");
    }
    if (vote_count > 1)
        return TRUE;
    if (vote_count == 1 && players == 2)
        return TRUE;
    //if (vote_count > 1 && players > 2)
     //   return TRUE;
        
    return FALSE;
};

//
//  R E P E A T
//
//  Print the request; schedule the next automatic action.
//  elohim_request.count counts the number of times the request
//  has been displayed.
//
void () vote_repeat =
{
    bprint4("Request to ", elohim_request.wad, elohim_request.map, "\n");
    bprint("Type 'yes' in console to pass\n");
    elohim_request.nextthink = time + 7;
    elohim_request.count = elohim_request.count + 1;
    if (elohim_request.count == 3)
        elohim_request.think = vote_reject;
};

//
//  A C C E P T
//
void () vote_accept =
{
    elohim_request.use();
    remove(elohim_request);
    elohim_request = world;
};

//
//  R E J E C T
//
//  Called when the vote is cancelled by an administrator or
//  21 seconds elapse.
//
void () vote_reject =
{
    bprint("Vote cancelled\n");
    elohim_request.th_die();
    remove(elohim_request);
    elohim_request = world;
};

//
//  I M P U L S E
//
void () vote_impulse =
{
    if (!elohim_request)
    {
        sprint(self, "Nothing to vote on\n");
        return;
    }

    if (self.impulse == 115)
        vote_yes();
    else if (self.impulse == 116)
        vote_no();
};
