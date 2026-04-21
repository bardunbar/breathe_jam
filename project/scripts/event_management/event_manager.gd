class_name EventManager extends Node

static var _manager : EventManager

static func get_manager() -> EventManager:
	if _manager == null:
		_manager = new()
	return _manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func queue_state_event(event_name: String, state_name: String) -> void:
	print('triggering event ' + event_name + ' at state ' + state_name)
