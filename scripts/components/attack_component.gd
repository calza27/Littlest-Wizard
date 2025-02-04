class_name AttackComponent
extends Node2D

@export var status_component: StatusComponent
@export var melee_weapon_component: MeleeWeapon
@export var ranged_weapon_component: RangedWeapon
@export var cooldown: float
var ready_to_attack: bool

func _ready() -> void:
	if self.cooldown < 0:
		self.cooldown = 0
	self.ready_to_attack = true
	
func attack_melee() -> void:
	if self.ready_to_attack:
		self.melee_weapon_component.swing_weapon()
		ready_to_attack = false
		var cd = status_component.apply_cooldown_status_effects(cooldown)
		start_timer(cd)
		
func attack_ranged() -> void:
	if self.ready_to_attack:
		self.ranged_weapon_component.fire_weapon()
		self.ready_to_attack = false
		var cd = status_component.apply_cooldown_status_effects(cooldown)
		start_timer(cd)
	
func start_timer(time: float) -> void:
	var timer = get_tree().create_timer(time)
	timer.timeout.connect(timeout_function)
	
func timeout_function() -> void:
	self.ready_to_attack = true
