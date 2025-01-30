class_name Twist

var twist_type: Constants.TwistType
var damage_modifier: float
var damage_multiplier: float
var damage_type_override: Constants.DamageType
var damage_over_time: DamageOverTime
var knockback_modifier: float
var knockback_multiplier: float
var status_effect: Status

func _init(damageModifier: float = 0, damageMultiplier: float = 1, knockbackModifier: float = 0, knockbackMultiplier: float = 1):
	self.damage_modifier = damageModifier
	self.damage_multiplier = damageMultiplier
	self.knockback_modifier = knockbackModifier
	self.knockback_multiplier = knockbackMultiplier
	
func apply(attack: Attack) -> void:
	attack.damage += self.damage_modifier
	attack.damage *= self.damage_multiplier
	attack.knockback_force += self.knockback_modifier
	attack.knockback_force *= self.knockback_multiplier
	if twist_type == Constants.TwistType.DAMAGE && self.damage_type_override: attack.damage_type = self.damage_type_override
	if twist_type == Constants.TwistType.DAMAGE_OVER_TIME && self.damage_over_time: attack.damage_over_time = self.damage_over_time
	if twist_type == Constants.TwistType.STATUS_EFFECT && self.status_effect: attack.status_effect = self.status_effect
