extends BaseMove
class_name LazerAxisMove

var constant_axis: Vector3
#position to always target
var constant_position_value: float
var beam_base: Vector3
#rads/s
var speed: float
var base_position: Vector3

func init(_p: Projectile, _params: Dictionary = {}):
	super.init(_p, _params)
	constant_axis = _params.get("constant_axis", Vector3(1, 0, 0))
	constant_position_value = _params.get("constant_position_value", 0.0)
	beam_base = _params.get("beam_position", Vector3(0,0,20))
	speed = _params.get("speed", 0.0)
	var starting_rot: Vector3 = _params.get("starting_rotation", Vector3.ZERO)
	if starting_rot != Vector3.ZERO:
		if !is_zero_approx(starting_rot.x): p.rotate_x(starting_rot.x)
		if !is_zero_approx(starting_rot.y): p.rotate_y(starting_rot.y)
		if !is_zero_approx(starting_rot.z): p.rotate_z(starting_rot.z)

	var half_height = p.get_aabb().size.y * 0.5
	var local_offset = Vector3(0, half_height, 0)
	var offset = p.global_transform.basis * local_offset
	var new_origin = beam_base + offset
	p.global_transform.origin = new_origin
	
	
func tick(delta: float, _params: Dictionary = {}):
	var gt = p.global_transform
	var angle = delta * speed
	var axis = constant_axis.normalized()

	var b = Basis(axis, angle)

	var r = gt.origin - beam_base
	var new_origin = beam_base + b * r

	var new_basis = b * gt.basis
	p.global_transform = Transform3D(new_basis, new_origin)
	# var gt = p.global_transform
	# var t = gt.translated(-beam_base)
	# t.basis = t.basis.rotated(constant_axis.normalized(),  speed * delta)
	# p.global_transform = t.translated(beam_base)
