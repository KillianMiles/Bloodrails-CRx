//Prototypes

void(string cmd) SV_ParseClientCommand;
void(entity e, string s) clientcommand = #440;
float(string s) tokenize = #441;
float(string s) tokenize_console = #514;
string(float n) argv = #442;

entity (entity e) racing_find_start;

void () admin_set_mode_vote;
void () admin_set_mode;
float request_mode;
void() racing_start;
void() racing_finish;
void () spawn_race_entities;

void () remove_pent;

void() flag_carry
void() PutDummyInServer;
void() rune_check;
void() auto_dash;
void() Plasma_Charge_Logic;

void() Called_in_PreThink;
void() Called_in_PostThink

void(entity targ, entity attacker, float damage) ClientObituary;
void(entity targ, entity attacker, vector damage_origin, float damage) Killed;
vector(float dm, float inair) VelocityForDamage;
void(string gibname, float dm, float inair) ThrowGib;
void() GibPlayerChangeTeams;
void() GibPlayer;


vector(vector a, vector b, float mix) lerpVector;
float (float x, float y) angle_difference;
void() turn_indicator;
void(float radius, float force) flag_homing_slide;
void() Stairs;

void() rail_jump;
void() LandingCheck;
void() PlayerJump;      //this is now in bloodrails/br_func.qc
void() CheckPowerups;    //this is now in bloodrails/br_func.qc
void() bloodrails_precache;       //called by worldspawn
void() movement_check;            //movement checks
void() GibPlayerChangeTeams;
void() spawn_protection;
void() goomba_stomp;
void() ceiling_ride;
void() Skiing;
void() Water_bounce;



void() update_sparks;   //think function for wall-runs sparks
void() make_sparks;      //spawning wall run sparks
void() check_jump;       // checks that jump has been pressed long enough but not too long - for Wall Run initiation ALSO checks for looking down and other conditions for expedited rail reload for rail jumping
void() WallRun;       //Wallrun mechanics QSSM
void() AirControl;           //Ironstride rune movements mechanics
void() DeathAura;            //Death Aura rune effects
void() Rail_HUD;
void() Shield_HUD;
void() You_Have_Flag;
void() You_Have_Rune;
void() Flag_Status;
void() make_jumbo_red;
void() make_jumbo_blue;
void() update_press_move;
void() make_press_move;
void() make_rail_ammo;


void () client_ping_think;                             //Antilag
void () client_responsetime_get_all;                   //Antilag
void () client_responsetime_show;                      //Antilag
void () antilag_restore_all;                             //Antilag
void (float pingtime, entity ignore) antilag_rewind_all;    //Antilag
void (entity e, float rewindtime) antilag_rewind;            //Antilag
void () SetPositions;                                         //Antilag

void(entity targ) make_spawnprotect; //spawn protect shield visual
void() update_speedlines;
void() make_speedlines;
void() update_crown;      //think function for Score-leaders smoke trail
void() make_crown;        // spawning Score-leader's smoke trail
void() update_shield_EXTERNAL;       // Think function for Pulse Shield for others to see
void() make_shield;          //spawning Pulse shield
void() update_impact;
void(vector z_offset, float shockwave) make_impact;
void() top_score;            // this calculates various player metrics, like counts, top score, kdr, etc.

void() update_aura;
void() make_aura;
void() update_haste;    //runes
void() make_haste;
void() update_power
void(vector origin, float _alpha, float _frame) make_power;

void(vector p0, vector p1, vector p2, vector p3) clean_DrawCurvedRail;
void(vector start, vector end, vector myAngles, entity shooter) clean_rail_make; 
void() clean_rail_fade;

void(vector start, vector end, vector myAngles, entity shooter) rail_make;           //This draws the rail trail
void() rail_fade;                                                                     //think function for rail trail - this controls how the trail fades
void() W_FireRailgun;                                                                 //Main Railgun firing function
void() W_FireProjectile;
void() W_Fire_BR_Axe;                                                                  //Main Axe firing function
void() Axe_Splash;
void(entity inflictor, vector org, entity attacker, float radius, float throw_high, entity ignore) PlasmaPusher;

void() Axe_Charge_Logic;   //charge-up logic for pulse shield
void() Rail_Charge_Logic;    //charge-up logic for curved rail

