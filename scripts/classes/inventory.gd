class_name Inventory

var _gold: int
var _items: Dictionary = {} # map[item.name]Array[Item]

func add_gold(amount: int) -> void:
	self._gold += amount
	
func remove_gold(amount: int) -> void:
	self._gold -= amount
	if self._gold < 0:
		self._gold = 0

func has_gold(amount: int) -> bool:
	return self._gold >= amount
	
func add_item(item: Item, qty: int) -> void:
	var array: Array[Item] = []
	if self._items.has(item.item_id):
		array = self._items[item.item_id]
	array.push_back(item)
	self._items[item.item_id] = array
	
func remove_item(item: Item, qty: int) -> void:
	if qty < 0:
		self._items[item.item_id] = []
		return

	var array: Array[Item] = []
	if self._items.has(item.item_id):
		array = self._items[item.item_id]
	if qty >= array.size():
		self._items[item.item_id] = []
		return
		
	for _i in qty: 
		array.remove_at(0)
	self._items[item.item_id] = array
	
func has_item(item: Item, qty: int) -> bool:
	if qty == 0 && !self._items.has(item.item_id):
		return true
	
	var array: Array[Item] = []
	if self._items.has(item.item_id):
		array = self._items[item.item_id]
	
	if qty == 0:
		return array.size() == 0
		
	return array.size() >= qty
