class_name State
extends Node

signal transitioned(State, Type)

var _previous_state: State

func enter(previousState: State) -> void:
	self._previous_state = previousState
	
func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
