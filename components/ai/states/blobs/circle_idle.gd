extends State
class_name CircleIdleState

var blobs: Array[Node3D] = []
@export var rotation_speed = 1.5
@export var velocity = 10
@export var acceleration = 20
@export var spin_axis := Vector3.FORWARD
@export var radius: float = 5.0

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
	else:
		request_transition_to(transition_state)
	if params.has("spin_axis"):
		spin_axis = params.get(spin_axis)
	spin_axis = spin_axis.normalized()

func tick(delta: float) -> void:
	super.tick(delta)
	var center = entity.global_position
	
	var n = blobs.size()
	MovementHelper.circular_move(delta, blobs, n, radius, elapsed_time, rotation_speed, velocity, acceleration, center, spin_axis)
	
