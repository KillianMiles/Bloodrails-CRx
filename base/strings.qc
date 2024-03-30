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

//
//  F T O S  G O L D
//
//  Return some gold number strings.
//
string (float n) strings_ftos_gold =
{
    if (n == 0)
        return "\0";
    if (n == 1)
        return "\1";
    if (n == 2)
        return "\2";
    if (n == 3)
        return "\3";
    if (n == 4)
        return "\4";
    if (n == 5)
        return "\5";
    if (n == 6)
        return "\6";
    if (n == 7)
        return "\7";
    if (n == 8)
        return "\8";
    if (n == 9)
        return "\9";
    return "?";
};

string (float n) strings_countdown =
{
    if (n == 0)
        return "\bcountdown:    \b\0\n\n";
    if (n == 1)
        return "\bcountdown:    \b\1\n\n";
    if (n == 2)
        return "\bcountdown:    \b\2\n\n";
    if (n == 3)
        return "\bcountdown:    \b\3\n\n";
    if (n == 4)
        return "\bcountdown:    \b\4\n\n";
    if (n == 5)
        return "\bcountdown:    \b\5\n\n";
    if (n == 6)
        return "\bcountdown:    \b\6\n\n";
    if (n == 7)
        return "\bcountdown:    \b\7\n\n";
    if (n == 8)
        return "\bcountdown:    \b\8\n\n";
    if (n == 9)
        return "\bcountdown:    \b\9\n\n";
    if (n == 10)
        return "\bcountdown:   \b\1\0\n\n";
    if (n == 11)
        return "\bcountdown:   \b\1\1\n\n";
    if (n == 12)
        return "\bcountdown:   \b\1\2\n\n";
    if (n == 13)
        return "\bcountdown:   \b\1\3\n\n";
    if (n == 14)
        return "\bcountdown:   \b\1\4\n\n";
    if (n == 15)
        return "\bcountdown:   \b\1\5\n\n";
    if (n == 16)
        return "\bcountdown:   \b\1\6\n\n";
    if (n == 17)
        return "\bcountdown:   \b\1\7\n\n";
    if (n == 18)
        return "\bcountdown:   \b\1\8\n\n";
    if (n == 19)
        return "\bcountdown:   \b\1\9\n\n";
    if (n == 20)
        return "\bcountdown:   \b\2\0\n\n";
    return "\bcountdown:   \b??\n\n";
};

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
    else if (elohim_playmode & CLAN_ARENA_MODE)
      return"-\b airshot mode \b-\n\n";
    else if (elohim_playmode & CLAN_ARENA_MODE)
      return"-\b  clan arena  \b-\n\n";
    else if (elohim_playmode & ROCKET_ARENA_MODE)
      return"-\b rocket arena \b-\n\n";
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

string (float n) strings_fraglimit_countdown =
{
    if (elohim_playmode & ELOHIM_MATCH_MODE)
        return "";
    if (elohim_playmode & AIR_ARENA_MODE)
        return "\bfraglimit:  \boff\n";
    if (n == 0)
        return "\bfraglimit:    \b\0\n";
    if (n == -1)
        return "\bfraglimit:  \boff\n";
    if (n == 15)
        return "\bfraglimit:   \b\1\5\n";
    if (n == 20)
        return "\bfraglimit:   \b\2\0\n";
    if (n == 50)
        return "\bfraglimit:   \b\5\0\n";
    if (n == 120)
        return "\bfraglimit:  \b\1\2\0\n";
    return "\bfraglimit:   \b??\n";
};

string (float n) strings_timelimit_countdown =
{
    if (elohim_playmode & AIR_ARENA_MODE)
        return "\btimelimit:    \b\2\n";
    if (n == 5)
        return "\btimelimit:    \b\5\n";
    if (n == 10)
        return "\btimelimit:   \b\1\0\n";
    if (n == 15)
        return "\btimelimit:   \b\1\5\n";
    if (n == 20)
        return "\btimelimit:   \b\2\0\n";
    if (n == 25)
        return "\btimelimit:   \b\2\5\n";
    if (n == 30)
        return "\btimelimit:   \b\3\0\n";
    return "\btimelimit:   \b??\n";
};

//
//  G E T  A R M O U R  V A L
//
//  Returns a string containing the amount of armour the player has.
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_armour_val =
{
    if (e.items & IT_INVULNERABILITY)
        return "[666]";
    if (e.armorvalue <= 100)
    {
        if (e.armorvalue <= 0) return "None ";
        if (e.armorvalue <= 5) return "5  ";
        if (e.armorvalue <= 10) return "10 ";
        if (e.armorvalue <= 20) return "20 ";
        if (e.armorvalue <= 30) return "30 ";
        if (e.armorvalue <= 40) return "40 ";
        if (e.armorvalue <= 50) return "50 ";
        if (e.armorvalue <= 60) return "60 ";
        if (e.armorvalue <= 70) return "70 ";
        if (e.armorvalue <= 80) return "80 ";
        if (e.armorvalue <= 90) return "90 ";
        return "100";
    }
    else
    {
        if (e.armorvalue <= 110) return "110";
        if (e.armorvalue <= 120) return "120";
        if (e.armorvalue <= 130) return "130";
        if (e.armorvalue <= 140) return "140";
        if (e.armorvalue <= 150) return "150";
        if (e.armorvalue <= 160) return "160";
        if (e.armorvalue <= 170) return "170";
        if (e.armorvalue <= 180) return "180";
        if (e.armorvalue <= 190) return "190";
        if (e.armorvalue <= 200) return "200";
        return "???";
    }
};

