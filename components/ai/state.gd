extends Node
class_name State

signal request_transition(target_state_name: String, params: Dictionary)

var entity: Node3D = null
var state_magine: Node = null

var state_length := 10.0
var time_remaining := 10.0
var transition_state = ""

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	entity = _entity
	state_magine = _machine
	time_remaining = state_length
	set_physics_process(true)

func exit() -> void:
	set_physics_process(false)

func tick(delta: float) -> void:
	time_remaining -= delta
	if time_remaining <= 0:
		request_transition_to(transition_state)

func request_transition_to(_name: String, params: Dictionary = {}) -> void:
	request_transition.emit(_name, params)
