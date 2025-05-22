/* hrscope_plugin.qc
===============================================================                                                                                      

 ░▒█░▒█░▄▀▀▄░█▀▀▄░█▀▀▄░▄▀▀▄░█▀▀▄░▒█▀▀▀█░█▀▄░▄▀▀▄░▄▀▀▄░█▀▀
 ░▒█▀▀█░█░░█░█▄▄▀░█▄▄▀░█░░█░█▄▄▀░░▀▀▀▄▄░█░░░█░░█░█▄▄█░█▀▀
 ░▒█░▒█░░▀▀░░▀░▀▀░▀░▀▀░░▀▀░░▀░▀▀░▒█▄▄▄█░▀▀▀░░▀▀░░█░░░░▀▀▀
 	 - On the fly cameras plugin for Quake mods -


 This version of HorrorScope has been edited and customized 
 for -Bloodrails- and may not apply to any other mod.  
 A custom camera (camera_deathmatch) is included in the cameras
 section.

=====================================- by Matboe 2023 -======*/

//globals
float HR_MAX_CAM_DIST	= 768;		// maximum distance to spawn a camera position
float HR_MIN_CAM_DIST	= 256;		// maximum distance to spawn a camera position
float hr_print_info	= 0;		// print cam info on/off
float SVC_SETVIEWPORT 	= 5;
float SVC_SETVIEWANGLES = 10;
float HR_ALLOW_FOV	= 1;		// allow changes to client FOV on/off

//entity fields
.float shot_time;			// time until shot expires
.float hr_button_time;			// allow 1 second to pass between mouse clicks
.vector last_cam_move;			// store cameras last angle move amount per axis
.vector hr_oldangles;			// store players original angles 
.vector hr_oldorigin;			// store players original origin
.vector camera_spot;			// players camera position
.entity cam;				// players camera entity
.entity last_enemy;			// client that player was last damaged by (set in T_DamageOrg())
.entity last_aiment;

//function prototypes
void(void() run_cam) HorrorScope;
void() Exit_HorrorScope;
void(string str) hr_print;
void() hr_frame;
float(vector org) hr_visible;
float(entity targ) hr_infront;
float() crandom;
float intermission_running;
void() camera_deathmatch;
void() camera_deathmatch_think;
void() W_SetCurrentAmmo;


//================================ SET CAMERA / PLAYER VIEW ================================

//===================
// set view to camera
//===================
void() hr_SetViewPort_Cam =
{
	msg_entity = self;	
	WriteByte (MSG_MULTICAST, SVC_SETVIEWPORT);
	WriteEntity (MSG_MULTICAST, self.cam);
	WriteByte (MSG_MULTICAST, SVC_SETVIEWANGLES);
	WriteAngle (MSG_MULTICAST, self.cam.angles_x);
	WriteAngle (MSG_MULTICAST, self.cam.angles_y);
	WriteAngle (MSG_MULTICAST, self.cam.angles_z);

        multicast('0 0 0', MULTICAST_ONE);
};

//===================
// set view to player
//===================
void() hr_SetViewPort_Player =
{
	msg_entity = self;
	WriteByte (MSG_MULTICAST, SVC_SETVIEWPORT);
	WriteEntity (MSG_MULTICAST, self);
	WriteByte (MSG_MULTICAST, SVC_SETVIEWANGLES);
	WriteAngle (MSG_MULTICAST, self.angles_x);
	WriteAngle (MSG_MULTICAST, self.angles_y);
	WriteAngle (MSG_MULTICAST, self.angles_z);

        multicast('0 0 0', MULTICAST_ONE);
};


//====================================================
// check player impulses and button press every frame
//====================================================
void() hr_frame =
{
	//check impulses
	/*
	if (self.impulse == 233)
	{
		if (self.cam)
		{
			Exit_HorrorScope();
			self.impulse = 0;
			return;
		}			
		else
		{
			//start HorrorScope			
			HorrorScope(camera_deathmatch);
		}
	}
	*/

	//check button click
	if (self.cam)
	{
		//exit on button press
		/*if (self.owner.button2 == 1 && self.owner.attack_finished < time)
		{
			self.owner.attack_finished = time + 0.5;
			self.owner.button2 = 0;
			self.owner.nextthink = time;
			self.owner.think = Exit_HorrorScope;
			return;
		}*/

	
		hr_SetViewPort_Cam ();		//set viewport every frame to lock player view to camera angles
		self.impulse = 0;
	}
};


