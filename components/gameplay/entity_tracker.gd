extends Node
class_name EntityTracker

var target_cache: Dictionary = {}

var player: Node3D
var boss: Node3D
var boss_targets: Array[Node3D]

func init(_player, _boss) -> void:
	player = _player
	boss = _boss
	if boss is BlobEnemyAI:
		boss_targets = boss.blobs

func reset() -> void:
	player = null
	boss = null

func get_player_position() -> Vector3:
	if player:
		return player.global_position
	return Vector3.ZERO

func get_boss_position() -> Vector3:
	if boss:
		return boss.global_position
	return Vector3.ZERO
	
func get_closest(starting_position: Vector3) -> Vector3:
	var closest = null
	var minimum_distance = INF
	
	for target: Node3D in boss_targets:
		var distance = target.global_position.distance_squared_to(starting_position)
		if distance < minimum_distance:
			minimum_distance = distance
			closest = target
	return closest.global_position
