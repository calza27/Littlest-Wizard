class_name AttackComponent
extends Area2D

@export var status_component: StatusComponent
@export var melee_weapon_component: MeleeWeapon
@export var ranged_weapon_component: RangedWeapon
@export var cooldown: float
var hitbox_in_range: HitboxComponent
var ready_to_attack: bool

func _ready() -> void:
	if self.cooldown < 0:
		self.cooldown = 0
	self.ready_to_attack = true
	
func attack_melee() -> void:
	if self.ready_to_attack && self.hitbox_in_range:
		self.melee_weapon_component.swing_weapon()
		ready_to_attack = false
		var cd = status_component.apply_cooldown_status_effects(cooldown)
		start_timer(cd)
		
func attack_ranged() -> void:
	if self.ready_to_attack && self.hitbox_in_range:
		self.ranged_weapon_component.fire_weapon()
		self.ready_to_attack = false
		var cd = status_component.apply_cooldown_status_effects(cooldown)
		start_timer(cd)
	
func start_timer(time: float) -> void:
	var timer = get_tree().create_timer(time)
	timer.timeout.connect(timeout_function)
	
func timeout_function() -> void:
	self.ready_to_attack = true

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		self.hitbox_in_range = area as HitboxComponent

func _on_area_exited(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox = area as HitboxComponent
		if hitbox == self.hitbox_in_range:
			self.hitbox_in_range = null
