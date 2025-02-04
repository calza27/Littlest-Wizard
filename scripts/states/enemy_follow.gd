class_name EnemyFollow
extends State

func enter(mob: MobOrchestrator) -> void:
	super.enter(mob)
	if self.mob.attack_component.melee_weapon_component:
		self.mob.attack_component.melee_weapon_component.player_in_melee.connect(_transition_melee)
	if self.mob.attack_component.ranged_weapon_component:
		self.mob.attack_component.ranged_weapon_component.player_in_range.connect(_transition_ranged)
	self.mob.vision_component.player_lost.connect(_transition_search)
	
func physics_update(delta: float) -> void:
	if self.mob && self.mob.movement_component:
		var direction = Utils.normalise_movement(self.mob.global_position.direction_to(self.player.global_position))
		self.mob.movement_component.move(direction, delta)
		if self.mob.mob_graphics_component:
			self.mob.mob_graphics_component.play_walk_animation()

func _transition_melee() -> void:
	self.transitioned.emit(self, "EnemyAttackMelee")
	
func _transition_ranged() -> void:
	self.transitioned.emit(self, "EnemyAttackRanged")

func _transition_search() -> void:
	self.transitioned.emit(self, "EnemySearch")
