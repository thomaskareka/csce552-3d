extends Node3D
class_name EnemyAI

@onready var state_machine : StateMachine = $StateMachine
var player_bounds: AABB
var boss_bounds: AABB

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
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
