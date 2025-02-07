class_name StatusComponent
extends Node2D

signal status_applied(status: Status)
signal status_removed(status: Status)

var active_status: Dictionary = {}

func apply_status_condition(status: Status) -> void:
	var existing = self.active_status.get(status.effect, null) as Status
	if existing:
		existing.timer.queue_free()
	self.active_status[status.effect] = status
	status_applied.emit(status)
	if status.duration > 0:
		add_child(status.timer)
		status.timer.timeout.connect(status_condition_timeout.bind(status))
		status.timer.start(status.duration)
	
func status_condition_timeout(status: Status) -> void:
	self.active_status.erase(status.effect)
	status_removed.emit(status)
	status.timer.queue_free()

func has_status_effect(statusEffect: Constants.StatusEffect) -> bool:
	return self.active_status.has(statusEffect)
	
func get_status_effect(statusEffect: Constants.StatusEffect) -> Status:
	return self.active_status.get(statusEffect, null) as Status

func apply_movement_status_effects(speed: float) -> float:
	if has_status_effect(Constants.StatusEffect.RESTRAINED):
		return 0
	if has_status_effect(Constants.StatusEffect.SLOW):
		var statusEffect = get_status_effect(Constants.StatusEffect.SLOW)
		speed -= statusEffect.modifier
		speed *= statusEffect.multiplier
	if has_status_effect(Constants.StatusEffect.HASTE):
		var statusEffect = get_status_effect(Constants.StatusEffect.SLOW)
		speed += statusEffect.modifier
		speed *= statusEffect.multiplier
	return speed
	
func apply_attack_status_effects(attack: Attack) -> Attack:
	var damage = attack.damage
	if has_status_effect(Constants.StatusEffect.BUFF):
		var status = get_status_effect(Constants.StatusEffect.BUFF)
		damage += status.modifier
		damage *= status.multiplier
	if has_status_effect(Constants.StatusEffect.ENFEEBLE):
		var status = get_status_effect(Constants.StatusEffect.ENFEEBLE)
		damage -= status.modifier
		damage *= status.multiplier
	attack.damage = damage
	return attack

func apply_cooldown_status_effects(cooldown: float) -> float:
	if has_status_effect(Constants.StatusEffect.VIGOR):
		var status = get_status_effect(Constants.StatusEffect.VIGOR)
		cooldown -= status.modifier
		cooldown *= status.multiplier
	if has_status_effect(Constants.StatusEffect.LETHARGY):
		var status = get_status_effect(Constants.StatusEffect.LETHARGY)
		cooldown += status.modifier
		cooldown *= status.multiplier
	return cooldown
	
func apply_dodge_status_effects(dodgeChance: float) -> float:
	if has_status_effect(Constants.StatusEffect.NIMBLE):
		var status = get_status_effect(Constants.StatusEffect.NIMBLE)
		dodgeChance += status.modifier
		dodgeChance *= status.multiplier
	if has_status_effect(Constants.StatusEffect.CUMBERSOME):
		var status = get_status_effect(Constants.StatusEffect.CUMBERSOME)
		dodgeChance -= status.modifier
		dodgeChance *= status.multiplier
	return dodgeChance
