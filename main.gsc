#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_dev;
#include maps\mp\perks\_perkfunctions;
#include maps\mp\killstreaks\_perkstreaks;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\gametypes\_class;
#include maps\mp\perks\_perks;
#include maps\mp\killstreaks\_killstreaks;

init() 
{
    level thread onPlayerConnect();
    level loadarrays();
    level loadEffects();
    level gameIntermission();
    
    level.strings = [];
    
    level.airDropCrates = getEntArray( "airdrop_crate", "targetname" );
    level.airDropCrateCollision = getEnt( level.airDropCrates[0].target, "targetname" );
    
    precacheItem( "flare_mp" );
    
    PreCacheShader( "iw5_cardicon_elite_05" );
    PreCacheShader( "iw5_cardicon_gign" );
    preCacheShader( "waypoint_captureneutral" );
    preCacheShader( "compass_waypoint_panic" );
    preCacheShader( "compass_objpoint_ammo_friendly" );
    preCacheShader( "waypoint_flag_friendly" );
    preCacheShader( "compassping_explosion" );
    
    PreCacheModel( "prop_flag_delta" );
    PreCacheModel( "com_deploy_ballistic_vest_friend_world" );
    PreCacheModel( "prop_suitcase_bomb" );
    PreCacheModel( "com_plasticcase_friendly" );
    
    bypassDvars  = [ "pdc", "validate_drop_on_fail", "validate_apply_clamps", "validate_apply_revert", "validate_apply_revert_full", "validate_clamp_experience", "validate_clamp_weaponXP", "validate_clamp_kills", "validate_clamp_assists",     "validate_clamp_headshots", "validate_clamp_wins", "validate_clamp_losses", "validate_clamp_ties", "validate_clamp_hits", "validate_clamp_misses", "validate_clamp_totalshots", "dw_leaderboard_write_active", "matchdata_active" ];
    bypassValues = [ "0", "0", "0", "0", "0", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1", "1" ];
    for( e = 0; e < bypassDvars.size; e++ )
    {
        makeDvarServerInfo( bypassDvars[e], bypassValues[e] );
        setDvar( bypassDvars[e], bypassValues[e] );
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
    self thread forceSpawn();
    self waittill("spawned_player");
    
    if(self isHost())
        self thread runDebugScripts();
    
    if(self isHost())
    {     
        //remove this 
        
        self thread forceHost();
        
        level thread overflowfix(); 
        level thread initialThreads();
        
        writeInt( 0x0664157C, 18 );
    }
    
    self setClientDvar( "cg_fov", 80 );
    self thread initialPlayerThreads();
    self FreezeControls( false );
}

overflowfix()
{
    level.overflow       = level createserverfontstring( "default", 1 );
    level.overflow.alpha = 0;
    level.overflow setText( "marker" );

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        if( level.strings.size >= 40 )
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
        }
    }
}

initialThreads()
{
    self thread spawnMapEdit();
    level getCustomSpawnPoints();
    level initialCountdown();
    level chooseRandomZombie();
    
    level thread hasFinalZombieQuit();
    level thread hasGameFinished();
}

initialPlayerThreads()
{
    self setKillstreaks( "none", "none", "none" );
    self.pers["cur_death_streak"] = 0;
    
    self gameIntermission();
    self initializeVars();
    
    self setCustomSpawnPoints();
    self humanLoadout();
 
    self thread gameHuds();
    self thread drawMenuInstruct();
    self thread menuOptions();
    self thread menuMonitor();
    self thread deathMonitor();
    
    if( isDefined(level.turnedZombies) && isInArray( level.turnedZombies, self GetGUID() ) )
        self isNowZombie( true );
}

