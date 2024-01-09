//
// Addon code
//
#pragma warning disable F321
__accumulate void() worldspawn =
{
    localcmd("bind F1 impulse 100\n");
    localcmd("exec mapcycle.cfg\n");
    //localcmd("exec bloodrails.cfg\n");
    localcmd("sv_maxvelocity 25000\n");
    localcmd("timelimit 10\n");
    localcmd("sv_defaultmap ctf_dissocia_c2\n");   //default map
    localcmd("sys_ticrate 0.0166667\n");
    
	localcmd("fov_adapt 1\n");
	localcmd("viewsize 110\n");
	localcmd("fov 100\n");
	//localcmd("alias fov bf\n"); 
	
	localcmd("cl_gun_fovscale 0\n");
	localcmd("alias cl_gun_fovscale bf\n");

	localcmd("cl_bob 0\n");
	localcmd("alias cl_bob bf\n");
	
	localcmd("cl_rollangle 0\n");
	localcmd("alias cl_rollangle bf\n");
	
	localcmd("cl_screenangle 0\n");
	
	//localcmd("cl_screenangle_speed 2.5\n");
	//localcmd("alias cl_screenangle_speed bf\n");
	
	localcmd("scr_conscale 3.2\n");
	localcmd("alias scr_conscale bf\n");
	
	localcmd("scr_sbarscale 1.5\n");
	localcmd("alias scr_sbarscale bf\n");
	
	localcmd("scr_sbar 3\n");
	localcmd("alias scr_sbar bf\n");
	
	

	
   // localcmd("fraglimit 40\n");
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