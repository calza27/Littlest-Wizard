class_name PlayerCastSpell
extends PlayerState

var _spell: Spell

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._active_spell = (self._previous_state as PlayerState)._active_spell
	_spell = self._player.spell_component.get_spell(self._active_spell)
	if !_spell:
		self.transitioned.emit(self, Type.IDLE_PUFFED)
		return
	
	self._player.spell_component.spell_cast_start.connect(_start_cast)
	self._player.spell_component.spell_cast_end.connect(_end_cast)
	if self._player.spell_component.cast_spell(_spell):
		self._player.mana_component.spend_mana(_spell.mana_cost)
	
func exit() -> void:
	self._player.weapon.set_weapon_enabled(true)

func get_type() -> Type:
	return Type.SPELL_CAST
	
func _start_cast(spell: Spell) -> void:
	self._player.player_animator.play_cast_spell_animation()
	self._player.weapon.set_weapon_enabled(false)

func _end_cast(spell: Spell) -> void:
	self._player.player_animator.stop_animation()
	self.transitioned.emit(self, Type.IDLE_PUFFED)
