extends Camera3D
@export var rotation_strength: float = 0.2
@export var max_angle: float = 0.09
@export var smooth_speed: float = 5.0

var entity_tracker: EntityTracker
var base_q: Quaternion
func _ready() -> void:
	entity_tracker = get_tree().get_first_node_in_group("EntityTracker")
	base_q = global_transform.basis.get_rotation_quaternion()

func _physics_process(delta: float) -> void:
	if not entity_tracker: return
	
	var player_position = entity_tracker.get_player_position()
	var direction = MovementHelper.get_direction_to_target(self.global_position, player_position)
	
	var desired_basis = Basis.looking_at(direction, Vector3.UP)
	var desired_q = desired_basis.get_rotation_quaternion()
	
	var delta_q: Quaternion = base_q.inverse() * desired_q
	
	var axis := delta_q.get_axis()
	var angle := delta_q.get_angle()
	
	angle = min(angle, max_angle)
	var limited_q := Quaternion(axis.normalized(), angle)
	var target_q = base_q * limited_q
	
	var rotation_q := base_q.slerp(target_q, rotation_strength)
	var current_q = global_transform.basis.get_rotation_quaternion()
	
	var t = global_transform
	t.basis = Basis(current_q.slerp(rotation_q, delta * smooth_speed))
	global_transform = t
