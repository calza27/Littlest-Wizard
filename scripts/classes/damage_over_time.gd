class_name DamageOverTime

var attack: Attack
var tick_rate: float
var duration: float
var timer: Timer
var particle_effect: ParticleEffect

func _init(damageAmount: float, damageType: Constants.DamageType, tickRate: float, durationSeconds: float, particleEffect: ParticleEffect.Effect):
	self.attack = Attack.new(damageAmount, damageType)
	self.tick_rate = tickRate
	self.duration = durationSeconds
	self.timer = Timer.new()
	
	if particleEffect:
		var particle: Resource = load("res://scenes/effects/" + ParticleEffect.Effect.find_key(particleEffect).to_lower() + ".tscn")
		var new_particle: ParticleEffect = particle.instantiate()
		new_particle.init(durationSeconds, particleEffect)
		self.particle_effect = new_particle
	
func duplicate() -> DamageOverTime:
	var particle: ParticleEffect.Effect = ParticleEffect.Effect.NONE
	if self.particle_effect:
		particle = self.particle_effect.effect
	return DamageOverTime.new(self.attack.damage, self.attack.damage_type, self.tick_rate, self.duration, particle)
