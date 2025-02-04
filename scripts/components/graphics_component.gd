class_name GraphicsComponent
extends Node2D

var rng = RandomNumberGenerator.new()
	
func attach_particle(part: String, particleEffect: ParticleEffect) -> void:
	var points = _get_particle_attachment_points()
	if points.size == 0:
		return
	var component_name = "particle_area_" + part
	for point in points:
		if point.name == component_name:
			self._attach_effect(particleEffect, point)

func attach_random(particleEffect: ParticleEffect) -> void:
	var points = _get_particle_attachment_points()
	if points.size() == 0:
		return
	var index = rng.randi_range(0, points.size()-1)
	var point = points[index]
	self._attach_effect(particleEffect, point)
		
func _attach_effect(particleEffect: ParticleEffect, point: ParticleAttachmentComponent) -> void:
	var numEffects = rng.randi_range(3, 7)
	for num in numEffects:
		var e: ParticleEffect = particleEffect.duplicate()
		e.set_timeout(particleEffect.timeout)
		var offset: Vector2 = point.get_random_position()
		e.attach_to(point, offset)
	
func _get_particle_attachment_points() -> Array[ParticleAttachmentComponent]:
	return self._particle_attachments(self)

func _particle_attachments(node: Node) -> Array[ParticleAttachmentComponent]:
	if node.get_child_count() == 0:
		return []
	var particalNodes: Array[ParticleAttachmentComponent] = []
	for child in node.get_children():
		if child is ParticleAttachmentComponent:
			particalNodes.append(child as ParticleAttachmentComponent)
		particalNodes.append_array(self._particle_attachments(child))
	return particalNodes
