class_name PlayerStateMachine
extends Node

@export var initial_state: PlayerState
@export var debug: bool = false
var current_state: PlayerState
var states: Dictionary = {}
var _player: PlayerCharacter
@onready var label: Label = %StateMachineLabel

func _ready() -> void:
	if self.label:
		self.label.visible = self.debug
	for child in self.get_children():
		if child is PlayerState:
			self.states[child.get_type()] = child
			child.transitioned.connect(_on_child_transition)

func start(player: PlayerCharacter) -> void:
	if self.initial_state:
		_update_label(self.initial_state.name)
		self.initial_state.enter(self.initial_state)
		self.current_state = self.initial_state
	self._player = player
	self._player.status_component.status_applied.connect(_stun_check)
	self._player.hitbox_component.attack_dodged.connect(_transision_dodge)

func _process(delta) -> void:
	if self.current_state:
		self.current_state.update(delta)

func _physics_process(delta) -> void:
	if self.current_state:
		self.current_state.physics_update(delta)
		
func _input(event: InputEvent) -> void:
	if self.current_state:
		self.current_state.input(event)

func transition(new_state_type: PlayerState.Type) -> void:
	var new_state: State = self.states.get(new_state_type)
	if !new_state:
		return
	if self.current_state:
		self.current_state.exit()
	var old_state: State = self.current_state
	self.current_state = new_state
	_update_label(self.current_state.name)
	new_state.enter(old_state)

func _on_child_transition(state: PlayerState, new_state_type: PlayerState.Type) -> void:
	if state != self.current_state:
		return
	transition(new_state_type)
	
func _update_label(text: String) -> void:
	if self.label:
		self.label.text = text

func _stun_check(status: Status) -> void:
	if status.effect == Constants.StatusEffect.STUN:
		transition(PlayerState.Type.STUNNED)
		
func _transision_dodge(_attack: Attack) -> void:
	transition(PlayerState.Type.DODGE)