//
//  G E T  A R M O U R  T Y P E
//
//  Returns one of
//
//     "Armour: R "
//     "Armour: Y "
//     "Armour: G "
//     "Armour: "
//
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_armour_type =
{

    if (e.items & IT_INVULNERABILITY) return "Armor: 666";
    if (e.armortype == 0.8) return "Armor: R ";
    if (e.armortype == 0.6) return "Armor: Y ";
    if (e.armortype == 0.3) return "Armor: G ";
    return "Armor: ";
};

//
//  G E T  W E A P O N
//
//  Returns "[QOR] <weapon>\n" where [QOR] are the quad, ring and
//  suit flags (either present or absent) and <weapon> is the player's
//  weapon (I'm sure you were having trouble figuring that one out).
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_weapon =
{
    if (e.items & IT_SUIT)
    {
        if (e.items & IT_QUAD)
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " [QOR] Rocket Launcher\n";
                if (e.weapon == 64) return " [QOR] Lightning Gun\n";
                if (e.weapon == 16) return " [QOR] Grenade Launcher\n";
                if (e.weapon == 8) return " [QOR] Super Nailgun\n";
                if (e.weapon == 2) return " [QOR] Super Shotgun\n";
                if (e.weapon == 4) return " [QOR] Nailgun\n";
                if (e.weapon == 1) return " [QOR] Shotgun\n";
                if (e.weapon == 4096) return " [QOR] Axe\n";
                return " [QOR] No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " [Q R] Rocket Launcher\n";
                if (e.weapon == 64) return " [Q R] Lightning Gun\n";
                if (e.weapon == 16) return " [Q R] Grenade Launcher\n";
                if (e.weapon == 8) return " [Q R] Super Nailgun\n";
                if (e.weapon == 2) return " [Q R] Super Shotgun\n";
                if (e.weapon == 4) return " [Q R] Nailgun\n";
                if (e.weapon == 1) return " [Q R] Shotgun\n";
                if (e.weapon == 4096) return " [Q R] Axe\n";
                return " [Q R] No Weapon\n";
            }
        }
        else
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " [ OR] Rocket Launcher\n";
                if (e.weapon == 64) return " [ OR] Lightning Gun\n";
                if (e.weapon == 16) return " [ OR] Grenade Launcher\n";
                if (e.weapon == 8) return " [ OR] Super Nailgun\n";
                if (e.weapon == 2) return " [ OR] Super Shotgun\n";
                if (e.weapon == 4) return " [ OR] Nailgun\n";
                if (e.weapon == 1) return " [ OR] Shotgun\n";
                if (e.weapon == 4096) return " [ OR] Axe\n";
                return " [ OR] No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " [  R] Rocket Launcher\n";
                if (e.weapon == 64) return " [  R] Lightning Gun\n";
                if (e.weapon == 16) return " [  R] Grenade Launcher\n";
                if (e.weapon == 8) return " [  R] Super Nailgun\n";
                if (e.weapon == 2) return " [  R] Super Shotgun\n";
                if (e.weapon == 4) return " [  R] Nailgun\n";
                if (e.weapon == 1) return " [  R] Shotgun\n";
                if (e.weapon == 4096) return " [  R] Axe\n";
                return "   [  R] No Weapon\n";
            }
        }
    }
    else
    {
        if (e.items & IT_QUAD)
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " [QO ] Rocket Launcher\n";
                if (e.weapon == 64) return " [QO ] Lightning Gun\n";
                if (e.weapon == 16) return " [QO ] Grenade Launcher\n";
                if (e.weapon == 8) return " [QO ] Super Nailgun\n";
                if (e.weapon == 2) return " [QO ] Super Shotgun\n";
                if (e.weapon == 4) return " [QO ] Nailgun\n";
                if (e.weapon == 1) return " [QO ] Shotgun\n";
                if (e.weapon == 4096) return " [QO ] Axe\n";
                return " �Q� � No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " [Q  ] Rocket Launcher\n";
                if (e.weapon == 64) return " [Q  ] Lightning Gun\n";
                if (e.weapon == 16) return " [Q  ] Grenade Launcher\n";
                if (e.weapon == 8) return " [Q  ] Super Nailgun\n";
                if (e.weapon == 2) return " [Q  ] Super Shotgun\n";
                if (e.weapon == 4) return " [Q  ] Nailgun\n";
                if (e.weapon == 1) return " [Q  ] Shotgun\n";
                if (e.weapon == 4096) return " [Q  ] Axe\n";
                return " [Q  ] No Weapon\n";
            }
        }
        else
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " [ O ] Rocket Launcher\n";
                if (e.weapon == 64) return " [ O ] Lightning Gun\n";
                if (e.weapon == 16) return " [ O ] Grenade Launcher\n";
                if (e.weapon == 8) return " [ O ] Super Nailgun\n";
                if (e.weapon == 2) return " [ O ] Super Shotgun\n";
                if (e.weapon == 4) return " [ O ] Nailgun\n";
                if (e.weapon == 1) return " [ O ] Shotgun\n";
                if (e.weapon == 4096) return " [ O ] Axe\n";
                return "  [ O ] No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " [   ] Rocket Launcher\n";
                if (e.weapon == 64) return " [   ] Lightning Gun\n";
                if (e.weapon == 16) return " [   ] Grenade Launcher\n";
                if (e.weapon == 8) return " [   ] Super Nailgun\n";
                if (e.weapon == 2) return " [   ] Super Shotgun\n";
                if (e.weapon == 4) return " [   ] Nailgun\n";
                if (e.weapon == 1) return " [   ] Shotgun\n";
                if (e.weapon == 4096) return " [   ] Axe\n";
                return "  [   ] No Weapon\n";
            }
        }
    }
};

