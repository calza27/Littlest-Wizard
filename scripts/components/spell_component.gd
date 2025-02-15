class_name SpellComponent
extends Node2D

signal spell_cast_start(spell: Spell)
signal spell_cast_end(spell: Spell)
signal spell_cooldown_start(spell: Spell, cooldown: float)
signal spell_cooldown_end(spell: Spell)

@export var status_component: StatusComponent
var cooldown_spells: Dictionary = {} #map[spell.get_spell_name()]float

func _process(delta: float) -> void:
	for key in self.cooldown_spells:
		var cooldown: float = self.cooldown_spells.get(key, 0)
		cooldown -= delta
		if cooldown <= 0:
			self.cooldown_spells.erase(key)
			var spell: Spell = GameState.player_spell_book.get_spell(key)
			self.spell_cooldown_end.emit(spell)
		else:
			self.cooldown_spells[key] = cooldown

func get_spell(key_binding: String) -> Spell:
	return GameState.player_spell_book.get_active_spell(key_binding)

func spell_on_cooldown(spell: Spell) -> bool:
	var active_cooldown: float = self.cooldown_spells.get(spell.get_spell_name(), 0)
	return active_cooldown > 0
	
func cast_spell(spell: Spell) -> bool:
	var active_cooldown: float = self.cooldown_spells.get(spell.get_spell_name(), 0)
	if active_cooldown > 0:
		return false
	
	spell.cast_end.connect(_on_cast_end.bind(spell))
	if !Utils.add_node_to_group(spell, Constants.Group.PROJECTILE):
		return false
	spell_cast_start.emit(spell)
	var cast: bool = spell.cast()
	if cast:
		var cooldown: float = self.status_component.apply_cooldown_status_effects(spell.cooldown)
		self.cooldown_spells[spell.get_spell_name()] = cooldown
		self.spell_cooldown_start.emit(spell, cooldown)
	return cast
	
func _on_cast_end(spell: Spell) -> void:
	spell_cast_end.emit(spell)
