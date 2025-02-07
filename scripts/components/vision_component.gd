class_name VisionComponent
extends Area2D

signal player_spotted
signal player_lost

@export var vision_mode: VisionMode = VisionMode.BLINDSIGHT
@export var debug: bool = false
var _cast_rays = false
var _active_rays: Array[RayCast2D] = []
var _player_corners: Array[Vector2] = [] #offset from the center of the rectangle
var _ray_spot_player: bool = false
var _vision_area: Node2D
enum VisionMode { BLINDSIGHT, LINE_OF_SIGHT }

func _ready() -> void:
	var player_shape: Rect2 = Utils.get_player_shape()
	var dimensions: Vector2 = player_shape.size
	self._player_corners.push_back(Vector2(0,-1*(dimensions.y/2))) #center
	self._player_corners.push_back(Vector2(-1*(dimensions.x/2),-1*dimensions.y)) #top-left
	self._player_corners.push_back(Vector2((dimensions.x/2),-1*dimensions.y)) #top-right
	self._player_corners.push_back(Vector2(-1*(dimensions.x/2),0)) #bottom-left
	self._player_corners.push_back(Vector2((dimensions.x/2),0)) #bottom-right
	self._vision_area = self.get_child(0)

func _process(delta: float) -> void:
	if self._cast_rays:
		_cast_vision_rays()

func spot_player() -> void:
	self.player_spotted.emit()

func lost_player() -> void:
	self.player_lost.emit()
	
func update_direction(new: Constants.Direction) -> void:
	self._vision_area.rotation = Utils.direction_to_radians(new)
	
func _cast_vision_rays() -> void:
	if self._active_rays.size() == 0:
		for i  in range(5):
			var ray: RayCast2D = RayCast2D.new()
			ray.set_collision_mask_value(1, true)
			ray.set_collision_mask_value(4, true)
			ray.set_collision_mask_value(5, true)
			ray.collide_with_bodies = true
			ray.collide_with_areas = false
			self.add_child(ray)
			self._active_rays.push_back(ray)
	
	var player_position: Vector2 = Utils.get_player().global_position
	for i in self._active_rays.size():
		var ray: RayCast2D = self._active_rays[i]
		var player_corner: Vector2 = self._player_corners[i]
		var target: Vector2 = player_position - self.global_position + player_corner
		ray.target_position = target
		var collider: Object = ray.get_collider()
		if collider && collider is PlayerCharacter:
			if !self._ray_spot_player:
				spot_player()
			self._ray_spot_player = true
			return
			
	if self._ray_spot_player:
		lost_player()
		self._ray_spot_player = false
		
	
func _on_area_entered(_area: Area2D) -> void:
	if self.vision_mode == VisionMode.BLINDSIGHT:
		self.player_spotted.emit()
	else:
		self._cast_rays = true
	
func _on_area_exited(area: Area2D) -> void:
	self._cast_rays = false
	for ray in self._active_rays:
		ray.queue_free()
	self._active_rays = []
	lost_player()
