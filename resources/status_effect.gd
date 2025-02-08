class_name StatusEffect
extends Resource

@export var effect: Constants.StatusEffectType
@export var duration: float
@export var modifier: float:
	set(val):
		modifier = val
		if modifier < 0:
			modifier = 0
@export var multiplier: float
@export var particle: Particle:
	set(val):
		particle = val
		set_particle_effect(particle.effect)
var time_remaining: float
var _particle_effect: ParticleEffect

static func build(statusEffect: Constants.StatusEffectType, durationSeconds: float, skillModifier: float = 0, skillMultiplier: float = 1) -> StatusEffect:
	var status: StatusEffect = StatusEffect.new()
	status.effect = statusEffect
	status.duration = durationSeconds
	status.modifier = skillModifier
	status.multiplier = skillMultiplier
	return status
		
func set_particle_effect(particleEffect: Constants.ParticleEffectType) -> void:
	if particleEffect:
		var particle_resource: Resource = load("res://scenes/effects/" + Constants.ParticleEffectType.find_key(particleEffect).to_lower() + ".tscn")
		var new_particle: ParticleEffect = particle_resource.instantiate()
		new_particle.set_effect(particleEffect)
		new_particle.set_timeout(self.duration)
		self._particle_effect = new_particle
	else:
		self._particle_effect = null
	
func get_particle_effect() -> ParticleEffect:
	return self._particle_effect

# STUN - Unable to act, pauses all user input and AI decisions
# SLOW - Reduces movement speed
# HASTE - Increases movement speed
# RESTRAINED - Prevents all movement
# BUFF - Increases attack damage
# ENFEEBLE - Reduces attack damage
# LETHARGY - Increases attack/spell cooldown
# VIGOR - Decreases attack/spell cooldown 
# NIMBLE - increases dodge chance
# CUMBERSOME - decreases dodge chance
# FRIGHTENED - No effect on player, causes monsters to move away from player, regardless of AI
## NOT YET IMPLEMETED
# BLINDED - Reduces the players vision radius to the immediate surroundings
	# prevents monsters from gaining vision of player, causes them to move and attack towards last known position of player
