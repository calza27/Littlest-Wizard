class_name PlayerAnimator
extends Node2D

signal animation_finished

var curr_facing: Constants.Facing = Constants.Facing.RIGHT
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	if self.player_sprite:
		self.player_sprite.animation_finished.connect(_on_animation_finished)
		
func play_idle_animation(calm: bool) -> void:
	var speed: float = 1
	if !calm:
		speed = 4
	self.player_sprite.play("idle-" + _player_facing_as_string(), speed)
	self.animation_player.play("RESET")
	
func play_walk_animation(speed: float = 1) -> void:
	self.player_sprite.play("walk-" + _player_facing_as_string(), speed)
	self.animation_player.play("walk_bounce", -1, speed)
	
func play_stun_animation() -> void:
	self.player_sprite.play("stun-" + _player_facing_as_string())
	self.animation_player.play("RESET")
	
func play_dodge_animation() -> void:
	self.player_sprite.play("dodge-" + _player_facing_as_string())
	self.animation_player.play("RESET")
	
func play_charge_spell_animation() -> void:
	self.player_sprite.play("idle-" + _player_facing_as_string(), 5)
	self.animation_player.play("RESET")
	
func play_cast_spell_animation() -> void:
	self.player_sprite.play("cast", 10)
	self.animation_player.play("walk_bounce", -1, 10)

func stop_animation() -> void:
	self.player_sprite.stop()
	self.animation_player.play("RESET")
	
func _player_facing_as_string() -> String:
	return Constants.Facing.keys()[self.curr_facing]
	
func _on_animation_finished() -> void:
	self.animation_finished.emit()
