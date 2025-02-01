class_name PlayerCharacter
extends CharacterBody2D

@onready var health_component: HealthComponent = %HealthComponent
@onready var mana_component: ManaComponent = %ManaComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var inventory_component: InventoryComponent = %InventoryComponent
@onready var status_component: StatusComponent = %StatusComponent
@onready var player_animator: PlayerAnimator = %PlayerAnimator
@onready var graphics_component: GraphicsComponent = %GraphicsComponent
@onready var weapon: Weapon = %Weapon

func _ready() -> void:
	var twists: Array[Twist] = []
	#twists.append_array([Firebolt.new(5, 10), Frost.new(3), ConcussionShot.new(0.0)])
	twists.append_array([Firebolt.new(5, 10)])
	self.inventory_component.twists = twists
	#self.status_component.apply_status_condition(MageArmour.new().status_effect)

func _input(event: InputEvent) -> void:
	if !self.status_component.has_status_effect(Constants.StatusEffect.STUN):
		if event.is_action("shoot"):
			weapon.shoot()
			
func _physics_process(delta: float) -> void:
	if self.status_component.has_status_effect(Constants.StatusEffect.STUN):
		self.player_animator.play_stun_animation()
	else:
		var direction = Input.get_vector("left", "right", "up", "down")
		self.set_player_direction(direction)
		self.movement_component.move(direction, delta)
		if direction.x == 0 && direction.y == 0:
			self.player_animator.play_idle_animation()
		else:
			self.player_animator.play_walk_animation()
			
func set_player_direction(direction) -> void:
	if direction.x == 1:
		self.player_animator.curr_facing = Constants.Facing.RIGHT
	elif direction.x == -1:
		self.player_animator.curr_facing = Constants.Facing.LEFT
	if direction.y == 1:
		self.player_animator.curr_facing = Constants.Facing.DOWN
	elif direction.y == -1:
		self.player_animator.curr_facing = Constants.Facing.UP
	
func _on_hitbox_component_attack_dodged(_attack: Attack) -> void:
	self.player_animator.play_dodge_animation()

func _on_hitbox_component_hit_by_attack(attack: Attack) -> void:
	self.movement_component.apply_knockback(attack)
	self.health_component.take_damage(attack)
	if attack.damage_over_time:
		self.health_component.apply_damage_over_time(attack.damage_over_time)
	if  attack.status_effect:
		self.status_component.apply_status_condition(attack.status_effect)

func _on_mana_component_mana_changed(newValue: float) -> void:
	EventBus.player_mana_change.emit(self.mana_component.max_mana, newValue)

func _on_health_component_health_changed(newValue: float) -> void:
	EventBus.player_health_change.emit(self.health_component.max_health, newValue)

func _on_health_component_max_health_changed(newValue: float) -> void:
	EventBus.player_health_change.emit(newValue, self.health_component.curr_health)

func _on_mana_component_max_mana_changed(newValue: float) -> void:
	EventBus.player_mana_change.emit(newValue, self.mana_component.curr_mana)
