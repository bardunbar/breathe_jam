extends Node3D

#Singleton Event Manager
var event_manager = preload("res://scripts/event_management/event_manager.gd").get_manager()

@export var event_name : String
@export var starting_visibility : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_manager.register_listener(event_name, self)
	visible = starting_visibility
	
func trigger_event(event_name : String) -> void:
	visible = not starting_visibility
