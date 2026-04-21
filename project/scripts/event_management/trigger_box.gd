extends Area3D

var event_manager = preload("res://scripts/event_management/event_manager.gd").get_manager()

@export var event_name : String
@export var state_name : String

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		event_manager.queue_state_event(event_name, state_name)