gameIntermission()
{
    bypassDvars  = [ "pdc", "validate_drop_on_fail", "validate_apply_clamps", "validate_apply_revert", "validate_apply_revert_full", "validate_clamp_experience", "validate_clamp_weaponXP", "validate_clamp_kills", "validate_clamp_assists",     "validate_clamp_headshots", "validate_clamp_wins", "validate_clamp_losses", "validate_clamp_ties", "validate_clamp_hits", "validate_clamp_misses", "validate_clamp_totalshots", "dw_leaderboard_write_active", "matchdata_active" ];
    bypassValues = [ "0", "0", "0", "0", "0", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1", "1" ];
    for( e = 0; e < bypassDvars.size; e++ )
    {
        makeDvarServerInfo( bypassDvars[e], bypassValues[e] );
        setDvar( bypassDvars[e], bypassValues[e] );
    }
    
    makeDvarServerInfo( "ui_allow_classchange", 0 );
    SetDvar( "ui_allow_classchange", 0 );
    makeDvarServerInfo( "ui_allow_teamchange", 0 );
    SetDvar( "ui_allow_teamchange", 0 );

    SetDvar( "liveanticheatunknowndvar", 1 );
    MakeDvarServerInfo( "liveanticheatunknowndvar", 1 );
    setDvar( "scr_teambalance", 0 );
    makeDvarServerInfo("scr_teambalance", 0 );
    setDvar( "party_autoteams", 0 );
    makeDvarServerInfo( "party_autoteams", 0 );
    
    setdvar("ui_gametype", "^1Zombieland By Extinct");
    makeDvarServerInfo("ui_gametype", "^1Zombieland By Extinct");
    
    // TESTING DVARS
    setDvar( "ui_maxclients", 18 );
    makeDvarServerInfo("ui_maxclients", 18 );
    setDvar( "sv_maxclients", 18 );
    makeDvarServerInfo( "sv_maxclients", 18 ); 
    
    setDvar( "party_maxplayers", 18 );
    makeDvarServerInfo( "party_maxplayers", 18 ); 
    
    setDvar("g_motd", "^1Zombieland By Extinct" );
    setDvar("g_TeamName_Allies", "^2Humans");
    setDvar("g_TeamName_Axis", "^1Zombies");
    setDvar("g_teamicon_allies", "cardicon_juggernaut_1" );
    setDvar("g_TeamIcon_Axis", "cardicon_biohazard" );
    
    setDvar( "loc_warnings", 0 );
    makeDvarServerInfo( "loc_warnings", 0 );
    setDvar( "loc_warningsAsErrors", 0 );
    makeDvarServerInfo( "loc_warningsAsErrors", 0 );
    
    setDvar("scr_" + level.gameType + "_scorelimit", 0);
    setDvar( "scr_" + level.gameType + "_timeLimit", 30 );
    setDvar( "player_useradius", 80 );
    
    level.onPlayerKilled              = ::onPlayerKilled;
    level.default_use_radius          = getdvarint( "player_useradius" );
    level.killstreakRewards           = false;
    level.doPrematch                  = false;
    level.teambalance                 = false;
    level.intermission                = false;
    level.teamBased                   = true;
    level.maxClients                  = 18;
    level.teamLimit                   = 18;
    level.prematchPeriod              = 0;
    level.postGameNotifies            = 0;
    level.matchRules_damageMultiplier = 0;

    level.airDropCrateCollision = getEnt( level.airDropCrates[0].target, "targetname" );
    level.oldAirDropCrates      = getEntArray( "airdrop_crate", "targetname" );
}

loadarrays()
{
    level.turnedZombies = [];
    
    level.weapons  = [];
    level.weapons[0] = strTok("fal;m4;m16;famas;scar;ak47;aug;masada;fn2000", ";"); //Assault Rifles
    level.weapons[1] = StrTok( "uzi;ump45;mp5k;p90;tavor;kriss", ";" ); //Submachine Guns
    level.weapons[2] = StrTok( "model1887;aa12;ranger;spas12;m1014", ";" ); //Shotguns
    level.weapons[3] = StrTok( "m240;rpd;sa80;mg4", ";" ); //Light Machine Guns
    level.weapons[4] = StrTok( "m21;cheytac;wa2000;barrett", ";" ); //Sniper Rifles
    level.weapons[5] = StrTok( "at4;rpg;javelin;stinger;m79", ";" ); //Launchers
    level.weapons[6] = StrTok( "beretta;coltanaconda;usp;deserteagle", ";" ); //Pistols
    level.weapons[7] = StrTok( "pp2000;glock;tmp", ";" ); //Auto Pistols
    
    level.equipment = [];
    level.equipment[0] = strTok( "frag_grenade_mp;semtex_mp;throwingknife_mp;claymore_mp;c4_mp;specialty_tacticalinsertion", ";" ); //Primary
    level.equipment[1] = strTok( "flash_grenade_mp;smoke_grenade_mp;concussion_grenade_mp", ";" ); //Secondary
    
    //EQUIPMENT REAL NAMES
    level.equipment[2] = strTok( "Frag Grenade;Semtex Grenade;Throwing Knife;Claymore;C4;Tactical Insertion", ";");
    level.equipment[3] = strTok( "Flash Grenade;Smoke Grenade;Concussion Grenade", ";" );
    
    level.custPerks = [];
    level.custPerks[0] = StrTok( "specialty_marathon;specialty_fastreload;specialty_scavenger;specialty_bling;specialty_onemanarmy", ";" ); //PERK 1 SLOT
    level.custPerks[1] = StrTok( "specialty_bulletdamage;specialty_lightweight;specialty_hardline;specialty_coldblooded;specialty_explosivedamage", ";" ); //PERK 2 SLOT
    level.custPerks[2] = StrTok( "specialty_extendedmelee;specialty_bulletaccuracy;specialty_heartbreaker;specialty_detectexplosive;specialty_pistoldeath", ";" ); //PERK 3 SLOT

    //PERK REAL NAMES
    level.custPerks[3] = StrTok( "Marathon;Sleight Of Hand;Scavenger;Bling;One Man Army", ";" ); //PERK 1 SLOT
    level.custPerks[4] = StrTok( "Stopping Power;Lightweight;Hardline;Cold Blooded;Danger Close", ";" ); //PERK 2 SLOT
    level.custPerks[5] = StrTok( "Commando;Steady Aim;Ninja;Sitrep;Last Stand", ";" ); //PERK 3 SLOT

    level.attachments     = strtok( "acog;grip;gl;tactical;reflex;silencer;akimbo;thermal;shotgun;heartbeat;fmj;rof;dtap;xmags;mags;eotech",";" );
    level.attachmentNames = StrTok( "Acog;Grip;Grenade Launcher;Tactical;Reflex;Silencer;Akimbo;Thermal;Shotgun;Heartbeat;Fmj;Rapid Fire;Dtap;Extended Mags;Fast Mags;Eotech", ";" );
    
    level.killstreaks = [];
    level.killstreaks[0] = strTok("uav;helicopter;ac130;predator_missile;helicopter_minigun;precision_airstrike;counter_uav;sentry;helicopter_flares;emp;stealth_airstrike;harrier_airstrike", ";");
    level.killstreaks[1] = StrTok("uav;counter_uav;emp", ";");
}
