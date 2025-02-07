class_name EnemyDodge
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.mob.mob_graphics_component.animation_finished.connect(_transition_dodge_finished)
	self.mob.mob_graphics_component.play_dodge_animation()

func get_type() -> Type:
	return Type.DODGE

func _transition_dodge_finished() -> void:
	self.transitioned.emit(self, self._previous_state.get_type())
