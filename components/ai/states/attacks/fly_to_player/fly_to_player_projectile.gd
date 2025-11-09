extends State

var blobs: Array[Node3D] = []

@export var rotation_speed: float = 1.5
@export var velocity: float = 20.0
@export var acceleration: float = 40.0
@export var radius: float = 5.0
@export var shoot_delay: float = 1.0
var player_bounds: AABB
var directions: Array[Vector3] = []

var idle_count: int = 10
var last_count: int = 10
var center: Vector3
var entity_tracker: EntityTracker
var projectile_manager: ProjectileManager

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
		directions.resize(len(blobs))
		for i in range(len(directions)):
			directions[i] = Vector3.ZERO
		player_bounds = _entity.get_player_bounds()
		center = _entity.global_position
		entity_tracker = _entity.get_tree().get_first_node_in_group("EntityTracker")
		projectile_manager = get_node("ProjectileManager")
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	elapsed_time += delta
	var seconds := int(elapsed_time / shoot_delay)
	
	idle_count = ceil(len(blobs) - seconds)
	if idle_count < last_count:
		var player_position = entity_tracker.get_player_position()
		directions[idle_count] = MovementHelper.get_direction_to_target(blobs[idle_count].global_position, player_position)
		
		last_count = idle_count
		for i in range(2):
			await get_tree().create_timer(0.4).timeout
			spawn_projectile(blobs[idle_count])

	MovementHelper.circular_move(delta, blobs, idle_count, radius, elapsed_time, rotation_speed, velocity, acceleration, center)
	for i in range(idle_count, len(blobs)):
		MovementHelper.move_with_direction(blobs[i], delta, directions[i], velocity, 1000)
	if elapsed_time >= state_length:
		request_transition_to(transition_state)

func spawn_projectile(blob) -> void:
	var params = {
		"direction": MovementHelper.get_direction_to_target(blob.global_position, entity_tracker.get_player_position()),
		"spawn_position": blob.global_position
	}
	projectile_manager.spawn_projectile(params)
