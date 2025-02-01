class_name Weapon
extends Area2D

@export var cooldown: float = 0.8
@export var magic_bolt_speed: float = 1000
@export var magic_bolt_max_range: float = 1500
@export var magic_bolt_damage: float = 20
@export var magic_bolt_damage_type: Constants.DamageType = Constants.DamageType.FORCE
@export var magic_bolt_knockback_force: float = 400
@export var status_component: StatusComponent
@export var inventory_component: InventoryComponent
var ready_to_attack: bool
@onready var projectile_point: Marker2D = %ProjectilePoint

func _ready() -> void:
	self.ready_to_attack = true
	
func shoot():
	if self.ready_to_attack:
		self.ready_to_attack = false
		const MAGIC_BOLT = preload(Files.PROJECTILES["magic_bolt"])
		var new_magic_bolt = MAGIC_BOLT.instantiate()
		var magicBoltAttack = Attack.new(self.magic_bolt_damage, self.magic_bolt_damage_type, self.magic_bolt_knockback_force)
		if self.inventory_component:
			magicBoltAttack = self.inventory_component.apply_twists(magicBoltAttack)
		new_magic_bolt.set_attack(magicBoltAttack)
		new_magic_bolt.global_position = self.projectile_point.global_position
		new_magic_bolt.global_rotation = self.projectile_point.global_rotation
		self.projectile_point.add_child(new_magic_bolt)
		var cd = self.status_component.apply_cooldown_status_effects(self.cooldown)
		self.start_cooldown(cd)
	
func start_cooldown(time: float) -> void:
	var timer = self.get_tree().create_timer(time)
	timer.timeout.connect(self.clear_cooldown)
	
func clear_cooldown() -> void:
	self.ready_to_attack = true
