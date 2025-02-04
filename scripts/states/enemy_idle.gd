class_name EnemyIdle
extends State

func enter(mob: MobOrchestrator) -> void:
	super.enter(mob)
	self.mob.vision_component.player_spotted.connect(_transition_follow)
	
func _transition_follow() -> void:
	self.transitioned.emit(self, "EnemyFollow")
