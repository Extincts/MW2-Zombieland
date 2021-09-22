loadEffects()
{
    //light_glow_walllight_white
    //angle_flare_geotrail
    //laserTarget
    
    level._effect[ "ac130_light_red" ] = loadfx( "misc/aircraft_light_wingtip_red" );
    level._effect[ "nuke_aftermath" ]  = loadfx( "dust/nuke_aftermath_mp" );
    
    list          = ["misc/ui_flagbase_red", "misc/ui_flagbase_black", "misc/ui_flagbase_gold", "misc/ui_flagbase_silver"];
    level.circles = [];
    foreach( fxID in list )  
        level.circles[ cutString( fxID, "_" ) ] = loadfx( fxID );
}

spawnMapEdit()
{
    if( level.script == "mp_terminal" )
    {
        bounceOriginList      = strTok( "2360,6175,192;1912,4458,192;1403,3136,40;766,2950,184;465,3310,184;128,3341,40", ";" );
        ziplineOriginsList    = StrTok( "352,4569,306;1671,4217,450;1695,2560,422;2645,3077,40;1967,3465,180;3010,3500,192", ";" );
        weaponOriginList      = strtok( "1551,7241,192;1078,7245,192;590,6972,192;188,6770,192;408,6482,192;-450,5594,192;-275,4892,193;64,4850,192;592,4971,192;613,2836,202;358,4134,304;603,4002,341;610,3083,342;244,3192,176;34,3495,112;1312,2598,156;1047,3152,176;1627,3051,184;1936,3215,120;2643,2787,40;2157,4336,304;1604,4248,168;1272,5586,192;1439,5624,192;2405,6295,192;2644,6229,372;2619,5478,192;2237,5466,192;2868,4515,192;3205,4988,192;3985,4349,192;3929,3681,192;4480,3329,192;4329,2428,192;3717,2443,192;3351,2796,192;3070,2927,192;2154,3259,48;2011,4194,48",";");   
        teleportalOriginsList = StrTok( "-895,5228,192; 2642,6229,372; -758,5064,192; 1275,5603,368; -1050,5064,192; 4319,2466,192", ";" );
        
        doorOriginsList = StrTok( "-1108,4640,222;-666,4640,222", ";" ); //OPEN;CLOSE
        doorWidthsList  = StrTok( "8", ";" ); //WIDTH 
        doorHeightsList = StrTok( "2", ";" ); //HEIGHT
                                                                                               
        wallOriginsList = StrTok( "-1149,4642,192; -1151,5440,192; -1160,4641,222; -1308,4640,222; -640,4642,192; -640,5440,192; -596,4640,222; -490,4640,222", ";" ); 
        wallHeightList  = StrTok( "3;3;3;3", ";" );
        
        floorOriginsList = StrTok( "", ";" ); //START;END
        rampOriginsList  = StrTok( "", ";" ); //TOP;BOTTOM
    }
    if( level.script == "mp_afghan")
    {
        weapons = []; 
        weapons[0] = StrTok( "2388,1610,18;1936,2391,2;2497,2433,0;3038,2492,-14;3783,2489,-24;4007,2858,125;3539,2861,129;2879,2885,122;2815,3283,118;3365,3560,127;2035,3622,214;1724,3179,258;1029,3503,239;675,3165,226;191,3209,104;-196,2964,-23;-456,2172,64;-436,1736,200;-703,1549,182;186,-165,74.498;979,-327,0;1529,51,0;2199,254,115;2399,642,53;1051,1817,503;1002,1544,503;1668,1401,335;2000,1834,186;1912,2331,376;-1141,472,423;-1121,19,386;-1605,344,407;-1874,214,437;2099,-234,136;1759,-146,136;1067,5,-19;399,352,32;93,-65,0", ";" );
        weapons[1] = StrTok( "-444,248,65;-1123,1240,84;-1316,825,62;-431,2606,-55;87,3233,104;856,3276,227;1308,3787,248;1893,4010,257;1867,2737,361;2806,3511,123;2638,2438,15;3760,2475,-23;3475,3293,129;3650,1663,65;3645,818,76;3885,278,138;3345,296,144", ";" );
        weaponOriginList = array_combine( weapons[0], weapons[1] );
        
        rampOriginsList = StrTok( "1931,2626,381;2219,1918,59;2295,1288,135;2551,1240,31", ";" ); //TOP;BOTTOM
    }
    if( level.script == "mp_boneyard")
    {}
    if( level.script == "mp_brecourt")
    {}
    if( level.script == "mp_checkpoint")
    {}
    if( level.script == "mp_derail")
    {}
    if( level.script == "mp_estate")
    {}
    if( level.script == "mp_favela")
    {}
    if( level.script == "mp_highrise")
    {}
    if( level.script == "mp_nightshift")
    {}
    if( level.script == "mp_invasion")
    {}
    if( level.script == "mp_quarry")
    {}
    if( level.script == "mp_rundown")
    {}
    if( level.script == "mp_rust")
    {}
    if( level.script == "mp_subbase" )
    {}
    if( level.script == "mp_underpass" )
    {}

    if( isDefined( bounceOriginList ) )
    {
        level.bouncePads   = [];
        level.bouncePadsFx = [];
        for( e = 0; e < bounceOriginList.size; e++ )
        {
            origins = strTok( bounceOriginList[e], "," );
            level.bouncePads[ level.bouncePads.size ] = modelSpawner( (int(origins[0]), int(origins[1]), int(origins[2])), "tag_origin" );
            level.bouncePads[ level.bouncePads.size - 1 ] thread createBounce( 50, 160, 4 );
            
            level.bouncePadsFx[ level.bouncePadsFx.size ] = spawnFx( level.circles[ "red" ], (int(origins[0]), int(origins[1]), int(origins[2])));
            TriggerFX( level.bouncePadsFx[ level.bouncePadsFx.size - 1 ] );
        }
    }

    if( isDefined( ziplineOriginsList ) )
    {
        level.ziplines     = [];
        level.ziplinesFx   = [];
        for( e = 0; e < (ziplineOriginsList.size) / 2; e++ )
        {
            origins = strTok( ziplineOriginsList[2 * e] + "," + ziplineOriginsList[(2 * e ) + 1], "," );
            level.ziplines[ level.ziplines.size ] = modelSpawner( (int(origins[0]), int(origins[1]), int(origins[2])), "prop_flag_neutral" ); //Flag maybe?
            level.ziplines[ level.ziplines.size ] = modelSpawner( (int(origins[3]), int(origins[4]), int(origins[5])), "prop_flag_neutral" ); //Flag maybe?
            level.ziplines[ level.ziplines.size - 1 ] thread createZipline( level.ziplines[ level.ziplines.size - 2 ], level.ziplines[ level.ziplines.size - 1 ], 50 );
            level.ziplines[ level.ziplines.size - 2 ] thread createZipline( level.ziplines[ level.ziplines.size - 2 ], level.ziplines[ level.ziplines.size - 1 ], 50 );
            
            level.ziplines[ level.ziplines.size - 1 ] showOnMiniMap( "waypoint_flag_friendly" );
            level.ziplines[ level.ziplines.size - 2 ] showOnMiniMap( "waypoint_flag_friendly" );
            
            level.ziplinesFx[ level.ziplinesFx.size ] = spawnFx( level.circles[ "black" ], (int(origins[0]), int(origins[1]), int(origins[2])));
            level.ziplinesFx[ level.ziplinesFx.size ] = spawnFx( level.circles[ "black" ], (int(origins[3]), int(origins[4]), int(origins[5])));  
            TriggerFX( level.ziplinesFx[ level.ziplinesFx.size - 1 ] );
            TriggerFX( level.ziplinesFx[ level.ziplinesFx.size - 2 ] );
        }
    }
    
    if( isDefined( teleportalOriginsList ) )
    {
        level.teleportals   = [];
        level.teleportalsFx = [];
        for( e = 0; e < (teleportalOriginsList.size) / 2; e++ )
        {
            origins = strTok( teleportalOriginsList[2 * e] + "," + teleportalOriginsList[(2 * e ) + 1], "," );
            level.teleportals[ level.teleportals.size ] = spawnFx( level.circles[ "black" ], (int(origins[0]), int(origins[1]), int(origins[2])));
            level.teleportals[ level.teleportals.size ] = spawnFx( level.circles[ "black" ], (int(origins[3]), int(origins[4]), int(origins[5])));  
            TriggerFX( level.teleportals[ level.teleportals.size - 1 ] );
            TriggerFX( level.teleportals[ level.teleportals.size - 2 ] );
            
            level.teleportals[ level.teleportals.size - 1 ] showOnMiniMap( "compassping_explosion" );
            level.teleportals[ level.teleportals.size - 2 ] showOnMiniMap( "compassping_explosion" );
            
            level.teleportals[ level.teleportals.size - 1 ] thread createTeleportal( level.teleportals[ level.teleportals.size - 2 ], level.teleportals[ level.teleportals.size - 1 ], 50 );
            level.teleportals[ level.teleportals.size - 2 ] thread createTeleportal( level.teleportals[ level.teleportals.size - 2 ], level.teleportals[ level.teleportals.size - 1 ], 50 );
        }
    }

    if( isDefined( weaponOriginList ) )
    {
        level.weaponSpawns   = [];
        level.weaponSpawnsFx = [];
        for( e = 0; e < weaponOriginList.size; e++ )
        {
            if( doCoinToss() )
            {
                origins    = strTok( weaponOriginList[e], "," );
                
                if( doCoinToss() )
                {
                    custom = [ "weapon_oma_pack_in_hand", "prop_suitcase_bomb" ];
                    model  = custom[ RandomInt( custom.size ) ];
                }
                else
                {
                    randomWeap = returnRandomWeapon();
                    model      = GetWeaponModel( randomWeap ); 
                }
                
                level.weaponSpawns[ level.weaponSpawns.size ] = modelSpawner( (int(origins[0]), int(origins[1]), int(origins[2]) + 40), model );
                level.weaponSpawnsFx[ level.weaponSpawnsFx.size ] = spawnFx( level._effect["fluorescent_glow"], (int(origins[0]), int(origins[1]), int(origins[2]) + 40));
                TriggerFX( level.weaponSpawnsFx[ level.weaponSpawnsFx.size - 1 ] );
            
                level.weaponSpawns[ level.weaponSpawns.size - 1 ] thread rotateObj();
                level.weaponSpawns[ level.weaponSpawns.size - 1 ] thread createWeaponTrigger( randomWeap, level.weaponSpawnsFx[ level.weaponSpawnsFx.size - 1] );
            }
        }
    }
    
    if( IsDefined( doorOriginsList ) )
    {
        for( e = 0; e < (doorOriginsList.size) / 2; e++ )
        {
            origins = strTok( doorOriginsList[2 * e] + "," + doorOriginsList[(2 * e ) + 1], "," );
            level thread CreateDoor("com_plasticcase_friendly", (int(origins[0]), int(origins[1]), int(origins[2])), (int(origins[3]), int(origins[4]), int(origins[5])), int(doorWidthsList[e]), int(doorHeightsList[e]), 58, 33, 1000, 1000);
        }
    }
    
    if( IsDefined( wallOriginsList ) )
    {
        for( e = 0; e < (wallOriginsList.size) / 2; e++ )
        {
            origin  = [];
            origins = strTok( wallOriginsList[2 * e] + "," + wallOriginsList[(2 * e) + 1], "," );
            origin[0] = (int(origins[0]), int(origins[1]), int(origins[2]));
            origin[1] = (int(origins[3]), int(origins[4]), int(origins[5]));
            
            distance = Distance2D( origin[0], origin[1] );
            blocks   = roundUp( distance / 58 );
            height   = int( wallHeightList[e] ); 
                
            wall = modelSpawner(origin[0], "tag_origin");
            for(b=0;b<blocks+1;b++) for(h=0;h<height;h++)
            {
                block = modelSpawner(origin[0] + (0, (b * 58), (h * 32)), "com_plasticcase_friendly", (0, 90, 0), undefined, true);
                block EnableLinkTo();
                block LinkTo( wall );
            }
            wall.angles = (0, VectorToAngles(origin[0] - origin[1])[1] + 90, 0);        
        }
    }
    
    if( isDefined( floorOriginsList ) )
    {
        lengthspace = 35;
        widthspace  = 60;
        heightspace = 42;
        
        for( e = 0; e < (floorOriginsList.size) / 2; e++ )
        {
            origins = strTok( floorOriginsList[2 * e] + "," + floorOriginsList[(2 * e) + 1], "," );
            start   = (int(origins[0]), int(origins[1]), int(origins[2])); //start
            end     = (int(origins[3]), int(origins[4]), int(origins[5])); //end
            
            start += (0, 0, heightspace / 2);
            end += (0, 0, heightspace / 2);
            
            length       = Distance((start[0], 0, 0), (end[0], 0, 0));
            width        = Distance((0, start[1], 0), (0, end[1], 0));
            height       = Distance((0, 0, start[2]), (0, 0, end[2]));
            
            blockslength = Ceil(length / lengthspace);
            blockswidth  = Ceil(width / widthspace);
            blocksheight = Ceil(height / heightspace);
            
            originx      = (end[0] - start[0]) / blockslength;
            originy      = (end[1] - start[1]) / blockswidth;
            originz      = (end[2] - start[2]) / blocksheight;
            center       = Spawn("script_origin", start);
            
            for (l = 0; l <= blockslength; l ++)
            {
                for (w = 0; w <= blockswidth; w ++)
                {
                    for (h = 0; h <= blocksheight; h ++)
                    {
                        block = modelSpawner(start + (originx * l, originy * w, originz * h), "com_plasticcase_friendly", (0, 90, 0), undefined, true);
                        block LinkTo(center);
                    }
                }
            }
            center.angles = angles;
        }
    }
    
    if( isDefined( rampOriginsList ) )
    {
        for( e = 0; e < (rampOriginsList.size) / 2; e++ )
        {
            origins = strTok( rampOriginsList[2 * e] + "," + rampOriginsList[(2 * e) + 1], "," );
            start   = (int(origins[0]), int(origins[1]), int(origins[2]) + 18); //top
            end     = (int(origins[3]), int(origins[4]), int(origins[5]) + 18); //bottom
            
            length       = Distance(start, end);
            blockslength = Ceil(length / 58);
            angles       = VectorToAngles(start - end);
            
            block = [];
            block[ 0 ] = modelSpawner(start - (0,0,16), "com_plasticcase_friendly", angles, undefined, true);
            for(l=0;l<blockslength;l++)
                block[ block.size ] = modelSpawner(block[ block.size-1 ].origin - AnglesToForward( block[ block.size-1 ].angles ) * 57, "com_plasticcase_friendly", angles, undefined, true);
        
            block[ 0 ].angles = (0, angles[1], 0);
            block[ block.size-1 ].angles = (0, angles[1], 0);
            
            block[ 0 ].origin = block[ 1 ].origin + (0,0,12);
            block[ block.size-1 ].origin = block[ block.size-2 ].origin - (0,0,12);
            
            block[ 0 ].origin += AnglesToForward( block[ 0 ].angles ) * 52;
            block[ block.size-1 ].origin -= AnglesToForward( block[ 0 ].angles ) * 52;
        }
    }
}

