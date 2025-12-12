extends Node3D
class_name EnemyAI

@onready var state_machine : StateMachine = $StateMachine
@export var states: Dictionary[String, StateRequirement] = {}
@export var start_state: String = ""

var player_bounds: AABB
var boss_bounds: AABB

var last_state := ""
var last_attack_state := ""
var phase = 1

var camera: Camera3D #used for warping back if off screen

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
	var desired_prefix : String = "i_"
	if last_state != "" and last_state.begins_with("i_"):
		desired_prefix = "a_"
	
	var candidates := []
	var total_weight := 0
	for key in states.keys():
		if not key.begins_with(desired_prefix): continue
		
		if last_attack_state == key:
			continue
		
		var state: StateRequirement = states[key]
		if state.scene == null:
			continue
		
		if phase < state.min_phase || (phase > state.max_phase && state.max_phase != 0):
			continue
		
		candidates.append([key, state.weight])
		total_weight += state.weight

	var pick := randf() * total_weight
	var sum := 0
	var chosen_key = ""
	for pair in candidates:
		sum += pair[1]
		if pick <= sum:
			chosen_key = pair[0]
			break
	if chosen_key == "" and not candidates.is_empty():
		chosen_key = candidates[0][0]
	return [chosen_key, params]

func update_tracked_data(state: String) -> void:
	last_state = state
	if last_state.begins_with("a_"):
		last_attack_state = last_state
