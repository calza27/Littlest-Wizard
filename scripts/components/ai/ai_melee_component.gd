class_name AiMelee
extends AIComponent

func _physics_process(delta: float) -> void:
	if self.status_component.has_status_effect(Constants.StatusEffect.STUN):
		if self.mob_graphics_component:
			self.mob_graphics_component.play_stun_animation()
		return
		
	var direction = _normalise_movement(global_position.direction_to(self.player.global_position))
	if self.curr_mode == Constants.AiMode.STATIONARY:
		if self.mob_graphics_component:
			self.mob_graphics_component.play_idle_animation()
	if self.curr_mode == Constants.AiMode.ENGAGED:
		if self.attack_component.hitbox_in_range && self.attack_component.ready_to_attack:
			if !self.attack_component.attack_melee():
				return
			if self.mob_graphics_component:
				self.mob_graphics_component.set_facing(direction)
				self.mob_graphics_component.play_attack_animation()
		else:
			self.movement_component.move(direction, delta)
			if self.mob_graphics_component:
				self.mob_graphics_component.set_facing(direction)
				self.mob_graphics_component.play_walk_animation()

func set_mode(mode: Constants.AiMode) -> void:
	self.curr_mode = mode
