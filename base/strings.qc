//
// Strings.qc
//
// A bunch of routines for returning various strings.
// Several routines were inspired by the clanring server mod.
//
// Written by J.P. Grossman, modified by bucksh0t.
//

//
//  F T O S
//
//  Some numbers have been hard-coded to avoid the problems associated with
//  a single ftos buffer.
//
string (float n) strings_ftos =
{
    if (n == 1)
        return "1 ";
    if (n == 2)
        return "2 ";
    if (n == 3)
        return "3 ";
    if (n == 4)
        return "4 ";
    if (n == 5)
        return "5 ";
    if (n == 6)
        return "6 ";
    if (n == 7)
        return "7 ";
    if (n == 8)
        return "8 ";
    if (n == 9)
        return "9 ";
    if (n == 10)
        return "10";
    if (n == 11)
        return "11";
    if (n == 12)
        return "12";
    if (n == 13)
        return "13";
    if (n == 14)
        return "14";
    if (n == 15)
        return "15";
    if (n == 20)
        return "20";
    if (n == 25)
        return "25";
    if (n == 30)
        return "30";
    return "???";
};



string (float n) strings_countdown ={return"";}

string () strings_mode_countdown =
{
    if (elohim_playmode & ELOHIM_MATCH_MODE)
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        return"-\bctf match mode\b-\n\n";
      else 
        return"-\btdm match mode\b-\n\n";
    }
    //don't need these now but just in case
    else if (elohim_playmode & RACE_MODE)
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        return"-\bctf practice mode\b-\n\n";
      else
        return"-\b practice mode \b-\n\n";
    }
    else if (elohim_playmode & DM_PUBLIC_MODE)
      return"-\bpublic tdm mode\b-\n\n";
    else
    {
      if (elohim_playmode & CLANRING_CTF_MODE)
        return"-\bpublic ctf mode\b-\n\n";
      else
		return"-\b  ffa mode  \b-\n\n";
    }
    return"\n\n";
};

string (float n) strings_fraglimit_countdown ={return"";};
string (float n) strings_timelimit_countdown ={return"";};
string (entity e) strings_get_armour_val ={return"";}
string (entity e) strings_get_armour_type ={return"";}
string (entity e) strings_get_weapon ={return"";}
string (entity e) strings_get_health_ammo ={return"";}
string (float num) strings_get_teamname ={return "";}
string (float num) strings_get_teamname_bronze ={return "";}
string (float num) strings_get_teamname2 ={return "";}
string (float num) strings_get_teamname3 ={return "";}
string (float num) strings_get_teamname_up_by ={return "";}
string (float num) strings_get_teamname_up_by_short ={return "";}
string (float num) strings_get_teamname_needs ={return "";}

//
//  G E T  M A P N A M E
//
//  Return the nth map name.
//
string (float mapnum) strings_get_mapname =
{
    if (mapnum < 10){return "";}
    
    if (mapnum < 26)
    {
        if (mapnum == 11)
            return "ctf_takayama_r1";
        if (mapnum == 12)
            return "ctf_dissocia_r1";
        if (mapnum == 13)
            return "ctf_bridge_r1";
        if (mapnum == 14)
            return "ctf_hanghigh_r1";
        if (mapnum == 15)
            return "ctf_swingest_r1";
        if (mapnum == 16)
            return "";
        if (mapnum == 17)
            return "ctf_teardown_r1";
	if (mapnum == 18)
            return "ctf_eyesout_r1";
	if (mapnum == 19)
            return "ctf_relic2_r1"; 
        if (mapnum == 20)
            return "ctf_rebirth_r1";
        if (mapnum == 21)
            return "ctf_edge3_r1";
        if (mapnum == 22)
            return "ctf_faceoff_r1";
        if (mapnum == 23)
            return "ctf_sandstorm_r1";
        if (mapnum == 24)
            return "ctf_lasertag_r1";
        if (mapnum == 25)
            return "ctf_dreamland_r1";
              
        return "";
    }
    if (mapnum < 41)
    {
        if (mapnum == 26)
            return "ctf_bikini_r1";
        if (mapnum == 27)
            return "ctf_doglyfe_r1";
        if (mapnum == 28)
            return "ctf_bamboo_r1";
        if (mapnum == 29)
            return "ctf_daywalker_r1";
        if (mapnum == 30)
            return "ctf_easter_r1";
        if (mapnum == 31)
            return "ctf_fulcrum_r1";
        if (mapnum == 32)
            return "ctf_albatross_r1";
	if (mapnum == 33)
            return "ctf_firestorm_r1";
	if (mapnum == 34)
            return "ctf_feral_r1";
        if (mapnum == 35)
            return "ctf_gulch_r1";
        if (mapnum == 36)
            return "";
        if (mapnum == 37)
            return "";
        if (mapnum == 38)
            return "";
        if (mapnum == 39)
            return "";
        if (mapnum == 40)
            return "";
            
        return "";
    }
    if (mapnum < 56)
    {
        if (mapnum == 41)
            return "ctf_bamboo_r1";
        if (mapnum == 42)
            return "ctf_relic2_r1";
        if (mapnum == 43)
            return "";
        if (mapnum == 44)
            return "";
        if (mapnum == 45)
            return "";
        if (mapnum == 46)
            return "";
        if (mapnum == 47)
            return "";
        if (mapnum == 48)
            return "";
        if (mapnum == 49)
            return "";
        if (mapnum == 50)
            return "";
        if (mapnum == 51)
            return "";
        if (mapnum == 52)
            return "";
        if (mapnum == 53)
            return "";
        if (mapnum == 54)
            return "";
        if (mapnum == 55)
            return "";
        return ""; 
    }

    	if (mapnum < 60) {return "";}
	if (mapnum < 70) {return "";}
	if (mapnum < 80) {return "";}
	if (mapnum < 90) {return "";}
	if (mapnum < 100) {return "";}
	if (mapnum < 110) {return "";}
	if (mapnum < 120) {return "";}
	if (mapnum < 130) {return "";}
	if (mapnum < 140) {return "";}
	if (mapnum < 150) {return "";}
	if (mapnum < 160) {return "";}
	if (mapnum < 170) {return "";}
	if (mapnum < 180) {return "";}
	if (mapnum < 190) {return "";}
	if (mapnum < 200) {return "";}
	if (mapnum < 210) {return "";}
	if (mapnum < 220) {return "";}
	if (mapnum < 230) {return "";}
	if (mapnum < 240) {return "";}
	if (mapnum < 250) {return "";}
	if (mapnum < 260) {return "";}
	if (mapnum < 270) {return "";}
	if (mapnum < 280) {return "";}
	if (mapnum < 290) {return "";}
	if (mapnum < 300) {return "";}
    return "";
};

//
//  G E T  M O D E
//
//  Returns mode string 
//
string (float mode) strings_get_mode =
{
    // if (mode == 0)
    //     return "Normal";
    if (mode == 1)
        return "Practice";
    else if (mode == 2)
        return "CTF - public";
    else if (mode == 3)
        return "CTF - match";
    else if (mode == 4)
        return "TDM - public";
    else if (mode == 5)
        return "TDM - match";

    else
        return "Normal";
};

//
//  S Z P L U R A L
//
//  Helper string for printing.
//
string (float n) strings_szplural =
{
    if (n == 1)
        return "\n";
    return "s\n";
};