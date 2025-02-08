class_name Projectile
extends Area2D

@export var attributes: ProjectileAttributes
@export var inert: bool = true
var _attack: Attack
@onready var movement_component: MovementComponent = %MovementComponent
@onready var sprite: Sprite2D = %Sprite
@onready var hitbox_collision_shape: CollisionShape2D = %CollisionShape

func _ready() -> void:
	if self.inert:
		self.set_process_mode(Node.PROCESS_MODE_DISABLED)
		self.hide()
		return

	self.top_level = true
	if self.sprite:
		self.sprite.texture = self.attributes.texture
		if self.attributes.transform:
			self.sprite.transform = self.attributes.transform
	if self.hitbox_collision_shape:
		self.hitbox_collision_shape.shape = self.attributes.hitbox_shape
		self.hitbox_collision_shape.position = self.attributes.hitbox_pos
	if self.movement_component:
		self.movement_component.speed = self.attributes.speed
		self.movement_component.max_distance = self.attributes.max_distance

func set_inert(i: bool) -> void:
	self.inert = i
	if !self.inert:
		self.set_process_mode(Node.PROCESS_MODE_INHERIT)
		self.show()
	
func set_attributes(attr: ProjectileAttributes) -> void:
	self.attributes = attr

func get_attack() -> Attack:
	return self._attack
		
func set_attack(attack: Attack) -> void:
	self._attack = attack 
	
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	self.movement_component.move(direction, delta)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		if self.attributes.free_on_hit:
			self.queue_free()
		var hitbox = area as HitboxComponent
		self._attack.attack_rotation = Vector2.RIGHT.rotated(self.global_rotation)
		hitbox.apply_attack(self._attack)

func _on_movement_component_traversed_max_distance() -> void:
	self.queue_free()
