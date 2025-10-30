extends Area3D
class_name ProjectileCollider

@export var LAYER: ColliderMasks.LAYERS = ColliderMasks.LAYERS.ENEMY_PROJECTILE
@export var MASK: ColliderMasks.LAYERS = ColliderMasks.LAYERS.PLAYER
@export var SELF_DESTRUCT: bool

func _ready() -> void:
	collision_layer = LAYER
	collision_mask = MASK
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _on_body_entered(body: Node) -> void:
	print("body")
	_do_hit(body)

func _on_area_entered(area: Area3D) -> void:
	print("area")
	_do_hit(area)

func _do_hit(node: Node):
	var parent = node.get_parent()
	if parent.has_node("HealthSystem"):
		var hs: HealthSystem = parent.get_node("HealthSystem")
		#TODO: get details from projectile/attack
	
	if SELF_DESTRUCT:
		get_parent().queue_free()
