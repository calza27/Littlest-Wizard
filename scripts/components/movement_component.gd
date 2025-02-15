class_name MovementComponent
extends Node2D

signal traversed_max_distance
signal direction_changed(new: Constants.Direction)

@export var speed: float
@export var travelled: float
@export var max_distance: float
@export var weight: float
var pending_knockback: Attack
var _curr_direction: Constants.Direction = Constants.Direction.E
var _speed: float = 0

func _ready() -> void:
	#if self.speed < 0:
		#self.speed = 0
	if self._speed < 0:
		self._speed = 0
	
	if self.travelled < 0:
		self.travelled = 0
	
	if self.max_distance < 0:
		self.max_distance = 0
	
	if self.weight <= 0:
		self.weight = 1

func set_direction(new_Direction: Constants.Direction) -> void:
	if new_Direction != self._curr_direction:
		self._curr_direction = new_Direction
		direction_changed.emit(new_Direction)

func set_speed(new_speed: float) -> void:
	self._speed = new_speed
	if self._speed < 0:
		self._speed = 0

func move(vec: Vector2, delta: float) -> void:
	if vec.length() > 0:
		var new_Direction: Constants.Direction = Utils.vector_to_direction(vec)
		set_direction(new_Direction)
	
	if self.get_parent() is CharacterBody2D:
		var characterBody = self.get_parent() as CharacterBody2D
		characterBody.velocity = vec * self._speed
		characterBody.move_and_slide()
	else:
		self.get_parent().position += vec * self._speed * delta
		
	self.travelled += (self._speed * delta)
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
