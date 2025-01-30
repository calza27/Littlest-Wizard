class_name AttackComponent
extends Area2D

@export var status_component: StatusComponent
var hitbox_in_range: HitboxComponent
var melee_attack: Attack
var cooldown: float
var ready_to_attack: bool

func init(meleeAttack: Attack, cooldownF: float) -> void:
	self.melee_attack = meleeAttack
	self.cooldown = cooldownF
	self.ready_to_attack = true
	
func attack_melee() -> bool:
	if ready_to_attack && hitbox_in_range:
		melee_attack.attack_rotation = position.direction_to(hitbox_in_range.position)
		var attack = status_component.apply_attack_status_effects(melee_attack)
		hitbox_in_range.apply_attack(attack)
		ready_to_attack = false
		var cd = status_component.apply_cooldown_status_effects(cooldown)
		start_timer(cd)
		return true
	return false
	
func start_timer(time: float) -> void:
	var timer = get_tree().create_timer(time)
	timer.timeout.connect(timeout_function)
	
func timeout_function() -> void:
	ready_to_attack = true

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		hitbox_in_range = area as HitboxComponent

func _on_area_exited(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox = area as HitboxComponent
		if hitbox == hitbox_in_range:
			hitbox_in_range = null
