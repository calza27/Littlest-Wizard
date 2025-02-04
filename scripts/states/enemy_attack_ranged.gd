class_name EnemyAttackRanged
extends State

func enter(mob: MobOrchestrator) -> void:
	super.enter(mob)
	if self.mob.attack_component.melee_weapon_component:
		self.mob.attack_component.melee_weapon_component.player_in_melee.connect(_transition_melee)
	else:
		self.mob.attack_component.ranged_weapon_component.player_too_close.connect(_transition_retreat)
	self.mob.attack_component.ranged_weapon_component.player_out_of_range.connect(_transition_follow)
	
func physics_update(_delta: float) -> void:
	
	self.mob.attack_component.attack_ranged()

func _transition_melee() -> void:
	self.transitioned.emit(self, "EnemyAttackMelee")
	
func _transition_retreat() -> void:
	self.transitioned.emit(self, "EnemyRetreat")
	
func _transition_follow() -> void:
	self.transitioned.emit(self, "EnemyFollow")
