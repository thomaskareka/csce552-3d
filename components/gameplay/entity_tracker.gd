extends Node
class_name EntityTracker

var target_cache: Dictionary = {}

var player: Node3D
var boss: Node3D

func init(_player, _boss) -> void:
	player = _player
	boss = _boss

func reset() -> void:
	player = null
	boss = null

func get_player_position() -> Vector3:
	if player:
		return player.global_position
	return Vector3.ZERO

func get_boss_position() -> Vector3:
	if player:
		return boss.global_position
	return Vector3.ZERO
