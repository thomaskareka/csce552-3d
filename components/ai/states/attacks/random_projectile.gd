extends State

var blobs: Array[Node3D] = []
@export var velocity = 20
@export var acceleration = 40
var player_bounds: AABB
var boss_bounds: AABB

var projectile_manager: ProjectileManager
var targets: Array[Vector3] = []

var state = 0
var state_timer = 0
var local_state_length = 1.5

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	projectile_manager = get_node("ProjectileManager")
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
		targets.resize(len(blobs))
		player_bounds = _entity.get_player_bounds()
		boss_bounds = _entity.get_self_bounds()
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	elapsed_time += delta
	state_timer += delta
	match state:
		0:
			get_targets()
			state += 1
		1:
			if state_timer <= local_state_length:
				move_to_target(delta)
			else:
				state += 1;
		2: 
			spawn_projectiles()
			state = 0;
			local_state_length -= 0.05
			state_timer = 0
	if elapsed_time >= state_length:
		request_transition_to(transition_state)

func get_targets() -> void:
	for i in len(blobs):
		targets[i] = MovementHelper.get_random_point_in_aabb(boss_bounds) + Vector3(0, 0, i)

func move_to_target(delta: float) -> void:
	for i in len(blobs):
		var blob = blobs[i]
		var target_velocity = MovementHelper.get_velocity_to_target(blob.global_position, targets[i], velocity, delta)
		MovementHelper.move_with_force(blob, delta, target_velocity, acceleration, velocity)

func spawn_projectiles() -> void:
	for i in len(blobs):
		var blob = blobs[i]
		var target_position = Vector3(
			targets[i].x * randf_range(0.2, 0.5),
			targets[i].y * randf_range(0.2, 0.5),
			player_bounds.position.z
		)
		var params = {
			"direction": MovementHelper.get_direction_to_target(targets[i], target_position),
			"spawn_position": blob.global_position
		}
		projectile_manager.spawn_projectile(params)
