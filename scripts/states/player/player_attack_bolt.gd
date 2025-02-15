class_name PlayerAttackBolt
extends PlayerState

@export var cast_time: float = 0.75
var _time_remaining: float

func enter(previousState: State) -> void:
	super.enter(previousState)
	var mouse_pos: Vector2 = self._player.get_global_mouse_position()
	var direction: Constants.Direction = Utils.vector_to_direction(mouse_pos - self._player.global_position)
	self._player.set_direction(direction)
	self._player.player_animator.play_idle_animation(false)
	self._player.weapon.fire_weapon()
	self._time_remaining = self.cast_time
	
func update(delta: float) -> void:
	self._time_remaining -= delta
	if self._time_remaining <= 0:
		self.transitioned.emit(self, Type.IDLE_PUFFED)
	
func get_type() -> Type:
	return Type.ATTACK_BOLT
