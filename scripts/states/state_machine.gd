class_name StateMachine
extends Node

@export var initial_state: EnemyState
@export var mob: MobOrchestrator
@export var debug: bool = false
var current_state: EnemyState
var states: Dictionary = {} #map[state.get_type]State
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
		self.mob.status_component.status_applied.connect(_status_check)
	if self.mob.hitbox_component:
		self.mob.hitbox_component.attack_dodged.connect(_transision_dodge)
	if self.mob.health_component:
		self.mob.health_component.entity_death.connect(_transision_death)

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
		
func _status_check(status: StatusEffect) -> void:
	if status.effect == Constants.StatusEffectType.STUN:
		transition(EnemyState.Type.STUNNED)
		return
	if status.effect == Constants.StatusEffectType.FRIGHTENED:
		transition(EnemyState.Type.FRIGHTENED)
		return
	if status.effect == Constants.StatusEffectType.BLINDED:
		transition(EnemyState.Type.BLIND)
		return
		
func _transision_dodge(_attack: Attack) -> void:
	transition(EnemyState.Type.DODGE)
	
func _transision_death() -> void:
	transition(EnemyState.Type.DEAD)
