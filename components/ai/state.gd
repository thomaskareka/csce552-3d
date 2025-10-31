extends Node
class_name State

signal request_transition(target_state_name: String, params: Dictionary)

var entity: Node = null
var state_magine: Node = null

func enter(_entity: Node, _machine: Node, params: Dictionary = {}) -> void:
	entity = _entity
	state_magine = _machine
	set_physics_process(true)

func exit() -> void:
	set_physics_process(false)

func tick(delta: float) -> void:
	pass

func request_transition_to(_name: String, params: Dictionary = {}) -> void:
	request_transition.emit(_name, params)
