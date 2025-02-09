class_name Missile
extends Twist

func _init(damage_multi: float):
	super._init()
	self.twist_name = get_twist_name()
	self.twist_type = Constants.TwistType.DAMAGE
	self.damage_type_override = Constants.DamageType.THUNDER
	self.damage_multiplier = damage_multi
	if self.damage_multiplier < 1:
		self.damage_multiplier = 1

static func get_twist_name() -> String:
	return "Missile"
