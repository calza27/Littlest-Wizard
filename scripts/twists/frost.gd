class_name Frost
extends Twist

func _init(damage_mod: float):
	super._init()
	self.name = "Frost"
	self.twist_type = Constants.TwistType.STATUS_EFFECT
	self.status_effect = Status.new(Constants.StatusEffect.SLOW, 3, 0, 0.5, ParticleEffect.Effect.FROST)
	self.damage_modifier = damage_mod
	
static func get_name() -> String:
	return "Frost"
