extends MeshInstance3D
@export var offset : float = 0.5
@export var zoffset : float = -40
@export var max_speed : float = 2.0
@export var disappear_event : String = "BoatDisappear"
@export var reappear_event : String = "BoatReappear"
@onready var player: CharacterBody3D = $"../Character"

const WaterLibrary = preload("res://scripts/water/water_utility_library.gd")
var event_manager = preload("res://scripts/event_management/event_manager.gd").get_manager()

func _ready() -> void:
	event_manager.register_listener(disappear_event, self)
	event_manager.register_listener(reappear_event, self)
	
func trigger_event(event_name : String) -> void:
	if event_name == disappear_event:
		visible = false
	elif event_name == reappear_event:
		visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var target_z = player.global_position.z + zoffset
	var target_z_offset = target_z - global_position.z
	var max_target_z = clamp(target_z_offset, -max_speed, max_speed)
	global_position.z += max_target_z * _delta
	
	var global_pos_vector = Vector2(global_position.x, global_position.z)
	var new_height = WaterLibrary.get_height(global_pos_vector)
	global_position.y = new_height + offset
	#translate(Vector3(0.0, new_height - global_position.y, 0.0))
