extends Node3D

@export var play_menu: PackedScene
@export var game_over_menu: PackedScene

@onready var canvas_animation: AnimationPlayer = $CanvasAnimation
@onready var interface_layer: CanvasLayer = %InterfaceLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_open_play_menu"):
		interface_layer.add_child(play_menu.instantiate())
		get_viewport().set_input_as_handled()

func _ready() -> void:
	canvas_animation.animation_finished.connect(_animation_finished)
	canvas_animation.play("StartGameTitle", -1, 10.0)

func _on_character_death_event() -> void:
	canvas_animation.play("Drown")
	
func _animation_finished(anim_name: String) -> void:
	if anim_name == "Drown":
		interface_layer.add_child(game_over_menu.instantiate())
