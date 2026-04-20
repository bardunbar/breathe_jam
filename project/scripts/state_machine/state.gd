class_name State extends Node

signal finished(next_state_path: String, data: Dictionary)

func handle_input(_event: InputEvent) -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	pass
	
func exit() -> void:
	pass

func transition(next_state_path: String, data: Dictionary = {}) -> void:
	finished.emit(next_state_path, data)
