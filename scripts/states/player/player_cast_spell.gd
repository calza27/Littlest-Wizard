class_name PlayerCastSpell
extends PlayerState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._active_spell = (self._previous_state as PlayerState)._active_spell
	self._player.player_animator.play_cast_spell_animation()
	self._player.weapon.set_weapon_enabled(false)
	self._player.player_animator.animation_finished.connect(_transition_cast_finished)
	print("Active spell: ", self._active_spell)
	# cast the spell
	# self._player.spell_component.cast_spell(self._active_spell)
	
func exit() -> void:
	self._player.weapon.set_weapon_enabled(true)

func get_type() -> Type:
	return Type.SPELL_CAST
	
func _transition_cast_finished() -> void:
	self.transitioned.emit(self, Type.IDLE_PUFFED)
	
