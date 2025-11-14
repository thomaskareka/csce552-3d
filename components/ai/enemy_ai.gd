extends Node3D
class_name EnemyAI

@onready var state_machine : StateMachine = $StateMachine
@export var states: Dictionary[String, StateRequirement] = {}
@export var start_state: String = ""

var player_bounds: AABB
var boss_bounds: AABB

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	state_machine.parent = self
	state_machine.start_state = start_state
	
	var state_scenes: Dictionary[String, PackedScene] = {}
	
	for key in states:
		state_scenes[key] = states[key].scene
		
	state_machine.state_scenes = state_scenes
	
	state_machine.change_to_start()

func set_player_bounds(b: AABB) -> void:
	player_bounds = b

func get_player_bounds() -> AABB:
	return player_bounds
	
func set_self_bounds(b: AABB) -> void:
	boss_bounds = b

func get_self_bounds() -> AABB:
	return boss_bounds

func _physics_process(delta: float) -> void:
	state_machine.tick(delta)

func choose_state(params: Dictionary = {}) -> Array:
	push_error("_choose_state not implemented on ", self)
	return []

func update_tracked_data(state: String) -> void:
	push_error("_update_tracked_data not implemented on ", self)
