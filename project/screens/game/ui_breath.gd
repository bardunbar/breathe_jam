extends ProgressBar

func _on_character_oxygen_update(old_value: float, new_value: float) -> void:
	value = new_value
