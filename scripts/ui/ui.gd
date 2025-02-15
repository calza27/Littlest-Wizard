extends Control

var _status_indicators: Dictionary = {} #map[status.type]StatusIcon
@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar
@onready var enemy_health_label: Label = %EnemyLabel
@onready var money_label: Label = %MoneyLabel
@onready var binding_spell_1: StatusIcon = %binding_spell_1
@onready var binding_spell_2: StatusIcon = %binding_spell_2
@onready var binding_spell_3: StatusIcon = %binding_spell_3
@onready var binding_spell_4: StatusIcon = %binding_spell_4
@onready var status_effect_container: Container = %StatusEffectContainer
func _ready() -> void:
	EventBus.player_money_change.connect(update_money_counter)
	EventBus.focus_enemy.connect(focus_enemy)
	EventBus.bound_spell_changed.connect(on_bound_spell_change)
	EventBus.player_spell_cooldown_start.connect(on_spell_cooldown_enter)
	EventBus.player_spell_cooldown_end.connect(on_spell_cooldown_exit)
	EventBus.player_status_applied.connect(on_player_status_applied)
	EventBus.player_status_removed.connect(on_player_status_removed)
	
	self._hide_enemy_info()
	self.on_bound_spell_change("spell_1", GameState.player_spell_book.get_active_spell("spell_1"))
	self.on_bound_spell_change("spell_2", GameState.player_spell_book.get_active_spell("spell_2"))
	self.on_bound_spell_change("spell_3", GameState.player_spell_book.get_active_spell("spell_3"))
	self.on_bound_spell_change("spell_4", GameState.player_spell_book.get_active_spell("spell_4"))

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

func on_bound_spell_change(binding: String, spell: Spell) -> void:
	var sb: StatusIcon
	var num: int = 0
	match binding:
		"spell_1":
			sb = binding_spell_1
			num = 1
		"spell_2":
			sb = binding_spell_2
			num = 2
		"spell_3":
			sb = binding_spell_3
			num = 3
		"spell_4":
			sb = binding_spell_4
			num = 4
	sb.visible = true
	sb.set_numeral(num)
	if spell: 
		sb.set_sprite_texture(spell.sprite)
		sb.set_label(spell.get_spell_name())
	#else:
		#sb.set_sprite_texture(null)
		#sb.set_label("")
		#sb.visible = false
	
func on_spell_cooldown_enter(spell: Spell, cooldown: float) -> void:
	var binding: StatusIcon = self._binding_component_for_spell(spell)
	if binding:
		binding.apply_cooldown(cooldown)
	
func on_spell_cooldown_exit(spell: Spell) -> void:
	var binding: StatusIcon = self._binding_component_for_spell(spell)
	if binding:
		binding.end_cooldown()
		
func on_player_status_applied(status: StatusEffect) -> void:
	self.on_player_status_removed(status)
	const COMP: Resource = preload(Files.UI_COMPONENTS["status_icon"])
	var status_icon: StatusIcon = COMP.instantiate()
	self.status_effect_container.add_child(status_icon)
	
	var image = Image.load_from_file(Files.STATUS_ICONS[status.effect])
	status_icon.set_sprite_texture(ImageTexture.create_from_image(image))
	status_icon.set_label(Constants.StatusEffectType.find_key(status.effect))
	if status.duration > 0:
		status_icon.apply_cooldown(status.duration)
	self._status_indicators[status.effect] = status_icon
	
func on_player_status_removed(status: StatusEffect) -> void:
	if self._status_indicators.has(status.effect):
		(self._status_indicators.get(status.effect) as StatusIcon).queue_free()
		self._status_indicators.erase(status.effect)
	
func _show_enemy_info() -> void:
	enemy_health_bar.visible = true
	enemy_health_label.visible = true
	
func _hide_enemy_info() -> void:
	enemy_health_bar.visible = false
	enemy_health_label.visible = false
	
func _binding_component_for_binding(binding: String) -> StatusIcon:
	match binding:
		"spell_1":
			return binding_spell_1
		"spell_2":
			return binding_spell_2
		"spell_3":
			return binding_spell_3
		"spell_4":
			return binding_spell_4
	return null
	
func _binding_component_for_spell(spell: Spell) -> StatusIcon:
	var binding: String = GameState.player_spell_book.get_binding_for_spell(spell)
	match binding:
		"spell_1":
			return binding_spell_1
		"spell_2":
			return binding_spell_2
		"spell_3":
			return binding_spell_3
		"spell_4":
			return binding_spell_4
	return null
