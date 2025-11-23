extends State

var blobs: Array[Node3D]
@onready var path: Path3D = $Path3D
@export var path_speed := 8
@export var spacing := 8
@export var history_length := 1000
@export var acceleration := 200.0
@export var max_speed := 40.0

var history := PackedVector3Array()
var history_index := 0
var history_full := false
var total_distance := 0.0

func enter(_entity: Node3D, _machine: Node, params: Dictionary = {}) -> void:
	super.enter(_entity, _machine, params)
	if _entity is BlobEnemyAI and path:
		blobs = _entity.blobs

		history.resize(history_length)
		var head_pos := blobs[0].global_position
		for i in range(history_length):
			history[i] = head_pos
		history_full = false
	else:
		request_transition_to(transition_state)

func tick(delta: float) -> void:
	move_head(delta)
	update_followers(delta)

func move_head(delta: float) -> void:
	var curve := path.curve
	total_distance = fmod(total_distance + path_speed * delta, curve.get_baked_length())

	var pos := curve.sample_baked(total_distance, true)

	var head := blobs[0]
	var target_velocity := MovementHelper.get_velocity_to_target(head.global_position, pos, path_speed, delta)
	MovementHelper.move_with_force(head, delta, target_velocity, acceleration, max_speed)

	history[history_index] = head.global_position
	history_index = (history_index + 1) % history_length
	if history_index == 0:
		history_full = true

func get_from_history(index: int) -> Vector3:
	if index < 0: index = 0
	if not history_full:
		if history_index == 0:
			return Vector3.ZERO
		if index >= history_index:
			index = history_index - 1
		var ix = (history_index - 1 - index) % history_length
		return history[ix]
	var i := (history_index - 1 - index + history_length) % history_length
	return history[i]

func update_followers(delta: float) -> void:
	var samples_between := maxi(1, int(round(spacing / max(path_speed * delta, 0.0001))))
	var valid_samples := history_length if history_full else history_index

	for i in range(1, blobs.size()):
		var blob = blobs[i]
		var index_offset = samples_between * i
		
		if index_offset >= valid_samples:
			break

		var target := get_from_history(index_offset)

		var target_velocity := MovementHelper.get_velocity_to_target(blob.global_position, target, path_speed, delta)
		MovementHelper.move_with_force(blob, delta, target_velocity, acceleration, max_speed)
		

	# var needed_samples := int((spacing * float(blobs.size())) / (path_speed * delta)) + 2
	# if not history_full and history_index < needed_samples:
	# 	return
	
	# var curve := path.curve
	# var time := float(Time.get_ticks_msec()) * 0.001

	# for i in range(1, blobs.size()):
	# 	var blob := blobs[i]

	# 	var offset := int((spacing * float(i)) / (path_speed * delta))
	# 	var target := get_from_history(offset)
	# 	var next_pos := get_from_history(max(offset - 1, 0))
	# 	var dir := MovementHelper.get_direction_to_target(next_pos, target)

	# 	var side := dir.cross(Vector3.UP).normalized()
	# 	var phase := time * wave_frequency + float(i) * 0.5
	# 	var side_offset := side * sin(phase) * wave_amplitude
	# 	var vertical_offset := Vector3.UP * sin(phase) * wave_amplitude / 2.0

	# 	var final_pos := target + side_offset + vertical_offset

	# 	var target_velocity := MovementHelper.get_velocity_to_target(blob.global_position, final_pos, path_speed, delta)
	# 	MovementHelper.move_with_force(blob, delta, target_velocity, acceleration, max_speed)
