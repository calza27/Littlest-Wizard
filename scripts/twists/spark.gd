class_name Spark
extends Twist

func _init(damage_modifier: float):
	super._init()
	self.twist_name = get_twist_name()
	self.twist_type = Constants.TwistType.STATUS_EFFECT
	self.status_effect = StatusEffect.build(Constants.StatusEffectType.ENFEEBLE, 3, 0, 0.5)
	self.damage_modifier = damage_modifier
	
static func get_twist_name() -> String:
	return "Spark"
