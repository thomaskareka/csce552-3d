extends State

var blobs: Array[Node3D] = []

@export var rotation_speed = 1.5
@export var velocity: float = 20.0
@export var acceleration: float = 40.0
@export var radius: float = 5.0
var player_bounds: AABB

var idle_count: int = 10
var center: Vector3
func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
		idle_count = len(blobs)
		player_bounds = _entity.get_player_bounds()
		center = _entity.global_position
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	elapsed_time += delta
	idle_count = ceil(9 - elapsed_time * 0.2)
	MovementHelper.circular_move(delta, blobs, idle_count, radius, elapsed_time, rotation_speed, velocity, acceleration, center)

	if elapsed_time >= state_length:
		request_transition_to(transition_state)
