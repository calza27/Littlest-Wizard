class_name State
extends Node

signal transitioned
var player: PlayerCharacter
var mob: MobOrchestrator

func enter(m: MobOrchestrator) -> void:
	self.mob = m
	self.player = Utils.get_player()
	
func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
