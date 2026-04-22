extends MeshInstance3D

@onready var player: CharacterBody3D = $"../Character"
@export var player_offset: float = -100.0

var WaterLibrary = preload("res://scripts/water/water_utility_library.gd")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WaterLibrary.ready()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_water(delta)
	_update_position()
	_update_player_transform()
	
func _update_water(delta: float) -> void:
	WaterLibrary.process(delta)
	var material: Material = get_active_material(0)
	material.set_shader_parameter("water_time", WaterLibrary.water_time)
	material.set_shader_parameter("wave_height", WaterLibrary.cur_water_wave_height)

func _update_position() -> void:
	global_position.x = player.global_position.x;
	global_position.z = player.global_position.z;
	
func _update_player_transform() -> void:
	var offset = 0.5
	var right_position : Vector3 = global_position + (Vector3.RIGHT * offset)
	var left_position : Vector3 = global_position + (Vector3.LEFT * offset)
	var new_height = WaterLibrary.get_height(Vector2(global_position.x, global_position.z))
	right_position.y = WaterLibrary.get_height(Vector2(right_position.x, right_position.z))
	left_position.y = WaterLibrary.get_height(Vector2(left_position.x, left_position.z))
	var rotation_vector = (right_position - left_position).normalized()
	var z_angle = atan2(rotation_vector.y, rotation_vector.x)
	player.global_position = Vector3(global_position.x, new_height + player_offset, global_position.z)
	player.global_rotation.z = z_angle
