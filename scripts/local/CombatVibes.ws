function cvsVibrate(intensity: int, duration: float) {
        switch (intensity) {
            case 3: 
                theGame.VibrateControllerVeryHard(duration); 
                break;
            case 2: 
                theGame.VibrateControllerHard(duration); 
                break;
            case 1: 
                theGame.VibrateControllerLight(duration); 
                break;
            case 0:
                theGame.VibrateControllerVeryLight(duration);
                break;
            default: 
                GetWitcherPlayer().DisplayHudMessage("Invalid vibration intensity requested");
                break;
        }
    }

@wrapMethod(CNewNPC) function ReactToBeingHit(damageAction : W3DamageAction, optional buffNotApplied : bool) : bool {
    var result       : bool;
    var attackAction : W3Action_Attack;
    var victim       : CNewNPC;
    var hitType      : EHitReactionType;
    var attackName   : name;
    
    result = wrappedMethod(damageAction, buffNotApplied);
    
    if ( damageAction.attacker == thePlayer && !damageAction.IsDoTDamage() ) {
        attackAction = (W3Action_Attack)damageAction;
        victim = (CNewNPC)damageAction.victim;
        hitType = damageAction.GetHitReactionType();
        
        if ( victim && victim.GetHealth() <= 0 ) {
            cvsVibrate(3, 0.3);
        }

        else if ( damageAction.DealtDamage() && attackAction ) {
            attackName = attackAction.GetAttackName();

            if ( damageAction.IsCriticalHit() ) {
                cvsVibrate(2, 0.45);
            }

            else if ( attackName == theGame.params.ATTACK_NAME_HEAVY || attackName == theGame.params.ATTACK_NAME_SUPERHEAVY ) {
                cvsVibrate(3, 0.4);
            }
            else {
                cvsVibrate(2, 0.3);
            }
        }
    }
    
    return result;
}

@addField(W3PlayerWitcher) var quenVibeCounter : float;

@wrapMethod(W3PlayerWitcher) function OnPlayerTickTimer( deltaTime : float ) {
    if ( this.IsCurrentSignChanneled() && this.GetCurrentlyCastSign() == ST_Quen ) {
        
        quenVibeCounter += deltaTime;

        // Create a 0.4 second cycle
        if ( quenVibeCounter < 0.2 ) {
            // Phase 1: Soft LFM "Thrum"
            theGame.VibrateController(0.04, 0.0, 0.1); 
        } else if ( quenVibeCounter < 0.4 ) {
            // Phase 2: Very faint HFM "Shimmer"
            theGame.VibrateController(0.0, 0.02, 0.1);
        } else {
            // Reset cycle
            quenVibeCounter = 0;
        }
    } else {
        quenVibeCounter = 0; // Reset if we stop casting
    }

    wrappedMethod(deltaTime);
}
}

@wrapMethod(W3PlayerWitcher) function QuenImpulse( isAlternate : bool, signEntity : W3QuenEntity, source : string, optional forceSkillLevel : int )
{
    var level : int;

    // Check skill level if not forced (S_Magic_s13 = Exploding Shield)
    if( forceSkillLevel > 0 ) {
        level = forceSkillLevel;
    } else {
        level = GetSkillLevel(S_Magic_s13);
    }

    if (isAlternate) {                          // Alt Quen burst
        theGame.VibrateControllerVeryHard(); 
    } else if (level >= 3) {                    // Exploding Shield Level 3
        theGame.VibrateControllerHard();
    } else {                                    // Exploding Shield Level 1-2
        theGame.VibrateControllerLight();
    }

    wrappedMethod(isAlternate, signEntity, source, forceSkillLevel);
}
