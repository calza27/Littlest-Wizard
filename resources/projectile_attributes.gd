class_name ProjectileAttributes
extends Resource

@export var texture: Texture
@export var transform: Transform2D
@export var hitbox_shape: Shape2D
@export var hitbox_pos: Vector2
@export var damage: float
@export var damage_type: Constants.DamageType
@export var speed: float
@export var max_distance: float
@export var free_on_hit: bool = true
