extends State

@onready var player : CharacterBody3D = $"../.."
@onready var animation_player : AnimationPlayer = %PlayerAnimations
@onready var camera_animation : AnimationPlayer = %CameraAnimations
@onready var underwater_splash : AudioStreamPlayer3D = %UnderwaterSplash
@onready var water_splash : AudioStreamPlayer3D = %WaterSplash
@onready var underwater_pull : AudioStreamPlayer3D = %UnderwaterPull

signal oxygen_update(new_value: float, old_value: float)
signal death_event()

var event_manager : EventManager = preload("res://scripts/event_management/event_manager.gd").get_manager()

var started_swimming : bool = false
var current_side : String = "Left"
var left_pull_ready : bool = false
var right_pull_ready : bool = false
var breathing : bool = false
var moving : bool = false

var oxygen_level = 100.0
var oxygen_max_level = 100.0
var oxygen_decrease_rate = 3.0
var oxygen_move_decrease_rate = 40.0
var oxygen_increase_rate = 100.0

var current_velocity : float = 0.0
@export var velocity_per_stroke : float = 10.0
@export var max_velocity : float = 20.0 
@export var velocity_decay : float = 10.0
var decay_accumulator : float = 0.0
@export var decay_easing_time : float = 1.0

var default_underwater_volume : float = 0.0
var target_underwater_volume : float = 0.0
var default_surface_volume : float = 0.0
var target_surface_volume : float = 0.0
var bus_transition_speed : float = 5.0

const UNDERWATER_BUS_IDX : int = 1
const SURFACE_BUS_IDX : int = 2 

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	animation_player.animation_finished.connect(_animation_finished)
	camera_animation.animation_finished.connect(_cam_animation_finished)
	
	animation_player.play("ReadyLeft")
	event_manager.on_enter_event_state("HeadInWater")
	
	default_underwater_volume = AudioServer.get_bus_volume_linear(UNDERWATER_BUS_IDX)
	default_surface_volume = AudioServer.get_bus_volume_linear(SURFACE_BUS_IDX)
	
	target_underwater_volume = default_underwater_volume
	
	target_surface_volume = 0
	AudioServer.set_bus_volume_linear(SURFACE_BUS_IDX, 0)

func exit() -> void:
	animation_player.animation_finished.disconnect(_animation_finished)
	camera_animation.animation_finished.disconnect(_cam_animation_finished)

func update(delta: float) -> void:
	if current_velocity > 0.0:
		# Update current velocity
		var normalized_decay_progress = clampf(decay_accumulator/decay_easing_time, 0.0, 1.0)
		var current_decay = velocity_decay * ease(normalized_decay_progress, 3.0)
		current_velocity = maxf(0.0, current_velocity - velocity_decay * delta)
		
		if current_velocity > 0.0:
			# Then move
			player.move_and_collide(delta * Vector3.FORWARD * current_velocity)
			
	var current_surface_volume = AudioServer.get_bus_volume_linear(SURFACE_BUS_IDX)
	if target_surface_volume != current_surface_volume:
		var dir = signf(target_surface_volume - current_surface_volume)
		current_surface_volume = clamp(current_surface_volume + dir * bus_transition_speed * delta, 0, default_surface_volume)
		AudioServer.set_bus_volume_linear(SURFACE_BUS_IDX, current_surface_volume)
		
	var current_underwater_volume = AudioServer.get_bus_volume_linear(UNDERWATER_BUS_IDX)
	if target_underwater_volume != current_underwater_volume:
		var dir = signf(target_underwater_volume - current_underwater_volume)
		current_underwater_volume = clamp(current_underwater_volume + dir * bus_transition_speed * delta, 0, default_underwater_volume)
		AudioServer.set_bus_volume_linear(UNDERWATER_BUS_IDX, current_underwater_volume)
		
#	Oxygen
	var old_oxygen = oxygen_level
	if started_swimming and oxygen_level > 0.0:
		var oxygen_change = delta
		if breathing:
			oxygen_change *= oxygen_increase_rate
		elif moving:
			oxygen_change *= -oxygen_move_decrease_rate
		else:
			oxygen_change *= -oxygen_decrease_rate
		oxygen_level = clamp(oxygen_level + oxygen_change, 0.0, 100.0)
		if oxygen_level < old_oxygen and oxygen_level <= 0.0:
			death_event.emit()
	oxygen_update.emit(oxygen_level, old_oxygen)

func _animation_finished(anim_name: String) -> void:
	if anim_name == "ReadyLeft":
		left_pull_ready = true
	elif anim_name == "ReadyRight":
		right_pull_ready = true
	moving = false

func _cam_animation_finished(anim_name: String) -> void:
	if anim_name == "BreatheRight" or anim_name == "BreatheLeft": #transition between breathing and head in water
		if breathing:
			event_manager.on_enter_event_state("Breathing")
		else:
			event_manager.on_enter_event_state("HeadInWater")

func trigger_breath(_side: String) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if oxygen_level <= 0.0: # Dead
		return
	started_swimming = true
	if event.is_action_pressed("left_stroke"):
		if left_pull_ready or (animation_player.current_animation == "ReadyLeft" and animation_player.current_animation_length - animation_player.current_animation_position < 0.1):
			left_pull_ready = false
			current_side = "Right"
			animation_player.play("PullLeft")
			moving = true
			current_velocity = minf(max_velocity, current_velocity + velocity_per_stroke)
			animation_player.queue("ReadyRight")
			do_pull_sfx()
			if breathing:
				camera_animation.play_backwards("BreatheRight")
				breathing = false
				do_splash_sfx()
				enable_underwater_sounds()
			
	elif event.is_action_pressed("right_stroke"):
		if right_pull_ready or (animation_player.current_animation == "ReadyRight" and animation_player.current_animation_length - animation_player.current_animation_position < 0.1):
			right_pull_ready = false
			current_side = "Left"
			animation_player.play("PullRight")
			moving = true
			current_velocity = minf(max_velocity, current_velocity + velocity_per_stroke)
			animation_player.queue("ReadyLeft")
			do_pull_sfx()
			if breathing:
				camera_animation.play_backwards("BreatheLeft")
				breathing = false
				do_splash_sfx()
				enable_underwater_sounds()
				
			
	elif event.is_action_pressed("breathe"):
		if not breathing:
			breathing = true
			enable_surface_sounds()
			if current_side == "Left":
				camera_animation.play("BreatheRight")
			else:
				camera_animation.play("BreatheLeft")
				
func do_pull_sfx() -> void:
	underwater_pull.play()
	
func do_splash_sfx() -> void:
	underwater_splash.play()
	water_splash.play()

func enable_underwater_sounds() -> void:
	target_underwater_volume = default_underwater_volume
	target_surface_volume = 0

func enable_surface_sounds() -> void:
	target_surface_volume = default_surface_volume
	target_underwater_volume = 0
