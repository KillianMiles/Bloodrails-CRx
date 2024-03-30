void () spawn_ctf_entities;
void () update_ctf_entities;



void () spawn_pubtdm_entities =
{

};

void () update_pubtdm_entities =
{

};

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

};





void () spawn_new_entities =
{
	if (elohim_playmode & CLANRING_CTF_MODE)
	{
		spawn_ctf_entities();
	}
	else if (elohim_playmode & DM_PUBLIC_MODE)
	{
		spawn_pubtdm_entities();
	}
	else if(elohim_playmode & RACE_MODE)
	{
		spawn_race_entities();
	}
	else
	{
		if (mapname == "aerowalk")
		{
			Maps_SpawnQuad('-895 -878 248');
		}
	
		else if (mapname == "dm7")
		{
			Maps_SpawnQuad ('1140 660 472');
			Maps_SpawnPent ('20 832 472');
			Maps_SpawnRing ('1458 -180 664');
			if (elohim_playmode & ELOHIM_MATCH_MODE)
			{
				Maps_CreateFishSpot('123 192 232');
				Maps_CreateFishSpot('215 192 232');
				Maps_CreateFishSpot('365 194 216');
				Maps_CreateFishSpot('455 194 216');
				Maps_CreateFishSpot('525 75 296');
			}
		}
		else if (mapname == "dm3")
		{
			if (elohim_playmode & ELOHIM_MATCH_MODE)
			{
				Maps_CreateFishSpot('1655 -227 -391');
				Maps_CreateFishSpot('1665 198 -391');
				Maps_CreateFishSpot('1486 -242 -391');
				Maps_CreateFishSpot('1423 706 -359');
				Maps_CreateFishSpot('1319 759 -359');
			}
		}
		else if (mapname == "dm4")
		{
			if (elohim_playmode & ELOHIM_MATCH_MODE)
			{
				Maps_CreateFishSpot('130 -88 -439');
				Maps_CreateFishSpot('269 -105 -439');
				Maps_CreateFishSpot('146 -347 -439');
				Maps_CreateFishSpot('289 -343 -439');
				Maps_CreateFishSpot('400 -354 -439');
			}
		}
		else if (mapname == "endif")
		{
			Maps_SpawnQuad('256 -256 -520');
		}
	}
};

void () remove_pent =
{
	utils_do_item(SUB_Remove, "item_artifact_invulnerability");
	remove(self);
};

void () update_old_entities = 
{
	if (elohim_playmode & CLANRING_CTF_MODE)
	{
		update_ctf_entities();
	}
	else if (elohim_playmode & DM_PUBLIC_MODE)
	{
		update_pubtdm_entities();
	}
};



