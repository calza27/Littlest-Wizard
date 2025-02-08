class_name MageArmour
extends Spell

func _init():
	self.name = "Magic Barrier"
	self.target = Constants.Target.PLAYER
	self.status_effect = StatusEffect.build(Constants.StatusEffectType.NIMBLE, 0, 0.25, 1)
	