void() update_flick_marker;
void() make_flick_marker;
void() FlickCurves;     //Calculatations related to curved rail flicks
void( vector p0, vector p1, vector p2, vector p3) DrawCurvedRail;    //draws curved rail trails

void(entity inflictor, vector origin, entity attacker, float radius, float damage, entity ignore) areaDMG;           // various Area of Effect functions, used in axe splash damage etc
void(entity inflictor, vector org, entity attacker, float radius, float throw_high, entity ignore) areaTHROW;        // used in Thor slam
void(entity inflictor, vector origin, entity attacker, float radius, float damage, entity ignore) areaKDR;
void(entity inflictor, vector origin, entity attacker, float radius, float damage, entity ignore) areaKDR2;

void() Shuffle_Teams;
void() Rebalance_Teams;

void() racing_countdown;

string (float t) utils_get_time;



// called by worldspawn
void() bloodrails_precache =
{
	
	// S O U N D S 
	precache_sound ("misc/h2ohit1.wav");		// landing splash
	
	precache_sound ("bloodrailz/legacy/enforcer_enfstop.wav");		//rail impact sizzle
	precache_sound ("bloodrailz/legacy/weapons_ax1.wav");		// ax swoosh
	precache_sound ("bloodrailz/legacy/lburn1.wav");		// lava burn
	precache_sound ("bloodrailz/legacy/lburn2.wav");		// lava burn
	precache_sound ("bloodrailz/legacy/drown1.wav");		// drowning pain
	precache_sound ("bloodrailz/legacy/drown2.wav");		// drowning pain
	precache_sound ("bloodrailz/player/gib.wav");		// player gib sound
	
	
	precache_sound ("bloodrailz/legacy/pain1.wav");
	precache_sound ("bloodrailz/legacy/pain2.wav");
	precache_sound ("bloodrailz/legacy/pain3.wav");
	precache_sound ("bloodrailz/legacy/pain4.wav");
	precache_sound ("bloodrailz/legacy/pain5.wav");
	precache_sound ("bloodrailz/legacy/pain6.wav");
	
	precache_sound ("bloodrailz/player/h2ojump.wav");		// Christian Ice // player jumping into water
	precache_sound ("bloodrailz/player/inh2o.wav");		// Christian Ice //player enter water
	precache_sound ("bloodrailz/player/inlava.wav");		// Christian Ice // player enter lava
	precache_sound ("bloodrailz/player/teledth1.wav");		// Christian Ice // lava burn
	precache_sound ("bloodrailz/player/udeath.wav");		// Christian Ice // player gib sound
	precache_sound ("bloodrailz/player/h2odeath.wav");		// Christian Ice // drowning death
	
	

	precache_sound ("bloodrailz/misc/outwater.wav");		// leaving water sound
	precache_sound ("bloodrailz/misc/water1.wav");			// Christian Ice swimming
	precache_sound ("bloodrailz/misc/water2.wav");			// Christian Ice swimming
	precache_sound ("bloodrailz/misc/talk.wav");			// Christian Ice swimming
	
	
	
	
	
	precache_sound ("bloodrailz/weapons/br_exp1.wav");		// Christian Ice
	
	precache_sound ("bloodrailz/weapons/br_ric1.wav");		// Christian ice
	precache_sound ("bloodrailz/weapons/br_ric2.wav");		// Christian ice
	precache_sound ("bloodrailz/weapons/br_ric3.wav");		// Christian ice
	precache_sound ("bloodrailz/weapons/rail1.wav");		// Bloodrailz railgun
	precache_sound ("bloodrailz/weapons/rail22.wav");		// Bloodrailz railgun with recharge woosh
	precache_sound ("bloodrailz/weapons/plasma1.wav");		// plasma noise Q3
	precache_sound ("bloodrailz/weapons/plasma2.wav");		// plasma noise Q3
	precache_sound ("bloodrailz/weapons/plasma_bounce.wav");		// edited from inv2 and suit.wav from christian ice pak
	precache_sound ("bloodrailz/weapons/empty.wav");            //br custom
	

	precache_sound("bloodrailz/weapons/armorhit.wav");  	 //play sound when armored opponent is hit with rail
	precache_sound("bloodrailz/weapons/axe_charge.wav");  	// shield power-up
	precache_sound("bloodrailz/weapons/shield_pulse.wav"); 	 //shield up
	precache_sound("bloodrailz/weapons/slowdn.wav"); 	 //rail charge down
	//precache_sound("bloodrailz/weapons/charge_up.wav"); 	 //rail charge down
	precache_sound("bloodrailz/weapons/lockon.wav"); // curved shot lockon
	
	precache_sound("bloodrailz/weapons/ammo_ding.wav");     // custom br sound
	precache_sound("bloodrailz/weapons/br_clink.wav");     // still the regular Quake sound
	precache_sound("bloodrailz/weapons/gravity4.wav");     // br custom based on Christian Ice release 
	precache_sound("bloodrailz/weapons/gravity5.wav");     //  br custom based on Christian Ice release
	precache_sound("bloodrailz/weapons/quasar_push.wav");     // soniss free sounds CB Sound Design - Whoosh and Push Sci Fi Hit 3
	precache_sound("bloodrailz/weapons/quasar1.wav");     // based on librequake pent noises
	precache_sound("bloodrailz/weapons/quasar2.wav");     // based on librequake pent noises

		//////////////////////////
	precache_sound ("bloodrailz/ambience/red.wav");		// red scores sound
	precache_sound ("bloodrailz/ambience/blue.wav");	        // blue scores sound
		//////////////////////////
	precache_sound ("bloodrailz/misc/menu3.wav");  		 //shield depleted
	precache_sound ("bloodrailz/misc/take_flag.wav");		//take flag grab flag noise
	precache_sound ("bloodrailz/misc/grind1.wav");	
	precache_sound ("bloodrailz/misc/grind2.wav");
	precache_sound ("bloodrailz/misc/grind3.wav");
	
	precache_sound ("bloodrailz/misc/runsteps1.wav");         //xonotic
	precache_sound ("bloodrailz/misc/runsteps2.wav");
	precache_sound ("bloodrailz/misc/runsteps3.wav");
	
	precache_sound ("bloodrailz/misc/water1.wav");         //christian ice
	precache_sound ("bloodrailz/misc/water2.wav");
	precache_sound ("bloodrailz/misc/water_bubble1.wav");
	precache_sound ("bloodrailz/misc/water_bounce1.wav");
	
	precache_sound ("bloodrailz/misc/ding1.wav");                                // localsound rail hit xon
	precache_sound ("bloodrailz/misc/ding2.wav");                                // localsound rail hit xon
	precache_sound ("bloodrailz/misc/sameteam.wav");			// localsound on your team  xon
		//////////////////////////
	
	precache_sound ("bloodrailz/player/gib1.wav");		// custom noise
	precache_sound ("bloodrailz/player/gib2.wav");		// custom noise
	precache_sound ("bloodrailz/player/gib3.wav");		// custom noise
	precache_sound ("bloodrailz/player/gib7.wav");		// custom noise
	
	precache_sound ("bloodrailz/player/tornoff2.wav");		// Christian Ice gib sound
	
	precache_sound ("bloodrailz/player/air_boost.wav");		
	precache_sound ("bloodrailz/player/slimbrn2.wav");		// Christian Ice player enter slime
	precache_sound ("bloodrailz/player/br_jump1.wav");             //Christian Ice jump noises
	precache_sound ("bloodrailz/player/br_jump2.wav");             // Christian ice
	precache_sound ("bloodrailz/player/br_jump3.wav");             // Christian ice
	
	precache_sound ("bloodrailz/player/br_land1.wav");			// player landing    xon
	precache_sound ("bloodrailz/player/br_land2.wav");			// player landing1   xon
	precache_sound ("bloodrailz/player/br_land3.wav");			// player landing2   xon
	precache_sound ("bloodrailz/player/br_land4.wav");			// player landing2   xon
	
	precache_sound ("bloodrailz/player/axhit_flesh.wav");			// Xonotic
	//precache_sound ("bloodrailz/player/axhit_stone.wav");			// Xonotic -- to be finished
	
		/////////////
	precache_sound ("bloodrailz/items/itembk2.wav");		// Christian Ice item respawn sound
	precache_sound ("bloodrailz/items/br_damage.wav");          //Librequake
	precache_sound ("bloodrailz/items/br_damage2.wav");         //Librequake
	precache_sound ("bloodrailz/items/br_damage3.wav");       //Librequake
	
	precache_sound ("bloodrailz/items/br_inv1.wav");          //Librequake
	precache_sound ("bloodrailz/items/br_inv2.wav");         //Librequake
	precache_sound ("bloodrailz/items/br_inv3.wav");         //Librequake
	
	precache_sound ("bloodrailz/items/br_protect.wav");      //Librequake
	precache_sound ("bloodrailz/items/br_protect2.wav");     //Librequake
	precache_sound ("bloodrailz/items/br_protect3.wav");    //Librequake
	
	precache_sound ("bloodrailz/items/cells.wav");	    //from soniss free sounds David Dumais Audio - Sci-Fi weapons Pack1 - DSGNBass_Weapon Power Down 04_DDUMAIS_NONE.wav
	precache_sound ("bloodrailz/items/runegrab.wav");	    //custom made for BR
	precache_sound ("bloodrailz/items/runedrop.wav");     //custom made for BR
	precache_sound ("bloodrailz/items/br_armor1.wav");   //Librequake
	precache_sound ("bloodrailz/items/zap.wav");   //Librequake
	
	precache_sound("bloodrailz/items/br_r_item1.wav");   //Librequake
	
	
	precache_sound ("bloodrailz/buttons/switch04.wav"); 		//Christian Ice (as well as airbut1, switch02 and switch21) //match timer 

	
	
	
	// M O D E L S
	
	
	precache_model ("progs/bloodrailz/player_left_5.mdl");
	precache_model ("progs/bloodrailz/player_left_10.mdl");
	precache_model ("progs/bloodrailz/player_left_15.mdl");
	precache_model ("progs/bloodrailz/player_left_20.mdl");
	
	precache_model ("progs/bloodrailz/player_right_5.mdl");
	precache_model ("progs/bloodrailz/player_right_10.mdl");
	precache_model ("progs/bloodrailz/player_right_15.mdl");
	precache_model ("progs/bloodrailz/player_right_20.mdl");
	
	precache_model ("progs/bloodrailz/null.mdl");
	precache_model ("progs/bloodrailz/null_trail.mdl");
	precache_model ("progs/bloodrailz/br_sparks.mdl");
	
	precache_model ("progs/bloodrailz/v_br_rail_red1.mdl");
	precache_model ("progs/bloodrailz/v_br_rail_blu1.mdl");
	precache_model ("progs/bloodrailz/v_br_axe_red1.mdl");
	precache_model ("progs/bloodrailz/v_br_axe_blu1.mdl");
	precache_model ("progs/bloodrailz/v_axe_null.mdl");
	
	precache_model ("progs/bloodrailz/v_br_axe_bluzz.mdl");   //charged-up axe view models
	precache_model ("progs/bloodrailz/v_br_axe_redzz.mdl");
	precache_model ("progs/bloodrailz/v_br_rail_bluzz.mdl");   // charged-up rail view models
	precache_model ("progs/bloodrailz/v_br_rail_redzz.mdl");
	
	precache_model ("progs/bloodrailz/vial.mdl");
	precache_model ("progs/bloodrailz/br_chain.mdl");
	precache_model ("progs/bloodrailz/star_color.mdl");
	precache_model ("progs/bloodrailz/hookx.mdl");
	precache_model ("progs/bloodrailz/marker.mdl");
	precache_model ("progs/bloodrailz/marker150.mdl");
	precache_model ("progs/bloodrailz/marker250.mdl");
	
	
	
	precache_model ("progs/bloodrailz/flag_red.mdl");
	precache_model ("progs/bloodrailz/flag_blu.mdl");
	precache_model ("progs/bloodrailz/flag_hud.mdl");
	precache_model ("progs/bloodrailz/flag_status.mdl");
	precache_model ("progs/bloodrailz/hud_digits_red.mdl");
	precache_model ("progs/bloodrailz/hud_digits_blue.mdl");
	precache_model ("progs/bloodrailz/press_move2_1.mdl");
	
	precache_model ("progs/bloodrailz/rail0.mdl"); //short segment, half the length of rail1. - used in curved rail trails
	precache_model ("progs/bloodrailz/rail1.mdl");
	precache_model ("progs/bloodrailz/rail2.mdl");
	precache_model ("progs/bloodrailz/rail3.mdl");
	
	//precache_model ("progs/bloodrailz/rail0_1.mdl");
	//precache_model ("progs/bloodrailz/rail0_1_30.mdl");
	precache_model ("progs/bloodrailz/rail1_1.mdl");
	//precache_model ("progs/bloodrailz/rail1_1_90.mdl");
	precache_model ("progs/bloodrailz/rail2_1.mdl");
	precache_model ("progs/bloodrailz/rail3_1.mdl");
	
	precache_model ("progs/bloodrailz/rail_a.mdl");
	precache_model ("progs/bloodrailz/rail_b.mdl");
	precache_model ("progs/bloodrailz/rail_b1.mdl");
	precache_model ("progs/bloodrailz/rail_c.mdl");
	precache_model ("progs/bloodrailz/rail_d.mdl");
	precache_model ("progs/bloodrailz/rail_e.mdl");
	
	precache_model ("progs/bloodrailz/rail5.mdl");
	
	precache_model ("progs/bloodrailz/br_rune1a.mdl");
	precache_model ("progs/bloodrailz/br_rune2a.mdl");
	precache_model ("progs/bloodrailz/br_rune3a.mdl");
	precache_model ("progs/bloodrailz/br_rune4a.mdl");
	precache_model ("progs/bloodrailz/br_rune1b_1.mdl");
	precache_model ("progs/bloodrailz/br_rune2b_1.mdl");
	precache_model ("progs/bloodrailz/br_rune3b_1.mdl");
	precache_model ("progs/bloodrailz/br_rune4b_1.mdl");
	
	precache_model ("progs/bloodrailz/ef_smoke1.mdl");
	precache_model ("progs/bloodrailz/ef_smoke2.mdl");
	precache_model ("progs/bloodrailz/ef_thor.mdl");
	precache_model ("progs/bloodrailz/ef_thor_big.mdl");
	precache_model ("progs/bloodrailz/ef_power.mdl");
	precache_model ("progs/bloodrailz/ef_haste.mdl");
	precache_model ("progs/bloodrailz/ef_aura1.mdl");
	precache_model ("progs/bloodrailz/ef_shields.mdl");
	precache_model ("progs/bloodrailz/ef_speed.mdl");
	precache_model ("progs/bloodrailz/ef_rail_pop1.mdl");
	//precache_model ("progs/bloodrailz/ef_speed2.mdl");
	
	precache_model ("progs/bloodrailz/hud_r.mdl");
	precache_model ("progs/bloodrailz/hud_s.mdl");
	precache_model ("progs/bloodrailz/hud_r1.mdl");
	precache_model ("progs/bloodrailz/hud_s1.mdl");
	precache_model ("progs/bloodrailz/hud_bolt_sym.mdl");
	precache_model ("progs/bloodrailz/rail_ammo_1.mdl");

	
	precache_model ("progs/bloodrailz/br_quad.mdl");
	precache_model ("progs/bloodrailz/br_ring1.mdl");
	precache_model ("progs/bloodrailz/br_pent.mdl");
	precache_model ("progs/bloodrailz/br_pent2.mdl");
	
};



