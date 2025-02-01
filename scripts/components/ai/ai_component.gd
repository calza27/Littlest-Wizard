class_name AIComponent
extends Node2D

@export var movement_component: MovementComponent
@export var vision_component: VisionComponent
@export var hitbox_component: HitboxComponent
@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var status_component: StatusComponent
@export var mob_graphics_component: MobGraphicsComponent
var curr_mode: Constants.AiMode = Constants.AiMode.STATIONARY
@onready var player: CharacterBody2D = get_node("/root/Game/Player")

func _normalise_movement(movement: Vector2) -> Vector2:
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