//================================ LINE OF SIGHT ================================

//==========================================================
// returns TRUE if vector v has line of sight to self.origin
//==========================================================
float(vector v) hr_visible =
{
	traceline (v, self.origin, TRUE, self);
	
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};

//======================================================
// returns TRUE if targ is in front of camera (in frame)
//======================================================
float(entity targ) hr_infront =
{
	local vector	vec;
	local float	dot, val;
	
	
	makevectors (self.angles);
	vec = normalize (targ.origin + targ.view_ofs - self.origin);

	dot = vec * v_forward;
	
	if (cvar ("fov") < 100)
		val = 0.85;
	else
		val = 0.6;
		
	if ( dot > val)
	{
		return TRUE;
	}

	return FALSE;
};


//================================ CAMERA POSITION ================================

//======================================
// returns a random vector nearby aiment
//======================================
vector(entity e) calc_camera_spot =
{
	local vector 	org, spot, end, tmp;
	local float	pc, cam_dist;


	if (e == world)	return e.origin;	//exit or this will cause a loop error later

	org = e.origin;

	pc = CONTENT_SKY;

	while (pc != CONTENT_EMPTY && pc != CONTENT_WATER)	
	{
		//random angle
		tmp_x = random()*-90 + random()*20;
		tmp_y = random()*360;	
		makevectors (tmp);

		//calc cam distance from org
		cam_dist = HR_MAX_CAM_DIST - HR_MIN_CAM_DIST;
		cam_dist = HR_MIN_CAM_DIST + (cam_dist * random());
		if (cam_dist > HR_MAX_CAM_DIST)
			cam_dist = HR_MAX_CAM_DIST;

		//trace org + direction * distance
		traceline (org, org + v_forward * cam_dist, TRUE, e);

		//check poincontents at end pos
		pc = pointcontents (trace_endpos);

		//double check line of sight by tracing endpos back to e.origin
		end = trace_endpos;
		traceline (end, org, TRUE, e);
		if (trace_fraction < 1)
			pc = CONTENT_SOLID;	
	}

	//found a spot!  now adjust spot away from wall back towards org by 20%
	spot = end - ((end - org) * 0.2);

	return spot;
};


//================================ CAMERA ANGLE ================================

/*===================
update_cam_angles_y

Change camera y_angle by 'move' amount from current angles towards target
===================*/
void(vector dir, float speed_cap) update_cam_angles_y =
{
	local float  move, s, speed, ideal, current_yaw;


	dir = normalize(dir);
	ideal = vectoyaw(dir);

	current_yaw = anglemod( self.angles_y );
	
	if (current_yaw == ideal)
	{
		self.avelocity_y = 0;
		return;
	}
	
	move = ideal - current_yaw;

	if (ideal > current_yaw)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}

	//speed - camera angles follows aiment slowly while aiment is close to center
	//        then speeds up when aiment is further from center
	s = move;
	if (s < 0) 
		s = s*s;

	if (s > 20)
	{
		s = s*0.3;
		if (s > 10)
			s = 10;
	}
	else
	{
		s = s*0.1;
		if (s > 3) s = 3; 
	}

	if (s > speed_cap) s = speed_cap;

	speed = s;

	if (move > 0)
	{
		if (move > speed)
			move = speed;
	}
	else
	{
		if (move < 0-speed )
			move = 0-speed;
	}

	move = move * 50;
	self.avelocity_y = 0.5*(move + self.last_cam_move_y);
	self.last_cam_move_y = self.avelocity_y;
};

