void() spawn_new_entities;
void() update_old_entities;
void() InitBodyQue;
//string(string title) GetMapName;
void client_responsetime_get_all();

void() main =
{
	dprint ("main function\n");
	
// these are just commands the the prog compiler to copy these files

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");


//
// these are all of the lumps from the cached.ls files
//
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");
	precache_file2 ("gfx/pop.lmp");
	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");
	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");
	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");
	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	precache_file ("gfx/mp_menu.lmp");
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	precache_file ("gfx/sell.lmp");
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");
	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");
	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
	precache_sound ("bloodrailz/misc/menu1.wav");
	precache_sound ("bloodrailz/misc/menu2.wav");
	precache_sound ("bloodrailz/misc/menu3.wav");
	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");



};

entity	lastspawn;
entity	lastspawn_red;
entity	lastspawn_blue;
//entity  lastspawn_ra;

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.
Set message to the level name.
Set sounds to the cd track to play.

World Types:
0: medieval
1: metal
2: base
*/
//=======================
void() worldspawn =
{
	lastspawn = world;
	lastspawn_blue = world;
	lastspawn_red = world;
	runespawn = world;
	
	elohim_playmode = cvar("samelevel");
	ctf_precache();
	runes_precache();
	bloodrails_precache();

	elohim_num_spawns = 0;
	elohim_num_redspawns = 0;
	elohim_num_bluespawns = 0;

	cvar_set("scr_usekfont", "0");
	if (elohim_playmode & CLANRING_CTF_MODE || elohim_playmode & CLAN_ARENA_MODE)
		cvar_set("teamplay", "4");
	else if (elohim_playmode & ELOHIM_MATCH_MODE)
		cvar_set("teamplay","2");
	else
    	cvar_set("teamplay", "0");
	cvar_set("noexit", "1");

// custom map attributes
	if (self.model == "maps/e1m8.bsp")	cvar_set ("sv_gravity", "100");
	else					cvar_set ("sv_gravity", "800");

// custom map title
	//self.message = GetMapName(self.message);
	

	


	precache_sound ("bloodrailz/misc/talk.wav");		// talk
	precache_sound ("bloodrailz/player/teledth1.wav");		// telefrag
	precache_sound ("bloodrailz/misc/r_tele1.wav");		// teleport sounds
	precache_sound ("bloodrailz/misc/r_tele2.wav");
	precache_sound ("bloodrailz/misc/r_tele3.wav");
	precache_sound ("bloodrailz/misc/r_tele4.wav");
	precache_sound ("bloodrailz/misc/r_tele5.wav");


// player gib sounds

	

// player pain sounds




// ax sounds	







	precache_sound ("doors/drclos4.wav");

	precache_model ("progs/bloodrailz/player.mdl");
	precache_model ("progs/bloodrailz/h_player.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_model ("progs/bloodrailz/s_bubble.spr");	// LibreQuake //drowning bubbles
	precache_model ("progs/bloodrailz/s_explod.spr");	// LibreQuake //sprite explosion
	
//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//

	// 0 normal
	lightstyle(0, "m");
	
	// 1 FLICKER (first variety)
	//lightstyle(1, "mmnmmommommnonmmonqnmmo");
	lightstyle(1, "m");
	
	// 2 SLOW STRONG PULSE
	//lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle(2, "m");
	
	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	
	// 4 FAST STROBE
	//lightstyle(4, "mamamamamama");
	lightstyle(4, "m");
	
	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	
	// 6 FLICKER (second variety)
	//lightstyle(6, "nmonqnmomnmomomno");
	lightstyle(6, "m");
	
	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	
	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	
	// 9 SLOW STROBE (fourth variety)
	//lightstyle(9, "aaaaaaaazzzzzzzz");
	lightstyle(9, "m");
	
	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	
	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");
	
	//TODO: no bot support right now
	//localcmd("bot_reloadsettings\n");
	
	if (mode_is_arena() == FALSE)
	{
		spawn_new_entities();
	}

    // ELOHIM_MOD - do elohim specific stuff
    elohim_init_world();
    // END_MOD

	if (elohim_playmode & CLANRING_RUNES)
	{
		local entity stspawn;
		stspawn = spawn();
		stspawn.nextthink = time + 0.5;
		stspawn.think = rune_spawn_start;
	}
		
		
};

void() StartFrame =
{
	// Framecount 2 is the frame after .cfg was loaded
	if(framecount == 2)
	{
		update_old_entities();
	}

    // teamplay = cvar("teamplay"); // ELOHIM_MOD - moved to elohim_start_frame
    skill = cvar("skill"); // ELOHIM_MOD - unused
	framecount = framecount + 1;
	
	if (time > responsetimecheck)
	{
		responsetimecheck = (time + 10);
		client_responsetime_get_all();
	}

    // ELOHIM_MOD - do elohim specific stuff
    elohim_start_frame();
    // END_MOD
    
};



/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyque_head;

void() bodyque =
{	// just here so spawn functions don't complain after the world
	// creates bodyques
};

void() InitBodyQue =
{
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin (bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};