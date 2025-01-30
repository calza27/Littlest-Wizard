extends Twist
class_name Firebolt

func _init(dot: float, damage_mod: float):
	super._init()
	self.twist_type = Constants.TwistType.DAMAGE_OVER_TIME
	self.damage_over_time = DamageOverTime.new(dot, Constants.DamageType.FIRE, 0.5, 3, ParticleEffect.Effect.FIRE)
	self.damage_modifier = damage_mod
	if self.damage_modifier < 0:
		self.damage_modifier = 0
	
