class_name Goblin
extends MobOrchestrator

func _ready() -> void:
	super._ready()
	health_component.set_damage_multiplier({Constants.DamageType.FORCE: 1.5})
