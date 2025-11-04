extends State
class_name CircleIdleState

var blobs: Array[Node3D] = []
var velocity = 10

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	super.tick(delta)
	var center = entity.position
	var n = blobs.size()
	for i in range(n):
		var angle = TAU / n * i + (time_remaining * 1.5)
		var x = center.x + (5 * cos(angle))
		var y = center.y + (5 * sin(angle))
		blobs[i].velocity = MovementHelper.get_velocity_to_target(blobs[i].position, Vector3(x, y, 0), velocity, delta)
		blobs[i].move_and_slide()
	
