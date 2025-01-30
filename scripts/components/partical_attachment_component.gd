class_name ParticleAttachmentComponent
extends Area2D

enum ShapeType { UNKNOWN, RECT, CIRCLE }

@export var collision_shape: CollisionShape2D
var rng = RandomNumberGenerator.new()

func get_random_position() -> Vector2:
	match _get_shape_type():
		ShapeType.UNKNOWN: #assume rectangle
			var size: Vector2 = self.collision_shape.shape.get_rect().size
			return Vector2(self.rng.randf_range(-1*size.x/2, size.x/2), self.rng.randf_range(-1*size.y/2, size.y/2))
		ShapeType.RECT:
			var rect: RectangleShape2D = self.collision_shape.shape as RectangleShape2D
			var size: Vector2 = rect.size
			return Vector2(self.rng.randf_range(-1*size.x/2, size.x/2), self.rng.randf_range(-1*size.y/2, size.y/2))
		ShapeType.CIRCLE:
			var circ: CircleShape2D = self.collision_shape.shape as CircleShape2D
			var radius: float = circ.get_radius()
			var randomAngle: float = self.rng.randf_range(0, 1) * 2 * PI
			var randomDistance: float = pow(self.rng.randf_range(0, 1), 0.5) * radius
			var x = randomDistance * cos(randomAngle)
			var y = randomDistance * sin(randomAngle)
			return Vector2(x, y)
		_:
			#assume rectangle for unknown, capsule, and everything in between
			var size: Vector2 = self.collision_shape.shape.get_rect().size
			return Vector2(self.rng.randf_range(-1*size.x/2, size.x/2), self.rng.randf_range(-1*size.y/2, size.y/2))
			

func _get_shape_type() -> ShapeType:
	if self.collision_shape:
		if self.collision_shape.shape is CircleShape2D:
			return ShapeType.CIRCLE
		if self.collision_shape.shape is RectangleShape2D:
			return ShapeType.RECT
	return ShapeType.UNKNOWN
	
