class_name Item
extends Area2D

var item_id: String:
	set(val):
		assert(val != null && val.length() > 0, "item_id must not be empty")
		item_id = val
var label: String:
	set(val):
		assert(val != null && val.length() > 0, "label must not be empty")
		label = val
var quantity: int:
	set(val):
		assert(val > 0, "quantity must be greater than 0")
		quantity = val
var single_use: bool = false
var _player: PlayerCharacter
const _SPEED: int = 300

func _init() -> void:
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(6, true)
	self.set_collision_mask_value(1, true)
	self.area_entered.connect(self._on_area_entered)

func _process(delta: float) -> void:
	if self._player:
		var vec: Vector2 = self.global_position.direction_to(self._player.global_position)
		self.position += vec * self._SPEED * delta

func move_to_player(player: PlayerCharacter) -> void:
	self._player = player

func _on_area_entered(area: Area2D) -> void:
	self.queue_free()
	GameState.player_inventory.add_item(self, self.quantity)
