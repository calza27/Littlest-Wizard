class_name InventoryComponent
extends Node2D

var spells: Array[Spell] = []
var twists: Array[Twist] = []

func apply_twists(attack: Attack) -> Attack:
	var appliedTwists: Array[Constants.TwistType] = []
	# apply only the set and additive affects first
	for twist in self.twists:
		if appliedTwists.has(twist.twist_type):
			continue
		appliedTwists.append(twist.twist_type)
		attack.damage += twist.damage_modifier
		attack.knockback_force += twist.knockback_modifier
		if twist.twist_type == Constants.TwistType.DAMAGE && twist.damage_type_override:
			attack.damage_type = twist.damage_type_override
		if twist.twist_type == Constants.TwistType.DAMAGE_OVER_TIME && twist.damage_over_time:
			attack.damage_over_time = twist.damage_over_time
		if twist.twist_type == Constants.TwistType.STATUS_EFFECT && twist.status_effect:
			attack.status_effect = twist.status_effect
	
	# now apply the multiplicative affects
	appliedTwists = []
	for twist in self.twists:
		if appliedTwists.has(twist.twist_type):
			continue
		appliedTwists.append(twist.twist_type)
		attack.damage *= twist.damage_multiplier
		attack.knockback_force *= twist.knockback_multiplier
	return attack