roundUp( floatVal )
{
    if ( int( floatVal ) != floatVal )
        return int( floatVal + 1 );
    else
        return int( floatVal );
}

createWeaponTrigger( weapon, fx )
{
    self makeUsable();
    self SetCursorHint( "HINT_ACTIVATE" );
    self setHintString( "Press ^3[{+activate}]^7 To Pick Up Item." );
    
    self waittill( "trigger", player );
    
    if( self.model == "weapon_oma_pack_in_hand" )
    {   
        if( doCoinToss() )
            player addHealth( 100 );
        else player addshield( 100 );
        delete = true;
    }
    else if( self.model == "prop_suitcase_bomb" )
    {
        player addMoney( 250 );
        playFx( level._effect["money"], self.origin );
        delete = true;
    }
    else if( !player isZombie() )
    {
        player thread giveWeap( weapon, 0 );
        delete = true;
    }
    
    if( isDefined( delete ) )
    {
        PlaySoundAtPos( self.origin, "mp_suitcase_pickup" ); 
        fx delete(); self delete(); 
        wait .1;
    }
}

createBounce( radius, force, num )
{
    level endon("game_ended");
    self showOnMiniMap( "cardicon_prestige10" );
    
    while(isDefined(self))
    {
        foreach(player in level.players)
        {
            if( distance( self.origin, player.origin ) < radius && player isOnGround() )   
                player thread doBounce( force, num );
        }
        wait .05;
    }
}    

