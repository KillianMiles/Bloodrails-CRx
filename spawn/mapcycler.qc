//
// Addon code
//
#pragma warning disable F321
__accumulate void() worldspawn =
{
    localcmd("bind F1 impulse 100\n");
    localcmd("exec mapcycle.cfg\n");
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
	
	

	
}
#pragma warning enable F321

float changingMap;
__wrap void() GotoNextMap =
{
    if(changingMap)
        return;

    // Execute nextmap alias, if available
    localcmd("nextmap_");
    localcmd(mapname);
    localcmd("\n");

    changingMap = TRUE;

    local entity ent = spawn();
    ent.think = prior;
    ent.nextthink = time + 0.25;
}

__wrap void() NextLevel =
{
    local entity o = find(world, classname, "trigger_changelevel");
    local float r;

    // Create a fake trigger changelevel if it doesn't exist
    if(!o)
    {
        o = spawn();
        o.classname = "trigger_changelevel";
        
        r = random();
		if (r < 0.2)
			o.map = "ctf_dissocia_c2";
		else if (r<0.4)
			o.map = "ctf_edge3_c1";
		else if (r<0.6)
			o.map = "ctf_relic2_b2";
		else if (r<0.8)
			o.map = "ctf_teardown_b2";
		else
			o.map = "ctf_bridge_b1";
   
    }

    prior();
}