//
//  G E T  H E A L T H  A M M O
//
//  Returns "  Health: <amount>   Ammo: "
//
//  The nested ifs are to speed things up.  Used for observer mode
//  heads-up display.
//
string (entity e) strings_get_health_ammo =
{
    if (e.health <= 125)
    {
        if (e.health <= 65)
        {
            if (e.health <= 30)
            {
                if (e.health <= 0)
                    return "  Health: 0    Ammo: ";
                if (e.health <= 5)
                    return "  Health: 5    Ammo: ";
                if (e.health <= 10)
                    return "  Health: 10   Ammo: ";
                if (e.health <= 15)
                    return "  Health: 15   Ammo: ";
                if (e.health <= 20)
                    return "  Health: 20   Ammo: ";
                if (e.health <= 25)
                    return "  Health: 25   Ammo: ";
                return "  Health: 30   Ammo: ";
            }
            else
            {
                if (e.health <= 35)
                    return "  Health: 35   Ammo: ";
                if (e.health <= 40)
                    return "  Health: 40   Ammo: ";
                if (e.health <= 45)
                    return "  Health: 45   Ammo: ";
                if (e.health <= 50)
                    return "  Health: 50   Ammo: ";
                if (e.health <= 55)
                    return "  Health: 55   Ammo: ";
                if (e.health <= 60)
                    return "  Health: 60   Ammo: ";
                return "  Health: 65   Ammo: ";
            }
        }
        else
        {
            if (e.health <= 95)
            {
                if (e.health <= 70)
                    return "  Health: 70   Ammo: ";
                if (e.health <= 75)
                    return "  Health: 75   Ammo: ";
                if (e.health <= 80)
                    return "  Health: 80   Ammo: ";
                if (e.health <= 85)
                    return "  Health: 85   Ammo: ";
                if (e.health <= 90)
                    return "  Health: 90   Ammo: ";
                return "  Health: 95   Ammo: ";
            }
            else
            {
                if (e.health <= 100)
                    return "  Health: 100  Ammo: ";
                if (e.health <= 105)
                    return "  Health: 105  Ammo: ";
                if (e.health <= 110)
                    return "  Health: 110  Ammo: ";
                if (e.health <= 115)
                    return "  Health: 115  Ammo: ";
                if (e.health <= 120)
                    return "  Health: 120  Ammo: ";
                return "  Health: 125  Ammo: ";
            }
        }
    }
    else
    {
        if (e.health <= 195)
        {
            if (e.health <= 160)
            {
                if (e.health <= 130)
                    return "  Health: 130  Ammo: ";
                if (e.health <= 135)
                    return "  Health: 135  Ammo: ";
                if (e.health <= 140)
                    return "  Health: 140  Ammo: ";
                if (e.health <= 145)
                    return "  Health: 145  Ammo: ";
                if (e.health <= 150)
                    return "  Health: 150  Ammo: ";
                if (e.health <= 155)
                    return "  Health: 155  Ammo: ";
                return "  Health: 160  Ammo: ";
            }
            else
            {
                if (e.health <= 165)
                    return "  Health: 165  Ammo: ";
                if (e.health <= 170)
                    return "  Health: 170  Ammo: ";
                if (e.health <= 175)
                    return "  Health: 175  Ammo: ";
                if (e.health <= 180)
                    return "  Health: 180  Ammo: ";
                if (e.health <= 185)
                    return "  Health: 185  Ammo: ";
                if (e.health <= 190)
                    return "  Health: 190  Ammo: ";
                return "  Health: 195  Ammo: ";
            }
        }
        else
        {
            if (e.health <= 225)
            {
                if (e.health <= 200)
                    return "  Health: 200  Ammo: ";
                if (e.health <= 205)
                    return "  Health: 205  Ammo: ";
                if (e.health <= 210)
                    return "  Health: 210  Ammo: ";
                if (e.health <= 215)
                    return "  Health: 215  Ammo: ";
                if (e.health <= 220)
                    return "  Health: 220  Ammo: ";
                return "  Health: 225  Ammo: ";
            }
            else
            {
                if (e.health <= 230)
                    return "  Health: 230  Ammo: ";
                if (e.health <= 235)
                    return "  Health: 235  Ammo: ";
                if (e.health <= 240)
                    return "  Health: 240  Ammo: ";
                if (e.health <= 245)
                    return "  Health: 245  Ammo: ";
                if (e.health <= 600)
                    return "  Health: 250  Ammo: ";
                return "  Health: 666  Ammo: ";
            }
        }
    }
};

