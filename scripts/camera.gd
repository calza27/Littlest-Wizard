extends Camera2D

var camera_tween: Tween
#Todo, change these values to 1/8 of the window dimensions (Vector2(240, 135)) try: 320, 180 for the 0.75 scaling
@export var max_distance: Vector2 = Vector2(320, 180)
@export var lag: float = 0.75

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if camera_tween:
		camera_tween.kill()
		
	camera_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	camera_tween.tween_property(self, "global_position", _get_position_for_camera(), self.lag)

func _get_position_for_camera() -> Vector2:
	var player: PlayerCharacter = get_tree().get_first_node_in_group(Utils.group_name_for_group(Constants.Group.PLAYER)) as PlayerCharacter
	var player_position: Vector2 = player.global_position
	var mouse_position: Vector2 = get_global_mouse_position()
	var max_bounds: Rect2 = Rect2(player_position.x - max_distance.x, player_position.y - max_distance.y, max_distance.x*2, max_distance.y*2)
	if !max_bounds.has_point(mouse_position):
		return player_position.direction_to(mouse_position) * max_distance.length() + player_position
	return mouse_position
