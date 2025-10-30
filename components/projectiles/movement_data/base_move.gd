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

func tick(delta: float, _params: Dictionary = {}):
	p.global_position += params["direction"] * delta * params["base_velocity"]
	remaining_time -= delta
	if remaining_time < 0:
		p.despawn.emit(p)
