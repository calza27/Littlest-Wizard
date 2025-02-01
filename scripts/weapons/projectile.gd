class_name Projectile
extends Area2D

@export var attributes: ProjectileAttributes
var _attack: Attack
@onready var movement_component: MovementComponent = %MovementComponent
@onready var sprite: Sprite2D = %Sprite
@onready var hitbox_collision_shape: CollisionShape2D = %CollisionShape

func _ready() -> void:
	if self.attributes:
		self._attack = Attack.new(self.attributes.damage, self.attributes.damage_type)
		self.sprite.texture = self.attributes.texture
		self.hitbox_collision_shape.shape = self.attributes.hitbox_shape
		self.hitbox_collision_shape.position = self.attributes.hitbox_pos
		self.movement_component.speed = self.attributes.speed
		self.movement_component.max_distance = self.attributes.max_distance

func set_attributes(attr: ProjectileAttributes) -> void:
	self.attributes = attr
	if self.sprite:
		self.sprite.texture = self.attributes.texture
	if self.hitbox_collision_shape:
		self.hitbox_collision_shape.shape = self.attributes.hitbox_shape
		self.hitbox_collision_shape.position = self.attributes.hitbox_pos
	if self.movement_component:
		self.movement_component.speed = self.attributes.speed
		self.movement_component.max_distance = self.attributes.max_distance
	
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
