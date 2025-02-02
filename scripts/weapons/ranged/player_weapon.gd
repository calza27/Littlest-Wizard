class_name PlayerWeapon
extends RangedWeapon

@export var cooldown: float = 0.8
@export var magic_bolt_knockback_force: float = 400
@export var status_component: StatusComponent
var ready_to_attack: bool

func _ready() -> void:
	self.ready_to_attack = true
	
func _physics_process(_delta: float) -> void:
	var mousePos = get_global_mouse_position()
	self.pivot_point.look_at(mousePos)
	var direction = Vector2.RIGHT.rotated(self.pivot_point.rotation)
	if direction.x < 0:
		self.sprite.rotation = self.pivot_point.rotation * -1
		self.projectile_point.rotation =  self.pivot_point.rotation
	else:
		self.sprite.rotation = self.pivot_point.rotation * -1
		self.projectile_point.rotation = self.pivot_point.rotation
	
func fire_weapon() -> void:
	if self.ready_to_attack:
		self.ready_to_attack = false
		const PROJECTILE = preload(Files.PROJECTILES.projectile)
		var new_projectile = PROJECTILE.instantiate()
		new_projectile.set_attributes(self.projectile_attributes)
		var attack: Attack = new_projectile.get_attack()
		attack.knockback_force = self.magic_bolt_knockback_force
		attack = GameState.player_spell_book.apply_twists(attack)
		new_projectile.set_attack(attack)
		new_projectile.set_collision_mask_value(2, true)
		new_projectile.set_collision_mask_value(1, false)
		new_projectile.global_position = self.projectile_point.global_position
		new_projectile.global_rotation = self.projectile_point.global_rotation
		self.projectile_point.add_child(new_projectile)
		
		var cd = self.status_component.apply_cooldown_status_effects(self.cooldown)
		self.start_cooldown(cd)
	
func start_cooldown(time: float) -> void:
	var timer = self.get_tree().create_timer(time)
	timer.timeout.connect(self.clear_cooldown)
	
func clear_cooldown() -> void:
	self.ready_to_attack = true
