class_name EnemyBlind
extends EnemyState

@export var distance_threshold: int = 5:
	set(val):
		distance_threshold = val
		if distance_threshold < 5:
			distance_threshold = 5
var _last_known_position: Vector2

func enter(previousState: State) -> void:
	super.enter(previousState)
	_last_known_position = self.player.global_position
	self.mob.status_component.status_removed.connect(_transition_blind_finished)
		
func physics_update(delta: float) -> void:
	var curr_pos = self.mob.global_position
	var distance_to_last_known: float = abs((curr_pos - _last_known_position).length())
	if distance_to_last_known < self.distance_threshold:
		return
	var direction = self.mob.global_position.direction_to(self._last_known_position).normalized()
	self.mob.movement_component.move(direction, delta)

func get_type() -> Type:
	return Type.BLIND
	
func _transition_blind_finished(status: StatusEffect) -> void:
	if status.effect == Constants.StatusEffectType.BLINDED:
		self.transitioned.emit(self, self._previous_state.get_type())
