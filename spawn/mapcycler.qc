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
	
		localcmd("timelimit 8\n");// changing default from 10 to 8
		localcmd("scr_matchclock 3\n");
		localcmd("scr_matchclockscale 3.5\n");
	
		if (elohim_playmode & CLANRING_CTF_MODE) localcmd("fraglimit 120\n");
		else localcmd("fraglimit 40\n");
	
	}
    
	localcmd("sv_defaultmap ctf_dissocia_r1\n");   //default map
	localcmd("sys_ticrate 0.0166667\n");
    
    /*
	localcmd("bind F1 impulse 100\n");
	localcmd("fov_adapt 1\n");
	localcmd("viewsize 110\n");
	localcmd("cl_gun_fovscale 0.84\n");
	localcmd("gl_polyblend 1\n");
	localcmd("gl_cshiftpercent_damage 21\n");
	localcmd("cl_rollangle 0\n");
	localcmd("alias cl_rollangle bf\n");
	localcmd("cl_screenangle 0\n");
	localcmd("scr_conscale 3.2\n");
	localcmd("scr_sbarscale 1.5\n");
	localcmd("scr_sbar 3\n");
	localcmd("alias scr_sbar bf\n");
	localcmd("if vid_width == 2560 scr_matchclock_x 70.35; if vid_width == 1920 scr_matchclock_x 70.4\n");
	localcmd("if vid_width == 2560 scr_matchclock_y 87; if vid_width == 1920 scr_matchclock_y 87\n");
	localcmd("if vid_width == 2560 scr_matchclockscale 4.6; if vid_width == 1920 scr_matchclockscale 3.5\n");
	localcmd("if vid_width == 2560 scr_sbarscale 2.1; if vid_width == 1920 scr_sbarscale 1.5\n");
	localcmd("if vid_width == 2560 scr_conscale 3.7; if vid_width == 1920 scr_conscale 3.2\n");
	localcmd("if vid_width == 2560 scr_menuscale 2.1; if vid_width == 1920 scr_menuscale 1.6\n");
	*/
	

	
}
#pragma warning enable F321

float changingMap;
__wrap void() GotoNextMap =
{
    if(changingMap)
        return;
	
	
	maplist = cvar("saved4");
	
	if(maplist >= 8388607) 
	{
		maplist =0;
		//bprint("zero out");
	}
	
	if(mapname == "ctf_takayama_r1" && !(maplist & 1)) maplist = maplist | 1;
	else if(mapname == "ctf_dissocia_r1" && !(maplist & 2)) maplist = maplist | 2;


	
	local float a = random()*100;
	local float b =0, step =25, c;
	
	local float sign = random();
	
	if(a<4)        {b =1;}
	else if(a< 8)  {b =2;}
	else if(a< 12) {b =4;}
	else if(a< 16) {b =8;}
	else if(a< 20) {b =16;}
	else if(a< 24) {b =32;}
	else if(a< 28) {b =64;}
	else if(a< 32) {b =128;}
	else if(a< 36) {b =256;}
	else if(a< 40) {b =512;}
	else if(a< 44) {b =1024;}
	else if(a< 48) {b =2048;}
	else if(a< 52) {b =4096;}
	else if(a< 56) {b =8192;}
	else if(a< 60) {b =16384;}
	else if(a< 64) {b =32768;}
	else if(a< 68) {b =65536;}
	else if(a< 72) {b =131072;}
	else if(a< 76) {b =262144;}
	else if(a< 85) {b =524288;}
	else if(a< 90) {b =1048576;}
	else if(a< 95) {b =2097152;}
	else if(a<= 100) {b =4194304;}
	//else if(a< 96) {b =8388608;}
	//else if(a< 100) {b =16777216;}


	while(step)
	{
		//bprint(ftos(b));
		//bprint("  ");
		
		if(maplist & b)
		{
			b = b*2;
			if(b >=8388607) b = 1;
			
		}
		else if(!(maplist & b)) 
		{
			maplist = maplist | b;
			cvar_set("saved4", ftos(maplist));
			current_map = b;
			step = 1;
			break;
		}
		
		step = step-1;
	}
	
	if(b >=8388608) b = 1;
	

	if     (b ==1) c =11;
	else if(b ==2) c =12;
	else if(b ==4) c =13;
	else if(b ==8) c =14;
	else if(b ==16) c =15;
	else if(b ==32) c =17;
	else if(b ==64) c =18;
	else if(b ==128) c =19;
	else if(b ==256) c =20;
	else if(b ==512) c =21;
	else if(b ==1024) c =22;
	else if(b ==2048) c =23;
	else if(b ==4096) c =24;
	else if(b ==8192) c =25;
	else if(b ==16384) c =26;
	else if(b ==32768) c =27;
	else if(b ==65536) c =28;
	else if(b ==131072) c =29;
	else if(b ==262144) c =30;
	else if(b ==524288) c =31;
	else if(b ==1048576) c =32;
	else if(b ==2097152) c =33;
	else if(b ==4194304) c =34;
	
	//bprint("\nb = ");
	//bprint(ftos(b));
	//bprint("  ");
	

	//bprint("\nmaplist = ");
	//bprint(ftos(maplist));
	//bprint("  ");
	
	//if(maplist & (1 + 2 + 4 + 8 + 16 + 32 + 64 + 128 + 256 + 512 + 1024 + 2048 + 4096 + 8192 + 16384 + 32768 + 65536 + 131072 + 262144 + 524288 + 1048576 + 2097152 + 4194304)) 
	
	if(maplist >= 8388607)
	{
		maplist =0;
		cvar_set("saved4", "0");
		bprint("map set complete!\n");
	}
		

	local string newmap = strings_get_mapname(c);
	
	//bprint(ftos(c));
	//bprint("   MAP!!\n");
	
	request_mapname = newmap;
        admin_change_level();
    
    

    changingMap = TRUE;

    local entity ent = spawn();
    ent.think = prior;
    ent.nextthink = time + 0.25;
}
