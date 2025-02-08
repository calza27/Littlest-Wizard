class_name PlayerDead
extends PlayerState

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._player.queue_free()

func get_type() -> Type:
	return Type.DEAD
