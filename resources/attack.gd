class_name Attack
extends Resource 

@export var damage: float
@export var damage_type: Constants.DamageType
@export var knockback_force: float
@export var damage_over_time: DamageOverTime
@export var status_effect: StatusEffect
var attack_rotation: Vector2

static func build(d:float = 100.0, dt: Constants.DamageType = Constants.DamageType.FORCE, kf:float = 0.0, ar:Vector2 = Vector2(0,0)) -> Attack:
	var attack: Attack = Attack.new()
	attack.damage = d
	attack.damage_type = dt
	attack.knockback_force = kf
	attack.attack_rotation = ar
	return attack

func set_damage_over_time(dot: DamageOverTime) -> void:
	self.damage_over_time = dot
	
func get_damage_over_time() -> DamageOverTime:
	return self.damage_over_time

func set_status_effect(status: StatusEffect) -> void:
	self.status_effect = status
	
func get_status_effect() -> StatusEffect:
	return self.status_effect
