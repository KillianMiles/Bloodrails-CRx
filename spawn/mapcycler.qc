

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
	
		localcmd("timelimit 8.05\n");// changing default from 10 to 8
		localcmd("sys_throttle 0.002\n");
		localcmd("net_messagetimeout 60\n");
		
		
	
		if (elohim_playmode & CLANRING_CTF_MODE) localcmd("fraglimit 120\n");
		else localcmd("fraglimit 40\n");
	
	}
    
	localcmd("sv_defaultmap ctf_dissocia_r1\n");   //default map
	localcmd("sys_ticrate 0.01666667\n");
	//localcmd("sys_ticrate 0.015625\n");
	

	
}
#pragma warning enable F321


float changingMap;
__wrap void() GotoNextMap =
{
	if(changingMap) return;
	
	
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





//MAP_ENTS

void () spawn_pubtdm_entities ={};
void () update_pubtdm_entities ={};
void () spawn_ctf_entities = {};
void () update_ctf_entities ={};

void () spawn_race_entities =
{
	if (mapname == "race19")
	{
		Maps_SpawnPent ('1664 -4740 24');
		Maps_SpawnRing ('5783 4210 -1895');
	}
	else if (mapname == "race18")
	{
		Maps_SpawnPent ('-3407 -3095 1064');
		Maps_SpawnRing ('802 978 48');
	}
	else if (mapname == "race16")
	{
		Maps_SpawnPent ('150 3622 2136');
		Maps_SpawnRing ('125 -2784 -2440');
	}
	else if (mapname == "race15")
	{
		Maps_SpawnPent ('-261 96 24');
		Maps_SpawnRing ('452 -2725 -2823');
	}
	else if (mapname == "race14")
	{
		Maps_SpawnPent ('-5267 -595 2696');
		Maps_SpawnRing ('-2486 -2751 -4000');
	}
	else if (mapname == "race11")
	{
		Maps_SpawnPent ('-1138 3151 2752');
		Maps_SpawnRing ('-3347 3781 -2184');
	}
	else if (mapname == "race_valley_b2")
	{
		Maps_SpawnPent ('-2313 -2595 740');
		Maps_SpawnRing ('550 500 330');
	}
	else if (mapname == "race_valley_b2")
	{
		Maps_SpawnPent ('-2313 -2595 740');
		Maps_SpawnRing ('550 500 250');
	}
	else if (mapname == "race_orange_b1")
	{
		Maps_SpawnPent ('-71 -102 40');
		Maps_SpawnRing ('433 -241 2328');
	}
	else if (mapname == "slide2")
	{
		Maps_SpawnPent ('-1596 2426 2736');
		Maps_SpawnRing ('1824 -699 920');
	}
	else if (mapname == "slide5")
	{
		Maps_SpawnPent ('2367 3305 3224');
		Maps_SpawnRing ('1523 192 -1255');
	}
	else if (mapname == "slide7")
	{
		Maps_SpawnPent ('285 -8 2072');
		Maps_SpawnRing ('2844 2242 -3287');
	}
	else if (mapname == "petra")
	{
		Maps_SpawnPent ('-3436 -2686 3832');
		Maps_SpawnRing ('1250 3481 -711');
	}
	else if (mapname == "tut1")
	{

	}

};



void () spawn_new_entities =
{
	if (elohim_playmode & CLANRING_CTF_MODE) spawn_ctf_entities();
	else if (elohim_playmode & DM_PUBLIC_MODE) spawn_pubtdm_entities();
	else if(elohim_playmode & RACE_MODE) spawn_race_entities();
};

void () update_old_entities = 
{
	if (elohim_playmode & CLANRING_CTF_MODE) update_ctf_entities();
	else if (elohim_playmode & DM_PUBLIC_MODE) update_pubtdm_entities();
};