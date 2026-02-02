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
        
        if (victim && victim.GetHealth() <= 0) {
            theGame.VibrateControllerVeryHard(0.3);
        }

        else if (damageAction.DealtDamage() && attackAction) {
            attackName = attackAction.GetAttackName();

            if ( damageAction.IsCriticalHit() ) {
                theGame.VibrateControllerHard(0.45);
            }

            else if (attackName == theGame.params.ATTACK_NAME_HEAVY) {
                theGame.VibrateControllerVeryHard(0.4);
            }
            else {
                theGame.VibrateControllerHard(0.3);
            }
        }
    }
    
    return result;
}

@addField(W3PlayerWitcher) var quenVibeCounter : float;
@addField(W3PlayerWitcher) var lfmNext : bool;

@wrapMethod(W3PlayerWitcher) function OnPlayerTickTimer( deltaTime : float ) {
    if ( this.IsCurrentSignChanneled() && this.GetCurrentlyCastSign() == ST_Quen ) {        
        if ( quenVibeCounter > 0 ) {
            quenVibeCounter -= deltaTime;
        } 
        else {

            if (lfmNext) {
                theGame.VibrateController(0.01, 0.0, 0.4); 
                quenVibeCounter = 0.35;
                lfmNext = false;  // Next time, play HFM
            } 
            else {
                theGame.VibrateController(0.0, 0.02, 0.125); 
                quenVibeCounter = 1.18; 
                lfmNext = true;   // Next time, play LFM
            }
        }
    } else {
        quenVibeCounter = 0;
        lfmNext = true; // Reset state
    }

    wrappedMethod(deltaTime);
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
