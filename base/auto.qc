//
// auto.qc
//
// This is the autocam handling code for CRMod++.
//
// All code by Paul Baker unless otherwise commented.
//
// // Global variables used:
// crmod_best_to_chase          this is calculated every frame to state who is the best target right now
//
//  TODO 4.1 : move computation from auto_camera_think to auto_compute_score


// // Client fields used:
//
// .attack_finished				used to tell when a person last fired a weapon
// .super_damage_finished		find person with quad
// .crmod_autotime				time change targets
//
// Prototypes:
void () observer_chase_start;
void () observer_camera_start;
void () observer_set_chase_position;
vector (vector from, vector to) angles_bestaim;
void (vector v) angles_fixangle;
void () observer_next_camera;


// CRMOD
// A U T O  C O M P U T E  S C O R E
//		by Paul Baker
//
//  Renamed and revamped by J.P. Grossman
//
//  based on specified criteria, rates the player to see if they are the best player to watch
//
void () auto_compute_score =
{
	local float score, dist, temp;
	local entity tempe;
	
	// JP - dead players don't get a score
	if (self.deadflag != DEAD_NO)
		return;
	
	// score starts off with health, armor, frags, last time they fired their gun, 
	// and last time they hurt someone.
	score = self.health + self.armorvalue + self.frags;
	
	temp = self.crmod_did_damage + 10 - time;
	if (temp > 0)
		score = score + temp * 15;
	temp = self.attack_finished + 15 - time;
	if (temp > 0)
		score = score + temp * 10;
	
	// weapon relates stuff
	// 200 + # of rockets if they have RL
	if (self.items & IT_ROCKET_LAUNCHER)
		score = score + 200 + self.ammo_rockets;
	// or just # of rockets if they have GL
	else if (self.items & IT_GRENADE_LAUNCHER)
		score = score + self.ammo_rockets;
	// and # of cells if they have LG
	if (self.items & IT_LIGHTNING)
		score = score + self.ammo_cells;
	
	if (self.items & IT_QUAD)
		score = score + 300;
	if (self.items & IT_INVULNERABILITY)
		score = score + 300;
	if (self.items & IT_INVISIBILITY)
		score = score + 50;
	
	// potential for action (ie how many enemies are near by?)
	// JP - fixed bug; code was looking at observers only!  Optimized slightly
	local float dscore;
	dscore = 0;
	tempe = find(world, classname, "player");
	while (tempe != world)
	{
		if ((tempe.height != self.height) && (tempe.style & ELOHIM_CONNECTED) && !(tempe.style & ELOHIM_OBSERVER))
		{
			dist = vlen(self.origin - tempe.origin);
			if (dist < 600)
				dscore = dscore + 600 - dist;
		}
		tempe = find(tempe, classname, "player");
	}
	score = score + dscore * auto_parm3 / 100;
	
	// now store their score for later
	self.crmod_chase_score = score;
};
	
// CRMOD
// A U T O  C A M E R A  T H I N K
//   by Paul Baker
//
//   Once every second or two by each camera to rate them.
//
//   JP - added self.count to compute a 'visible player' score
//	 JP - got rid of 'best'; used self.movetarget throughout
//
void () auto_camera_think =
{
	local float score, seeable;
	local entity player;
		
	self.movetarget = world;	// JP - added this
	score = 0;		// JP - added this
	self.count = 0;	// JP - added this
	player = find(world, classname, "player");
	while (player != world)
	{
		if (player.crmod_chase_score != ELOHIM_NEGINF)
		{
			seeable = utils_new_visible(self, player);
			if (seeable)
			{
				local float temp;	// JP - added this

				self.count = self.count + seeable; // JP added this

				// Bonus points for activity
				temp = player.attack_finished + 5 - time;
				if (temp > 0)
					temp = temp * auto_parm1 + player.crmod_chase_score;
				else
					temp = player.crmod_chase_score;
				score = score + seeable * temp;

				if (seeable == 4) // JP - removed unnecessary call to utils_new_visible
				{
					// Bonus points for proximity
					if (vlen(self.origin - player.origin) < 500)
						score = score + auto_parm2;

					if (!self.movetarget)
						self.movetarget = player;
					else
					{
						if (player.crmod_chase_score > self.movetarget.crmod_chase_score)
							self.movetarget = player;
					}
				}
			}
		}
		player = find(player, classname, "player");
	}

	// now store their score for later
	if (!self.count)
		self.count = 1;
	self.crmod_chase_score = score / self.count;
	
	self.nextthink = time + 0.5 + random();  // JP - minimum 0.5 second delay
	self.super_time = time;	// remember last think time
};
	