void () spawn_ctf_entities =
{
    if (mapname == "dm1")
    {
        Maps_SpawnArmor1('1005 1424 72');
        Maps_SpawnWeaponRocketLauncher('424 1558 -119');
        Maps_SpawnWeaponLightning('581 597 24');
        Maps_SpawnWeaponSuperNailgun('254 1418 -120');
        //Maps_SpawnItemSpikes(TRUE,'-160 1502 -119');
        Maps_SpawnItemCells(FALSE,'241 595 24');
        Maps_SpawnItemCells(TRUE, '464 740 -119');
        Maps_SpawnItemCells(TRUE,'200 1032 0');
        Maps_SpawnItemRockets(FALSE,'415 1484 -119');
        Maps_SpawnItemRockets(TRUE,'-608 1597 24');
        Maps_SpawnQuad('140 1156 -120');
        Maps_RedSpawn('827 1237 24','0 90 0');
        Maps_RedSpawn('827 1100 24','0 90 0');
        Maps_RedSpawn('827 980 24','0 90 0');
        Maps_RedSpawn('586 1237 24','0 90 0');
        Maps_RedSpawn('586 1100 24','0 90 0');
        Maps_RedSpawn('586 980 24','0 90 0');
        Maps_RedSpawn('702 1237 60','0 90 0');
        Maps_RedSpawn('702 1100 60','0 90 0');
        Maps_BlueSpawn('-669 1609 24','0 0 0');
        Maps_BlueSpawn('-669 1410 24','0 0 0');
        Maps_BlueSpawn('-669 1224 24','0 0 0');
        Maps_BlueSpawn('-552 1410 24','0 0 0');
        Maps_BlueSpawn('-552 1224 24','0 0 0');
        Maps_BlueSpawn('-552 1410 24','0 0 0');
        Maps_SpawnRedFlag('827 920 24');
        Maps_SpawnBlueFlag('-676 1270 24');
    }
    else if (mapname == "dm2")
    {
        Maps_SpawnWeaponLightning('1698 -1506 24');
        Maps_SpawnItemCells(FALSE,'1698 -1658 24');
        Maps_SpawnItemCells(FALSE,'1698 -1702 24');
        Maps_SpawnItemCells(FALSE,'2568 -40 120');
        Maps_RedSpawn('1288 -1113 344','0 0 0');
        Maps_RedSpawn('1288 -762 344','0 0 0');
        Maps_RedSpawn('1369 -762 344','0 0 0');
        Maps_RedSpawn('1369 -1113 344','0 0 0');
        Maps_RedSpawn('2652 -75 -71','0 90 0');
        Maps_RedSpawn('2652 50 -71','0 90 0');
        Maps_RedSpawn('2652 205 -71','0 90 0');
        Maps_BlueSpawn('2178 -2323 88','0 90 0');
        Maps_BlueSpawn('2178 -2250 88','0 90 0');
        Maps_BlueSpawn('2178 -2170 88','0 90 0');
        Maps_BlueSpawn('2178 -2100 88','0 90 0');
        Maps_BlueSpawn('2178 -2000 88','0 90 0');
        Maps_BlueSpawn('2178 -2323 188','0 90 0');
        Maps_SpawnRedFlag('2247 -40 -135');
        Maps_SpawnBlueFlag('2422 -2302 120');
    }
    else if (mapname == "dm3")
    {
        Maps_RedSpawn('-105 800 120','0 0 0');
        Maps_RedSpawn('-242 845 120','0 0 0');
        Maps_RedSpawn('-405 845 120','0 0 0');
        Maps_RedSpawn('-541 845 120','0 0 0');
        Maps_RedSpawn('-686 845 120','0 0 0');
        Maps_RedSpawn('-846 845 120','0 0 0');

        Maps_BlueSpawn('1534 -648 -23','0 180 0');
        Maps_BlueSpawn('1710 -648 -23','0 180 0');
        Maps_BlueSpawn('1887 -648 -23','0 180 0');
        Maps_BlueSpawn('1534 -784 -23','0 180 0');
        Maps_BlueSpawn('1710 -784 -23','0 180 0');
        Maps_BlueSpawn('1887 -784 -23','0 180 0');

        Maps_SpawnRedFlag('-504 512 120');
        Maps_SpawnBlueFlag('1760 -672 -24');
    }
    if (mapname == "dm4")
    {
        Maps_RedSpawn('-73 389 -295','0 -90 0');
        Maps_RedSpawn('-73 310 -295','0 -90 0');
        Maps_RedSpawn('-73 230 -295','0 -90 0');
        Maps_RedSpawn('-73 140 -295','0 -90 0');
        Maps_RedSpawn('-63 20 -295','0 -90 0');
        Maps_RedSpawn('-51 -120 -295','0 -90 0');
        Maps_RedSpawn('-51 -237 -295','0 -90 0');
        Maps_BlueSpawn('787 -448 -103','0 180 0');
        Maps_BlueSpawn('900 -448 -103','0 180 0');
        Maps_BlueSpawn('1040 -448 -103','0 180 0');
        Maps_BlueSpawn('787 -589 -103','0 180 0');
        Maps_BlueSpawn('900 -589 -103','0 180 0');
        Maps_BlueSpawn('1040 -589 -103','0 180 0');
        Maps_SpawnRedFlag('-87 445 -295');
        Maps_SpawnBlueFlag('995 -505 -103');
    }
    if (mapname == "dm5")
    {
        Maps_SpawnQuad('648 8 -8');
        Maps_SpawnArmor1('411 554 -8');
        Maps_SpawnWeaponSuperShotgun('-87 27 40');
        Maps_RedSpawn('205 968 120','0 -90 0');
        Maps_RedSpawn('356 968 120','0 -90 0');
        Maps_RedSpawn('118 716 120','0 -90 0');
        Maps_RedSpawn('290 716 120','0 -90 0');
        Maps_RedSpawn('464 716 120','0 -90 0');
        Maps_BlueSpawn('650 -414 120','0 -180 0');
        Maps_BlueSpawn('475 -414 120','0 -180 0');
        Maps_BlueSpawn('325 -414 120','0 -180 0');
        Maps_BlueSpawn('275 -514 120','0 -180 0');
        Maps_BlueSpawn('275 -715 120','0 -180 0');
        Maps_SpawnRedFlag('288 923 120');
        Maps_SpawnBlueFlag('508 -320 120');
    }
    if (mapname == "dm6")
    {
        Maps_SpawnQuad('1042 -1096 96');
        Maps_RedSpawn('96 -921 136','0 -90 0');
        Maps_RedSpawn('192 -921 136','0 -90 0');
        Maps_RedSpawn('269 -921 136','0 -90 0');
        Maps_RedSpawn('96 -1068 136','0 -90 0');
        Maps_RedSpawn('192 -1068 136','0 -90 0');
        Maps_RedSpawn('269 -1068 136','0 -90 0');
        Maps_BlueSpawn('1288 -575 168','0 0 0');
        Maps_BlueSpawn('1288 -459 168','0 0 0');
        Maps_BlueSpawn('1288 -351 168','0 0 0');
        Maps_BlueSpawn('1388 -272 168','0 0 0');
        Maps_BlueSpawn('1514 -272 168','0 0 0');
        Maps_BlueSpawn('1619 -272 168','0 0 0');
        Maps_SpawnRedFlag('120 -1184 112');
        Maps_SpawnBlueFlag('1872 -168 168');
    }
    else if (mapname == "dm7")
    {
        Maps_SpawnQuad ('1140 660 472');
        Maps_SpawnRing ('1458 -180 664');
        //Maps_TeamSpawn('88 -88 352','0 315 0');
        //Maps_TeamSpawn('1256 -24 352','0 225 0');
        //Maps_TeamSpawn('1256 -1256 352','0 135 0');
        //Maps_TeamSpawn('152 -152 160','0 315 0');
        Maps_BlueSpawn('1315 1349 920','0 90 0');
        Maps_BlueSpawn('1391 1349 920','0 90 0');
        Maps_BlueSpawn('1488 1349 920','0 90 0');
        Maps_BlueSpawn('1315 1185 920','0 90 0');
        Maps_BlueSpawn('1391 1185 920','0 90 0');
        Maps_BlueSpawn('1488 1185 920','0 90 0');
        Maps_RedSpawn('1166 616 352','0 90 0');
        Maps_RedSpawn('1018 616 352','0 90 0');
        Maps_RedSpawn('882 616 352','0 90 0');
        Maps_RedSpawn('1166 821 352','0 -90 0');
        Maps_RedSpawn('1018 821 352','0 -90 0');
        Maps_RedSpawn('882 821 352','0 -90 0');
        Maps_SpawnRedFlag('1270 614 352');
        Maps_SpawnBlueFlag('1387 1261 920');
    }
    else if (mapname == "e1m1")
    {
        Maps_SpawnArmor2('1312 1048 -432');
        Maps_RedSpawn( '624 248 40', '0 -180 0');
        Maps_RedSpawn( '624 114 40', '0 -180 0');
        Maps_RedSpawn( '480 114 60', '0 -180 0');
        Maps_RedSpawn( '336 248 40', '0 0 0');
        Maps_RedSpawn( '336 114 40', '0 0 0');
        Maps_RedSpawn( '480 248 60', '0 0 0');
        Maps_BlueSpawn( '1458 886 -256', '0 180 0');
        Maps_BlueSpawn( '1458 974 -256', '0 180 0');
        Maps_BlueSpawn( '1312 974 -240', '0 180 0');
        Maps_BlueSpawn( '1214 964 -256', '0 0 0');
        Maps_BlueSpawn( '1234 844 -256', '0 0 0');
        Maps_BlueSpawn( '1312 844 -240', '0 0 0');
        Maps_SpawnRedFlag('480 -44 36');
        Maps_SpawnBlueFlag('1312 640 -256');
    }
    else if (mapname == "e1m2")
    {
        Maps_SpawnWeaponLightning('1698 -1506 24');
        Maps_SpawnItemCells(FALSE,'1698 -1658 24');
        Maps_SpawnItemCells(FALSE,'1698 -1702 24');
        Maps_SpawnItemCells(FALSE,'2568 -40 120');
        Maps_SpawnHealth( '1648 454 88');
        Maps_RedSpawn('1336 1653 392','0 -90 0');
        Maps_RedSpawn('1681 1635 444','0 -90 0');
        Maps_RedSpawn('1774 1438 444','0 -90 0');
        Maps_RedSpawn('1276 1383 444','0 -90 0');
        Maps_RedSpawn('1495 1489 444','0 -90 0');
        Maps_RedSpawn('1298 1605 444','0 -90 0');
        Maps_BlueSpawn('-532 -328 651','0 0 0');
        Maps_BlueSpawn('-532 -454 651','0 0 0');
        Maps_BlueSpawn('-532 -565 651','0 0 0');
        Maps_BlueSpawn('-532 -664 651','0 0 0');
        Maps_BlueSpawn('-286 -651 651','0 180 0');
        Maps_BlueSpawn('-286 -374 651','0 180 0');
        Maps_SpawnRedFlag('1496 1664 288');
        Maps_SpawnBlueFlag('-540 -504 480');
        Maps_RemoveEntitiesByModel("*57");
    }
  
};