doBounce( force, num ) 
{
    if( !self _hasPerk( "specialty_falldamage" ) )
        remove = true;
    self _setPerk( "specialty_falldamage", false );
    
    PlaySoundAtPos( "ims_launch", self.origin );
    self setOrigin( self.origin );
    pVecF = anglestoforward( self getplayerangles() );
    for(e = 0; e < num; e++)
    {
        self setVelocity(self GetVelocity() + (0,0,force));
        wait .05;
    }
    while(!self isOnGround())
        wait .1;
    if(isDefined( remove ))
        self _unsetPerk( "specialty_falldamage" );
}

createZipline( pointA, pointB, radius )
{
    level endon("game_ended");
    
    self makeUsable();
    self SetCursorHint( "HINT_ACTIVATE" );
    self setHintString( "Press ^3[{+activate}]^7 To Use Zipline." );
    
    while( IsDefined( self ) )
    {
        self waittill( "trigger", player );
        if( !isDefined( player.isOnZipline )) //safety check
            player thread useZipline( pointA, pointB );
    }
}

useZipline( pointA, pointB )
{
    self.isOnZipline = true;
    location         = pointA.origin;
    if( closer( self.origin, pointA.origin, pointB.origin ) )
        location = pointB.origin;
    
    PlaySoundAtPos( location, "elev_bell_ding" );
    ziplineTag = modelSpawner( self.origin, "tag_origin" );
    ziplineTag PlayLoopSound( "elev_run_loop" );
    time       = calcDistance( 1000, ziplineTag.origin, location );
    
    self PlayerLinkTo( ziplineTag, "tag_origin" );
    ziplineTag MoveTo( location, time ); 
    ziplineTag waittill("movedone");
    PlaySoundAtPos( ziplineTag.origin, "elev_run_end" );
    self Unlink();
    ziplineTag delete(); 
    self.isOnZipline = undefined;
}

