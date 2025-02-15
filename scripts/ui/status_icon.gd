class_name StatusIcon
extends Control

@export var _numeral: int = 0
@onready var sprite: TextureRect = %TextureRect
@onready var label: Label = %label
@onready var cooldown_filter: TextureProgressBar = %CooldownFilter
@onready var numeric: Label = %Numeric

func _ready() -> void:
	self.cooldown_filter.visible = false
	set_numeral(self._numeral)

func _process(delta: float) -> void:
	if self.cooldown_filter.value > 0:
		self.cooldown_filter.value -= (delta * 1000)
	if self.cooldown_filter.value <= 0:
		self.cooldown_filter.visible = false

func set_numeral(num: int) -> void:
	self._numeral = num
	self.numeric.text = str(self._numeral)
	self.numeric.visible = true if self._numeral > 0 else false
	
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
	
