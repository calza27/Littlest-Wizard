class_name EnemyReturn
extends State

func enter(mob: MobOrchestrator) -> void:
	super.enter(mob)
	self.mob.vision_component.player_spotted.connect(_transition_follow)
	
func physics_update(delta: float) -> void:
	var curr_pos = self.mob.global_position
	var distance_to_origin: float = abs((curr_pos - self.mob.origin_point).length())
	if distance_to_origin < 5:
		_transition_wander()
		return
	var direction = self.mob.global_position.direction_to(self.mob.origin_point).normalized()
	self.mob.movement_component.move(direction, delta)
	
func _transition_follow() -> void:
	self.transitioned.emit(self, "EnemyFollow")
	
func _transition_wander() -> void:
	self.transitioned.emit(self, "EnemyWander")