createTeleportal( pointA, pointB, radius )
{
    level endon("game_ended");
    
    self makeUsable();
    self SetCursorHint( "HINT_ACTIVATE" );
    self setHintString( "Press ^3[{+activate}]^7 To Use Teleportal." );
    
    while(isDefined(self))
    {
        self waittill( "trigger", player );
        if(!isDefined( player.isInPortal)) //safety check
            player thread useTeleportal( pointA, pointB );
    }
}

useTeleportal( pointA, pointB )
{
    self.isInPortal = true;
    location         = pointA.origin;
    if( closer( self.origin, pointA.origin, pointB.origin ) )
        location = pointB.origin;
    
    PlaySoundAtPos( location, "juggernaut_breathing_sound" );
    self SetOrigin( location );
    wait .25;
    
    self.isInPortal = undefined;
}

CreateDoor(model, open, close, width, height, lengthspace, heightspace, health, price)
{
    door        = Spawn("script_origin", open);
    door.center = Spawn("script_origin", open + (0, (lengthspace / 2) + ((lengthspace * width) / 2) - (lengthspace / 2), 0));
    door.center LinkTo(door);
    door.health    = health;
    door.maxhealth = health;
    door showOnMiniMap( "compass_objpoint_ammo_friendly" );

    duration = calcDistance( 400, open, close );
    for (w = 0; w < width; w ++)
    {
        block = modelSpawner(open + (0, (lengthspace / 2) + (lengthspace * w), 0), model, (0, 90, 0), undefined, true);
        block EnableLinkTo();
        block LinkTo( door );
        block thread DoorDamageMonitor(door, open, close, duration, price);
        block thread DoorHudMonitor( door, price );
        
        for (h = 1; h < height; h ++)
        {
            block = modelSpawner(open + (0, (lengthspace / 2) + (lengthspace * w), 0) + (0, 0, ((heightspace * 2) * h)), model, (0, 90, 0), undefined, true );
            block EnableLinkTo();
            block LinkTo( door );
            block thread DoorDamageMonitor(door, open, close, duration, price);
            block thread DoorHudMonitor( door, price );
        }
    }
    door.angles = (0, VectorToAngles(close - open)[1] + 90, 0);
}