//Bloodrailz globals

.float decline_time;
.float boost_time;
.float turn_speed;
.float last_angle;

float	intermission_running;
float	intermission_exittime;
.float print_killa;
//.float print_killa_time;
//.float illedbyworld;
//.entity killedby;
//.float killedwep;

.float spawn_protect_time;
//.float spawn_protected;              


.float total_deaths;
.float total_kills;
.float shot_time;
.float shot_time2;

.float shot_downward;  //used to check if rail recharge time needs to be  reduced
//.float axe_fasthit;      //used to check if axe recharge time needs to be  reduced
.float done_damage;

.float axe_splash_time;
.float axe_time;

.float thor_time;
.float thor_slam;
.float death_aura_frag;
.float plasma_frag;
.float rune_bang;
float death_aura_counter;

.float smoke_counter;
.float smoke_height_is_adjusted;
.float smoke_rate;
.vector smoke_offset;
.float smoke_offset_counter;
vector smoke_origin;
float smoke_radius;
float first_smoke;
float smoke_ceiling;

float gravity_counter;
vector gravity_origin;
vector gravity_origin1;
float quasar_counter;
vector quasar_origin;
vector quasar_origin1;
float quasar_push_sound;
float quasar_flash_time;
float gravity_flash_time;

entity smoke_owner;
entity gravity_owner;
entity quasar_owner;
.float smoke_frags;