/*===================
update_cam_angles_x

Change camera x_angle by 'move' amount from current angles towards target
===================*/
void(vector dir, float speed_cap) update_cam_angles_x =
{
	local float	move, s, speed, ideal, current_pitch;



	dir = normalize(dir);
	dir = vectoangles(dir);
	ideal = dir_x;

	current_pitch = anglemod( self.angles_x );
	
	if (current_pitch == ideal)
	{
		self.avelocity_x = 0;
		return;
	}
	
	move = ideal - current_pitch;

	if (ideal > current_pitch)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}
	
	//speed - camera angles follows target slowly while target is close to center
	//        then speeds up when target is further from center
	s = move;
	if (s < 0) s = s*s;
	if (s > 20)
	{
		s = s*0.3;
		if (s > 3)
			s = 3;
	}
	else
	{
		s = s*0.1;
		if (s > 1) s = 1; 
	}


	if (s > speed_cap) s = speed_cap;

	speed = s;

	if (move > 0)
	{
		if (move > speed)
			move = speed;
	}
	else
	{
		if (move < 0-speed )
			move = 0-speed;
	}

	move = move * 50;
	self.avelocity_x = 0.5*(move + self.last_cam_move_x);
	self.last_cam_move_x = self.avelocity_x;
};


//=================================
// move camera angles toward aiment
//=================================
void(entity targ, float speed_cap) camera_update_angles =
{
	local vector dir1, dir2;

	dir1 = (targ.origin + targ.view_ofs) - self.origin;
	dir2 = self.origin - (targ.origin + targ.view_ofs);


	update_cam_angles_y (dir1, speed_cap);
	update_cam_angles_x (dir2, speed_cap);
};


//================================================
// set camera angles to instantly center on aiment
//================================================
void(vector vec) camera_snap =
{
	self.avelocity = '0 0 0';

	if (!vec || vec == '0 0 0')
		vec = ((self.aiment.origin + self.aiment.view_ofs) - self.origin);

        vec = normalize (vec);
	vec = vectoangles (vec);

	//don't turn camera upside down
        if (vec_x > 0)
        	vec_x = 0 - vec_x;
        else
        	vec_x = 360 - vec_x;

	self.angles_x = vec_x;
	self.angles_y = vec_y;
					/////////////////////////////////////
	self.punchangle = '0 0 0';	// this is suppsed to resolve the  //
					// issuse where camera angles snap //
					// to vector one frame too late.   //
					// the issue persists however...   //
};					/////////////////////////////////////

//==========================================================
// message client to set FOV to value, enforce min/max value
//==========================================================
void(float value) set_FOV =
{
	if (value < 30)
		value = 30;

	if (value > 100)
		value = 100;

	stuffcmd (self.owner, "fov ");
	stuffcmd (self.owner, ftos (value));
	stuffcmd (self.owner, "\n");
};


//================================ CAMERAS ================================

/*==============================================
 Deathmatch Camera
 * camera angles move to keep aiment centered
 * find player entity and store as .aiment or default to player start entity
 * find a position nearby aiment
 * when aiment is fighting choose a second position and move camera between the 2 points
 * when aiment is standing on a plat/door/train move camera to follow plat velocity
 * select players enemy as aiment
=============================================*/

//find a player entity that is not dead and not an observer
entity() find_player =
{
	local entity e;

	e = find (world, classname, "player");
	while (e)
	{
		if (!(e.style & ELOHIM_OBSERVER))
			if (e.health > 0)		// <-- aiment is a player in observer mode
				return e;

		e = find (e, classname, "player");
	}

	return world;					
};


