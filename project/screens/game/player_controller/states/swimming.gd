extends State

@onready var animation_player : AnimationPlayer = %PlayerAnimations

var current_side : String = "Left"

func enter(previous_state_path: String, data: Dictionary = {}) -> void:
	animation_player.animation_finished.connect(_animation_finished)
		
	#animation_player.play("StrokeRight")
	#animation_player.queue("StrokeLeft")
	#animation_player.queue("StrokeRight")
	#animation_player.queue("BreatheRight")
	#animation_player.queue("StrokeLeft")
	#animation_player.queue("StrokeRight")
	#animation_player.queue("StrokeLeft")
	#animation_player.queue("BreatheLeft")
	#
	
	if previous_state_path == "Breathing" and data["Direction"] != null:
		if data["Direction"] == "Left":
			animation_player.play("StrokeLeft")
		else:
			animation_player.play("StrokeRight")
	else:	
		if current_side == "Left":
			animation_player.play("StrokeLeft")
		else:
			animation_player.play("StrokeRight")
		

	
func exit() -> void:
	animation_player.animation_finished.disconnect(_animation_finished)


func _animation_finished(anim_name: String) -> void:
	if anim_name == "StrokeLeft":
		animation_player.play("StrokeRight")
		current_side = "Right"
	elif anim_name == "StrokeRight":
		animation_player.play("StrokeLeft")
		current_side = "Left"
		
		
