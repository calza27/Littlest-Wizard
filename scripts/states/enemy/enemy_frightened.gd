class_name EnemyFrightened
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.mob.status_component.status_removed.connect(_transition_frightened_finished)
	
func physics_update(delta: float) -> void:
	if self.mob && self.mob.movement_component:
		var direction = Utils.normalise_movement(self.player.global_position.direction_to(self.mob.global_position))
		self.mob.movement_component.move(direction, delta)

func get_type() -> Type:
	return Type.FRIGHTENED
	
func _transition_frightened_finished(status: StatusEffect) -> void:
	if status.effect == Constants.StatusEffectType.FRIGHTENED:
		self.transitioned.emit(self, self._previous_state.get_type())
