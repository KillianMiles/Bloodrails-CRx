//
//	Entity manipulation functions
//
//	Sourced from qectf by jpiolho, modified by bucksh0t.

//we don't need this part, but may be useful again at some point
//float map_removeDefaultEntities;
// void() Maps_CleanEntities =
// {
//     map_removeDefaultEntities = 1;
// }

float(entity ent) Maps_ShouldRemoveDefaultEntity =
{
	return FALSE;
    //return map_removeDefaultEntities && !ent.impulse;
}

entity(string entityTarget) Maps_FindEntityByTarget =
{
	return find(world,target,entityTarget);
}

entity(string entityModel) Maps_FindEntityByModel =
{
	return find(world,model,entityModel);
}

void(string entityModel) Maps_RemoveEntitiesByModel =
{
	local entity p = world;
	while((p = find(p,model,entityModel)))
		remove(p);
}

void(string entityClassname) Maps_RemoveEntitiesByClassname =
{
	local entity p = world;
	while((p = find(p,classname,entityClassname)))
	{
		remove(p);	
	}
}

void(string entityTarget) Maps_RemoveEntitiesByTarget =
{
	local entity p = world;
	while((p = find(p,target,entityTarget)))
	{
		remove(p);	
	}
}

void(string entityTargetName) Maps_RemoveEntitiesByTargetName =
{
	local entity p = world;
	while((p = find(p,targetname,entityTargetName)))
	{
		remove(p);	
	}
}

void(string entityClassname,vector searchOrigin) Maps_RemoveEntityByClassnameContainingPoint =
{
	local entity p = world;
	while((p = find(p,classname,entityClassname)))
	{
		if(searchOrigin_x >= p.absmin_x && searchOrigin_y >= p.absmin_y && searchOrigin_z >= p.absmin_z && searchOrigin_x <= p.absmax_x && searchOrigin_y <= p.absmax_y && searchOrigin.z <= p.absmax_z)
			remove(p);
	}
}

entity(string entityClassname,vector searchOrigin) Maps_FindEntityByClassnameContainingPoint =
{
	local entity p = world;
	while((p = find(p,classname,entityClassname)))
	{
		if(searchOrigin_x >= p.absmin_x && searchOrigin_y >= p.absmin_y && searchOrigin_z >= p.absmin_z && searchOrigin_x <= p.absmax_x && searchOrigin_y <= p.absmax_y && searchOrigin.z <= p.absmax_z)
			return p;
	}

	return world;
}

/*
Entities Functions
*/

entity(vector entityOrigin) Maps_CreateEntityAtPosition =
{
	local entity ent = spawn();
	ent.origin = entityOrigin;
	return ent;
}

entity(entity ent, void() initializer) Maps_InitializeEntity =
{
	local entity oself = self;
	self = ent;
	initializer();
	self = oself;

	return ent;
}

void(vector keyOrigin) Maps_SpawnRedFlag =
{
	local entity key = Maps_CreateEntityAtPosition(keyOrigin);
	key.impulse = 1;

	Maps_InitializeEntity(key,item_flag_team1);
}

void(vector keyOrigin) Maps_SpawnBlueFlag =
{
	local entity key = Maps_CreateEntityAtPosition(keyOrigin);
	key.impulse = 1;

	Maps_InitializeEntity(key,item_flag_team2);
}

void info_player_deathmatch();
void(vector spawnOrigin,vector spawnAngles,optional float spawnTeam = 0,optional float spawnFlags = 0) Maps_TeamSpawn =
{
	local entity playerSpawn = Maps_CreateEntityAtPosition(spawnOrigin);
	playerSpawn.team = spawnTeam;
	playerSpawn.impulse = 1;
	playerSpawn.angles = spawnAngles;
	playerSpawn.flags = spawnFlags;

	if (spawnTeam == TEAM_RED)
		Maps_InitializeEntity(playerSpawn,info_player_team1);
	else if (spawnTeam == TEAM_BLUE)
		Maps_InitializeEntity(playerSpawn,info_player_team2);
	else
		Maps_InitializeEntity(playerSpawn,info_player_deathmatch);
}

void(vector spawnOrigin,vector spawnAngles,optional float spawnFlags = 0) Maps_RedSpawn =
{
	Maps_TeamSpawn(spawnOrigin, spawnAngles, TEAM_RED, spawnFlags);
}

void(vector spawnOrigin,vector spawnAngles,optional float spawnFlags = 0) Maps_BlueSpawn =
{
	Maps_TeamSpawn(spawnOrigin, spawnAngles, TEAM_BLUE, spawnFlags);
}


entity(float entityBig,vector entityOrigin, optional float entityTeam = 0) Maps_SpawnItemRockets =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_rockets";

	if(entityBig)
		ent.spawnflags |= WEAPON_BIG2;

	return Maps_InitializeEntity(ent,item_rockets);
}

