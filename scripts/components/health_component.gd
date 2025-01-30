class_name HealthComponent
extends Node2D

signal damage_taken(attack: Attack)
signal health_changed(newValue: float)
signal max_health_changed(newValue: float)
signal entity_death()

var max_health: float
var curr_health: float
var temp_health: float
var damage_multiplier: Dictionary
var active_dot: Array[Constants.DamageType] = []
@export var status_component: StatusComponent
	
func init(maxHealth:float = 0.0, initialHealth:float = 0.0, tempHealth:float = 0.0, damageMultipliers:Dictionary = {}) -> void:
	self.max_health = maxHealth
	if self.max_health < 0.0:
		self.max_health = 0.0
	self.max_health_changed.emit(self.max_health)
		
	self.curr_health = initialHealth
	if self.curr_health < 0.0:
		self.curr_health = 0.0
	self.health_changed.emit(self.curr_health)
		
	self.temp_health = tempHealth
	if self.temp_health < 0.0:
		self.temp_health = 0.0
		
	self.damage_multiplier = damageMultipliers

func take_damage(attack: Attack) -> void:
	var damage = attack.damage
	damage *= self.damage_multiplier.get(attack.damage_type, 1)
	# if the entity has temp_health, we subtract the damage from temp_health
	if self.temp_health > 0:
		self.temp_health -= damage
		# if the damage was greater than the temp_health, then we aply the overflow damage to curr_health and set temp_health to 0
		if self.temp_health < 0:
			self.curr_health += self.temp_health
			self.temp_health = 0
	else:
		self.curr_health -= damage
	if self.curr_health <= 0:
		self.get_parent().queue_free()
		self.entity_death.emit()
	self.damage_taken.emit(attack)
	self.health_changed.emit(self.curr_health)

func apply_damage_over_time(damageOverTime: DamageOverTime) -> void:
	if self.active_dot.find(damageOverTime.attack.damage_type) < 0:
		self.active_dot.append(damageOverTime.attack.damage_type)
		var tickTimer = Timer.new()
		add_child(tickTimer)
		tickTimer.timeout.connect(self.dot_tick_timeout.bind(damageOverTime))
		tickTimer.start(damageOverTime.tick_rate)
		
		var durationTimer = get_tree().create_timer(damageOverTime.duration)
		await durationTimer.timeout
		tickTimer.stop()
		tickTimer.queue_free()
		self.active_dot.erase(damageOverTime.attack.damage_type)
	
func dot_tick_timeout(damageOverTime: DamageOverTime) -> void:
	self.take_damage(damageOverTime.attack)
			
func heal(amount: float) -> void:
	self.curr_health += amount
	if self.curr_health >= self.max_health:
		self.curr_health = self.max_health
	self.health_changed.emit(self.curr_health)
		
func set_temp_health(amount: float) -> void:
	if amount > self.temp_health:
		self.temp_health = amount
