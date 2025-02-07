class_name PlayerSpellBook
extends SpellBook

var active_spells: Dictionary #map[String]String - maps the key binding to the name of the spell
var active_twists: Dictionary  #map[String]bool - maps the name of the twist to a bool representing if the twist is active

func _init() -> void:
	super._init()
	self.item_id = "player_spellbook"
	self.active_spells = {}
	self.active_twists = {}
	
func set_spell_active(spellName: String, active: bool) -> void:
	self.active_spells[spellName] = active
	
func set_twist_active(twistName: String, active: bool) -> void:
	self.active_twists[twistName] = active
	
func clear_active_twists() -> void:
	self.active_twists = {}
	
func apply_twists(attack: Attack) -> Attack:
	var appliedTwists: Array[Constants.TwistType] = []
	# apply only the set and additive affects first
	for twist_name in self.active_twists:
		if !self.active_twists.get(twist_name, false):
			continue
		var twist: Twist = self.twists.get(twist_name)
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
	for twist_name in self.active_twists:
		if !self.active_twists.get(twist_name, false):
			continue
		var twist: Twist = self.twists.get(twist_name)
		if appliedTwists.has(twist.twist_type):
			continue
		appliedTwists.append(twist.twist_type)
		attack.damage *= twist.damage_multiplier
		attack.knockback_force *= twist.knockback_multiplier
	return attack
