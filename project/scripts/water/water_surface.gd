extends MeshInstance3D

var WaterLibrary = preload("res://scripts/water/water_utility_library.gd")
var water_time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	water_time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	water_time += delta
	WaterLibrary.update_water_time(water_time)
	var material: Material = get_active_material(0)
	material.set_shader_parameter("water_time", water_time)
