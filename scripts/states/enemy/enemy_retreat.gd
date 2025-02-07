class_name EnemyRetreat
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.mob.attack_component.ranged_weapon_component.player_not_close.connect(_transition_player_not_close)
	self.mob.mob_graphics_component.play_walk_animation()
	
func physics_update(delta: float) -> void:
	var direction_away_from_player: Vector2 = self.player.global_position.direction_to(self.mob.global_position).normalized()
	self.mob.movement_component.move(direction_away_from_player, delta)

func get_type() -> Type:
	return Type.RETREAT

func _transition_player_not_close() -> void:
	self.transitioned.emit(self, Type.ATTACK_RANGED)
