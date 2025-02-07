class_name PlayerDodge
extends PlayerState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._player.player_animator.animation_finished.connect(_transition_dodge_finished)
	self._player.player_animator.play_dodge_animation()

func input(event: InputEvent) -> void:
	if event.is_action("shoot"):
		self.transitioned.emit(self, Type.ATTACK_BOLT)
	elif _is_spell_event(event):
		_transition_with_spell(event, Type.SPELL_CHARGE)

func get_type() -> Type:
	return Type.DODGE

func _transition_dodge_finished() -> void:
	self.transitioned.emit(self, Type.IDLE_PUFFED)
