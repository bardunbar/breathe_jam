extends Area3D

var event_manager = preload("res://scripts/event_management/event_manager.gd").get_manager()
var WaterLibrary = preload("res://scripts/water/water_utility_library.gd")

@export var trigger_event : bool = true
@export var event_name : String
@export var state_name : String
@export var trigger_water_change : bool = false
@export var new_water_speed : float = 1.0
@export var new_wave_height : float = 1.0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if trigger_event:
			event_manager.queue_state_event(event_name, state_name)
		if trigger_water_change:
			WaterLibrary.change_water_speed(new_water_speed)
			WaterLibrary.change_wave_height(new_wave_height)
