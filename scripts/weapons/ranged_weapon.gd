class_name RangedWeapon
extends Area2D

@export var texture: Texture
@export var projectile_point_pos: Vector2
@export var projectile_attributes: ProjectileAttributes
var _projectile_attack_profile: Attack
@onready var pivot_point: Marker2D = %PivotPoint
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite
@onready var projectile_point: Marker2D = %ProjectilePoint
@onready var player: CharacterBody2D = get_node("/root/Game/Player")

func _ready() -> void:
	if self.texture:
		self.sprite.texture = self.texture
	if self.projectile_point_pos:
		self.projectile_point.position = self.projectile_point_pos

func _process(_delta: float) -> void:
	var playerPos = player.position
	self.look_at(playerPos)
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.sprite.flip_v = true
	else:
		self.sprite.flip_v = false
		
func set_projectile_attributes(attributes: ProjectileAttributes) -> void:
	self.projectile_attributes = attributes

func set_texture(texture: Texture) -> void:
	self.texture = texture
	self.sprite.texture = self.texture
	
func fire_weapon() -> void:
	const PROJECTILE = preload(Files.PROJECTILES.projectile)
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.set_attributes(self.projectile_attributes)
	new_projectile.global_position = self.projectile_point.global_position
	new_projectile.global_rotation = self.projectile_point.global_rotation
	get_node("/root").add_child(new_projectile)
