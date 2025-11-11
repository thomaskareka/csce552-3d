extends TrackingMove
class_name RotatedTrackedMove
@export var initial_rotation := Vector3(0, 30, 0)
@export var rotation_direction := Vector3(0, 1, 0)
@export var rotation_speed := 1.0

func init(_p: Projectile, _params: Dictionary = {}):
	super.init(_p, _params)
	_p.rotation_degrees = initial_rotation
	
func tick(delta: float, _params: Dictionary = {}):
	p.rotation_degrees += rotation_direction * rotation_speed * delta
	super.tick(delta, _params)
