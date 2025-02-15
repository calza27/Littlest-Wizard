@tool
class_name StatBar
extends PanelContainer

@export var stat: Stat:
	set(new_val):
		stat = new_val
		_update_colours()
@onready var label: Label = %Label
@onready var bar: ProgressBar = %Bar

enum Stat { MANA, HEALTH }

func _ready() -> void:
	var player: PlayerCharacter = Utils.get_player()
	match self.stat:
		Stat.MANA:
			EventBus.player_mana_change.connect(_update)
			_update(player.mana_component.max_mana, player.mana_component.curr_mana)
		Stat.HEALTH:
			EventBus.player_health_change.connect(_update)
			_update(player.health_component.max_health, player.health_component.curr_health)
	_update_colours()

func _update(max_value: float, curr_value: float) -> void:
	bar.max_value = max_value
	bar.value = curr_value
	label.text = str(snapped(curr_value, 1), " / ", snapped(max_value, 1))
	pass
	
func _update_colours() -> void:
	var background_style_box: StyleBoxFlat = StyleBoxFlat.new()
	background_style_box.corner_detail = 8
	var fill_style_box: StyleBoxFlat = StyleBoxFlat.new()
	fill_style_box.corner_detail = 8
	match self.stat:
		Stat.MANA:
			background_style_box.bg_color = Color(1, 1, 0, 1)
			fill_style_box.bg_color = Color(0, 0, 1, 1)
		Stat.HEALTH:
			background_style_box.bg_color = Color(1, 0, 0, 1)
			fill_style_box.bg_color = Color(0, 1, 0, 1)
	if self.bar:
		self.bar.remove_theme_stylebox_override("background")
		self.bar.remove_theme_stylebox_override("fill")
		self.bar.add_theme_stylebox_override("background", background_style_box)
		self.bar.add_theme_stylebox_override("fill", fill_style_box)
