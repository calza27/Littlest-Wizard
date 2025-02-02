class_name Firebolt
extends Twist

func _init(dot: float, damage_mod: float):
	super._init()
	self.name = get_name()
	self.twist_type = Constants.TwistType.DAMAGE_OVER_TIME
	self.damage_over_time = DamageOverTime.new(dot, Constants.DamageType.FIRE, 0.5, 3, ParticleEffect.Effect.FIRE)
	self.damage_modifier = damage_mod
	if self.damage_modifier < 0:
		self.damage_modifier = 0
	
static func get_name() -> String:
	return "Firebolt"
