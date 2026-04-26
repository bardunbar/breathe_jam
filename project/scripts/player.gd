extends CharacterBody3D

signal oxygen_update(new_value: float, old_value: float)
signal death_event()

func _on_swimming_oxygen_update(new_value: float, old_value: float) -> void:
	oxygen_update.emit(new_value, old_value)

func _on_swimming_death_event() -> void:
	death_event.emit()
