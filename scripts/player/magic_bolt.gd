class_name MagicBolt
extends Area2D

@export var movement_component: MovementComponent
var attack: Attack
var twists_appplied: Array[Constants.TwistType] = []

func initMagicBolt(speed: int, maxRange: int, attackProfile: Attack) -> void:
	self.movement_component.init(speed, maxRange)
	self.attack = attackProfile

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	self.movement_component.move(direction, delta)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		self.queue_free()
		var hitbox = area as HitboxComponent
		self.attack.attack_rotation = Vector2.RIGHT.rotated(self.global_rotation)
		hitbox.apply_attack(self.attack)

func _on_movement_component_traversed_max_distance() -> void:
	self.queue_free()
