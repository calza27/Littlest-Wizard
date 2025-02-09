class_name FireyBlast
extends Node2D

signal animation_finished

const MAX_RANGE = 1000
var _attack: Attack
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var collision_area: Area2D = %CollisionArea
	
func _ready() -> void:
	var cast_position: Vector2 = get_global_mouse_position()
	var player: PlayerCharacter = Utils.get_player()
	var distance: float = (cast_position - player.global_position).length()
	if distance > MAX_RANGE:
		var unit_vec: Vector2 = (cast_position - player.global_position).normalized()
		var new_vec = unit_vec * MAX_RANGE
		cast_position = new_vec + player.global_position
	self.global_position.x = cast_position.x
	self.global_position.y = cast_position.y
	self.sprite.animation_finished.connect(_on_animation_finished)
	self.collision_area.area_entered.connect(_on_area_entered)
	self.sprite.play("default")

func set_attack(attack: Attack) -> void:
	self._attack = attack
	
func _on_animation_finished() -> void:
	self.animation_finished.emit()
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		(area as HitboxComponent).apply_attack(self._attack)
