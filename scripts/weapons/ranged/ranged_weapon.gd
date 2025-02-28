class_name RangedWeapon
extends Node2D

signal player_in_range
signal player_out_of_range
signal player_not_close
signal player_too_close

@export var projectile_attributes: ProjectileAttributes
@export var status_component: StatusComponent
var _player: CharacterBody2D
@onready var pivot_point: Marker2D = %PivotPoint
@onready var sprite: Sprite2D = %Sprite
@onready var projectile_point: Marker2D = %ProjectilePoint

func _ready() -> void:
	self._player = Utils.get_player()
	stow_weapon()
		
func _physics_process(_delta: float) -> void:
	var playerPos = Utils.get_player().position
	self.look_at(playerPos)
	var direction = Vector2.RIGHT.rotated(rotation)
	if direction.x < 0:
		self.sprite.flip_v = true
	else:
		self.sprite.flip_v = false

func draw_weapon() -> void:
	self.visible = true

func stow_weapon() -> void:
	self.visible = false

func fire_weapon() -> void:
	const PROJECTILE: Resource = preload(Files.PROJECTILES["projectile"])
	var new_projectile: Projectile = PROJECTILE.instantiate()
	new_projectile.set_inert(false)
	new_projectile.set_attributes(self.projectile_attributes)
	var attack: Attack = self.projectile_attributes.attack
	if self.status_component:
		attack = self.status_component.apply_attack_status_effects(attack)
	new_projectile.set_attack(attack)
	new_projectile.global_position = self.projectile_point.global_position
	new_projectile.global_rotation = self.projectile_point.global_rotation
	Utils.add_node_to_group(new_projectile, Constants.Group.PROJECTILE)

func _on_attack_range_area_entered(area: Area2D) -> void:
	draw_weapon()
	player_in_range.emit()
	
func _on_attack_range_area_exited(area: Area2D) -> void:
	stow_weapon()
	player_out_of_range.emit()
	
func _on_close_in_range_area_entered(area: Area2D) -> void:
	stow_weapon()
	player_not_close.emit()

func _on_close_in_range_area_exited(area: Area2D) -> void:
	draw_weapon()
	player_too_close.emit()
