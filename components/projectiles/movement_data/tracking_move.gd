extends BaseMove
class_name TrackingMove

var entity_tracker: EntityTracker
var target: ColliderMasks.TARGETS = ColliderMasks.TARGETS.NONE

func init(_p: Projectile, _params: Dictionary = {}):
	target = _params.get("target", ColliderMasks.TARGETS.NONE)
	entity_tracker = _p.get_tree().get_first_node_in_group("EntityTracker")
	if not entity_tracker:
		_p.despawn.emit(_p)
	super.init(_p, _params)

func tick(delta: float, _params: Dictionary = {}):
	var target_position := Vector3.ZERO
	match target:
		ColliderMasks.TARGETS.PLAYER:
			target_position = entity_tracker.get_player_position()
		ColliderMasks.TARGETS.ENEMY:
			pass
		ColliderMasks.TARGETS.NEAREST_ENEMY:
			#TODO: get nearest
			target_position = entity_tracker.get_closest(p.global_position)
		ColliderMasks.TARGETS.BOSS:
			target_position = entity_tracker.get_boss_position()
		_:
			pass
	
	if target_position != null:
		var position_delta: Vector3 = target_position - p.global_position
		var desired_direction: Vector3 = position_delta.normalized()
		var t = clamp(params["track_strength"] * delta, 0.0, 1.0)
		params["direction"] = params["direction"].lerp(desired_direction, t).normalized()
	super.tick(delta, _params)