DoorDamageMonitor( door, open, close, duration, price )
{
    self SetCanDamage( true );
    while( IsDefined( self ) )
    {
        self waittill("damage", damage, attacker, direction, point, type, tagname, modelname, partname, weaponname);
        
        if( door.health <= 0 )
        {
            if (door.origin == close )
                door MoveTo( open, duration );
        }
        else if(door.health > 0 && !IsDefined(door.moving) && type == "MOD_MELEE" && !attacker isZombie())
        {
            door.moving = true;
            
            if (door.origin == open)
                door MoveTo( close, duration );
            if (door.origin == close)   
                door MoveTo( open, duration );
                
            wait duration;
            
            objective_position( door.objIdFriendly, door.center.origin );
            door.moving = undefined;
        }
        if( door.health > 0 && type == "MOD_MELEE" && attacker isZombie() )
        {
            door.health -= 25;
            attacker IPrintLn( "Door Damaged By 25 " );
        }
           
    }
}
    
DoorHudMonitor( door, price )
{
    OldDoor = door.health;
    while( IsDefined( self ) )
    {
        foreach( player in level.players )
        {
            if( Distance( player.origin, self.origin ) < 110  && bullettracepassed( self.origin, player GetEye(), 0, self.origin ))
            {
                if( door.health <= 25 && !player isZombie())
                {
                    if( !isDefined( player.hintString ) )
                        player thread doHintString( "Door is currently damaged, hold [{+melee}] to repair for " + price, undefined, 110 );
                    result = player isHoldingMelee();
                    if( result && player.persInfo["money"] > 1000 && door.health <= 0 )
                    {
                        door.health = door.maxhealth;
                        player removeMoney( 1000 );
                    }
                }
                else if( !isDefined( player.hintString ) && door.health > 0 || OldDoor > door.health )
                {
                    player thread doHintString( (player isZombie() ? "[{+melee}] The door to damage, Current Door Health ["+ door.health +"]" : "To Open / Close the door press [{+melee}], Current Door Health ["+ door.health +"]"), undefined, 110 );
                    OldDoor = door.health;
                }
                wait .3;
            }
        }
        wait .05;
    }
}
    
