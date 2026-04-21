extends State

@onready var animation_player : AnimationPlayer = %PlayerAnimations
@onready var camera_animation : AnimationPlayer = %CameraAnimations

var current_side : String = "Left"
var left_pull_ready : bool = false
var right_pull_ready : bool = false

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	animation_player.animation_finished.connect(_animation_finished)
	
	animation_player.play("ReadyLeft")
	
func exit() -> void:
	animation_player.animation_finished.disconnect(_animation_finished)


func _animation_finished(anim_name: String) -> void:
	if anim_name == "ReadyLeft":
		left_pull_ready = true
	elif anim_name == "ReadyRight":
		right_pull_ready = true
		

func trigger_breath(_side: String) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_stroke"):
		if left_pull_ready or (animation_player.current_animation == "ReadyLeft" and animation_player.current_animation_length - animation_player.current_animation_position < 0.1):
			left_pull_ready = false
			animation_player.play("PullLeft")
			animation_player.queue("ReadyRight")
			
	elif event.is_action_pressed("right_stroke"):
		if right_pull_ready or (animation_player.current_animation == "ReadyRight" and animation_player.current_animation_length - animation_player.current_animation_position < 0.1):
			right_pull_ready = false
			animation_player.play("PullRight")
			animation_player.queue("ReadyLeft")
			
	elif event.is_action_pressed("breathe"):
		print("Breathe")
