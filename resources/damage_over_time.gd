class_name DamageOverTime
extends Resource

@export var attack: Attack
@export var tick_rate: float
@export var duration: float
@export var particle: Particle:
	set(val):
		particle = val
		set_particle_effect(particle.effect)
var timer: Timer
var _particle_effect: ParticleEffect

static func build(damageAmount: float, damageType: Constants.DamageType, tickRate: float, durationSeconds: float) -> DamageOverTime:
	var damage_over_time: DamageOverTime = DamageOverTime.new()
	damage_over_time.attack = Attack.build(damageAmount, damageType)
	damage_over_time.tick_rate = tickRate
	damage_over_time.duration = durationSeconds
	damage_over_time.timer = Timer.new()
	return damage_over_time
		
func set_particle_effect(particleEffect: Constants.ParticleEffectType) -> void:
	if particleEffect:
		var particle: Resource = load("res://scenes/effects/" + Constants.ParticleEffectType.find_key(particleEffect).to_lower() + ".tscn")
		var new_particle: ParticleEffect = particle.instantiate()
		new_particle.set_effect(particleEffect)
		new_particle.set_timeout(self.duration)
		self._particle_effect = new_particle
	else:
		self._particle_effect = null
	
func get_particle_effect() -> ParticleEffect:
	return self._particle_effect
