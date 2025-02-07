class_name PlayerAttackBolt
extends PlayerState

@export var cast_time: float = 0.75
var _time_remaining: float

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._player.player_animator.play_idle_animation(false)
	self._player.weapon.fire_weapon()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var direction: Constants.Direction = Utils.vector_to_direction(mouse_pos)
	var facing: Constants.Facing = Utils.direction_to_facing(direction)
	self._player.player_animator.curr_facing = facing
	self._time_remaining = self.cast_time
	
func update(delta: float) -> void:
	self._time_remaining -= delta
	if self._time_remaining <= 0:
		self.transitioned.emit(self, Type.IDLE_PUFFED)
	
func get_type() -> Type:
	return Type.ATTACK_BOLT
