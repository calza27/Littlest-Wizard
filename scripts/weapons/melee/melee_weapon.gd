class_name MeleeWeapon
extends Node2D

@export var weapon_Attributes: MeleeAttributes
var _attack_profile: Attack
@onready var pivot_point: Marker2D = %PivotPoint
@onready var swing_point: Marker2D = %SwingPoint
@onready var hitbox_collision_shape: CollisionShape2D = %HitboxShape
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite
@onready var player: CharacterBody2D = get_node("/root/Game/Player")

func _ready() -> void:
	self.visible = false
	self.hitbox_collision_shape.disabled = true
	if self.weapon_Attributes:
		self._attack_profile = Attack.new(self.weapon_Attributes.damage, self.weapon_Attributes.damage_type)
		self.sprite.texture = self.weapon_Attributes.texture
		self.hitbox_collision_shape.shape = self.weapon_Attributes.hitbox_shape
		self.hitbox_collision_shape.position = self.weapon_Attributes.hitbox_pos

func _physics_process(_delta: float) -> void:
	self.look_at(player.position)
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.sprite.flip_v = true
	else:
		self.sprite.flip_v = false

func set_weapon_Attributes(attr: MeleeAttributes) -> void:
	self.weapon_Attributes = attr
	self._attack_profile = Attack.new(self.weapon_Attributes.damage, self.weapon_Attributes.damage_type)
	if self.sprite:
		self.sprite.texture = self.weapon_Attributes.texture
	if self.hitbox_collision_shape:
		self.hitbox_collision_shape.shape = self.weapon_Attributes.hitbox_shape
		self.hitbox_collision_shape.position = self.weapon_Attributes.hitbox_pos
		
func swing_weapon() -> void:
	if self.weapon_Attributes.mode == Constants.MeleeMode.THRUST:
		self.animation_player.play("thrust")
		return
		
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.animation_player.play("swing_right")
	else:
		self.animation_player.play("swing_left")
		
func _on_hitbox_area_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area as HitboxComponent
		hitbox.apply_attack(self._attack_profile)
