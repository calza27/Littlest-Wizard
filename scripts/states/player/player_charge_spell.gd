class_name PlayerChargeSpell
extends PlayerState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._active_spell = (self._previous_state as PlayerState)._active_spell
	self._player.player_animator.play_charge_spell_animation()

func physics_update(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var direction: Constants.Direction = Utils.vector_to_direction(mouse_pos)
	var facing: Constants.Facing = Utils.direction_to_facing(direction)
	self._player.player_animator.curr_facing = facing
		
func input(event: InputEvent) -> void:
	if event.is_action("shoot"):
		# get spell from spell component
		#var spell: Spell = self._player.spell_component.get_spell(self._active_spell)
		#if self._player.mana_component.can_spend_mana(spell.mana_cost):
		if self._player.mana_component.can_spend_mana(10):
			_transition_with_spell(event, Type.SPELL_CAST)
		else:
			self.transitioned.emit(self, Type.IDLE_PUFFED)
			self._player.status_component.apply_status_condition(Status.new(Constants.StatusEffect.STUN, 0.5))
	elif event.is_action("cancel"):
		self.transitioned.emit(self, Type.IDLE_PUFFED)

func get_type() -> Type:
	return Type.SPELL_CHARGE