//
//  F I N D  B E S T
//
//  By J.P. Grossman
//
//  Compute crmod_best_chase_target and crmod_best_camera.
//  Called once every second from elohim_start_frame.
//
void () auto_find_best = 
{
	local entity e;

	// First find the best chase target
	crmod_best_chase_target = world;
	e = find(world, classname, "player");
	while (e)
	{
		if ((e.style & ELOHIM_CONNECTED) && !(e.style & ELOHIM_OBSERVER))
		{
			if (crmod_best_chase_target == world)
				crmod_best_chase_target = e;
			else if (e.crmod_chase_score > crmod_best_chase_target.crmod_chase_score)
				crmod_best_chase_target = e;
		}
		e = find(e, classname, "player");
	}

	// Now find the best camera (either a camera or the best chase target)
	crmod_best_camera = crmod_best_chase_target;
	e = find(world, classname, "elohim_camera");
	while (e)
	{
		if (e.count >= 6)
		{
			if (crmod_best_camera == world)
				crmod_best_camera = e;
			else if (e.crmod_chase_score > crmod_best_camera.crmod_chase_score)
				crmod_best_camera = e;
		}
		e = find(e, classname, "elohim_camera");
	}
};
	
// CRMOD
//  A U T O  C A M E R A  S T A R T
//    by Paul Baker
//
//  start autocamera from anywhere
//
void () auto_camera_start =
{
	self.oflags = self.oflags | OBSERVER_GO_AUTO;
	observer_camera_start();
};

// CRMOD
//  A U T O  C H A S E  S T A R T
//    by Paul Baker
//
//  start autochase from anywhere
void () auto_chase_start =
{
	self.oflags = self.oflags | OBSERVER_GO_AUTO;
	observer_chase_start();
};
	
// CRMOD
// A U T O  C H A S E
//   by Paul Baker
//
//   checks if it's time to switch to a new target
//
void () auto_chase =
{
	local float temp1, temp2, vSwitch;
	local entity inflictor;

	vSwitch = FALSE;

	// JP - added mandantory delays
	if (time < self.crmod_cam_delay || time < self.movetarget.crmod_cam_delay)
		return;

	// JP - *Don't* switch to crmod_best_chase_target if it is world
	if (crmod_best_chase_target == world)
		return;	
	
	// switch if they haven't done any damage for the last 15 seconds, 
	// they haven't fired their gun for 10 seconds,
	// or they haven't killed anyone in the last half a minute,
	// but not if they've done damage in the last 3 seconds
	// or have been damaged in the last 3 seconds
	if (time - self.movetarget.crmod_did_damage < 3)
		return;
	inflictor = self.movetarget.dmg_inflictor;
	if (inflictor)
	{
		if ((inflictor.crmod_inflicted == self.movetarget) && (time - inflictor.crmod_did_damage < 3))
			return;
	}

	temp1 = self.movetarget.crmod_did_damage + 15;
	temp2 = self.movetarget.attack_finished + 10;
	if ((time > temp1) || (time > temp2))
		vSwitch = TRUE;
	else
	{
		// switch if the best target is way better than current target
		temp1 = crmod_best_chase_target.crmod_chase_score - self.movetarget.crmod_chase_score;
		temp2 = self.movetarget.attack_finished + 5;
		if ((temp1 > auto_parm4) && (time > temp2))
			vSwitch = TRUE;
		else if (self.movetarget.crmod_chase_score == ELOHIM_NEGINF)
			vSwitch = TRUE;
	}

	if (vSwitch)
	{
		self.movetarget = crmod_best_chase_target;
		self.crmod_cam_delay = time + 4;
		self.delay = 0;
	}
};

