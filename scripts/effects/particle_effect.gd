class_name ParticleEffect
extends AnimatedSprite2D

var effect: Constants.ParticleEffectType
var timeout: float:
	set(val):
		timeout = val
		if timeout < 0:
			timeout = 0
	
func set_timeout(d: float) -> void:
	self.timeout = d
		
func set_effect(particleEffect: Constants.ParticleEffectType) -> void:
	self.effect = particleEffect
	
func attach_to(node: ParticleAttachmentComponent, shift: Vector2) -> void:
	var area = node.get_child(0)
	area.add_child(self)
	self.position.x = shift.x
	self.position.y = shift.y
	var numFrames: int = get_sprite_frames().get_frame_count("default")
	var startFrame: int = RandomNumberGenerator.new().randi_range(0, numFrames-1)
	play("default")
	set_frame_and_progress(startFrame, 0)
	if self.timeout > 0:
		start_timer(self.timeout)

func start_timer(time: float) -> void:
	var timer = get_tree().create_timer(time)
	timer.timeout.connect(timeout_function)
	
func timeout_function() -> void:
	queue_free()
	
