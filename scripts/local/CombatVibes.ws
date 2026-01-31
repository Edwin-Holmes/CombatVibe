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
    
    result = wrappedMethod(damageAction, buffNotApplied);
    
    if ( damageAction.attacker == thePlayer && !damageAction.IsDoTDamage() ) {
        attackAction = (W3Action_Attack)damageAction;
        victim = (CNewNPC)damageAction.victim;

        if ( victim && victim.GetHealth() <= 0 ) {
            this.Vibrate(3, 0.5);
        }

        else if ( damageAction.IsCountered() ) {
            this.Vibrate(3, 0.2);
        }

        else if ( damageAction.IsParried() ) {
            this.Vibrate(1, 0.1);
        }

        else if ( damageAction.DealsAnyDamage() && attackAction ) {
            if ( damageAction.IsCriticalHit() ) {
                this.Vibrate(2, 0.4);
            }
            else if ( attackAction.GetSwingType() == ST_Heavy ) {
                this.Vibrate(2, 0.3);
            }
            else {
                this.Vibrate(1, 0.2);
            }
        }
    }
    
    return result;
}

@wrapMethod(W3BoltProjectile) function OnProcessThrowEvent( animEventName : name ) {
    if ( animEventName == 'ProjectileThrow' ) {
        this.Vibrate(2, 0.1); 
    }

    return wrappedMethod(animEventName);
}