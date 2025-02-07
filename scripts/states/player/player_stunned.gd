class_name PlayerStunned
extends PlayerState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._player.status_component.status_removed.connect(_transition_stun_finished)
	self._player.player_animator.play_stun_animation()
	self._player.weapon.set_weapon_enabled(false)
	
func exit() -> void:
	self._player.weapon.set_weapon_enabled(true)

func get_type() -> Type:
	return Type.STUNNED

func _transition_stun_finished(status: Status) -> void:
	if status.effect == Constants.StatusEffect.STUN:
		self.transitioned.emit(self, self._previous_state.get_type())
