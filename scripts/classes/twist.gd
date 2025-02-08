class_name Twist
extends Node

var twist_name: String
var twist_type: Constants.TwistType
var damage_modifier: float
var damage_multiplier: float
var damage_type_override: Constants.DamageType
var damage_over_time: DamageOverTime
var knockback_modifier: float
var knockback_multiplier: float
var status_effect: StatusEffect

func _init(damageModifier: float = 0, damageMultiplier: float = 1, knockbackModifier: float = 0, knockbackMultiplier: float = 1):
	self.damage_modifier = damageModifier
	self.damage_multiplier = damageMultiplier
	self.knockback_modifier = knockbackModifier
	self.knockback_multiplier = knockbackMultiplier

static func get_twist_name() -> String:
	push_error("get_twist_name func not implemented")
	return ""