float smoke_teammate_frags;
float smoke_enemy_frags;
float quasar_teammate_frags;
float quasar_enemy_frags;
float gravity_teammate_frags;
float gravity_enemy_frags;
float power_teammate_frags;
float power_enemy_frags;


float smoke_time;
float quasar_time;
float quasar_buzz_counter;
float gravity_time;

float rune1_plasma;
float rune2_power;
float rune3_haste;
float rune4_aura;


float hasteeffect;

.float speed_sound;
.float dash_timer;    //axe-dash timer
.float dash_counter;    //axe-dash timer

.float alpha;
.float cnt;
.float tarzan_time;
.vector old_hook_vel;
.float spring_chain_on;
.float hook_swing_ground;
.float hook_lookaway;
.float flag_displayed;
.float rune_displayed;

.float hascrown;              
float crown_out;


float top_score_global;			 //    START -- PLAYER AND TEAM STATS
float bottom_score_global;        //
float top_KDR_global;
float bottom_KDR_global;
float total_players_global;     //
float total_score_global;
float red_count_global;
float red_topscore_global;                  
float red_secondscore_global;    
float red_thirdscore_global;    
float red_bottomscore_global;     //    
float red_teamscore_global; 
float blue_count_global;
float blue_topscore_global;       
float blue_secondscore_global;
float blue_thirdscore_global;    
float blue_bottomscore_global;  
float blue_teamscore_global;    
float winning_team_global;    
float teams_are_even;             //    ^^^ END -- PLAYER AND TEAM STATS
.float KDR;

