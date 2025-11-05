extends Node3D
class_name State

signal request_transition(target_state_name: String, params: Dictionary)

var entity: Node3D = null
var state_magine: Node = null

@export var state_length := 10.0
var elapsed_time := 0.0
@export var transition_state = ""

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	entity = _entity
	state_magine = _machine

func exit() -> void:
	queue_free()

func tick(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time >= state_length:
		request_transition_to(transition_state)

func request_transition_to(_name: String, params: Dictionary = {}) -> void:
	request_transition.emit(_name, params)
