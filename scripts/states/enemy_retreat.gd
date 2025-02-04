class_name EnemyRetreat
extends State

func enter(mob: MobOrchestrator) -> void:
	super.enter(mob)
	self.mob.attack_component.ranged_weapon_component.player_not_close.connect(_transition_ranged)
	
func physics_update(delta: float) -> void:
	var direction_away_from_player: Vector2 = self.player.global_position.direction_to(self.mob.global_position).normalized()
	self.mob.movement_component.move(direction_away_from_player, delta)

func _transition_ranged() -> void:
	self.transitioned.emit(self, "EnemyAttackRanged")