.float airborn_pos;
.float is_over_sky;

.float thor_frag_count;
.float axe_frag_count;
.float rail_frag_count;
.float rails_in_a_row;
.float rail_record_timer;
.float axes_in_a_row;
.float axe_record_timer;



.float railjump_yes;
.float rail_frags;
.float rail_shots;
//.float blocked_rail;
//.float first_block;


float fte_server;
string(entity e, string key) infokey = #80;
float(string) stof = #81;

.float hook_button_released;
.float hook_time;
.float hook_time2;

//AXE CHARGE UP STUFF
.float axe_button_released;
.float axe_power_time;
.float axe_powered;
.float shields_up;
.float shield_time;
.float shield_recharge_time;
.float speedlines_time;
.float speedlines_are_on;
.float speedlines_are_visible;

//RAIL CHARGE UP STUFF
.float rail_button_released;
.float rail_power_time;
.float rail_powered;
.float mag_recharge_time;
.float rail_was_curved;

.float frame_count;
.float old_vel;
.float stored_frame2;
.float stored_z1;
.float stored_z2;
.float stored_z3;
.float stored_z4;
.float stored_z5;
.float stored_z6;

.float up_count;
.float down_count;
.float bounce_switch;
.float bounce_yes;

.float pre_vanish_dist;

