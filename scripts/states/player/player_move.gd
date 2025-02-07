class_name PlayerMove
extends PlayerState

func enter(previousState: State) -> void:
	super.enter(previousState)

func exit() -> void:
	self._player.player_animator.stop_animation()

func physics_update(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		if Input.is_action_pressed("sprint"):
			self.transitioned.emit(self, Type.SPRINT)
		else:
			self._player.movement_component.move(direction, delta)
			self._player.player_animator.play_walk_animation()
	else:
		self.transitioned.emit(self, Type.IDLE_PUFFED)
	
func input(event: InputEvent) -> void:
	if event.is_action("shoot"):
		self.transitioned.emit(self, Type.ATTACK_BOLT)
	elif _is_spell_event(event):
		_transition_with_spell(event, Type.SPELL_CHARGE)

func get_type() -> Type:
	return Type.MOVE
