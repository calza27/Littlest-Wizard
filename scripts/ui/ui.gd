extends Control

@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar
@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar
@onready var enemy_health_label: Label = %EnemyLabel

func _ready() -> void:
	EventBus.player_health_change.connect(update_health_bar)
	EventBus.player_mana_change.connect(update_mana_bar)
	EventBus.focus_enemy.connect(focus_enemy)
	_hide_enemy_info()

func update_health_bar(maxValue:float, currValue:float) -> void:
	health_bar.max_value = maxValue
	health_bar.value = currValue

func update_mana_bar(maxValue:float, currValue:float) -> void:
	mana_bar.max_value = maxValue
	mana_bar.value = currValue
	
func focus_enemy(label: String, maxHealth: float, currHealth: float) -> void:
	if currHealth <= 0:
		_hide_enemy_info()
		return
	enemy_health_bar.max_value = maxHealth
	enemy_health_bar.value = currHealth
	enemy_health_label.text = label
	_show_enemy_info()

func _show_enemy_info() -> void:
	enemy_health_bar.visible = true
	enemy_health_label.visible = true
	
func _hide_enemy_info() -> void:
	enemy_health_bar.visible = false
	enemy_health_label.visible = false
