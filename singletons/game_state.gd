extends Node

@onready var player_inventory: Inventory = Inventory.new()
@onready var player_spell_book: PlayerSpellBook = PlayerSpellBook.new()
@onready var player_money: int = 0:
	set(val):
		EventBus.player_money_change.emit(player_money, val)
		player_money = val
		
func add_player_money(amount: int) -> void:
	var new: int = player_money + amount
	EventBus.player_money_change.emit(player_money, new)
	player_money = new
	
func subtract_player_money(amount: int) -> void:
	var new: int = player_money - amount
	if new < 0:
		new = 0
	EventBus.player_money_change.emit(player_money, new)
	player_money = new
	
func has_money(qty: int) -> bool:
	return player_money >= qty
