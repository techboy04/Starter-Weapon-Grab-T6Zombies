#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm;

init()
{
    if(getDvar("mapname") != "zm_prison")
	{
		level thread setStartLocation();
		level thread onPlayerConnect();
	}
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
		
		weap = level.start_weapon;
		self takeweapon(weap);
		self weapon_give( "no_hands_zm", 0, 0, 1 );

		self iprintln("^4Starter Weapon Grab mod ^7created by ^1techboy04gaming");
    }
}

setStartLocation()
{
	if ( getDvar( "g_gametype" ) == "zgrief" || getDvar( "g_gametype" ) == "zstandard" )
	{
		if(getDvar("mapname") == "zm_prison") //mob of the dead grief
		{

		}
		else if(getDvar("mapname") == "zm_buried") //buried grief
		{

		}
		else if(getDvar("mapname") == "zm_nuked") //nuketown
		{
			thread spawnStarterCrate((-253.12, 544.922, -55.375), "m1911_zm", "t6_wpn_pistol_m1911_world", 120);
		}
		else if(getDvar("mapname") == "zm_transit") //transit grief and survival
		{
			if(getDvar("ui_zm_mapstartlocation") == "town") //town
			{
				thread spawnStarterCrate((1667.92, -735.349, -22.4021), "m1911_zm", "t6_wpn_pistol_m1911_world", -150);
			}
			else if (getDvar("ui_zm_mapstartlocation") == "transit") //busdepot
			{
				thread spawnStarterCrate((-7171.67, 5355.02, -30.0795), "m1911_zm", "t6_wpn_pistol_m1911_world", -1);
			}
			else if (getDvar("ui_zm_mapstartlocation") == "farm") //farm
			{
				thread spawnStarterCrate((8024.63, -6233.51, 142.837), "m1911_zm", "t6_wpn_pistol_m1911_world", 127);
			}
		}
	}
	else
	{
		if(getDvar("mapname") == "zm_prison") //mob of the dead
		{
			thread spawnStarterCrate((755.531, 10397.1, 1344.13), "m1911_zm", "t6_wpn_pistol_m1911_world", -90);
		}
		else if(getDvar("mapname") == "zm_buried") //buried
		{
			thread spawnStarterCrate((-2996.58, -47.6409, 1365.13), "m1911_zm", "t6_wpn_pistol_m1911_world", -90);
			thread spawnStarterCrate((-1256.88, -104.969, 298.125), "m1911_zm", "t6_wpn_pistol_m1911_world", -90);
		}
		else if(getDvar("mapname") == "zm_transit") //transit
		{
			thread spawnStarterCrate((-6985.49, 5321, -32.8871), "m1911_zm", "t6_wpn_pistol_m1911_world", 90);
		}
		else if(getDvar("mapname") == "zm_tomb") //origins
		{
			thread spawnStarterCrate((2458.98, 5057.47, -335.298), "c96_zm", "t6_wpn_zmb_mc96_world", -14);
		}
		else if(getDvar("mapname") == "zm_highrise")
		{
			thread spawnStarterCrate((1553.25, 1581.86, 3418.72), "m1911_zm", "t6_wpn_pistol_m1911_world", 112);
		}
	}
}

spawnStarterCrate(location, weapon, weaponmodel, angle)
{
	starterTrigger = spawn( "trigger_radius", location, 1, 50, 50 );
	starterTrigger setHintString("^7Press ^3&&1 ^7to pick up ^3" + get_weapon_display_name( weapon ));
	starterTrigger setcursorhint( "HINT_NOICON" );
//	starterModel = spawn( "script_model", location);
//	starterModel setmodel ("char_ger_zombieeye");
//	starterModel rotateTo(angle,.1);

	starterGunModel = spawn( "script_model", (location[0], location[1], location[2]));
	starterGunModel setmodel (weaponmodel);
	starterGunModel rotateTo((0,angle - 270,0),.1);
	
	while(1)
	{
		starterTrigger waittill( "trigger", player );
		if ( player usebuttonpressed() && !isDefined(player.e_afterlife_corpse))
		{
			if(player usebuttonpressed() && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
			{
				if(player hasweapon(weapon))
				{
					if(player ammo_give(weapon))
					{
						player playsound("zmb_cha_ching");
					}
				}
				else
				{
					player playsound( "zmb_cha_ching" );
					player thread weapon_give( weapon, 0, 1 );
					wait 3;
				}
			}
		}
		wait 0.5;
	}
}
