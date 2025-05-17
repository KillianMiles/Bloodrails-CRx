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