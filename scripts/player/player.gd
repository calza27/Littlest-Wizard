class_name PlayerCharacter
extends CharacterBody2D

@onready var health_component: HealthComponent = %HealthComponent
@onready var mana_component: ManaComponent = %ManaComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var status_component: StatusComponent = %StatusComponent
@onready var player_animator: PlayerAnimator = %PlayerAnimator
@onready var graphics_component: GraphicsComponent = %GraphicsComponent
@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var weapon: PlayerWeapon = %Weapon
@onready var state_machine: PlayerStateMachine = %PlayerStateMachine
func _ready() -> void:
	#twists.append_array([Firebolt.new(5, 10), Frost.new(3), ConcussionShot.new(0.0)])
	var firebolt: Firebolt = Firebolt.new(5, 10)
	GameState.player_spell_book.add_twist(firebolt)
	GameState.player_spell_book.set_twist_active(firebolt.get_name(), true)
	#var ccShot: ConcussionShot = ConcussionShot.new(2)
	#GameState.player_spell_book.add_twist(ccShot)
	#GameState.player_spell_book.set_twist_active(ccShot.get_name(), true)
	#self.status_component.apply_status_condition(MageArmour.new().status_effect)
	self.movement_component.direction_changed.connect(_update_direction)
	self.state_machine.start(self)
			
func _update_direction(new: Constants.Direction) -> void:
	self.player_animator.curr_facing = Utils.direction_to_facing(new)

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