entity(float entityBig,vector entityOrigin, optional float entityTeam = 0) Maps_SpawnItemCells =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_cells";

	if(entityBig)
		ent.spawnflags |= WEAPON_BIG2;

	return Maps_InitializeEntity(ent,item_cells);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnWeaponSuperShotgun =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "weapon_supershotgun";

	return Maps_InitializeEntity(ent,weapon_supershotgun);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnWeaponRocketLauncher =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "weapon_rocketlauncher";

	return Maps_InitializeEntity(ent,weapon_rocketlauncher);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnWeaponNailgun =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "weapon_nailgun";

	return Maps_InitializeEntity(ent,weapon_nailgun);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnWeaponSuperNailgun =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "weapon_supernailgun";

	return Maps_InitializeEntity(ent,weapon_supernailgun);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnWeaponLightning =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "weapon_lightning";

	return Maps_InitializeEntity(ent,weapon_lightning);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnWeaponGrenadeLauncher =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "weapon_grenadelauncher";

	return Maps_InitializeEntity(ent,weapon_grenadelauncher);
}


entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnArmor1 =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_armor1";

	return Maps_InitializeEntity(ent,item_armor1);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnArmor2 =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_armor2";

	return Maps_InitializeEntity(ent,item_armor2);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnArmorInv =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_armorInv";

	return Maps_InitializeEntity(ent,item_armorInv);
}


entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnHealth =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_health";

	return Maps_InitializeEntity(ent,item_health);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnHealthRotten =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_health";
	ent.spawnflags = 1;

	return Maps_InitializeEntity(ent,item_health);
}

entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnHealthMega =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_health";
	ent.spawnflags = 2;

	return Maps_InitializeEntity(ent,item_health);
}

void item_artifact_super_damage();
entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnQuad =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_artifact_super_damage";

	return Maps_InitializeEntity(ent,item_artifact_super_damage);
}

void item_artifact_invulnerability();
entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnPent =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_artifact_invulnerability";

	return Maps_InitializeEntity(ent,item_artifact_invulnerability);
}

void item_artifact_invisibility();
entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnRing =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_artifact_invisibility";

	return Maps_InitializeEntity(ent,item_artifact_invisibility);
}

void item_artifact_envirosuit();
entity(vector entityOrigin, optional float entityTeam = 0) Maps_SpawnEnviroSuit =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.impulse = 1;
	ent.team = entityTeam;
	ent.classname = "item_artifact_envirosuit";

	return Maps_InitializeEntity(ent,item_artifact_envirosuit);
}

entity(string entityModel,vector entityOrigin,vector entityAngles) Maps_CreateWall =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.model = entityModel;
	ent.classname = "func_wall";
	ent.impulse = 1;

	Maps_InitializeEntity(ent,func_wall);

	ent.angles = entityAngles;

	return ent;
}

void(string entityModel,vector entityOriginStart,vector entityOriginEnd,vector entityAngles,float numberOfSteps) Maps_CreateStairs =
{
	local float i;
	local vector entityOrigin;

	for(i=0;i<=numberOfSteps;i++) {
		entityOrigin = entityOriginStart + (entityOriginEnd - entityOriginStart) * (i / numberOfSteps);

		Maps_CreateWall(entityModel,entityOrigin,entityAngles);
	}
}

entity(vector entityOrigin,float entityAngle) Maps_CreateTorch =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	//ent.angles = '0 0 0';
	//ent.angles_y = entityAngle;
	//ent.classname = "light";
	ent.classname = "light_flame_large_yellow";
	//ent.effects = EF_BRIGHTLIGHT;
	ent.style = 0;
	//ent.light = 200;
	ent.impulse = 1;

	//return Maps_InitializeEntity(ent,light);
	return Maps_InitializeEntity(ent,light_flame_large_yellow);
}
entity(vector entityOrigin,float entityAngle) Maps_CreateLight =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	//ent.angles = '0 0 0';
	//ent.angles_y = entityAngle;
	//ent.classname = "light";
	ent.classname = "light_torch_small_walltorch";
	ent.style = 0;
	//ent.effects = EF_DIMLIGHT;
	//ent.light = 200;
	ent.impulse = 1;

	//return Maps_InitializeEntity(ent,light);
	return Maps_InitializeEntity(ent,light_torch_small_walltorch);
}

entity(string entityName,vector entityOrigin,float entityAngle) Maps_CreateTeleportDestination =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.angles = '0 0 0';
	ent.angles_y = entityAngle;
	ent.classname = "info_teleport_destination";
	ent.targetname = entityName;
	ent.impulse = 1;

	return Maps_InitializeEntity(ent,info_teleport_destination);
}

entity(string entityTarget,vector entityOrigin,vector entitySize,float effect) Maps_CreateTeleport =
{
	local entity ent = Maps_CreateEntityAtPosition(entityOrigin);
	ent.classname = "trigger_teleport";
	ent.target = entityTarget;
	ent.impulse = 1;

	if(effect)
		ent.spawnflags |= PARTICLE_EFFECT;

	Maps_InitializeEntity(ent,trigger_teleport);

	local vector hullMin = '0 0 0';
	local vector hullMax = '0 0 0';
	hullMin -= entitySize / 2;
	hullMax += entitySize / 2;

	setsize(ent,hullMin,hullMax);

	return ent;
}

void(string nextLevel) Maps_SetNextLevel = 
{
	local entity ent = spawn();
	ent.classname = "trigger_changelevel";
	ent.map = nextLevel;
	ent.impulse = 1;

	Maps_InitializeEntity(ent,trigger_changelevel);

	setorigin(ent,'-9999 9999 -9999');
}