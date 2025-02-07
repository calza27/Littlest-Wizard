class_name EnemySearch
extends EnemyState

@export var distance_threshold: int = 5:
	set(val):
		distance_threshold = val
		if distance_threshold < 5:
			distance_threshold = 5
@export var timeout: int = 10:
	set(val):
		timeout = val
		if timeout < 2:
			timeout = 2
var _last_known_position: Vector2

func enter(previousState: State) -> void:
	super.enter(previousState)
	_last_known_position = self.player.global_position
	self.mob.vision_component.player_spotted.connect(_transition_player_spotted)
	var timer: Timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_transition_end_search)
	timer.start(self.timeout)
	self.mob.mob_graphics_component.play_walk_animation()
	
func physics_update(delta: float) -> void:
	var curr_pos = self.mob.global_position
	var distance_to_last_known: float = abs((curr_pos - _last_known_position).length())
	if distance_to_last_known < self.distance_threshold:
		_transition_end_search()
		return
	var direction = self.mob.global_position.direction_to(self._last_known_position).normalized()
	self.mob.movement_component.move(direction, delta)

func get_type() -> Type:
	return Type.SEARCH
	
func _transition_end_search() -> void:
	self.transitioned.emit(self, Type.RETURN)

func _transition_player_spotted() -> void:
	self.transitioned.emit(self, Type.FOLLOW)
