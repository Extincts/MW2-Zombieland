deathMonitor()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath );
        if( attacker.name == "" && self.health <= 0)
            self removeMoney( 10 );
        else if( attacker.name != "" && self.health <= 0)
        {
            self addMoney( 20, true );
            attacker addMoney( 100, true );
        }
        
        if( attacker.name == "" )
        {
            self removePersInfo( "health", damage );
            if( self.persInfo[ "health" ] <= 0 )
                self Suicide();
        }
        else 
        {
            health = damage - self.persInfo[ "shield" ];
            if( self.persInfo[ "shield" ] > 0 )
                self removePersInfo( "shield", damage ); 
            if( health > 0 )
                self removePersInfo( "health", health );
        }
            
        if(self.health <= 0)
        {
            if( attacker != self )
                self waittill("spawned_player");
                
            self.droppedDeathWeapon = true;       
            self resetToDefault();    
                
            if( !self isZombie() )
                self isNowZombie();
            else 
                self zombieLoadout();
            
            visionSetNaked( "", 0 ); 
            visionSetNaked( "icbm", 0 ); 
        }    
        else 
        {
            self.maxhealth = self.persInfo[ "shield" ] + self.persInfo[ "health" ];
            self.health    = self.persInfo[ "shield" ] + self.persInfo[ "health" ];
        }
    }
}

hasFinalZombieQuit()
{
    level endon("game_ended");
    
    for(;;)
    {
        count = 0;
        foreach( player in level.players )
        {
            if( player isZombie() )
                count++;
        }
        if( count == 0 )
        {
            level initialCountdown();
            level chooseRandomZombie();
        }
        wait 1;
    }
}

hasGameFinished()
{
    level endon("game_ended");
    //return; //remove
    for(;;)
    {
        human = 0;
        foreach( player in level.players )
        {
            if( !player isZombie() )
                human++;
        }
        
        timeRemaining = maps\mp\gametypes\_gamelogic::getTimeRemaining() / 1000;
        timeRemaining = (timeRemaining / 60);
        
        if( human == 0 && !IsDefined( level.initializingCountdown ) )
            thread endGameWithKillcam( 0 );
        else if( timeRemaining <= .1 && human > 0 && !IsDefined( level.initializingCountdown ) )
            thread endGameWithKillcam( 1 );
        wait 1;
    }
}

endGameWithKillcam( type )
{
    level.showingFinalKillcam = true;    
    foreach( player in level.players )
        player thread do_killcam_final( level.most_recent_killer );    
        
    while( level.showingFinalKillcam )
        wait .05;   
    
    if( type )
        thread endGame( "allies", "Humans Has Successfully Survived The Outbreak." );
    else 
        thread endGame( "axis", "Zombies Has Successfully Eliminated All Humans." );
}
