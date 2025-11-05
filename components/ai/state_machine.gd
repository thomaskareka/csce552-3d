extends Node3D
class_name StateMachine

@export var start_state: String = ""
@export var state_scenes: Dictionary[String, PackedScene] = {}

var current_state: State = null
var current_state_name: String = ""

func change_to_start() -> void:
	print("changing to start state ", start_state)
	if start_state != "":
		change_state(start_state)

func change_state(_name: String, params: Dictionary = {}) -> void:
	if current_state_name == name:
		return
	
	if current_state:
		current_state.exit()
		current_state = null
		current_state_name = ""
	
	if not state_scenes.has(_name):
		push_error("unknown state '%s'" % _name)
		return
	
	var state: PackedScene = state_scenes.get(_name)
	if not state:
		push_error("state for '%s' is null" % _name)
		return
	
	var state_instance := state.instantiate() as State
	
	state_instance.request_transition.connect(_on_state_transition_request)
	current_state = state_instance
	current_state_name = _name
	call_deferred("enter_state", params)

func tick(delta) -> void:
	if current_state:
		current_state.tick(delta)

func enter_state(params: Dictionary = {}) -> void:
	if current_state:
		print("entering state ", current_state_name)
		current_state.enter(get_parent(), self, params)

func _on_state_transition_request(target_name: String, params: Dictionary = {}) -> void:
	change_state(target_name, params)
