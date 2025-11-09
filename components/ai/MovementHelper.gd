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

static func move_with_force(item: RigidBody3D, delta: float, target_velocity: Vector3, acceleration: float, max_speed: float = 40):
	if target_velocity.length() > max_speed:
		target_velocity = target_velocity.normalized() * max_speed
	var target_acceleration = (target_velocity - item.linear_velocity) / delta
	if target_acceleration.length() > acceleration:
		target_acceleration = target_acceleration.normalized() * acceleration
	item.apply_central_force(item.mass * target_acceleration)

static func move_with_direction(item: RigidBody3D, delta: float, direction: Vector3, speed: float, acceleration: float):
	var target_velocity := direction * speed
	var diff := target_velocity - item.linear_velocity
	
	var max_change := acceleration * delta
	if diff.length() > max_change:
		diff = diff.normalized() * max_change
	
	var accel := diff / delta
	item.apply_central_force(item.mass * accel)

static func get_direction_to_target(source: Vector3, target: Vector3) -> Vector3:
	return (target - source).normalized()

static func get_random_point_in_aabb(aabb: AABB) -> Vector3:
	return Vector3(
		randf_range(aabb.position.x, aabb.position.x + aabb.size.x),
		randf_range(aabb.position.y, aabb.position.y + aabb.size.y),
		randf_range(aabb.position.z, aabb.position.z + aabb.size.z)
	)

static func circular_move(delta: float, items: Array[Node3D], count: int, radius: float, time: float, rotation_speed: float, velocity: float, acceleration: float, center: Vector3, spin_axis:Vector3 = Vector3.FORWARD, start_time: float = 0.0):
	for i in range(count):
		var item:Node3D = items[i]
		var offset = Vector3(radius, 0, 0)
		var angle = TAU / count * i + ((time + start_time) * rotation_speed)
		var rotation_basis := Basis(spin_axis, angle)
		offset = rotation_basis * offset
		var target_velocity = MovementHelper.get_velocity_to_target(item.global_position, center + offset, velocity, delta)
		MovementHelper.move_with_force(item, delta, target_velocity, acceleration)
