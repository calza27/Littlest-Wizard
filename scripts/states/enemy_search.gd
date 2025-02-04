class_name EnemySearch
extends State

var _last_known_position: Vector2

func enter(mob: MobOrchestrator) -> void:
	super.enter(mob)
	_last_known_position = self.player.global_position
	self.mob.vision_component.player_spotted.connect(_transition_follow)
	
func physics_update(delta: float) -> void:
	var curr_pos = self.mob.global_position
	var distance_to_last_known: float = abs((curr_pos - _last_known_position).length())
	if distance_to_last_known < 5:
		_transition_return()
		return
	var direction = self.mob.global_position.direction_to(self._last_known_position).normalized()
	self.mob.movement_component.move(direction, delta)

func _transition_return() -> void:
	self.transitioned.emit(self, "EnemyReturn")

func _transition_follow() -> void:
	self.transitioned.emit(self, "EnemyFollow")
