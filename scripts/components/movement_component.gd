class_name MovementComponent
extends Node2D

signal traversed_max_distance
#signal knockback

@export var status_component: StatusComponent
var speed: float
var travelled: float
var max_distance: float
var weight: float

var pending_knockback: Attack
	
func init(moveSpeed:float, maxRange:float = 0.0, weightF:float = 1.0) -> void:
	self.speed = moveSpeed
	self.max_distance = maxRange
	self.weight = weightF
	self.travelled = 0

func move(direction: Vector2, delta: float) -> void:
	var moveSpeed = self.speed
	if self.status_component:
		moveSpeed = self.status_component.apply_movement_status_effects(moveSpeed)
	var distance = moveSpeed * delta
	if self.get_parent() is CharacterBody2D:
		var characterBody = self.get_parent() as CharacterBody2D
		characterBody.velocity = direction * moveSpeed
		characterBody.move_and_slide()
	else:
		self.get_parent().position += direction * distance
	self.travelled += distance
	if self.max_distance > 0 && self.travelled >= self.max_distance:
		traversed_max_distance.emit()
	
func apply_knockback(attack: Attack) -> void:
	self.pending_knockback = attack
		
func _physics_process(delta: float) -> void:
	if self.pending_knockback:
		var direction = self.pending_knockback.attack_rotation
		var distance = self.pending_knockback.knockback_force * self.weight
		self.pending_knockback = null
		if self.get_parent() is CharacterBody2D:
			var characterBody = self.get_parent() as CharacterBody2D
			characterBody.velocity = direction * distance
			characterBody.move_and_slide()
		else:
			self.get_parent().position += direction * distance * delta
