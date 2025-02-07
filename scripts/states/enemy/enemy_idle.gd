class_name EnemyIdle
extends EnemyState

@export var inital_direction: Constants.Direction = Constants.Direction.E
var _wait_time: float
var _curr_direction: Constants.Direction

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._curr_direction = self.inital_direction
	self.mob.vision_component.player_spotted.connect(_transition_player_spotted)
	self.mob.mob_graphics_component.play_idle_animation()
	_randomize_idle()

func update(delta: float) -> void:
	if _wait_time > 0:
		_wait_time -= delta
	else:
		_randomize_idle()
		_rotate()
		
func get_type() -> Type:
	return Type.IDLE
		
func _transition_player_spotted() -> void:
	self.transitioned.emit(self, Type.FOLLOW)
	
func _randomize_idle() -> void:
	self._wait_time = randf_range(1, 3)
	
func _rotate() -> void:
	var new_dir: Constants.Direction = self._curr_direction + 1
	if new_dir >= Constants.Direction.values().size():
		new_dir = 0
	self._curr_direction = new_dir
	self.mob.vision_component.update_direction(self._curr_direction)
	self.mob.mob_graphics_component.set_facing_for_direction(self._curr_direction)
