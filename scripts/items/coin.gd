class_name Coin
extends Item

func _init() -> void:
	super._init()
	self.item_id = "coin"
	self.label = "Coin"
	self.quantity = 1
	self.single_use = true

func _on_area_entered(area: Area2D) -> void:
	self.queue_free()
	GameState.add_player_money(self.quantity)
