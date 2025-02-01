extends Node2D
class_name MeleeWeapon

@export var texture: Texture2D
@export var mode: Constants.MeleeMode = Constants.MeleeMode.SWING
var _attack_profile: Attack
@onready var pivot_point: Marker2D = %PivotPoint
@onready var swing_point: Marker2D = %SwingPoint
@onready var hitbox_shape: CollisionShape2D = %HitboxShape
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite
@onready var player: CharacterBody2D = get_node("/root/Game/Player")

func _ready() -> void:
	self.visible = false
	self.hitbox_shape.disabled = true
	if self.texture:
		self.sprite.texture = self.texture

func _physics_process(delta: float) -> void:
	self.look_at(player.position)
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.sprite.flip_v = true
	else:
		self.sprite.flip_v = false

func set_attack(attack: Attack) -> void:
	self._attack_profile = attack
		
func swing_weapon() -> void:
	if mode == Constants.MeleeMode.THRUST:
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
