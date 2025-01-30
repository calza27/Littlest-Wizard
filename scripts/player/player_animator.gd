class_name PlayerAnimator
extends Node2D

var curr_facing: Constants.Facing = Constants.Facing.RIGHT
var prevent_default: bool = false
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func play_idle_animation() -> void:
	if self.prevent_default: return
	self.player_sprite.play("idle-" + player_facing_as_string())
	self.animation_player.play("RESET")
	
func play_walk_animation() -> void:
	if self.prevent_default: return
	self.player_sprite.play("walk-" + player_facing_as_string())
	self.animation_player.play("walk_bounce")
	
func play_stun_animation() -> void:
	self.player_sprite.play("stun-" + player_facing_as_string())
	self.animation_player.play("RESET")
	
func play_dodge_animation() -> void:
	self.prevent_default = true
	self.player_sprite.play("dodge-" + player_facing_as_string())
	self.animation_player.play("RESET")

func player_facing_as_string() -> String:
	return Constants.Facing.keys()[self.curr_facing]

func _on_player_sprite_animation_finished() -> void:
	self.prevent_default = false
	
