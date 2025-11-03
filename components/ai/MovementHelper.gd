extends Node
class_name MovementHelper

static func get_position_from_target(source: Vector3, target: Vector3, velocity: float, delta: float) -> Vector3:
	var direction = target - source
	var distance = direction.length_squared()
	
	var move_distance = velocity * delta
	if move_distance >= distance:
		return target
	
	var new_position = source + direction.normalized() * move_distance
	return new_position
