class_name EnemyAttackRanged
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	if self.mob.attack_component.melee_weapon_component:
		self.mob.attack_component.melee_weapon_component.player_in_melee.connect(_transition_in_melee)
	else:
		self.mob.attack_component.ranged_weapon_component.player_too_close.connect(_transition_too_close)
	self.mob.attack_component.ranged_weapon_component.player_out_of_range.connect(_transition_out_of_range)
	
func physics_update(_delta: float) -> void:
	
	self.mob.attack_component.attack_ranged()

func get_type() -> Type:
	return Type.ATTACK_RANGED
	
func _transition_in_melee() -> void:
	self.transitioned.emit(self, Type.ATTACK_MELEE)
	
func _transition_too_close() -> void:
	self.transitioned.emit(self, Type.RETREAT)
	
func _transition_out_of_range() -> void:
	self.transitioned.emit(self, Type.FOLLOW)