// CRMOD
// A U T O  C A M E R A
//   by Paul Baker
//
// Runs autocam for observers
//
// Rewritten by J.P. Grossman
//
void () auto_camera =
{	
	local float temp1, temp2, temp3, vSwitch;
	local entity inflictor;

	vSwitch = FALSE;

	if (crmod_best_camera == world)
		return;

	if (self.movetarget == world)
	{
		self.movetarget = crmod_best_camera;
		return;
	}

	if (self.movetarget.classname == "player") // chasecam mode
	{
		// mandantory delay
		if (time < self.crmod_cam_delay)
			return;

		// switch if they haven't done any damage for the last 15 seconds, 
		// they haven't fired their gun for 10 seconds,
		// or they haven't killed anyone in the last half a minute,
		// but not if they've done damage in the last 3 seconds
		// or if they have been damaged in the last 3 seconds
		// But it's OK to switch if it's to a camera watching the fight
		inflictor = self.movetarget.dmg_inflictor;
		if (time - self.movetarget.crmod_did_damage < 3)
		{
			// If we can determine that best camera is not watching the fight then return
			if (crmod_best_camera.classname == "player")
				return;
			if (!crmod_best_camera.movetarget)
				return;
			if ((crmod_best_camera.movetarget != self.movetarget) &&
				(crmod_best_camera.movetarget != self.movetarget.crmod_inflicted) &&
				(crmod_best_camera.movetarget != inflictor))
				return;
		}
		if (inflictor)
		{
			if ((inflictor.crmod_inflicted == self.movetarget) && (time - inflictor.crmod_did_damage < 3))
			{
				// If we can determine that best camera is not watching the fight then return
				if (crmod_best_camera.classname == "player")
					return;
				if (!crmod_best_camera.movetarget)
					return;
				if ((crmod_best_camera.movetarget != self.movetarget) &&
					(crmod_best_camera.movetarget != self.movetarget.crmod_inflicted) &&
					(crmod_best_camera.movetarget != inflictor))
					return;
			}
		}
		temp1 = self.movetarget.crmod_did_damage + 15;
		temp2 = self.movetarget.attack_finished + 10;
		if ((time > temp1) || (time > temp2))
			vSwitch = TRUE;
		else
		{
			// switch if the best target is way better than current target,
			// or if it's a camera looking at the current target.
			temp1 = crmod_best_camera.crmod_chase_score - self.movetarget.crmod_chase_score;
			temp2 = self.movetarget.attack_finished + 5;
			if ((crmod_best_camera.classname == "elohim_camera") && (crmod_best_camera.movetarget == self.movetarget))
				vSwitch = TRUE;
			if ((temp1 > auto_parm4) && (time > temp2))
				vSwitch = TRUE;
			else if (self.movetarget.crmod_chase_score == ELOHIM_NEGINF)
				vSwitch = TRUE;
		}
	}
	else // camera mode
	{
		local entity camera;

		camera = self.movetarget;

		// switch if current camera doesn't have a target
		if (camera.movetarget == world)
		{
			vSwitch = TRUE;
			if (camera == crmod_best_camera)
			{
				if (crmod_best_chase_target == world)
					return;
				crmod_best_camera = crmod_best_chase_target;
			}
		}
		else
		{
			// smaller mandantory delay
			if (time < self.crmod_cam_delay - 2)
				return;

			// switch if best camera has the same movetarget
			if ((crmod_best_camera.classname == "camera") && (crmod_best_camera.movetarget == camera.movetarget))
				vSwitch = TRUE;

			temp1 =  crmod_best_camera.crmod_chase_score - camera.crmod_chase_score;
			if (temp1 > auto_parm4)
			{ 
				temp2 = camera.movetarget.attack_finished + 3;
				temp3 = self.movetarget.crmod_did_damage + 6;
				// switch if the best is better and movetarget hasn't fired
				if (((time > temp2) || (time > temp3)) && (time > self.crmod_cam_delay))
					vSwitch = TRUE;
			}
		}
	}

	if (vSwitch)
	{
		self.movetarget = crmod_best_camera;
		self.crmod_cam_delay = time + 4;
		self.delay = 0;
		if (crmod_best_camera.classname == "elohim_camera")
		{
			local vector angle;
			setorigin(self, crmod_best_camera.origin);
			if (camera.movetarget != world)
				angle = angles_bestaim(camera.origin, camera.movetarget.origin);
			else
				angle = camera.angles;
			angles_fixangle(angle);
		}
	}
};