//
//  G E T  T E A M N A M E
//
//  Return the colour string corresponding to a given team.
//
string (float num) strings_get_teamname =
{
    if (num == 1)
        return "Brown team";
    if (num == 2)
        return "Light Blue team";
    if (num == 3)
        return "Green team";
    if (num == 4)
        return "Red team";
    if (num == 5)
        return "Olive team";
    if (num == 6)
        return "Gold team";
    if (num == 7)
        return "Flesh team";
    if (num == 8)
        return "Lavender team";
    if (num == 9)
        return "Purple team";
    if (num == 10)
        return "Beige team";
    if (num == 11)
        return "Aqua team";
    if (num == 12)
        return "Yellow team";
    if (num == 13)
        return "Blue team";
    return "???? team"; // shouldn't happen
};

//
//  G E T  T E A M N A M E  B R O N Z E
//
//  Same as above, but in bronze letters.
//  My God, I've gone insane.
//
string (float num) strings_get_teamname_bronze =
{
    if (num == 1)
        return "\bBrown team\b";
    if (num == 2)
        return "\bLight Blue team\b";
    if (num == 3)
        return "\bGreen team\b ";
    if (num == 4)
        return "\bRed team\b";
    if (num == 5)
        return "\bOlive team\b";
    if (num == 6)
        return "\bGold team\b";
    if (num == 7)
        return "\bFlesh team\b  ";
    if (num == 8)
        return "\bLavender team\b";
    if (num == 9)
        return "\bPurple team\b";
    if (num == 10)
        return "\bBeige team\b";
    if (num == 11)
        return "\bAqua team\b";
    if (num == 12)
        return "\bYellow team\b";
    if (num == 13)
        return "\bBlue team\b";
    return "\bUnknown team\b"; // shouldn't happen
};

//
//  G E T  T E A M N A M E 2
//
//  Return the colour string corresponding to a given team.
//  The string contains EXACTLY 10 characters.
//
string (float num) strings_get_teamname2 =
{
    if (num == 1)
        return "Brown     ";
    if (num == 2)
        return "Light Blue";
    if (num == 3)
        return "Green     ";
    if (num == 4)
        return "Red       ";
    if (num == 5)
        return "Olive     ";
    if (num == 6)
        return "Gold      ";
    if (num == 7)
        return "Flesh     ";
    if (num == 8)
        return "Lavender  ";
    if (num == 9)
        return "Purple    ";
    if (num == 10)
        return "Beige     ";
    if (num == 11)
        return "Aqua      ";
    if (num == 12)
        return "Yellow    ";
    if (num == 13)
        return "Blue      ";
    return "????      "; // shouldn't happen
};

//
//  G E T  T E A M N A M E 3
//
//  For when 10 characters is too many.. I can't believe I'm doing this.
//
string (float num) strings_get_teamname3 =
{
    if (num == 1)
        return "Brown    ";
    if (num == 2)
        return "Lite Blue";
    if (num == 3)
        return "Green    ";
    if (num == 4)
        return "Red      ";
    if (num == 5)
        return "Olive    ";
    if (num == 6)
        return "Gold     ";
    if (num == 7)
        return "Flesh    ";
    if (num == 8)
        return "Lavender ";
    if (num == 9)
        return "Purple   ";
    if (num == 10)
        return "Beige    ";
    if (num == 11)
        return "Aqua     ";
    if (num == 12)
        return "Yellow   ";
    if (num == 13)
        return "Blue     ";
    return "????     "; // shouldn't happen
};

//
//  G E T  T E A M N A M E  U P  B Y
//
//  Return the "colour up by " string corresponding to a given team.
//
string (float num) strings_get_teamname_up_by =
{
    if (num == 1)
        return "        Brown up by ";
    if (num == 2)
        return "   Light Blue up by ";
    if (num == 3)
        return "        Green up by ";
    if (num == 4)
        return "          Red up by ";
    if (num == 5)
        return "        Olive up by ";
    if (num == 6)
        return "         Gold up by ";
    if (num == 7)
        return "        Flesh up by ";
    if (num == 8)
        return "     Lavender up by ";
    if (num == 9)
        return "       Purple up by ";
    if (num == 10)
        return "        Beige up by ";
    if (num == 11)
        return "         Aqua up by ";
    if (num == 12)
        return "       Yellow up by ";
    if (num == 13)
        return "         Blue up by ";
    return "         ???? up by "; // shouldn't happen
};

