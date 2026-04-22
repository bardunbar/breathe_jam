extends MeshInstance3D

var WaterLibrary = preload("res://scripts/water/water_utility_library.gd")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var material: Material = get_active_material(0)
	material.set_shader_parameter("water_time", WaterLibrary.water_time)
