class_name EnemyState
extends State

var player: PlayerCharacter
var mob: MobOrchestrator

enum Type { NONE, IDLE, WANDER, FOLLOW, SEARCH, RETREAT, RETURN, ATTACK_MELEE, ATTACK_RANGED, STUNNED, DODGE, FRIGHTENED, BLIND, DEAD }

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.player = Utils.get_player()
	self._previous_state = previousState
	
func set_mob(m: MobOrchestrator) -> void:
	self.mob = m
	
func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
	
func get_type() -> Type:
	return Type.NONE
