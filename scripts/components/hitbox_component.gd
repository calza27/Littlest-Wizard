class_name HitboxComponent
extends Area2D

signal attacked(attack: Attack, dodged: bool)
signal attack_dodged(attack: Attack)
signal hit_by_attack(attack: Attack)

var rng = RandomNumberGenerator.new()
var _dodge_chance: float

func set_dodge_chance(new_val: float) -> void:
	self._dodge_chance = new_val
	if self._dodge_chance > 1.0:
		self._dodge_chance = 1.0
	if self._dodge_chance < 0.0:
		self._dodge_chance = 0.0
	
func apply_attack(attack: Attack) -> void:
	var dodged: bool = dodge()
	self.attacked.emit(attack, dodged)
	if dodged:
		self.attack_dodged.emit(attack)
	else:
		self.hit_by_attack.emit(attack)
		
func dodge() -> bool:
	var d = rng.randf_range(0, 1)
	if d <= self._dodge_chance:
		return true
	return false
