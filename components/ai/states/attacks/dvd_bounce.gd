extends State

var blobs: Array[Node3D] = []

@export var rotation_speed = 1.5
@export var velocity: float = 20.0
@export var acceleration: float = 40.0
@export var radius: float = 5.0
var player_bounds: AABB

var idle_count: int = 10
@export var max_idle: int = 9
@export var blob_delay: float = 0.2
@export var speed_factor = 0.25
var center: Vector3

var dvd_velocities: Array[Vector3] = []
var dvd_initialized: Array[bool] = []
func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
		idle_count = len(blobs)
		player_bounds = _entity.get_player_bounds()
		center = _entity.global_position
		
		dvd_velocities.resize(len(blobs))
		dvd_initialized.resize(len(blobs))
		for i in range(len(blobs)):
			dvd_velocities[i] = Vector3.ZERO
			dvd_initialized[i] = false
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	elapsed_time += delta
	idle_count = ceil(max_idle - elapsed_time * blob_delay)
	MovementHelper.circular_move(delta, blobs, idle_count, radius, elapsed_time, rotation_speed, velocity, acceleration, center)
	
	var bounds_min = player_bounds.position
	var bounds_max = player_bounds.position + player_bounds.size
	for i in range(idle_count, len(blobs)):
		var blob = blobs[i]
		var pos = blob.global_position
		if not player_bounds.has_point(blob.global_position):
			var dir = MovementHelper.get_direction_to_target(pos, player_bounds.position + player_bounds.size * 0.5)
			MovementHelper.move_with_direction(blob, delta, dir, velocity, acceleration)
			continue
			
		if not dvd_initialized[i]:
			var v = MovementHelper.get_random_unit_vector()
			v.z = 0
			dvd_velocities[i] = v.normalized() * speed_factor * velocity
			dvd_initialized[i] = true
		
		var vel = dvd_velocities[i]
		pos += vel * delta
		for axis in range(2): # only x, y
			if pos[axis] <= bounds_min[axis]:
				pos[axis] = bounds_min[axis]
				vel[axis] = abs(vel[axis])
			elif pos[axis] >= bounds_max[axis]:
				pos[axis] = bounds_max[axis]
				vel[axis] = -abs(vel[axis])
		
		dvd_velocities[i] = vel
		MovementHelper.move_with_force(blob, delta, vel, 1000, 10)
	if elapsed_time >= state_length:
		request_transition_to(transition_state)
