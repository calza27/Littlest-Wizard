class_name MobGraphicsComponent
extends GraphicsComponent

signal animation_finished

@export var sprite_2D: AnimatedSprite2D
@export var animation_player: AnimationPlayer
var _curr_facing: Constants.Facing = Constants.Facing.RIGHT

func _ready() -> void:
	if self.sprite_2D:
		self.sprite_2D.animation_finished.connect(_on_animation_finished)
					
func set_facing_for_direction(dir: Constants.Direction) -> void:
	self._curr_facing = Utils.direction_to_facing(dir)
		
func play_idle_animation() -> void:
	if self.sprite_2D:
		if self._has_animation("idle-" + _facing_as_string()):
			self.sprite_2D.play("idle-" + _facing_as_string())
		elif self._has_animation("idle"):
			self.sprite_2D.play("idle")
	if self.animation_player:
		self.animation_player.play("RESET")
	
func play_walk_animation() -> void:
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
	if self.sprite_2D:
		if self._has_animation("dodge-" + _facing_as_string()):
			self.sprite_2D.play("dodge-" + _facing_as_string())
		elif self._has_animation("dodge"):
			self.sprite_2D.play("dodge")
		else:
			self.animation_finished.emit()
	if self.animation_player:
		self.animation_player.play("RESET")
		
func _has_animation(animationName: String) -> bool:
	if !self.sprite_2D:
		return false
	if !self.sprite_2D.sprite_frames:
		return false
	return self.sprite_2D.sprite_frames.get_animation_names().has(animationName)
	
func _facing_as_string() -> String:
	return Constants.Facing.keys()[self._curr_facing]
	
func _on_animation_finished() -> void:
	self.animation_finished.emit()
