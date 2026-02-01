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
            cvsVibrate(3, 0.25);
        }

        else if ( damageAction.DealtDamage() && attackAction ) {
            attackName = attackAction.GetAttackName();

            if ( damageAction.IsCriticalHit() ) {
                cvsVibrate(2, 0.3);
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
