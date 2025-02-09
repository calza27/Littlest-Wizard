class_name PlayerIdleCalm
extends PlayerState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._player.player_animator.play_idle_animation(true)

func input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		self.transitioned.emit(self, Type.ATTACK_BOLT)
	elif _is_movement_event(event):
		self.transitioned.emit(self, Type.MOVE)
	elif _is_spell_event(event):
		_transition_with_spell(event, Type.SPELL_CHARGE)

func get_type() -> Type:
	return Type.IDLE_CALM
