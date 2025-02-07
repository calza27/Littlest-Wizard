class_name PlayerSprint
extends PlayerState

var _sprint_speed: float = 1.5

func exit() -> void:
	self._player.player_animator.stop_animation()

func physics_update(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		self._player.movement_component.move(direction * self._sprint_speed, delta)
		self._player.player_animator.play_walk_animation(self._sprint_speed)
	else:
		self.transitioned.emit(self, Type.IDLE_PUFFED)
	
func input(event: InputEvent) -> void:
	if event.is_action_released("sprint"):
		self.transitioned.emit(self, Type.MOVE)

func get_type() -> Type:
	return Type.SPRINT
