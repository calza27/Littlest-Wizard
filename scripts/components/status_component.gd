class_name StatusComponent
extends Node2D

signal status_applied(status: StatusEffect)
signal status_removed(status: StatusEffect)

var active_status: Dictionary = {} #map[StatusEffect]Status

func apply_status_condition(status: StatusEffect) -> void:
	var existing = self.active_status.get(status.effect, null) as StatusEffect
	if existing:
		if existing.time_remaining > status.duration:
			return
		self.status_removed.emit(existing)
		self.active_status.erase(existing.effect)
	
	if status.duration > 0:
		status.time_remaining = status.duration
	self.active_status[status.effect] = status
	self.status_applied.emit(status)
	
func _physics_process(delta: float) -> void:
	for key in self.active_status:
		var status: StatusEffect = self.active_status.get(key, null) as StatusEffect
		if status && status.duration > 0:
			status.time_remaining -= delta
			if status.time_remaining <= 0:
				self.active_status.erase(key)
				self.status_removed.emit(status)

func has_status_effect(statusEffect: Constants.StatusEffectType) -> bool:
	return self.active_status.has(statusEffect)
	
func get_status_effect(statusEffect: Constants.StatusEffectType) -> StatusEffect:
	return self.active_status.get(statusEffect, null) as StatusEffect

func apply_movement_status_effects(speed: float) -> float:
	if has_status_effect(Constants.StatusEffectType.RESTRAINED):
		return 0
	if has_status_effect(Constants.StatusEffectType.SLOW):
		var statusEffect = get_status_effect(Constants.StatusEffectType.SLOW)
		speed -= statusEffect.modifier
		speed *= statusEffect.multiplier
	if has_status_effect(Constants.StatusEffectType.HASTE):
		var statusEffect = get_status_effect(Constants.StatusEffectType.SLOW)
		speed += statusEffect.modifier
		speed *= statusEffect.multiplier
	return speed
	
func apply_attack_status_effects(attack: Attack) -> Attack:
	var damage = attack.damage
	if has_status_effect(Constants.StatusEffectType.BUFF):
		var status = get_status_effect(Constants.StatusEffectType.BUFF)
		damage += status.modifier
		damage *= status.multiplier
	if has_status_effect(Constants.StatusEffectType.ENFEEBLE):
		var status = get_status_effect(Constants.StatusEffectType.ENFEEBLE)
		damage -= status.modifier
		damage *= status.multiplier
	attack.damage = damage
	return attack

func apply_cooldown_status_effects(cooldown: float) -> float:
	if has_status_effect(Constants.StatusEffectType.VIGOR):
		var status = get_status_effect(Constants.StatusEffectType.VIGOR)
		cooldown -= status.modifier
		cooldown *= status.multiplier
	if has_status_effect(Constants.StatusEffectType.LETHARGY):
		var status = get_status_effect(Constants.StatusEffectType.LETHARGY)
		cooldown += status.modifier
		cooldown *= status.multiplier
	return cooldown
	
func apply_dodge_status_effects(dodgeChance: float) -> float:
	if has_status_effect(Constants.StatusEffectType.NIMBLE):
		var status = get_status_effect(Constants.StatusEffectType.NIMBLE)
		dodgeChance += status.modifier
		dodgeChance *= status.multiplier
	if has_status_effect(Constants.StatusEffectType.CUMBERSOME):
		var status = get_status_effect(Constants.StatusEffectType.CUMBERSOME)
		dodgeChance -= status.modifier
		dodgeChance *= status.multiplier
	return dodgeChance
