extends Node

func get_player() -> PlayerCharacter:
	return get_tree().get_first_node_in_group(Constants.group_name_for_group(Constants.Group.PLAYER))
	
func get_player_shape() -> Rect2:
	var player: PlayerCharacter = get_player()
	var rect: RectangleShape2D = player.collision_shape.shape as RectangleShape2D
	return rect.get_rect()

func normalise_movement(movement: Vector2) -> Vector2:
	var xMultiplier: int = (1 if movement.x >=0 else -1)
	var yMultiplier: int = (1 if movement.y >=0 else -1)
	if abs(movement.x) > abs(movement.y):
		var yDiff: float = abs(movement.x) - abs(movement.y)
		if yDiff > abs(movement.y):
			movement.y = 0
		else:
			movement.y = yMultiplier * abs(movement.x)
	elif abs(movement.x) < abs(movement.y):
		var xDiff: float = abs(movement.y) - abs(movement.x)
		if xDiff > abs(movement.x):
			movement.x = 0
		else:
			movement.x = xMultiplier * abs(movement.y)
	return movement.normalized()
