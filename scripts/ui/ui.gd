extends Control

@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar
@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar
@onready var enemy_health_label: Label = %EnemyLabel
@onready var money_label: Label = %MoneyLabel

func _ready() -> void:
	EventBus.player_health_change.connect(update_health_bar)
	EventBus.player_mana_change.connect(update_mana_bar)
	EventBus.player_money_change.connect(update_money_counter)
	EventBus.focus_enemy.connect(focus_enemy)
	_hide_enemy_info()

func update_health_bar(max_value:float, curr_value:float) -> void:
	health_bar.max_value = max_value
	health_bar.value = curr_value

func update_mana_bar(max_value:float, curr_value:float) -> void:
	mana_bar.max_value = max_value
	mana_bar.value = curr_value

func update_money_counter(_old_value: int, value: int) -> void:
	money_label.text = str(value)
	
func focus_enemy(label: String, max_health: float, curr_health: float) -> void:
	if curr_health <= 0:
		_hide_enemy_info()
		return
	enemy_health_bar.max_value = max_health
	enemy_health_bar.value = curr_health
	enemy_health_label.text = label
	_show_enemy_info()

func _show_enemy_info() -> void:
	enemy_health_bar.visible = true
	enemy_health_label.visible = true
	
func _hide_enemy_info() -> void:
	enemy_health_bar.visible = false
	enemy_health_label.visible = false
