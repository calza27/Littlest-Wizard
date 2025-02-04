class_name StateMachine
extends Node

@export var initial_state: State
@export var mob: MobOrchestrator
@export var debug: bool = false
var current_state: State
var states: Dictionary = {}
@onready var label: Label = %Label

func _ready() -> void:
	if self.label:
		self.label.visible = self.debug
	for child in self.get_children():
		if child is State:
			self.states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transition)

func start() -> void:
	if self.initial_state:
		_update_label(self.initial_state.name)
		self.initial_state.enter(self.mob)
		self.current_state = self.initial_state

func _process(delta) -> void:
	if self.current_state:
		self.current_state.update(delta)

func _physics_process(delta) -> void:
	if self.current_state:
		self.current_state.physics_update(delta)

func transition(new_state_name: String) -> void:
	var new_state: State = self.states.get(new_state_name.to_lower())
	if !new_state:
		return
	if self.current_state:
		self.current_state.exit()
	new_state.enter(self.mob)
	self.current_state = new_state
	_update_label(self.current_state.name)

func _on_child_transition(state: State, new_state_name: String) -> void:
	if state != self.current_state:
		return
	transition(new_state_name)
	
func _update_label(text: String) -> void:
	if self.label:
		self.label.text = text