void() camera_deathmatch =
{
	local float	dist;
	local vector 	dir, spot1, spot2, vec;
	local entity	plat;

	//find player
	if (self.aiment.classname != "player" || self.aiment.health <= 0)
		self.aiment = find_player();
	
	//no player found! setup camera nearby player start point 
	//then try to find a player again in 7 seconds
	if (self.aiment.classname != "player")
		self.aiment = find (world, classname, "info_player_start");

	//place camera above plat
	if (self.aiment.classname == "player")
	{
		//check below players feet for plat	
		traceline (self.aiment.origin, self.aiment.origin + ' 0 0 -128', TRUE, self.aiment);

		if (trace_ent.state > 0 && trace_ent.state != STATE_BOTTOM && trace_ent.state != STATE_TOP)  //standing on plat
		{
			plat = trace_ent;
			traceline (self.aiment.origin, self.aiment.origin + '0 0 256', TRUE, self.aiment);
			self.aiment.last_enemy = plat;
			spot1 = trace_endpos - ((trace_endpos - self.aiment.origin) * 0.2);	//step back 20% from wall toward aiment 
		}
	}

	//enemy becomes aiment
	if (self.last_aiment.classname == "player" && !plat && self.aiment.last_enemy)
	{
		traceline (self.aiment.origin, self.aiment.last_enemy.origin, FALSE, self.aiment);
		if (trace_ent == self.aiment.last_enemy)	
			self.aiment = self.aiment.last_enemy;
	}

	//camera position
	if (!plat)
		spot1 = calc_camera_spot (self.aiment);	

	vec = (self.aiment.origin + self.aiment.view_ofs) - spot1;
	camera_snap(vec);

	self.velocity = '0 0 0';

	//move camera when fighting
	if (self.aiment.attack_finished + 1 > time && !plat)
	{
		spot2 = calc_camera_spot (self.aiment);

		//calc bearing / velocity
		dist = vlen(spot2 - spot1);
		dir = normalize (spot2 - spot1);
		self.velocity = dir * (dist*0.2);
	}

	self.camera_spot = spot1;

	if (plat)
		self.velocity = plat.velocity;			

	//zoom
	local float dist1, dist2, chance;
	dist1 = vlen (spot1 - self.aiment.origin);
	dist2 = vlen (spot2 - self.aiment.origin);

	if (dist1 >= HR_MAX_CAM_DIST && dist2 >= HR_MAX_CAM_DIST) chance = 1;
	else if (dist1 > (HR_MAX_CAM_DIST*0.5)) chance = 0.5;
	else chance = 0;

	if (chance && random() < chance)
		set_FOV (100 - (dist1*0.2));
	else
		set_FOV (100);

	self.last_aiment = self.aiment;	//camera last_enemy used to store last aiment
	self.shot_time = time + 5;	//maximum shot time


	setorigin (self, self.camera_spot);
	setorigin (self.owner, self.origin);

	camera_deathmatch_think();
};

void() camera_deathmatch_think =
{
	local vector 	cam_dir;
	local float	aiment_visible;
	local entity 	plat;
	

	if (self.aiment.classname != "player")
	{
		//find player
		local entity e;
		if (self.last_aiment.classname == "player")
			e = self.last_aiment;
		else 
			e = find_player();

		//no player found - just stay looking at info_player_start
		//then reset in 7 seconds
		if (!e || intermission_running)
		{
			self.nextthink = time + 7;
			self.think = camera_deathmatch;
			self.last_aiment = world;
			return;
		}

		//aquaire players last_enemy as .aiment
		if ( e.last_enemy != self.aiment && e.last_enemy.solid != SOLID_BSP)  //last_enemy must not be a plat
		{
			if (hr_visible (e.last_enemy.origin))
			{
				self.aiment = e.last_enemy;
			
				//extend shot_time for new .aiment
				if (self.shot_time < time + 4)
					self.shot_time = time + 4;
			}
		}

		//limit shot_time for dead aiment
		if (self.aiment.health <= 0)
			if (self.shot_time > time + 2)
				self.shot_time = time + 2;

	}
	
	aiment_visible = hr_visible(self.aiment.origin);

	//extend shot time for long flythrough
	if (self.aiment.classname == "player")
		if (self.aiment.last_enemy.movetype != SOLID_BSP) //not standing on a plat
			if (vlen (self.velocity) > 96)
				aiment_visible = TRUE;

	//check switch to next camera
	if ( (!aiment_visible && self.shot_time < (time + 4) ) || self.shot_time < time)
	{
		camera_deathmatch();
		return;
	}

	//update camera angles
	camera_update_angles(self.aiment, 10);


	//aiment on plat, follow plat velocity
	if (self.aiment.last_enemy.solid == SOLID_BSP)
	{
		plat = self.aiment.last_enemy;
		traceline (self.aiment.origin, self.aiment.origin + '0 0 -128', TRUE, self.aiment); //check standing on plat

		if (trace_ent == plat && trace_ent.state > 0 && trace_ent.state != STATE_BOTTOM && trace_ent.state != STATE_TOP)  //plat is moving
			self.velocity = plat.velocity;  //follow plat velocity
		else
			self.velocity = 0;	//stop moving camera when plat stops moving
	}

	//decrease velocity when movement is blocked within 16 units in direction of travel 
	cam_dir = normalize (self.velocity);
	traceline (self.origin, self.origin + cam_dir * 16, TRUE, self);
	if (trace_fraction < 1)
	{
		if (plat)
			self.velocity = 0;
		else
			self.velocity = self.velocity * 0.95;
	}

	//update player
	setorigin (self.owner, self.origin);

	self.nextthink = time + (frametime * 3);	//update camera every 3 frames
	self.think = camera_deathmatch_think;		
};

