class_name InteractionComponent
extends Area2D

var _player: PlayerCharacter

func _ready() -> void:
	self._player = Utils.get_player()
	
func _on_area_entered(area: Area2D) -> void:
	var item: Item = area as Item
	item.move_to_player(self._player)
