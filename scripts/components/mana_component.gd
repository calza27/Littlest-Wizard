class_name ManaComponent
extends Node2D

signal mana_changed(newValue: float)
signal max_mana_changed(newValue: float)

var max_mana: float
var curr_mana: float
	
func init(maxMana:float = 0.0, initialMana:float = 0.0) -> void:
	self.max_mana = maxMana
	if self.max_mana < 0.0:
		self.max_mana = 0.0
	self.max_mana_changed.emit(self.max_mana)
		
	self.curr_mana = initialMana
	if self.curr_mana < 0.0:
		self.curr_mana = 0.0
	self.mana_changed.emit(self.curr_mana)

func can_spend_mana(amount: float) -> bool:
	return self.curr_mana >= amount
		
func spend_mana(amount: float) -> void:
	self.curr_mana -= amount
	if self.curr_mana <= 0:
		self.curr_mana = 0
	mana_changed.emit(self.curr_mana)
			
func regain_mana(amount: float) -> void:
	self.curr_mana += amount
	if self.curr_mana >= self.max_mana:
		self.curr_mana = self.max_mana
	mana_changed.emit(self.curr_mana)
