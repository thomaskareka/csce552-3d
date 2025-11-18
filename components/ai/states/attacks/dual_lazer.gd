extends State

var blobs: Array[Node3D] = []
@export var velocity = 20
@export var acceleration = 40
var player_bounds: AABB
var boss_bounds: AABB

var lazer_manager: ProjectileManager

var state = 0
var state_timer = 0
var targets: Array[Vector3] = []

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	lazer_manager = get_node("ProjectileManager")
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
		player_bounds = _entity.get_player_bounds()
		boss_bounds = _entity.get_self_bounds()
		
		var center_x = (boss_bounds.position.x + boss_bounds.end.x) * 0.5

		var left_aabb = AABB(
			Vector3(boss_bounds.position.x, boss_bounds.position.y, 0),
			Vector3(boss_bounds.size.x / 2, boss_bounds.size.y, 0)
		)
		var right_aabb = AABB(
			Vector3(center_x, boss_bounds.position.y, -2),
			Vector3(boss_bounds.size.x / 2, boss_bounds.size.y, 0)
		)

		targets.append(MovementHelper.get_random_point_in_aabb(left_aabb))
		targets.append(MovementHelper.get_random_point_in_aabb(right_aabb))
		print(left_aabb)
		print(right_aabb)
		print(targets)
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	elapsed_time += delta
	match state:
		0:
			move_in_circle(2, delta)
			if elapsed_time > 2:
				change_state(1)
		1: 
			move_in_circle(4, delta)
		2:
			pass

func change_state(new_state: int):
	state = new_state
	match new_state:
		1:
			spawn_lazers()

func move_in_circle(rotation_speed: float, delta:float) -> void:
	var n = blobs.size()
	for i in range(n):
		var center = entity.global_position + targets[i % 2]
		var blob: RigidBody3D = blobs[i]
		var offset = Vector3(3, 0.0, 0.0)
		var angle = TAU / n * i + (elapsed_time * rotation_speed)
		var rotation := Basis(Vector3.FORWARD, angle)
		offset = rotation * offset
		var target_velocity = MovementHelper.get_velocity_to_target(blob.global_position, center + offset, velocity, delta)
		MovementHelper.move_with_force(blob, delta, target_velocity, acceleration)

func spawn_lazers() -> void:
	var params_left = {
		"constant_axis": Vector3(1, 0, 0),
		"constant_position_value": targets[0].x / 2.0,
		"beam_position": entity.global_position + targets[0],
		"speed": 2.0,
		"self_destruct": false
	}
	var params_right = {
		"constant_axis": Vector3(1, 0, 0),
		"constant_position_value": targets[1].y / 2.0,
		"beam_position": entity.global_position + targets[1],
		"speed": 2.0,
		"starting_rotation": Vector3(0, 90, 0),
		"self_destruct": false
	}
	
	lazer_manager.spawn_projectile(params_left)
	lazer_manager.spawn_projectile(params_right)