isHoldingMelee()
{
    self endon("disconnect");
    mainCircle  = createRectangle("CENTER", "BOTTOM", 0, -20, 80, 10, (0, 0, 0), "white", 9, 1);
    innerCircle = createRectangle("CENTER", "BOTTOM", 0, -20, 0, 8, (0, 1, 0), "white", 10, 1);
    
    time = 0;
    while( self MeleeButtonPressed() )
    {
        innerCircle ScaleOverTime( .1, int(time * 4), 8 );
        time += 1;
        if(time > 20)
            break;
        wait .1;
    }
    
    mainCircle destroy();
    innerCircle destroy();
    
    if(time > 20)
        return true;
    return false;
}

rotateObj()
{
    while(isDefined(self))
    {
        self rotateTo((self.angles[0], self.angles[1]+90, self.angles[2]), .3);
        wait .3;
    }
}

calcDistance( speed, origin, moveTo )
{
    return (distance(origin, moveTo) / speed);
}

cutString( string, char )
{
    result = "";
    for(i = string.size - 1; i > 0; i--)
    {
        if( string[i] == char )
        {
            result = getSubStr(string, i + 1);
            return result;
        }
    }
    return string;
}

doCoinToss()
{
    if( randomint( 100 ) >= 50 )
        return true;
    return false;
}

showOnMiniMap( shader )
{
    curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();  
    objective_add( curObjID, "invisible", (0,0,0) );
    objective_position( curObjID, self.origin );
    objective_state( curObjID, "active" );
    objective_team( curObjID, self.team );
    objective_icon( curObjID, shader );
    self.objIdFriendly = curObjID;
}
