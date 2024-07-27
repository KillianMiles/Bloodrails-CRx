//
// Addon code
//
#pragma warning disable F321
__accumulate void() worldspawn =
{
    localcmd("bind F1 impulse 100\n");
    localcmd("sv_maxvelocity 25000\n");
    
    
	if(mapname =="tut1" || mapname =="tut2") 
	{
		localcmd("timelimit 0\n");
		localcmd("fraglimit 0\n");
	}
	else 
	{
	localcmd("timelimit 10\n");
	localcmd("scr_matchclock 1\n");
	
	if (elohim_playmode & CLANRING_CTF_MODE) localcmd("fraglimit 120\n");
	else localcmd("fraglimit 40\n");
	
	}
    
    localcmd("sv_defaultmap ctf_dissocia_c2\n");   //default map
    localcmd("sys_ticrate 0.0166667\n");
    
	localcmd("fov_adapt 1\n");
	localcmd("viewsize 110\n");
	

	
	localcmd("cl_gun_fovscale 0.84\n");
	localcmd("gl_polyblend 1\n");
	localcmd("gl_cshiftpercent_damage 21\n");
	
	
	localcmd("cl_rollangle 0\n");
	localcmd("alias cl_rollangle bf\n");
	
	localcmd("cl_screenangle 0\n");
	
	localcmd("scr_conscale 3.2\n");
	localcmd("alias scr_conscale bf\n");
	
	localcmd("scr_sbarscale 1.5\n");
	localcmd("alias scr_sbarscale bf\n");
	
	localcmd("scr_sbar 3\n");
	localcmd("alias scr_sbar bf\n");
	
	localcmd("if vid_width == 2560 scr_matchclock_x -320; if vid_width == 1920 scr_matchclock_x -245\n");
	localcmd("if vid_width == 2560 scr_matchclock_y 50; if vid_width == 1920 scr_matchclock_y 32\n");
	
	
	

	
}
#pragma warning enable F321

float changingMap;
__wrap void() GotoNextMap =
{
    if(changingMap)
        return;
	
	local float a = random()*100;
	
	if(a<4) a = 11;
	else if(a< 8) a = 12;
	else if(a< 12) a = 13;
	else if(a< 16) a = 14;
	else if(a< 20) a = 15;
	else if(a< 24) a = 16;
	else if(a< 28) a = 17;
	else if(a< 32) a = 18;
	else if(a< 36) a = 19;
	else if(a< 40) a = 20;
	else if(a< 44) a = 21;
	else if(a< 48) a = 22;
	else if(a< 52) a = 23;
	else if(a< 56) a = 24;
	else if(a< 60) a = 25;
	else if(a< 64) a = 26;
	else if(a< 68) a = 27;
	else if(a< 72) a = 28;
	else if(a< 76) a = 29;
	else if(a< 80) a = 30;
	else if(a< 84) a = 31;
	else if(a< 88) a = 32;
	else if(a< 92) a = 33;
	else if(a< 96) a = 34;
	else if(a< 100) a = 35;

	

    // Execute nextmap alias, if available
  //  localcmd("nextmap_");
  //  localcmd(mapname);
  //  localcmd("\n");
    
    admin_request_change_level(a);
    
    

    changingMap = TRUE;

    local entity ent = spawn();
    ent.think = prior;
    ent.nextthink = time + 0.25;
}

__wrap void() NextLevel =
{
    local entity o;
		local float a = random()*100;
	
	if(a<4) a = 11;
	else if(a< 8) a = 12;
	else if(a< 12) a = 13;
	else if(a< 16) a = 14;
	else if(a< 20) a = 15;
	else if(a< 24) a = 16;
	else if(a< 28) a = 17;
	else if(a< 32) a = 18;
	else if(a< 36) a = 19;
	else if(a< 40) a = 20;
	else if(a< 44) a = 21;
	else if(a< 48) a = 22;
	else if(a< 52) a = 23;
	else if(a< 56) a = 24;
	else if(a< 60) a = 25;
	else if(a< 64) a = 26;
	else if(a< 68) a = 27;
	else if(a< 72) a = 28;
	else if(a< 76) a = 29;
	else if(a< 80) a = 30;
	else if(a< 84) a = 31;
	else if(a< 88) a = 32;
	else if(a< 92) a = 33;
	else if(a< 96) a = 34;
	else if(a< 100) a = 35;
	
        o = spawn();
        o.classname = "trigger_changelevel";
        
        local string newmapname = strings_get_mapname(a);
        
        /*
        r = random();
		if (r < 0.2)
			o.map = "ctf_dissocia_c2";
		else if (r<0.4)
			o.map = "ctf_edge3_c2";
		else if (r<0.6)
			o.map = "ctf_relic2_b2";
		else if (r<0.8)
			o.map = "ctf_teardown_b2";
		else
			o.map = "ctf_bridge_b1";
			*/
	o.map =newmapname;
   
  

    prior();
}