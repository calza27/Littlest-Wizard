class_name SpellBook
extends Item

var _spells: Dictionary #map[String]Spell - maps the name of the spell to the spell instance
var _twists: Dictionary #map[String]Twist - maps the name of the twist to the twist instance

func _init() -> void:
	super._init()
	self.item_id = "spellbook"
	self.label = "SpellBook"
	self.single_use = false
	self._spells = {}
	self._twists = {}

func get_spell(spellName: String) -> Spell:
	return self._spells[spellName] as Spell
	
func add_spell(spell: Spell) -> void:
	self._spells[spell.get_spell_name()] = spell
	
func remove_spell(spell: Spell) -> void:
	self._spells[spell.get_spell_name()] = null

func get_twist(twistName: String) -> Twist:
	return self._twists[twistName] as Twist
	
func add_twist(twist: Twist) -> void:
	self._twists[twist.get_twist_name()] = twist
	
func remove_twist(twist: Twist) -> void:
	self._twists[twist.get_twist_name()] = null
