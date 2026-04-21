extends MeshInstance3D
@export var offset := 0.5
const WaterLibrary = preload("res://scripts/water/water_utility_library.gd")
var global_pos_vector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_pos_vector = Vector2(global_position.x, global_position.z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var new_height = WaterLibrary.get_height(global_pos_vector)
	global_position.y = new_height + offset
	#translate(Vector3(0.0, new_height - global_position.y, 0.0))
