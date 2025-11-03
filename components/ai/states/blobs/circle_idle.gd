extends State
class_name CircleIdleState

var blobs: Array[Node3D] = []
var velocity = 20

func enter(_entity: Node, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	if _entity is BlobEnemyAI:
		blobs = _entity.blobs
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	var center = entity.position
	for i in range(blobs.size()):
		var angle = TAU / blobs.size() * i + (time_remaining * 1.5)
		var x = center.x + (10 * cos(angle))
		var y = center.y + (10 * sin(angle))
		blobs[i].position = MovementHelper.get_position_from_target(blobs[i].position, Vector3(x, y, 0), velocity, delta)
	super.tick(delta)
