class_name Spark
extends Twist

func _init(damage_modifier: float):
	super._init()
	self.name = "Spark"
	self.twist_type = Constants.TwistType.STATUS_EFFECT
	self.status_effect = Status.new(Constants.StatusEffect.ENFEEBLE, 3, 0, 0.5)
	self.damage_modifier = damage_modifier
	
static func get_name() -> String:
	return "Spark"
