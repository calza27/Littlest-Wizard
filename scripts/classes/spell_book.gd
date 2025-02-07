class_name SpellBook
extends Item

var spells: Dictionary #map[String]Spell - maps the name of the spell to the spell instance
var twists: Dictionary #map[String]Twist - maps the name of the twist to the twist instance

func _init() -> void:
	super._init()
	self.item_id = "spellbook"
	self.label = "SpellBook"
	self.single_use = false
	self.spells = {}
	self.twists = {}

func add_spell(spell: Spell) -> void:
	self.spells[spell.name] = spell
	
func remove_spell(spell: Spell) -> void:
	self.spells[spell.name] = null

func add_twist(twist: Twist) -> void:
	self.twists[twist.name] = twist
	
func remove_twist(twist: Twist) -> void:
	self.twists[twist.name] = null
