class_name StateMachine
extends Node

@export var initial_state: EnemyState
@export var mob: MobOrchestrator
@export var debug: bool = false
var current_state: EnemyState
var states: Dictionary = {}
@onready var label: Label = %StateMachineLabel

func _ready() -> void:
	if self.label:
		self.label.visible = self.debug
	for child in self.get_children():
		if child is EnemyState:
			self.states[child.get_type()] = child
			child.transitioned.connect(_on_child_transition)

func start() -> void:
	if self.initial_state:
		_update_label(self.initial_state.name)
		self.initial_state.set_mob(self.mob)
		self.initial_state.enter(self.initial_state)
		self.current_state = self.initial_state
	if self.mob.status_component:
		self.mob.status_component.status_applied.connect(_stun_check)
	if self.mob.hitbox_component:
		self.mob.hitbox_component.attack_dodged.connect(_transision_dodge)

func _process(delta) -> void:
	if self.current_state:
		self.current_state.update(delta)

func _physics_process(delta) -> void:
	if self.current_state:
		self.current_state.physics_update(delta)

func transition(new_state_type: EnemyState.Type) -> void:
	var new_state: EnemyState = self.states.get(new_state_type)
	if !new_state:
		return
	if self.current_state:
		self.current_state.exit()
	var old_state: EnemyState = self.current_state
	self.current_state = new_state
	_update_label(self.current_state.name)
	new_state.set_mob(self.mob)
	new_state.enter(old_state)

func _on_child_transition(state: EnemyState, new_state_type: EnemyState.Type) -> void:
	if state != self.current_state:
		return
	transition(new_state_type)
	
func _update_label(text: String) -> void:
	if self.label:
		self.label.text = text
		
func _stun_check(status: Status) -> void:
	if status.effect == Constants.StatusEffect.STUN:
		transition(EnemyState.Type.STUNNED)
		
func _transision_dodge(_attack: Attack) -> void:
	transition(EnemyState.Type.DODGE)
