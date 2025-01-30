class_name VisionComponent
extends Area2D

signal player_is_spotted
@export var player_spotted: bool

func _on_area_entered(_area: Area2D) -> void:
	self.spot_player()
	
func spot_player() -> void:
	self.player_spotted = true
	self.player_is_spotted.emit()
