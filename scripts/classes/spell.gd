class_name Spell
extends Node2D

signal cast_end

var spell_name: String
var level: int
var mana_cost: int
var cooldown: int
var target: Constants.Target
var status_effect: StatusEffect
var attack: Attack

func cast() -> bool:
	cast_end.emit()
	return false
	
func get_spell_name() -> String:
	push_error("get_spell_name func not implemented")
	return ""
