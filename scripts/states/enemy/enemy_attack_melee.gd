class_name EnemyAttackMelee
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.mob.attack_component.melee_weapon_component.player_out_melee.connect(_transition_out_of_melee)
	_entry_check()
	
func physics_update(_delta: float) -> void:
	self.mob.attack_component.attack_melee()

func get_type() -> Type:
	return Type.ATTACK_MELEE
	
func _transition_out_of_melee() -> void:
	if self.mob.attack_component.ranged_weapon_component:
		self.transitioned.emit(self, Type.ATTACK_RANGED)
	else:
		self.transitioned.emit(self, Type.FOLLOW)

func _entry_check() -> void:
	var bodies: Array[Node2D] = self.mob.attack_component.melee_weapon_component.melee_range.get_overlapping_bodies()
	for body in bodies:
		if body is PlayerCharacter:
			return
	_transition_out_of_melee()
