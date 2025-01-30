class_name Attack

var damage: float
var damage_type: Constants.DamageType
var knockback_force: float
var attack_rotation: Vector2
var damage_over_time: DamageOverTime
var status_effect: Status

func _init(d:float = 100.0, dt: Constants.DamageType = Constants.DamageType.FORCE, kf:float = 0.0, ar:Vector2 = Vector2(0,0)):
	self.damage = d
	self.damage_type = dt
	self.knockback_force = kf
	self.attack_rotation = ar
	
func duplicate() -> Attack:
	var a = Attack.new(self.damage, self.damage_type, self.knockback_force, self.attack_rotation)
	if self.damage_over_time:
		a.set_damage_over_time(self.damage_over_time.duplicate())
	if self.status_effect:
		a.set_status(self.status_effect.duplicate())
	return a

func set_damage_over_time(dot: DamageOverTime) -> void:
	self.damage_over_time = dot

func set_status(status: Status) -> void:
	self.status_effect = status
