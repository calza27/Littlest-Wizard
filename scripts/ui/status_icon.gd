class_name StatusIcon
extends Control

@onready var sprite: Sprite2D = %sprite
@onready var label: Label = %label
@onready var cooldown_filter: TextureProgressBar = %CooldownFilter

func _ready() -> void:
	self.cooldown_filter.visible = false

func _process(delta: float) -> void:
	if self.cooldown_filter.value > 0:
		self.cooldown_filter.value -= (delta * 1000)
	if self.cooldown_filter.value <= 0:
		self.cooldown_filter.visible = false
	
func show_hide(show: bool) -> void:
	self.sprite.visible = show
	self.label.visible = show
	self.cooldown_filter.visible = false

func set_sprite_texture(texture: Texture) -> void:
	self.sprite.texture = texture
	
func set_label(text: String) -> void:
	self.label.text = text
	
func apply_cooldown(time: float) -> void:
	self.cooldown_filter.visible = true
	self.cooldown_filter.max_value = (time * 1000)
	self.cooldown_filter.value = (time * 1000)
	
func end_cooldown() -> void:
	self.cooldown_filter.visible = false
	self.cooldown_filter.max_value = 0
	self.cooldown_filter.value = 0
	
