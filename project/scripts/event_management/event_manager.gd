#Singleton EventManager
class_name EventManager extends Node

static var _manager : EventManager

var cur_state : String = ''
var queued_events : Dictionary[String, Array] = {}
var registered_listeners : Dictionary[String, Array] = {}

static func get_manager() -> EventManager:
	if _manager == null:
		_manager = new()
	return _manager

func on_enter_event_state(state_name: String) -> void:
	cur_state = state_name
	if queued_events.has(state_name):
		var events = queued_events.get(state_name)
		if events != null:
			for e in events:
				trigger_event(e)
	
func queue_state_event(event_name: String, state_name: String) -> void:
	if state_name == cur_state:
		trigger_event(event_name)
	else:
		var state_events : Array = queued_events.get_or_add(state_name, [])
		state_events.append(event_name)

func trigger_event(event_name: String) -> void:
	if registered_listeners.has(event_name):
		var listeners : Array = registered_listeners.get(event_name)
		if listeners != null:
			for listener in listeners:
				if listener.has_method("trigger_event"):
					listener.trigger_event(event_name)
			
func register_listener(event_name: String, listener: Variant) -> void:
	if not listener.has_method("trigger_event"):
		print("ERROR: Attempting to add listener for " + event_name + " with no trigger_event func")
		return
	var listeners : Array = registered_listeners.get_or_add(event_name, [])
	listeners.append(listener)
	
func unregister_listener(event_name: String, listener: Variant) -> void:
	var listeners : Array = registered_listeners.get(event_name)
	if listeners != null:
		var index = listeners.find(listener)
		if index >= 0:
			listeners.remove_at(index)
	
