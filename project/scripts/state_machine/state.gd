class_name State extends Node

signal finished(next_state_path: String, data: Dictionary)

func handle_input(_event: InputEvent) -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func enter(previous_state_path: String, data: Dictionary = {}) -> void:
	pass
	
func exit() -> void:
	pass
