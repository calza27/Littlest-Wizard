class_name Status

var effect: Constants.StatusEffect
var duration: float
var modifier: float
var multiplier: float
var timer: Timer
var particle_effect: ParticleEffect

func _init(statusEffect: Constants.StatusEffect, durationSeconds: float, skillModifier: float = 0, skillMultiplier: float = 1, particleEffect: ParticleEffect.Effect = ParticleEffect.Effect.NONE):
	self.effect = statusEffect
	self.duration = durationSeconds
	self.modifier = skillModifier
	if self.modifier < 0:
		self.modifier = 0
	self.multiplier = skillMultiplier
	self.timer = Timer.new()
	self.timer.one_shot = true
	
	if particleEffect:
		var particle: Resource = load("res://scenes/effects/" + ParticleEffect.Effect.find_key(particleEffect).to_lower() + ".tscn")
		var new_particle: ParticleEffect = particle.instantiate()
		new_particle.set_effect(particleEffect)
		new_particle.set_timeout(durationSeconds)
		self.particle_effect = new_particle
	
func duplicate() -> Status:
	var particle: ParticleEffect.Effect = ParticleEffect.Effect.NONE
	if self.particle_effect:
		particle = self.particle_effect.effect
	return Status.new(self.effect, self.duration, self.modifier, self.multiplier, particle)

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
## NOT YET IMPLEMETED
# BLINDED - Reduces the players vision radius to the immediate surroundings
	# prevents monsters from gaining vision of player, causes them to move and attack towards last known position of player
# FRIGHTENED - No effect on player, causes monsters to move away from player, regardless of AI
