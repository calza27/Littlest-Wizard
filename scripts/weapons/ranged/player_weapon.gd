class_name PlayerWeapon
extends RangedWeapon

@export var magic_bolt_knockback_force: float = 400
@export var status_component: StatusComponent
var _weapon_enabled: bool

func _ready() -> void:
	self.visible = true
	self._weapon_enabled = true
	
func _physics_process(_delta: float) -> void:
	if _weapon_enabled:
		var mousePos = get_global_mouse_position()
		self.pivot_point.look_at(mousePos)
		var direction = Vector2.RIGHT.rotated(self.pivot_point.rotation)
		if direction.x < 0:
			self.sprite.rotation = self.pivot_point.rotation * -1
			self.projectile_point.rotation =  self.pivot_point.rotation
		else:
			self.sprite.rotation = self.pivot_point.rotation * -1
			self.projectile_point.rotation = self.pivot_point.rotation
			
func set_weapon_enabled(b: bool) -> void:
	self._weapon_enabled = b

func fire_weapon() -> void:
	var new_projectile: Projectile = self.projectile.duplicate()
	new_projectile.set_inert(false)
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
