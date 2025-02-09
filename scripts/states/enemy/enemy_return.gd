class_name EnemyReturn
extends EnemyState

@export var distance_threshold: float = 5:
	set(val):
		distance_threshold = val
		if distance_threshold < 5:
			distance_threshold = 5

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.mob.vision_component.player_spotted.connect(_transition_player_spotted)
	
func physics_update(delta: float) -> void:
	var curr_pos = self.mob.global_position
	var distance_to_origin: float = abs((curr_pos - self.mob.origin_point).length())
	if distance_to_origin < self.distance_threshold:
		_transition_at_origin()
		return
	var direction = self.mob.global_position.direction_to(self.mob.origin_point).normalized()
	self.mob.movement_component.move(direction, delta)

func get_type() -> Type:
	return Type.RETURN
	
func _transition_player_spotted() -> void:
	self.transitioned.emit(self, Type.FOLLOW)
	
func _transition_at_origin() -> void:
	self.transitioned.emit(self, Type.WANDER)
