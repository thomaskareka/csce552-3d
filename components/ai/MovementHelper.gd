extends Node
class_name MovementHelper

static func get_position_from_target(source: Vector3, target: Vector3, velocity: float, delta: float) -> Vector3:
	var direction = target - source
	var distance = direction.length_squared()
	
	var move_distance = velocity * delta
	if move_distance.length_squared() >= distance:
		return target
	
	var new_position = source + direction.normalized() * move_distance
	return new_position

static func get_velocity_to_target(source: Vector3, target: Vector3, speed: float, delta: float) -> Vector3:
	var direction := target - source
	var distance := direction.length_squared()
	if distance <= 0.01:
		return Vector3.ZERO
	
	if speed * delta >= distance:
		return direction / delta
	return direction.normalized() * speed
	

static func get_direction_to_target(source: Vector3, target: Vector3) -> Vector3:
	return (target - source).normalized()