//
//  G E T  T E A M N A M E  U P  B Y
//
//  Return the "colour up by " string corresponding to a given team.
//
string (float num) strings_get_teamname_up_by_short =
{
    if (num == 1)
        return "The Brown Team up by ";
    if (num == 2)
        return "The Light Blue Team up by ";
    if (num == 3)
        return "The Green Team up by ";
    if (num == 4)
        return "The Red Team up by ";
    if (num == 5)
        return "The Olive Team up by ";
    if (num == 6)
        return "The Gold Team up by ";
    if (num == 7)
        return "The Flesh Team up by ";
    if (num == 8)
        return "The Lavender Team up by ";
    if (num == 9)
        return "The Purple Team up by ";
    if (num == 10)
        return "The Beige Team up by ";
    if (num == 11)
        return "The Aqua Team up by ";
    if (num == 12)
        return "The Yellow Team up by ";
    if (num == 13)
        return "The Blue Team up by ";
    return "The ???? Team up by "; // shouldn't happen
};

string (float num) strings_get_teamname_needs =
{
    if (num == 1)
        return "The Brown Team up by ";
    if (num == 2)
        return "The Light Blue Team up by ";
    if (num == 3)
        return "Green  needs ";
    if (num == 4)
        return "Red    needs ";
    if (num == 5)
        return "The Olive Team up by ";
    if (num == 6)
        return "The Gold Team up by ";
    if (num == 7)
        return "The Flesh Team up by ";
    if (num == 8)
        return "The Lavender Team up by ";
    if (num == 9)
        return "The Purple Team up by ";
    if (num == 10)
        return "The Beige Team up by ";
    if (num == 11)
        return "The Aqua Team up by ";
    if (num == 12)
        return "Yellow needs ";
    if (num == 13)
        return "Blue needs   ";
    return "???? needs   "; // shouldn't happen
};

