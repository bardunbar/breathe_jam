extends State

@onready var player : CharacterBody3D = $"../.."
@onready var animation_player : AnimationPlayer = %PlayerAnimations
@onready var camera_animation : AnimationPlayer = %CameraAnimations

var current_side : String = "Left"
var left_pull_ready : bool = false
var right_pull_ready : bool = false
var breathing : bool = false
var moving : bool = false

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	animation_player.animation_finished.connect(_animation_finished)
	
	animation_player.play("ReadyLeft")
	
func exit() -> void:
	animation_player.animation_finished.disconnect(_animation_finished)

func update(delta: float) -> void:
	if moving:
		player.move_and_collide(delta * Vector3.FORWARD * 10.0)

func _animation_finished(anim_name: String) -> void:
	if anim_name == "ReadyLeft":
		left_pull_ready = true
	elif anim_name == "ReadyRight":
		right_pull_ready = true
	moving = false
		

func trigger_breath(_side: String) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_stroke"):
		if left_pull_ready or (animation_player.current_animation == "ReadyLeft" and animation_player.current_animation_length - animation_player.current_animation_position < 0.1):
			left_pull_ready = false
			current_side = "Right"
			animation_player.play("PullLeft")
			moving = true
			animation_player.queue("ReadyRight")
			if breathing:
				camera_animation.play_backwards("BreatheRight")
				breathing = false
			
	elif event.is_action_pressed("right_stroke"):
		if right_pull_ready or (animation_player.current_animation == "ReadyRight" and animation_player.current_animation_length - animation_player.current_animation_position < 0.1):
			right_pull_ready = false
			current_side = "Left"
			animation_player.play("PullRight")
			moving = true
			animation_player.queue("ReadyLeft")
			if breathing:
				camera_animation.play_backwards("BreatheLeft")
				breathing = false
			
	elif event.is_action_pressed("breathe"):
		if not breathing:
			breathing = true
			if current_side == "Left":
				camera_animation.play("BreatheRight")
			else:
				camera_animation.play("BreatheLeft")
