class_name Frost
extends Twist

func _init(damage_mod: float):
	super._init()
	self.twist_name = get_twist_name()
	self.twist_type = Constants.TwistType.STATUS_EFFECT
	self.status_effect = StatusEffect.build(Constants.StatusEffectType.SLOW, 3, 0, 0.5)
	self.status_effect.set_particle_effect(Constants.ParticleEffectType.FROST)
	self.damage_modifier = damage_mod
	
static func get_twist_name() -> String:
	return "Frost"
