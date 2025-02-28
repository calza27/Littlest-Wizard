class_name MeleeWeapon
extends Node2D

signal player_in_melee
signal player_out_melee

@export var weapon_Attributes: MeleeAttributes
@export var status_component: StatusComponent
var _player: CharacterBody2D
var _attack_profile: Attack
@onready var pivot_point: Marker2D = %PivotPoint
@onready var swing_point: Marker2D = %SwingPoint
@onready var hitbox_collision_shape: CollisionShape2D = %HitboxShape
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite
@onready var melee_range: Area2D = %MeleeRange

func _ready() -> void:
	self._player = Utils.get_player()
	self.visible = false
	self.hitbox_collision_shape.disabled = true
	if self.weapon_Attributes:
		self._attack_profile = self.weapon_Attributes.attack

func _physics_process(_delta: float) -> void:
	self.look_at(_player.position)
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.sprite.flip_v = true
	else:
		self.sprite.flip_v = false

func set_weapon_Attributes(attr: MeleeAttributes) -> void:
	self.weapon_Attributes = attr
		
func swing_weapon() -> void:
	if self.weapon_Attributes.mode == Constants.MeleeMode.THRUST:
		self.animation__player.play("thrust")
		return
		
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.animation_player.play("swing_right")
	else:
		self.animation_player.play("swing_left")
		
func _on_hitbox_area_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area as HitboxComponent
		var attack: Attack = self._attack_profile
		if self.status_component:
			attack = self.status_component.apply_attack_status_effects(attack)
		hitbox.apply_attack(attack)
		
func _on_melee_range_area_entered(area: Area2D) -> void:
	player_in_melee.emit()

func _on_melee_range_area_exited(area: Area2D) -> void:
	player_out_melee.emit()
