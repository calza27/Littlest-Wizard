class_name ManaComponent
extends Node2D

signal mana_changed(newValue: float)
signal max_mana_changed(newValue: float)

@export var max_mana: float
@export var curr_mana: float
@export var mana_regen: float

func _ready() -> void:
	if self.max_mana < 0:
		self.max_mana = 0
		
	if self.curr_mana < 0:
		self.curr_mana = 0
		
	if self.curr_mana > self.max_mana:
		self.curr_mana = self.max_mana

func _process(delta: float) -> void:
	if self.curr_mana < self.max_mana:
		self.regain_mana(self.mana_regen * delta)
	
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
