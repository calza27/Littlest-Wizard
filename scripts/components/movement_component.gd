class_name MovementComponent
extends Node2D

signal traversed_max_distance

@export var status_component: StatusComponent
@export var speed: float
@export var travelled: float
@export var max_distance: float
@export var weight: float
var pending_knockback: Attack

func _ready() -> void:
	if self.speed < 0:
		self.speed = 0
	
	if self.travelled < 0:
		self.travelled = 0
	
	if self.max_distance < 0:
		self.max_distance = 0
	
	if self.weight <= 0:
		self.weight = 1

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
