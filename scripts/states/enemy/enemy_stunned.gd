class_name EnemyStunned
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.mob.status_component.status_removed.connect(_transition_stun_finished)
	self.mob.mob_graphics_component.play_stun_animation()

func get_type() -> Type:
	return Type.STUNNED

func _transition_stun_finished(status: Status) -> void:
	if status.effect == Constants.StatusEffect.STUN:
		self.transitioned.emit(self, self._previous_state.get_type())
