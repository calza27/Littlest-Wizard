extends Marker2D

@onready var sprite: Sprite2D = %Sprite

func _process(_delta: float) -> void:
	var mousePos = get_global_mouse_position()
	self.look_at(mousePos)
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.sprite.flip_v = true
	else:
		self.sprite.flip_v = false
