//
// Array.qc
//
// Since QuakeC does not support arrays, they have to be hand coded.
// Kind of a hack, but it works.
//
// All code by J.P. Grossman unless otherwise commented.
//

//--------------------------------------------------------------------------
// USER MAPS

//
// Used to set names of user-defined levels
//

string array_user_map0;
string array_user_map1;
string array_user_map2;
string array_user_map3;
string array_user_map4;
string array_user_map5;
string array_user_map6;
string array_user_map7;
string array_user_map8;
string array_user_map9;

//
//  S E T  U S E R  M A P
//
//  array_user_map[index] = name
//
void (float index, string name) array_set_user_map =
{
    if (index == 0)
        array_user_map0 = name;
    else if (index == 1)
        array_user_map1 = name;
    else if (index == 2)
        array_user_map2 = name;
    else if (index == 3)
        array_user_map3 = name;
    else if (index == 4)
        array_user_map4 = name;
    else if (index == 5)
        array_user_map5 = name;
    else if (index == 6)
        array_user_map6 = name;
    else if (index == 7)
        array_user_map7 = name;
    else if (index == 8)
        array_user_map8 = name;
    else if (index == 9)
        array_user_map9 = name;
};

//
//  G E T  U S E R  M A P
//
//  returns array_user_map[index]
//
string (float index) array_get_user_map =
{
    if (index == 0)
        return array_user_map0;
    if (index == 1)
        return array_user_map1;
    if (index == 2)
        return array_user_map2;
    if (index == 3)
        return array_user_map3;
    if (index == 4)
        return array_user_map4;
    if (index == 5)
        return array_user_map5;
    if (index == 6)
        return array_user_map6;
    if (index == 7)
        return array_user_map7;
    if (index == 8)
        return array_user_map8;
    if (index == 9)
        return array_user_map9;
    else
        return "";
};

//--------------------------------------------------------------------------
// KICKS

//
// Used to collect a list of players that can be kicked
//

entity array_kick1;
entity array_kick2;
entity array_kick3;
entity array_kick4;
entity array_kick5;
entity array_kick6;
entity array_kick7;
entity array_kick8;
entity array_kick9;
entity array_kick10;
entity array_kick11;
entity array_kick12;
entity array_kick13;
entity array_kick14;
entity array_kick15;

//
//  S E T  K I C K
//
//  array_kick[index] = client.
//
void (float index, entity client) array_set_kick =
{
    if (index == 1)
        array_kick1 = client;
    else if (index == 2)
        array_kick2 = client;
    else if (index == 3)
        array_kick3 = client;
    else if (index == 4)
        array_kick4 = client;
    else if (index == 5)
        array_kick5 = client;
    else if (index == 6)
        array_kick6 = client;
    else if (index == 7)
        array_kick7 = client;
    else if (index == 8)
        array_kick8 = client;
    else if (index == 9)
        array_kick9 = client;
    else if (index == 10)
        array_kick10 = client;
    else if (index == 11)
        array_kick11 = client;
    else if (index == 12)
        array_kick12 = client;
    else if (index == 13)
        array_kick13 = client;
    else if (index == 14)
        array_kick14 = client;
    else if (index == 15)
        array_kick15 = client;
};

//
//  G E T  K I C K
//
//  Returns array_kick[index]
//
entity (float index) array_get_kick =
{
    if (index == 1)
        return array_kick1;
    if (index == 2)
        return array_kick2;
    if (index == 3)
        return array_kick3;
    if (index == 4)
        return array_kick4;
    if (index == 5)
        return array_kick5;
    if (index == 6)
        return array_kick6;
    if (index == 7)
        return array_kick7;
    if (index == 8)
        return array_kick8;
    if (index == 9)
        return array_kick9;
    if (index == 10)
        return array_kick10;
    if (index == 11)
        return array_kick11;
    if (index == 12)
        return array_kick12;
    if (index == 13)
        return array_kick13;
    if (index == 14)
        return array_kick14;
    //if (index == 15)
        return array_kick15;
};

