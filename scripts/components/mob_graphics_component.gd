class_name MobGraphicsComponent
extends GraphicsComponent

@export var sprite_2D: AnimatedSprite2D
@export var animation_player: AnimationPlayer
var curr_facing: Constants.Facing = Constants.Facing.RIGHT
var prevent_default: bool = false

func _ready() -> void:
	if self.sprite_2D:
		self.sprite_2D.animation_finished.connect(_on_animation_finished)
	
func set_facing(direction) -> void:
	if direction.x == 1:
		self.curr_facing = Constants.Facing.RIGHT
	elif direction.x == -1:
		self.curr_facing = Constants.Facing.LEFT
	if direction.y == 1:
		self.curr_facing = Constants.Facing.DOWN
	elif direction.y == -1:
		self.curr_facing = Constants.Facing.UP
		
func play_idle_animation() -> void:
	if self.prevent_default: return
	if self.sprite_2D:
		if self._has_animation("idle-" + _facing_as_string()):
			self.sprite_2D.play("idle-" + _facing_as_string())
		elif self._has_animation("idle"):
			self.sprite_2D.play("idle")
	if self.animation_player:
		self.animation_player.play("RESET")
	
func play_walk_animation() -> void:
	if self.prevent_default: return
	if self.sprite_2D:
		if self._has_animation("walk-" + _facing_as_string()):
			self.sprite_2D.play("walk-" + _facing_as_string())
		elif self._has_animation("walk"):
			self.sprite_2D.play("walk")
	if self.animation_player && self.animation_player.get_animation_list().has("walk_bounce"):
		self.animation_player.play("walk_bounce")
	
func play_stun_animation() -> void:
	if self.sprite_2D:
		if self._has_animation("stun-" + _facing_as_string()):
			self.sprite_2D.play("stun-" + _facing_as_string())
		elif self._has_animation("stun"):
			self.sprite_2D.play("stun")
	if self.animation_player:
		self.animation_player.play("RESET")
	
func play_dodge_animation() -> void:
	self.prevent_default = true
	if self.sprite_2D:
		if self._has_animation("dodge-" + _facing_as_string()):
			self.sprite_2D.play("dodge-" + _facing_as_string())
		elif self._has_animation("dodge"):
			self.sprite_2D.play("dodge")
	if self.animation_player:
		self.animation_player.play("RESET")
		
func _has_animation(animationName: String) -> bool:
	if !self.sprite_2D:
		return false
	if !self.sprite_2D.sprite_frames:
		return false
	return self.sprite_2D.sprite_frames.get_animation_names().has(animationName)
	
func _facing_as_string() -> String:
	return Constants.Facing.keys()[self.curr_facing]
	
func _on_animation_finished() -> void:
	self.prevent_default = false
