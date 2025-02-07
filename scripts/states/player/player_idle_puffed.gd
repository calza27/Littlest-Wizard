class_name PlayerIdlePuffed
extends PlayerIdleCalm

@export var time_dur: float = 3
var _timer: Timer

func enter(previousState: State) -> void:
	super.enter(previousState)
	self._player.player_animator.play_idle_animation(false)
	self._timer = Timer.new()
	add_child(self._timer)
	self._timer.timeout.connect(_on_timeout)
	self._timer.start(self.time_dur)
	
func exit() -> void:
	self._timer.stop()
	self._timer.queue_free()

func get_type() -> Type:
	return Type.IDLE_PUFFED
		
func _on_timeout() -> void:
	self.transitioned.emit(self, Type.IDLE_CALM)