void () update_ctf_entities =
{
    if (mapname == "dm4")
    {
        Maps_FindEntityByTarget("t5").target = "t1";
        Maps_RemoveEntitiesByTargetName("t5");
    }
    else if (mapname == "dm5")
    {
        utils_make_scheduled_event(remove_pent, .5);
    }
    else if (mapname == "dm7")
    {
        Maps_FindEntityByTarget("t1").target = "t2";
    }
    else if (mapname == "e1m1")
    {
        local vector wallorg = Maps_FindEntityByModel("*21").origin;
        Maps_RemoveEntitiesByModel("*21");
        local entity ent = Maps_CreateEntityAtPosition(wallorg);
        ent.model = "*21";
        ent.classname = "func_wall";
        ent.angles = '0 90 0';
        Maps_InitializeEntity(ent,func_wall);
        utils_make_scheduled_event(remove_pent, .5);
    }
    else if (mapname == "e1m2")
    {
        Maps_RemoveEntitiesByModel("*24");
        Maps_RemoveEntitiesByModel("*27");
        Maps_RemoveEntitiesByModel("*23");
        Maps_RemoveEntitiesByModel("*26");
        Maps_RemoveEntitiesByModel("*25");
        Maps_RemoveEntitiesByModel("*37");
    }
    else if (mapname == "e1m3")
    {
        Maps_FindEntityByTarget("t172").target = "tele_mega";
        Maps_RemoveEntitiesByTargetName("t172");
        Maps_RemoveEntitiesByTargetName("t13");
        Maps_RemoveEntitiesByModel("*18");
        Maps_RemoveEntitiesByModel("*100");
        Maps_RemoveEntitiesByTargetName("t5");
        Maps_RemoveEntitiesByModel("*5");
        Maps_RemoveEntitiesByTargetName("t6");
        Maps_RemoveEntitiesByModel("*4");
    }
    else if (mapname == "e1m4")
    {
        utils_make_scheduled_event(remove_pent, .5);
        Maps_RemoveEntitiesByModel("*64");
        Maps_RemoveEntitiesByModel("*65");
        Maps_RemoveEntitiesByModel("*66");
        Maps_RemoveEntitiesByModel("*67");
        Maps_RemoveEntitiesByModel("*68");
        Maps_RemoveEntitiesByModel("*69");
        Maps_RemoveEntitiesByModel("*70");  
    }
    else if (mapname == "e1m7")
    {
        Maps_RemoveEntitiesByModel("*14");
        Maps_RemoveEntitiesByModel("*16");
    }
    else if (mapname == "e2m1")
    {
        Maps_RemoveEntitiesByTargetName("t14");
        Maps_RemoveEntitiesByTargetName("t15");
        Maps_RemoveEntitiesByTargetName("t16");
        Maps_RemoveEntitiesByTargetName("t60");
        Maps_RemoveEntitiesByTargetName("t68");
        Maps_RemoveEntitiesByModel("*20");
        Maps_RemoveEntitiesByModel("*21");
        Maps_RemoveEntitiesByModel("*22");
    }
    else if (mapname == "e2m3")
    {
        Maps_RemoveEntitiesByTargetName("t29");
        Maps_RemoveEntitiesByTarget("t29");
        Maps_RemoveEntitiesByTargetName("t32");
        Maps_RemoveEntitiesByTarget("t32");
        Maps_RemoveEntitiesByTargetName("t33");
        Maps_RemoveEntitiesByTarget("t33");
    }
    else if (mapname == "e3m2")
    {
        Maps_RemoveEntitiesByModel("*14");
        Maps_RemoveEntitiesByModel("*19");
        Maps_RemoveEntitiesByModel("*58");
    }
    else if (mapname == "e3m3")
    {
        Maps_FindEntityByTarget("t28").target = "tele_blue";
        Maps_RemoveEntitiesByTargetName("t28");
        Maps_RemoveEntitiesByModel("*32");
        Maps_RemoveEntitiesByModel("*38");
        Maps_RemoveEntitiesByModel("*39");
        Maps_RemoveEntitiesByModel("*40");
    }
    else if (mapname == "e3m4")
    {
        Maps_RemoveEntitiesByTargetName("t161");
        Maps_RemoveEntitiesByTarget("t89");
        Maps_RemoveEntitiesByTargetName("t83");
        Maps_RemoveEntitiesByTarget("t83");
    }
    else if (mapname == "e4m4")
    {
        Maps_FindEntityByTarget("t204").target = "tele_red";
        Maps_RemoveEntitiesByTargetName("t204");
    }
    else if (mapname == "e4m5")
    {
        Maps_RemoveEntitiesByTargetName("t68");
    }
};