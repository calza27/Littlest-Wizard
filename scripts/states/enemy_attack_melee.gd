class_name EnemyAttackMelee
extends State

func enter(mob: MobOrchestrator) -> void:
	super.enter(mob)
	if self.mob.attack_component.ranged_weapon_component:
		self.mob.attack_component.melee_weapon_component.player_out_melee.connect(_transition_ranged)
	else:
		self.mob.attack_component.melee_weapon_component.player_out_melee.connect(_transition_follow)
	
func physics_update(_delta: float) -> void:
	self.mob.attack_component.attack_melee()

func _transition_ranged() -> void:
	self.transitioned.emit(self, "EnemyAttackRanged")
	
func _transition_follow() -> void:
	self.transitioned.emit(self, "EnemyFollow")
