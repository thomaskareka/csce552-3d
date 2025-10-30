extends Area3D
class_name ProjectileCollider

@export var LAYER: ColliderMasks.LAYERS = ColliderMasks.LAYERS.ENEMY_PROJECTILE
@export var MASK: ColliderMasks.LAYERS = ColliderMasks.LAYERS.PLAYER
@export var SELF_DESTRUCT: bool = true
@export var damage: int = 0

func _ready() -> void:
	_update_layers()
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _update_layers() -> void:
	collision_layer = LAYER
	collision_mask = MASK

func _on_body_entered(body: Node) -> void:
	_do_hit(body)

func _on_area_entered(area: Area3D) -> void:
	_do_hit(area)

func _do_hit(node: Node):
	var target_parent: Node = node.get_parent()
	if target_parent.has_node("HealthSystem"):
		var hs: HealthSystem = target_parent.get_node("HealthSystem")
		hs.take_damage(damage)
	
	if SELF_DESTRUCT:
		var parent = get_parent()
		parent.despawn.emit(parent)

func set_targets(layer: ColliderMasks.LAYERS, mask: ColliderMasks.LAYERS):
	LAYER = layer
	MASK = mask
	_update_layers()
