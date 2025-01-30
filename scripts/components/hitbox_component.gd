class_name HitboxComponent
extends Area2D

signal attacked(attack: Attack, dodged: bool)
signal attack_dodged(attack: Attack)
signal hit_by_attack(attack: Attack)
@export var status_component: StatusComponent
var dodge_chance: float
var rng = RandomNumberGenerator.new()

func init(dodgeChance:float = 0.0) -> void:
	self.dodge_chance = dodgeChance
	if self.dodge_chance > 1.0:
		self.dodge_chance = 1.0
	if self.dodge_chance < 0.0:
		self.dodge_chance = 0.0
		
func apply_attack(attack: Attack) -> void:
	var dodged: bool = dodge()
	self.attacked.emit(attack.duplicate(), dodged)
	if dodged:
		self.attack_dodged.emit(attack.duplicate())
	else:
		self.hit_by_attack.emit(attack.duplicate())
		
func dodge() -> bool:
	var d = rng.randf_range(0, 1)
	var dodgeChance = self.dodge_chance
	if self.status_component:
		dodgeChance = self.status_component.apply_dodge_status_effects(dodgeChance)
	if d <= dodgeChance:
		return true
	return false
