class_name EnemyDead
extends EnemyState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self.mob.queue_free()

func get_type() -> Type:
	return Type.DEAD
