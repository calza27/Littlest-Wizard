class_name MagicBolt
extends Area2D

@export var movement_component: MovementComponent
var _attack: Attack
var twists_appplied: Array[Constants.TwistType] = []

func set_attack(attack: Attack) -> void:
	self._attack = attack.duplicate()

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	self.movement_component.move(direction, delta)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		self.queue_free()
		var hitbox = area as HitboxComponent
		self._attack.attack_rotation = Vector2.RIGHT.rotated(self.global_rotation)
		hitbox.apply_attack(self._attack)

func _on_movement_component_traversed_max_distance() -> void:
	self.queue_free()
