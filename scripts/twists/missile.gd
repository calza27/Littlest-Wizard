extends Twist
class_name Missile

func _init(damage_multi: float):
	super._init()
	self.twist_type = Constants.TwistType.DAMAGE
	self.damage_type_override = Constants.DamageType.THUNDER
	self.damage_multiplier = damage_multi
	if self.damage_multiplier < 1:
		self.damage_multiplier = 1
