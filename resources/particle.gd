class_name Particle
extends Resource

@export var effect: Constants.ParticleEffectType
@export var timeout: float:
	set(val):
		timeout = val
		if timeout < 0:
			timeout = 0