.float grind_sound_counter;
.float grind_completed;
.float grind_side_is;
.float angles_not_zero;
.float sparks_out;
.float anglestored;
.float grind_time;
.float vel_before_wallrun;
.float punchang; //dummy roll angle field

.float slope_time;
.float front_slope;
.vector slope_vec;
.float jump_time;
.float z_height;

.float blast_time;
.float skiing_on;
.float ski_button;

.float ski_time;
.float ski_time2;
.float ski_button_time;
.float ski_sound_counter;

.float landed_on_decline;


.vector movement;

.float rail_HUD;
.float shield_HUD;
.float symbols_HUD;
.float ctfhud;
.float flagscores_red;
.float flagscores_blue;
.float button_press_display;

.float rail_ammo_displayed;
.float ammo_slugs;
.float ammo_zero_time;   //9-17-23

.float tier1;
.float tier2;
.float tier3;

//float EF_ADDITIVE = 32;
float EF_NODEPTHTEST = 8192;
.entity viewmodelforclient;
.entity drawonlytoclient;
float(entity ent, string tagname) gettagindex = #451;
vector(entity ent, float tagindex) gettaginfo = #452;

//Plasma stuff
.vector velocity_plasma;
.float plasma_powered;
//.float plasma_is_pushed;
.float pushed_plasma;
.float plasma_time;
//.vector old_velocity;
//.vector plasma_forward;
.float bounce_time;
.float hookx;
.float hanim;
.float x_dist;
.float crossanim;
.entity hookhead;
.vector adjusted_hook_impact;

