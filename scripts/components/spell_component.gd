class_name SpellComponent
extends Node2D

signal spell_cast_start(spell: Spell)
signal spell_cast_end(spell: Spell)
signal spell_cooldown_start(spell: Spell)
signal spell_cooldown_end(spell: Spell)

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
	get_tree().get_first_node_in_group(Utils.group_name_for_group(Constants.Group.PROJECTILE)).add_child(spell)
	spell_cast_start.emit(spell)
	var cast: bool = spell.cast()
	if cast:
		self.cooldown_spells[spell.get_spell_name()] = spell.cooldown
		self.spell_cooldown_start.emit(spell)
	return cast
	
func _on_cast_end(spell: Spell) -> void:
	spell_cast_end.emit(spell)
