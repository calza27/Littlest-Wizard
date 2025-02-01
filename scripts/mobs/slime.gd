class_name Slime
extends MobOrchestrator

func _ready() -> void:
	super._ready()
	health_component.set_damage_multiplier({Constants.DamageType.FORCE: 0.5})

func _on_hitbox_component_attacked(attack: Attack, dodged: bool) -> void:
	EventBus.focus_enemy.emit(self.ui_label, self.health_component.max_health, self.health_component.curr_health)
	if !dodged:
		_spot_player()
		_apply_attack(attack)