//
//  G E T  M A P N A M E
//
//  Return the nth map name.
//
string (float mapnum) strings_get_mapname =
{
    if (mapnum < 10)
    {
    //     if (mapnum == 0)
    //         return "start";
    //     if (mapnum == 1)
    //         return "start0";
    //     if (mapnum == 2)
    //         return "start1";
    //     if (mapnum == 3)
    //         return "end";
    //     if (mapnum == 4)
    //         return "aerowalk";
    //     if (mapnum == 5)
    //         return "ztndm3";
    //     if (mapnum == 6)
    //         return "ztndm4";
	// if (mapnum == 7)
    //         return "ultrav";
	// if (mapnum == 8)
    //         return "q3dm6qw";   
	// if (mapnum == 9)
    //         return "aggressr";                                                            
        return "";
    }
    if (mapnum < 26)
    {
        if (mapnum == 11)
            return "ctf_takayama_b4";
        if (mapnum == 12)
            return "ctf_dissocia_c2";
        if (mapnum == 13)
            return "ctf_bridge_b1";
        if (mapnum == 14)
            return "ctf_hanghigh_c2";
        if (mapnum == 15)
            return "ctf_longest1_b1";
        if (mapnum == 16)
            return "ctf_longest2_c1";
        if (mapnum == 17)
            return "ctf_teardown_b2";
	if (mapnum == 18)
            return "ctf_eyesout_b2";
	if (mapnum == 19)
            return "ctf_relic2_b2"; 
        if (mapnum == 20)
            return "ctf_rebirth_b1";
        if (mapnum == 21)
            return "ctf_edge3_c1";
        if (mapnum == 22)
            return "ctf_facing_b5";
        if (mapnum == 23)
            return "ctf_sandstorm_b2";
        if (mapnum == 24)
            return "ctf_lasertag1_b1";
        if (mapnum == 25)
            return "ctf_lasertag2_b1";
              
        return "";
    }
    if (mapnum < 41)
    {
        if (mapnum == 26)
            return "ctf_spongebob_b2";
        if (mapnum == 27)
            return "ctf_doglyfe_b2";
        if (mapnum == 28)
            return "ctf_dogrun_b1";
        if (mapnum == 29)
            return "ctf_daywalker_c1";
        if (mapnum == 30)
            return "ctf_volcano_b2";
        if (mapnum == 31)
            return "ctf_fulcrum_c1";
        if (mapnum == 32)
            return "ctf_albatross_b1";
	if (mapnum == 33)
            return "ctf_firestorm_b1";
	if (mapnum == 34)
            return "ctf_feral_b2";
        if (mapnum == 35)
            return "ctf_gulch_b1";
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
            return "storm";
        if (mapnum == 42)
            return "ctf_relic2_b2";
        if (mapnum == 43)
            return "slug";
        if (mapnum == 44)
            return "widowmakr";
        if (mapnum == 45)
            return "shiro2";
        if (mapnum == 46)
            return "barrel";
        if (mapnum == 47)
            return "longest_yard";
        if (mapnum == 48)
            return "dranzdm8";
        if (mapnum == 49)
            return "endif";
        if (mapnum == 50)
            return "yunroot";
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
    if (mapnum < 71)
    {
        if (mapnum == 56)
            return "race_valley_b2";
        if (mapnum == 57)
            return "race_orange_b1";
        if (mapnum == 58)
            return "race_diss_b1";
        if (mapnum == 59)
            return "";
        if (mapnum == 60)
            return "";
        if (mapnum == 61)
            return "";
        if (mapnum == 62)
            return "";
	if (mapnum == 63)
            return "";
	if (mapnum == 64)
            return "";   
        if (mapnum == 65)
            return "";
        if (mapnum == 66)
            return "";
        if (mapnum == 67)
            return "";
        if (mapnum == 68)
            return "";
        if (mapnum == 69)
            return "";
        if (mapnum == 70)
            return "";
        return ""; 
    }
    if (mapnum < 60)
    {
        if (mapnum == 51)
            return "d1_";
        if (mapnum == 52)
            return "d2_";
        if (mapnum == 53)
            return "d3_";
        if (mapnum == 54)
            return "d4_";
        if (mapnum == 55)
            return "d5_";
        if (mapnum == 56)
            return "d6_";
        if (mapnum == 57)
            return "d7_";  
        if (mapnum == 58)
            return "d8_";
        if (mapnum == 59)
            return "";  
        return "";
    }
    if (mapnum < 70)
    {
        if (mapnum == 61)
            return "";
        if (mapnum == 62)
            return "";
        if (mapnum == 63)
            return "";
        if (mapnum == 64)
            return "";
        if (mapnum == 65)
            return "";
        if (mapnum == 66)
            return "";
        if (mapnum == 67)
            return "";
	if (mapnum == 68)
            return "";
	if (mapnum == 69)
            return "";   
        return "";
    }
    if (mapnum < 80)
    {
        if (mapnum == 71)
            return "";
        if (mapnum == 72)
            return "";
        if (mapnum == 73)
            return "";
        if (mapnum == 74)
            return "";
        if (mapnum == 75)
            return "";
        if (mapnum == 76)
            return "";
        if (mapnum == 77)
            return "";
	if (mapnum == 78)
            return "";
	if (mapnum == 79)
            return "";   
        return "";
    }
    if (mapnum < 90)
    {
        if (mapnum == 81)
            return "";
        if (mapnum == 82)
            return "";
        if (mapnum == 83)
            return "";
        if (mapnum == 84)
            return "";
        if (mapnum == 85)
            return "";
        if (mapnum == 86)
            return "";
        if (mapnum == 87)
            return "";
	if (mapnum == 88)
            return "";
	if (mapnum == 89)
            return "";   
        return "";
    }
    if (mapnum < 100)
    {
        if (mapnum == 91)
            return "";
        if (mapnum == 92)
            return "";
        if (mapnum == 93)
            return "";
        if (mapnum == 94)
            return "";
        if (mapnum == 95)
            return "";
        if (mapnum == 96)
            return "";
        if (mapnum == 97)
            return "";
	if (mapnum == 98)
            return "";
	if (mapnum == 99)
            return "";   
        return "";
    }
    if (mapnum < 120)
    {
        if (mapnum == 111)
            return "ctf1";
        if (mapnum == 112)
            return "ctf2";
        if (mapnum == 113)
            return "ctf3";
        if (mapnum == 114)
            return "ctf4";
        if (mapnum == 115)
            return "ctf5";
        if (mapnum == 116)
            return "ctf6";
        if (mapnum == 117)
            return "ctf7";
	    if (mapnum == 118)
            return "ctf8";
	    if (mapnum == 119)
            return "ctf9";   
        return "";
    }
    if (mapnum < 130)
    {
        if (mapnum == 121)
            return "ctf2m1";
        if (mapnum == 122)
            return "ctf2m2";
        if (mapnum == 123)
            return "ctf2m3";
        if (mapnum == 124)
            return "ctf2m4";
        if (mapnum == 125)
            return "ctf2m5";
        if (mapnum == 126)
            return "ctf2m6";
        if (mapnum == 127)
            return "ctf2m7";
	    if (mapnum == 128)
            return "ctf2m8";
	    if (mapnum == 129)
            return "ctf_start";   
        return "";
    }
    if (mapnum < 140)
    {
        if (mapnum == 131)
            return "ctf3m1";
        if (mapnum == 132)
            return "ctf3m2";
        if (mapnum == 133)
            return "ctf3m3";
        if (mapnum == 134)
            return "ctf3m4";
        if (mapnum == 135)
            return "ctf3m5";
        if (mapnum == 136)
            return "ctf3m6";
        if (mapnum == 137)
            return "ctf3m7";
	    if (mapnum == 138)
            return "ctf3m8";
	    if (mapnum == 139)
            return "ctf3m9";   
        return "";
    }
    if (mapnum < 150)
    {
        if (mapnum == 141)
            return "boom";
        if (mapnum == 142)
            return "kaboom";
        if (mapnum == 143)
            return "pound";
        if (mapnum == 144)
            return "pigremix";
        if (mapnum == 145)
            return "mctf1";
        if (mapnum == 146)
            return "rctf1";
        if (mapnum == 147)
            return "rctf2";
	    if (mapnum == 148)
            return "rctf4";
	    if (mapnum == 149)
            return "rctf5";
        return "";
    }
    if (mapnum < 160)
    {
		if (mapnum == 151)
			return "ctfgold7";
		if (mapnum == 152)
			return "";
		if (mapnum == 153)
			return "";
		if (mapnum == 154)
			return "";
		if (mapnum == 155)
			return "";
		if (mapnum == 156)
			return "";
		if (mapnum == 157)
			return "";
		if (mapnum == 158)
			return "";
		if (mapnum == 159)
			return "";
        return "";
    }
    if (mapnum < 170)
    {
		if (mapnum == 161)
			return "";
		if (mapnum == 162)
			return "";
		if (mapnum == 163)
			return "";
		if (mapnum == 164)
			return "";
		if (mapnum == 165)
			return "";
		if (mapnum == 166)
			return "";
		if (mapnum == 167)
			return "";
		if (mapnum == 168)
			return "";
		if (mapnum == 169)
			return "";
        return "";
    }
    if (mapnum < 180)
    {
		if (mapnum == 171)
			return "";
		if (mapnum == 172)
			return "";
		if (mapnum == 173)
			return "";
		if (mapnum == 174)
			return "";
		if (mapnum == 175)
			return "";
		if (mapnum == 176)
			return "";
		if (mapnum == 177)
			return "";
		if (mapnum == 178)
			return "";
		if (mapnum == 179)
			return "";
        return "";
    }
    if (mapnum < 190)
    {
		if (mapnum == 181)
			return "";
		if (mapnum == 182)
			return "";
		if (mapnum == 183)
			return "";
		if (mapnum == 184)
			return "";
		if (mapnum == 185)
			return "";
		if (mapnum == 186)
			return "";
		if (mapnum == 187)
			return "";
		if (mapnum == 188)
			return "";
		if (mapnum == 189)
			return "";
        return "";
    }
    if (mapnum < 200)
    {
		if (mapnum == 191)
			return "";
		if (mapnum == 192)
			return "";
		if (mapnum == 193)
			return "";
		if (mapnum == 194)
			return "";
		if (mapnum == 195)
			return "";
		if (mapnum == 196)
			return "";
		if (mapnum == 197)
			return "";
		if (mapnum == 198)
			return "";
		if (mapnum == 199)
			return "";
    }
    if (mapnum < 220)
    {
		if (mapnum == 211)
			return "23ar-a";
		if (mapnum == 212)
			return "2pyramid";
		if (mapnum == 213)
			return "2towers";
		if (mapnum == 214)
			return "arenarg2";
		if (mapnum == 215)
			return "arenarg4";
		if (mapnum == 216)
			return "arenarg5";
		if (mapnum == 217)
			return "arenarg6";
		if (mapnum == 218)
			return "arenax";
		if (mapnum == 219)
			return "arenazap";
        return "";
    }
    if (mapnum < 230)
    {
		if (mapnum == 221)
			return "arendm1a";
		if (mapnum == 222)
			return "arenrg3a";
		if (mapnum == 223)
			return "arma4";
		if (mapnum == 224)
			return "barena1";
		if (mapnum == 225)
			return "basarena";
		if (mapnum == 226)
			return "bbarena2";
		if (mapnum == 227)
			return "bunmoo3";
		if (mapnum == 228)
			return "bunski";
		if (mapnum == 229)
			return "chamber1";
        return "";
    }
    if (mapnum < 240)
    {
		if (mapnum == 231)
			return "crandome";
		if (mapnum == 232)
			return "dm2arena";
		if (mapnum == 233)
			return "dom2_1ra";
		if (mapnum == 234)
			return "egyptra";
		if (mapnum == 235)
			return "football";
		if (mapnum == 236)
			return "gear8";
		if (mapnum == 237)
			return "gnurena";
		if (mapnum == 238)
			return "hill20";
		if (mapnum == 239)
			return "iarena2";
        return "";
    }
    if (mapnum < 250)
    {
		if (mapnum == 241)
			return "id3";
		if (mapnum == 242)
			return "lowgrav";
		if (mapnum == 243)
			return "marena2";
		if (mapnum == 244)
			return "marena3";
		if (mapnum == 245)
			return "marena4";
		if (mapnum == 246)
			return "mayan1";
		if (mapnum == 247)
			return "nilsrar3";
		if (mapnum == 248)
			return "pen2";
		if (mapnum == 249)
			return "pitarena";
        return "";
    }
    if (mapnum < 260)
    {
		if (mapnum == 251)
			return "ptucket";
		if (mapnum == 252)
			return "ra_funkf";
		if (mapnum == 253)
			return "rarena3";
		if (mapnum == 254)
			return "rgarden";
		if (mapnum == 255)
			return "soyarena";
		if (mapnum == 256)
			return "terrain2";
		if (mapnum == 257)
			return "uarena1";
		if (mapnum == 258)
			return "unholy";
		if (mapnum == 259)
			return "xarena3";
    }
    if (mapnum < 270)
    {
		if (mapnum == 261)
			return "yard1";
		if (mapnum == 262)
			return "amphi";
		if (mapnum == 263)
			return "povdmm4";
		if (mapnum == 264)
			return "endif";
		if (mapnum == 265)
			return "midair";
		if (mapnum == 266)
			return "midair2";
		if (mapnum == 267)
			return "midair3";
		if (mapnum == 268)
			return "420bowl_b2";
		if (mapnum == 269)
			return "";
        return "";
    }
    if (mapnum < 280)
    {
		if (mapnum == 271)
			return "";
		if (mapnum == 272)
			return "";
		if (mapnum == 273)
			return "";
		if (mapnum == 274)
			return "";
		if (mapnum == 275)
			return "";
		if (mapnum == 276)
			return "";
		if (mapnum == 277)
			return "";
		if (mapnum == 278)
			return "";
		if (mapnum == 279)
			return "";
        return "";
    }
    if (mapnum < 290)
    {
		if (mapnum == 281)
			return "";
		if (mapnum == 282)
			return "";
		if (mapnum == 283)
			return "";
		if (mapnum == 284)
			return "";
		if (mapnum == 285)
			return "";
		if (mapnum == 286)
			return "";
		if (mapnum == 287)
			return "";
		if (mapnum == 288)
			return "";
		if (mapnum == 289)
			return "";
        return "";
    }
    if (mapnum < 300)
    {
		if (mapnum == 291)
			return "";
		if (mapnum == 292)
			return "";
		if (mapnum == 293)
			return "";
		if (mapnum == 294)
			return "";
		if (mapnum == 295)
			return "";
		if (mapnum == 296)
			return "";
		if (mapnum == 297)
			return "";
		if (mapnum == 298)
			return "";
		if (mapnum == 299)
			return "";
    }
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
//    else if (mode == 6)
 //       return "Rocket Arena";
 ////   else if (mode == 7)
//        return "Clan Arena";
 //   else if (mode == 8)
 //       return "Airshot";
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

string (float roundnum) get_round_string = 
{
    switch (roundnum)
    {
        case 1:
            return "\x10Round  \1\x11                                        \n";
            break;
        case 2:
            return "\x10Round  \2\x11                                        \n";
            break;
        case 3:
            return "\x10Round  \3\x11                                        \n";
            break;
        case 4:
            return "\x10Round  \4\x11                                        \n";
            break;
        case 5:
            return "\x10Round  \5\x11                                        \n";
            break;
        case 6:
            return "\x10Round  \6\x11                                        \n";
            break;
        case 7:
            return "\x10Round  \7\x11                                        \n";
            break;
        case 8:
            return "\x10Round  \8\x11                                        \n";
            break;
        case 9:
            return "\x10Round  \9\x11                                        \n";
            break;
        case 10:
            return "\x10Round \1\0\x11                                        \n";
            break;           
        case 11:
            return "\x10Round \1\1\x11                                        \n";
            break;
        case 12:
            return "\x10Round \1\2\x11                                        \n";
            break;
        case 13:
            return "\x10Round \1\3\x11                                        \n";
            break;
        case 14:
            return "\x10Round \1\4\x11                                        \n";
            break;
        case 15:
            return "\x10Round \1\5\x11                                        \n";
            break;
        case 16:
            return "\x10Round \1\6\x11                                        \n";
            break;
        case 17:
            return "\x10Round \1\7\x11                                        \n";
            break;
        case 18:
            return "\x10Round \1\8\x11                                        \n";
            break;
        case 19:
            return "\x10Round \1\9\x11                                        \n";
            break;
        case 20:
            return "\x10Round \2\0\x11                                        \n";
            break;           
        case 21:
            return "\x10Round \2\1\x11                                        \n";
            break;
        case 22:
            return "\x10Round \2\2\x11                                        \n";
            break;
        case 23:
            return "\x10Round \2\3\x11                                        \n";
            break;
        case 24:
            return "\x10Round \2\4\x11                                        \n";
            break;
        case 25:
            return "\x10Round \2\5\x11                                        \n";
            break;
        case 26:
            return "\x10Round \2\6\x11                                        \n";
            break;
        case 27:
            return "\x10Round \2\7\x11                                        \n";
            break;
        case 28:
            return "\x10Round \2\8\x11                                        \n";
            break;
        case 29:
            return "\x10Round \2\9\x11                                        \n";
            break;
        case 30:
            return "\x10Round \3\0\x11                                        \n";
            break;           
        case 31:
            return "\x10Round \3\1\x11                                        \n";
            break;
        case 32:
            return "\x10Round \3\2\x11                                        \n";
            break;
        case 33:
            return "\x10Round \3\3\x11                                        \n";
            break;
        case 34:
            return "\x10Round \3\4\x11                                        \n";
            break;
        case 35:
            return "\x10Round \3\5\x11                                        \n";
            break;
        case 36:
            return "\x10Round \3\6\x11                                        \n";
            break;
        case 37:
            return "\x10Round \3\7\x11                                        \n";
            break;
        case 38:
            return "\x10Round \3\8\x11                                        \n";
            break;
        case 39:
            return "\x10Round \3\9\x11                                        \n";
            break;
        case 40:
            return "\x10Round \4\0\x11                                        \n";
            break;
        default:
            return "\x10Round \b??\b\x11                                        \n";
    }
};