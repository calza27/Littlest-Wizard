class_name PlayerState
extends State

var _player: PlayerCharacter
var _active_spell: String

enum Type { NONE, IDLE_CALM, IDLE_PUFFED, MOVE, STUNNED, DODGE, SPRINT, ATTACK_BOLT, SPELL_CHARGE, SPELL_CAST, DEAD }

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._player = Utils.get_player()

func input(event: InputEvent) -> void:
	pass
	
func get_type() -> Type:
	return Type.NONE

func _is_movement_event(event: InputEvent) -> bool:
	if event.is_action_pressed("down"):
		return true
	if event.is_action_pressed("up"):
		return true
	if event.is_action_pressed("left"):
		return true
	if event.is_action_pressed("right"):
		return true
	return false
	
func _is_spell_event(event: InputEvent) -> bool:
	if event.is_action_pressed("spell_1"):
		return true
	if event.is_action_pressed("spell_2"):
		return true
	if event.is_action_pressed("spell_3"):
		return true
	if event.is_action_pressed("spell_4"):
		return true
	return false

func _transition_with_spell(event: InputEvent, type: Type) -> void:
	if event.is_action_pressed("spell_1"):
		self._active_spell = "spell_1"
	if event.is_action_pressed("spell_2"):
		self._active_spell = "spell_2"
	if event.is_action_pressed("spell_3"):
		self._active_spell = "spell_3"
	if event.is_action_pressed("spell_4"):
		self._active_spell = "spell_4"
	self.transitioned.emit(self, type)
