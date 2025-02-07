class_name EnemyWander
extends EnemyState

@export var distance_limit: float = 0
var _move_direction: Vector2
var _wander_time: float
var _origin: Vector2
var _waiting: bool = true

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._origin = self.mob.global_position
	self.mob.vision_component.player_spotted.connect(_transition_player_spotted)
	self.mob.mob_graphics_component.play_walk_animation()
	_randomize_wander()
	
func update(delta: float) -> void:
	if _wander_time > 0:
		_wander_time -= delta
	else:
		_randomize_wander()

func physics_update(delta: float) -> void:
	if _within_limit(delta):
		mob.movement_component.move(_move_direction, delta)

func get_type() -> Type:
	return Type.WANDER
	
func _within_limit(delta) -> bool:
	if self.distance_limit > 0:
		var distance: float =  self.mob.movement_component.speed * delta
		var curr_pos: Vector2 =  self.mob.global_position
		var final_pos = curr_pos + ( self._move_direction*distance)
		var distance_from_origin: float = (final_pos - self._origin).length()
		if distance_from_origin > self.distance_limit:
			return false
	return true
	
func _randomize_wander() -> void:
	self._wander_time = randf_range(1, 3)
	if self._waiting:
		self._move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	else:
		self._move_direction = Vector2(0, 0)
	self._waiting = !self._waiting

func _transition_player_spotted() -> void:
	self.transitioned.emit(self, Type.FOLLOW)
