class_name PlayerChargeSpell
extends PlayerState

var _spell: Spell

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._active_spell = (self._previous_state as PlayerState)._active_spell
	_spell = self._player.spell_component.get_spell(self._active_spell)
	if !_spell:
		self.transitioned.emit(self, Type.IDLE_CALM)
		return
	self._player.player_animator.play_charge_spell_animation()

func physics_update(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var direction: Constants.Direction = Utils.vector_to_direction(mouse_pos)
	var facing: Constants.Facing = Utils.direction_to_facing(direction)
	self._player.player_animator.curr_facing = facing
		
func input(event: InputEvent) -> void:
	if event.is_action("shoot"):
		if self._player.mana_component.can_spend_mana(self._spell.mana_cost):
			_transition_with_spell(event, Type.SPELL_CAST)
		else:
			self.transitioned.emit(self, Type.IDLE_PUFFED)
			self._player.status_component.apply_status_condition(StatusEffect.build(Constants.StatusEffectType.STUN, 0.5))
	elif event.is_action("cancel"):
		self.transitioned.emit(self, Type.IDLE_PUFFED)

func get_type() -> Type:
	return Type.SPELL_CHARGE
