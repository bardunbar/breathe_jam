extends MeshInstance3D

@onready var player: CharacterBody3D = $"../Character"
@export var player_offset: float = -100.0

var WaterLibrary = preload("res://scripts/water/water_utility_library.gd")
var water_time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	water_time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = player.global_position.x;
	global_position.z = player.global_position.z;
	var offset = 0.5
	var right_position : Vector3 = global_position + (Vector3.RIGHT * offset)
	var left_position : Vector3 = global_position + (Vector3.LEFT * offset)
	water_time += delta
	WaterLibrary.update_water_time(water_time)
	var new_height = WaterLibrary.get_height(Vector2(global_position.x, global_position.z))
	right_position.y = WaterLibrary.get_height(Vector2(right_position.x, right_position.z))
	left_position.y = WaterLibrary.get_height(Vector2(left_position.x, left_position.z))
	var rotation_vector = (right_position - left_position).normalized()
	var z_angle = atan2(rotation_vector.y, rotation_vector.x)
	player.global_position = Vector3(global_position.x, new_height + player_offset, global_position.z)
	player.global_rotation.z = z_angle
	var material: Material = get_active_material(0)
	material.set_shader_parameter("water_time", water_time)
