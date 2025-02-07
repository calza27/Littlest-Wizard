class_name SlimeFollow
extends EnemyFollow

func _transition_player_lost() -> void:
	self.transitioned.emit(self, Type.WANDER)
	
