extends Node

signal player_health_change(max_value: float, curr_value: float)
signal player_mana_change(max_value: float, curr_value: float)
signal player_money_change(old_value: int, new_value: int)
signal focus_enemy(label: String, max_health: float, curr_health: float)
signal player_spell_cooldown_start(spell: Spell)
signal player_spell_cooldown_end(spell: Spell)
signal bound_spell_changed(binding: String, spell: Spell)
signal player_status_applied(status: StatusEffect)
signal player_status_removed(status: StatusEffect)
