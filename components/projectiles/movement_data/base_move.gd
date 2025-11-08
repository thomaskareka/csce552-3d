extends Resource
class_name BaseMove

var p: Projectile
var params: Dictionary
var local_data: Dictionary = {}
var remaining_time: float

func init(_p: Projectile, _params: Dictionary = {}):
	p = _p
	params = _params
	remaining_time = _params.get("lifetime", 1)
	p.global_position = _params.get("spawn_position", p.global_position)

func tick(delta: float, _params: Dictionary = {}):
	p.global_position += params.get("direction", Vector3.ZERO) * delta * params.get("base_velocity", 0)
	remaining_time -= delta
	if remaining_time < 0:
		p.despawn.emit(p)
