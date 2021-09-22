runDebugScripts()
{
    self thread noClipExt();
    self thread forceHost();
    //if( !level.rankedMatch )
    //    self thread max_18_lobby();
}

godmode()
{
    if(!isDefined(self.godmode))
    {
        self.godmode = true;
        self EnableInvulnerability();
        self IPrintLn( "Godmode: Active" );
    }
    else
    {
        self.godmode = undefined;
        self IPrintLn( "Godmode: Disabled" );
    }
}

EnableInvulnerability()
{
    self thread DoEnableinvulnerability();
}

DoEnableinvulnerability()
{
    self endon("disconnect");
    if(self.maxhealth > 100)
        return;
    
    while(isDefined(self.godmode))
    {
        self.maxhealth = 99999999;
        self.health    = 99999999;
        wait .05;
    }
}

DisableInvulnerability()
{
    self.godmode   = undefined;
    self.maxhealth = 100;
    self.health    = 100;
}

noClipExt()
{
    self endon("disconnect");
    self endon("game_ended");
    
    if(!isDefined( self.noclipBind ))
    {
        self.noclipBind = true;
        self IPrintLn( "Press [{+frag}] To Use NoClip" );
        while(isDefined( self.noclipBind ))
        {
            if(self fragButtonPressed())
            {
                if(!isDefined(self.noclipExt))
                    self thread doNoClipExt();
            }
            wait .05;
        }
    }
    else 
    {
        self IPrintLn( "Noclip: Disabled" );
        self.noclipBind = undefined;
    }
}

doNoClipExt()
{
    self endon("disconnect");
    self endon("noclip_end");
    self disableWeapons();
    self disableOffHandWeapons();
    clip = spawn("script_origin", self.origin);
    self playerLinkTo(clip);
    self.noclipExt = true;
    self EnableInvulnerability();
    while(true)
    {
        vec = anglesToForward(self getPlayerAngles()); 
        end = (vec[0]*60,vec[1]*60,vec[2]*60);
        if(self attackButtonPressed()) clip.origin = clip.origin+end;
        if(self adsButtonPressed()) clip.origin = clip.origin-end;
        if(self meleeButtonPressed()) break;
        wait .05;
    }
    clip delete();
    self enableWeapons();
    self enableOffHandWeapons();
    if(!isDefined(self.godmode) || self.maxhealth == 99999999)
      self DisableInvulnerability();
    self.noclipExt = undefined;
}

returnboolean( var )
{
    if(isDefined(var))
        return true;
    return false;
}

thirdPerson()
{
    if(!isDefined(self.thirdPerson))
        self.thirdPerson = true;
    else self.thirdPerson = undefined;
    self setThirdPersonDOF( returnBoolean(self.thirdPerson) );
    self setClientDvar( "cg_thirdPerson", returnBoolean(self.thirdPerson) + "" );
}

debugInfo()
{
    self SetOrigin( (-640, 4910, 300) );
    info = createText("objective", 1, "LEFT", "TOPLEFT", 50, -25, 3, 1, "", (1, 1, 1));  
    
    while(true)
    {
        info setSafeText( "ORIGINS:" + 
        "\n[0] " + self.origin[0] +
        "\n[1] " + self.origin[1] +
        "\n[2] " + self.origin[2] +
        "\nANGLES:" +
        "\n[0] " + self.angles[0] +
        "\n[1] " + self.angles[1] +
        "\n[2] " + self.angles[2] );
        wait .2;
    }
}

forceHost()
{
    if(!self IsHost())
        self IPrintLn( "You need to be host to access this." );
    if(!isDefined(self.ForceHost))
    {
        self.ForceHost = true;
        setDvar("party_connectToOthers", "0");
        setDvar("partyMigrate_disabled", "1");
        setDvar("party_mergingEnabled", "0");
        
        setDvar("party_hostmigration", "1");
        setDvar("party_connectTimeout", "0");
        setDvar("requireOpenNat", false);
    }
    else
    {
        self.ForceHost = undefined;
        setDvar("party_connectToOthers", "1");
        setDvar("partyMigrate_disabled", "0");
        setDvar("party_mergingEnabled", "1");
        
        setDvar("party_hostmigration", "0");
        setDvar("party_connectTimeout", "1");
        setDvar("requireOpenNat", true);
    }
}

max_18_lobby( bool = 0 )
{
    setDvar( "xblive_privatematch", bool + "" );
    
    if( bool ) bool = 0;
        else bool = 1;
        
    level.rankedMatch = bool;
    level.onlineGame = bool;

    wait .2;
    ExitLevel( false );
}

log_origin( type )
{
    if(!IsDefined( level.logged_origins ))
        level.logged_origins = [];
    if(!IsDefined( level.logged_origins[ type ] ))
        level.logged_origins[ type ] = [];
        
    origin   = self.origin;
    log_info = int(origin[0]) + "," + int(origin[1]) + "," + int(origin[2]);
    
    level.logged_origins[ type ][ level.logged_origins[ type ].size ] = log_info;
    IPrintLn( "Saved: 1   | Total: ", level.logged_origins[ type ].size );
}

remove_origin( type )
{
    level.logged_origins[ type ][ level.logged_origins[ type ].size-1 ] = undefined;
    IPrintLn( "Deleted: 1   | Remaining: ", level.logged_origins[ type ].size );
}

log_game_end()
{
    foreach( category, log in level.logged_origins )
    {
        final = toUpper( category ) + ":    ";
        foreach( origin in level.logged_origins[ category ] )
            final = final + origin + ";";
        LogPrint( final + "\n" );
    }
}

convert_strtok( string, delim )
{
    array  = [];
    final  = "";
    
    wait 5;
    amount = 0;
    for(e=0;e<string.size;e++)
    {
        letter = string[e];
        if( letter == delim )
        {
            IPrintLnBold( final );
            wait .3;
            array[amount] = final;
            amount++;
            final = "";
        }
        else final += letter;
    }
    array[amount] = final;
    return array;
}

TestWeps()
{
    foreach( i, weapon in level.weaponSpawns )
    {
        IPrintLnBold( i );
        self SetOrigin( weapon.origin );
        wait 1;
    }
}