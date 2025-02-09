class_name EnemyFollow
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	if self.mob.attack_component.melee_weapon_component:
		self.mob.attack_component.melee_weapon_component.player_in_melee.connect(_transition_in_melee)
	if self.mob.attack_component.ranged_weapon_component:
		self.mob.attack_component.ranged_weapon_component.player_in_range.connect(_transition_in_ranged)
	self.mob.vision_component.player_lost.connect(_transition_player_lost)
	
func physics_update(delta: float) -> void:
	if self.mob && self.mob.movement_component:
		var direction = Utils.normalise_movement(self.mob.global_position.direction_to(self.player.global_position))
		self.mob.movement_component.move(direction, delta)

func get_type() -> Type:
	return Type.FOLLOW
	
func _transition_in_melee() -> void:
	self.transitioned.emit(self, Type.ATTACK_MELEE)
	
func _transition_in_ranged() -> void:
	self.transitioned.emit(self, Type.ATTACK_RANGED)

func _transition_player_lost() -> void:
	self.transitioned.emit(self, Type.SEARCH)
