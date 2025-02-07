extends Node

signal player_health_change(max_value: float, curr_value: float)
signal player_mana_change(max_value: float, curr_value: float)
signal player_money_change(old_value: int, new_value: int)
signal focus_enemy(label: String, max_health: float, curr_health: float)
