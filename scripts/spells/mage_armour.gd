extends Spell
class_name MageArmour

func _init():
	self.target = Constants.Target.PLAYER
	self.status_effect = Status.new(Constants.StatusEffect.NIMBLE, 0, 0.25, 1)
	
