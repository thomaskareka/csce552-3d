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
	for i in range(n):
		var blob: RigidBody3D = blobs[i]
		var offset = Vector3(radius, 0.0, 0.0)
		var angle = TAU / n * i + (elapsed_time * rotation_speed)
		var rotation := Basis(spin_axis, angle)
		offset = rotation * offset
		var target_velocity = MovementHelper.get_velocity_to_target(blob.global_position, center + offset, velocity, delta)
		MovementHelper.move_with_force(blob, delta, target_velocity, acceleration)
		
	
