class_name PlayerCharacter
extends CharacterBody2D

@onready var health_component: HealthComponent = %HealthComponent
@onready var mana_component: ManaComponent = %ManaComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var status_component: StatusComponent = %StatusComponent
@onready var player_animator: PlayerAnimator = %PlayerAnimator
@onready var graphics_component: GraphicsComponent = %GraphicsComponent
@onready var spell_component: SpellComponent = %SpellComponent
@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var weapon: PlayerWeapon = %Weapon
@onready var state_machine: PlayerStateMachine = %PlayerStateMachine
func _ready() -> void:
	set_test_spells_and_twists()
	self.state_machine.start(self)
	
func set_test_spells_and_twists() -> void:
	var firebolt: Firebolt = Firebolt.new(5, 10)
	GameState.player_spell_book.add_twist(firebolt)
	GameState.player_spell_book.set_twist_active(firebolt.get_twist_name(), true)
	
	var ccShot: ConcussionShot = ConcussionShot.new(2)
	GameState.player_spell_book.add_twist(ccShot)
	GameState.player_spell_book.set_twist_active(ccShot.get_twist_name(), true)
	
	#self.status_component.apply_status_condition(MageArmour.new().status_effect)
	
	var fireball: Fireball = Fireball.new()
	GameState.player_spell_book.add_spell(fireball)
	GameState.player_spell_book.set_spell_active("spell_1", fireball.get_spell_name())
	
			
func _on_hitbox_component_hit_by_attack(attack: Attack) -> void:
	self.movement_component.apply_knockback(attack)
	self.health_component.take_damage(attack)
	if attack.get_damage_over_time():
		self.health_component.apply_damage_over_time(attack.get_damage_over_time())
		if attack.get_damage_over_time().get_particle_effect():
			self.graphics_component.attach_random(attack.get_damage_over_time().get_particle_effect())
	if  attack.get_status_effect():
		self.status_component.apply_status_condition(attack.get_status_effect())
		if attack.get_status_effect().get_particle_effect():
			self.graphics_component.attach_random(attack.get_status_effect().get_particle_effect())

func _on_mana_component_mana_changed(newValue: float) -> void:
	EventBus.player_mana_change.emit(self.mana_component.max_mana, newValue)

func _on_health_component_health_changed(newValue: float) -> void:
	EventBus.player_health_change.emit(self.health_component.max_health, newValue)

func _on_health_component_max_health_changed(newValue: float) -> void:
	EventBus.player_health_change.emit(newValue, self.health_component.curr_health)

func _on_mana_component_max_mana_changed(newValue: float) -> void:
	EventBus.player_mana_change.emit(newValue, self.mana_component.curr_mana)

func _on_spell_component_spell_cooldown_start(spell: Spell) -> void:
	EventBus.player_spell_cooldown_start.emit(spell)

func _on_spell_component_spell_cooldown_end(spell: Spell) -> void:
	EventBus.player_spell_cooldown_end.emit(spell)

func _on_movement_component_direction_changed(new: Constants.Direction) -> void:
	self.player_animator.curr_facing = Utils.direction_to_facing(new)

func _on_status_component_status_applied(status: StatusEffect) -> void:
	EventBus.player_status_applied.emit(status)

func _on_status_component_status_removed(status: StatusEffect) -> void:
	EventBus.player_status_removed.emit(status)