//======================= START / STOP HORROR-SCOPE =======================


//======================================
// reset player in his original position
//======================================
void() Exit_HorrorScope =
{
	//reset player
	//self.flags = self.flags - (self.flags & (FL_NOTARGET | FL_GODMODE));
	//self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.angles = self.hr_oldangles;
	//self.movetype = MOVETYPE_WALK;
	self.view_ofs = '0 0 25';
	setmodel (self, "mdl/player.md3");
	self.classname = "player";
	//setsize (self, '-16 -16 -24', '-16 -16 -24');
	setorigin (self, self.hr_oldorigin);
	//self.punchangle = '0 0 0';
	//W_SetCurrentAmmo();
	
	observer_start();

	//console settings
	stuffcmd (self, "v_centerspeed 500\nv_centermove 0.15\n");	// reinstate camera wobble from movement keys
	stuffcmd (self, "fov 100\nalias fov bf\n");			// reinstate fixed FOV 
	stuffcmd (self, "cl_nolerp 1\n");			 	//fix for view jerking when exiting horrorscope
	
	//remove camera
	remove (self.cam);
	self.cam = world;

	hr_SetViewPort_Player();
};

//===============================
// start a new HorrorScope camera
//===============================
void (void() run_cam) HorrorScope = 
{
	if (self.cam)
		remove (self.cam);

	//spawn camera
	self.cam = spawn();
	self.cam.owner = self;
	self.cam.solid = SOLID_NOT;
	self.cam.movetype = MOVETYPE_NOCLIP;
	self.cam.classname = "camera";
	self.cam.origin = self.origin;
	setmodel (self.cam, "mdl/null.spr");
	self.frags = -99;
	setcolor2(self, 0, 0);

	//setup player
	self.hr_oldangles = self.angles;		//store players origin/angles 
	self.hr_oldorigin = self.origin;		
	self.weaponmodel = "";
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;
	self.view_ofs = '0 0 0';
	setsize (self, '0 0 0', '0 0 0');
	setmodel (self, "");
	self.flags = self.flags | FL_NOTARGET | FL_GODMODE;
	self.classname = "hr_player";
	setorigin (self, self.origin);

	//console settings
	stuffcmd (self, "v_centerspeed 0\nv_centermove 0\ncl_bob 0\ncl_rollangle 0\n");		// kill camera wobble when player presses movement keys

	//no cam specified - run default
	if (!run_cam)
		run_cam = camera_deathmatch;

	//run camera
	self.cam.nextthink = time;
	self.cam.think = run_cam;
};	


//================================ EXTRAS ================================


//========================
// print message to player
//========================
void(string str) hr_print =
{
	local entity e;


	//if (hr_print_info == FALSE)
	//	return;

	if (self.owner.classname == "hr_player")
		e = self.owner;

	else if (self.classname == "hr_player")
		e = self;

	sprint (e, "HorrorScope --> ");
	sprint (e, str);
	sprint (e, "\n");

};
