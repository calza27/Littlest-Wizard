class_name MobOrchestrator
extends CharacterBody2D

@export var ui_label: String
@export var state_machine: StateMachine
var origin_point: Vector2
@onready var vision_component: VisionComponent = %VisionComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var attack_component: AttackComponent = %AttackComponent
@onready var mob_graphics_component: MobGraphicsComponent = %MobGraphicsComponent
@onready var status_component: StatusComponent = %StatusComponent
func _ready() -> void:
	self.origin_point = self.global_position
		
	if  self.health_component:
		self.health_component.health_changed.connect(_on_health_component_health_changed)
		
	if  self.hitbox_component:
		self.hitbox_component.attacked.connect(_on_hitbox_component_attacked)
		self.hitbox_component.attack_dodged.connect(_on_hitbox_component_attack_dodged)
		
	if self.mob_graphics_component:
		self.mob_graphics_component.play_idle_animation()
		
	if self.state_machine:
		self.state_machine.start()
		
func _physics_process(delta: float) -> void:
	if self.mob_graphics_component:
		if self.status_component.has_status_effect(Constants.StatusEffect.STUN):
			self.mob_graphics_component.play_stun_animation()
			return
			
		if velocity.length() == 0:
			self.mob_graphics_component.play_idle_animation()
		else:
			self.mob_graphics_component.play_walk_animation()

func _on_hitbox_component_attacked(attack: Attack, dodged: bool) -> void:
	EventBus.focus_enemy.emit(self.ui_label, self.health_component.max_health, self.health_component.curr_health)
	_spot_player()
	if !dodged:
		_apply_attack(attack)

func _spot_player() -> void:
	if  self.vision_component:
		self.vision_component.spot_player()
				
func _apply_attack(attack: Attack) -> void:
	if self.movement_component:
		self.movement_component.apply_knockback(attack)
		
	if self.health_component:
		self.health_component.take_damage(attack)
		if attack.damage_over_time:
			self.health_component.apply_damage_over_time(attack.damage_over_time)
			if attack.damage_over_time.particle_effect && self.mob_graphics_component:
				self.mob_graphics_component.attach_random(attack.damage_over_time.particle_effect)
		if  attack.status_effect && self.status_component:
			self.status_component.apply_status_condition(attack.status_effect)
			if attack.status_effect.particle_effect && self.mob_graphics_component:
				self.mob_graphics_component.attach_random(attack.status_effect.particle_effect)

func _on_hitbox_component_attack_dodged(_attack: Attack) -> void:
	if self.mob_graphics_component:
		self.mob_graphics_component.play_dodge_animation()

func _on_health_component_health_changed(newValue: float) -> void:
	EventBus.focus_enemy.emit(self.ui_label, self.health_component.max_health, newValue)
