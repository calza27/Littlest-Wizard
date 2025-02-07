extends Node

func get_player() -> PlayerCharacter:
	return get_tree().get_first_node_in_group(group_name_for_group(Constants.Group.PLAYER))
	
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

func group_name_for_group(group: Constants.Group) -> String:
	match group:
		Constants.Group.PLAYER:
			return "player"
		Constants.Group.CAMERA:
			return "camera"
		Constants.Group.PROJECTILE:
			return "projectile"
	return ""
	
func vector_to_direction(vec: Vector2) -> Constants.Direction:
	var norm: Vector2 = normalise_movement(vec)
	if norm.x == norm.y:
		if norm.x > 0:
			return Constants.Direction.SE
		else:
			return Constants.Direction.NW
	elif norm.x == (norm.y * -1):
		if norm.x > 0:
			return Constants.Direction.NE
		else:
			return Constants.Direction.SW
	elif norm.x == 1:
		return Constants.Direction.E
	elif norm.x == -1:
		return Constants.Direction.W
	elif norm.y == 1:
		return Constants.Direction.S
	elif norm.y == -1:
		return Constants.Direction.N
	return Constants.Direction.E

func direction_to_facing(direction: Constants.Direction) -> Constants.Facing:
	match direction:
		Constants.Direction.NE, Constants.Direction.E, Constants.Direction.SE:
			return Constants.Facing.RIGHT
		Constants.Direction.NW, Constants.Direction.W, Constants.Direction.SW:
			return Constants.Facing.LEFT
		Constants.Direction.N:
			return Constants.Facing.UP
		Constants.Direction.S:
			return Constants.Facing.DOWN
	return Constants.Facing.RIGHT
	
func direction_to_radians(direction: Constants.Direction) -> float:
	return direction * PI / 4
	
func directional_rotation(start: Constants.Direction, finish: Constants.Direction) -> float:
	var start_rads: float = direction_to_radians(start)
	var fin_rads: float = direction_to_radians(finish)
	var diff: float = fin_rads - start_rads
	if diff > PI:
		return start_rads - (fin_rads - PI)
	return diff