.float wraith;
float ghost_red;
float ghost_blue;

// Curved rail stuff
.vector		lastEndPos;
.vector		lastFlick;
.vector		old_angles;
.entity		flickEnt;
.float		flickTime;
.float		lastButton0;
.vector	 	lastMouseUp;
.float 		marker_up;

#define DP_QC_SPRINTF
string(string fmt, ...) sprintf = #627;


float(string model) precache_vwep_model = #532;

void(vector start, vector mins, vector maxs, vector end, float nomonsters, entity ent) tracebox = #90; // Part of DP_QC_TRACEBOX

//Racing

.float racing_on;
float racing_on_global;
.float race_completed;
float chrono_time;
float countdown;
float countdown_ct;

float place_one_time;
float place_two_time;
float place_three_time;
.float my_previous_time;

.float shark_time;

.vector antilag_aim;


////////////  CTF DEFS   //////////////////

float TEAM_ALL = 0;
float TEAM_BLUE = 14;
float TEAM_RED = 5;
float TEAM_YELLOW = 13;
float TEAM_GREEN = 4;

.float flag_carrier;
.float flag_since;
.float last_returned_flag;
.float last_fragged_carrier;
.float last_hurt_carrier;

//for flag status
float BLUE_FLAG_TAKEN;
float RED_FLAG_TAKEN;

float CTF_FLAG_AT_BASE = 0;
float CTF_FLAG_CARRIED = 1;
float CTF_FLAG_DROPPED = 2;

//flag effects
float EF_BLUE = 64;
float EF_RED = 128;

float IT_HOOK = 8388608; //.items flag for hook

float hookspeedfire;
float hookspeedpull;
.float hook_out;

//--runedefs--
entity runespawn;

//.items2
float IT2_SIGIL1 = 1;
float IT2_SIGIL2 = 2;
float IT2_SIGIL3 = 4;
float IT2_SIGIL4 = 8;



.float dash_button;
.float dash_time;

.float leaning;

entity red_flag_ent;
entity blue_flag_ent;



float smoke_ent_number;
/*
.float brflags;


float BR_HOOK_OUT = 1;
float BR_HASCROWN = 2;
float BR_SHIELDS_UP = 4;
float BR_AXE_POWERED = 8;
float BR_RAIL_WAS_CURVED = 16;
float BR_RAIL_POWERED = 32;
float BR_SPARKS_OUT = 128;
float BR_ANGLES_NOT_ZERO =256;
float BR_XXXX = 512;
float BR_XXXXXXXX = 1024;
float BR_IS_OVER_SKY = 2048;

float BR_RAILJUMP_YES = 32768;
float BR_HOOK_BUTTON_RELEASED = 65536;
float BR_RAIL_BUTTON_RELEASED = 131072;
float BR_AXE_BUTTON_RELEASED = 262144;
float BR_LEANING = 524288;


float HUD_FLAG_CARRIER = 1;
float HUD_RAIL_HUD = 2;
float HUD_SHIELD_HUD = 4; 
float HUD_CTFHUD = 8;
float HUD_SYMBOLS_HUD = 16;
float HUD_FLAGSCORES_RED = 32;
float HUD_FLAGSCORES_BLUE = 64;
float HUD_BUTTON_PRESS_DISPLAY = 128;
float HUD_RAIL_AMMO_DISPLAYED = 256;
float HUD_MARKER_UP = 512;
float HUD_WRAITH =1024;
float HUD_FLAG_DISPLAYED =2048;
float HUD_RUNE_DISPLAYED =4096;
float HUD_SPEEDLINES_ARE_ON = 8192;
float HUD_SPEEDLINES_ARE_VISIBLE = 16384;
*/