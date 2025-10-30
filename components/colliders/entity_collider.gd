extends Area3D
class_name EntityCollider

@export var LAYER: ColliderMasks.LAYERS = ColliderMasks.LAYERS.ENEMY
@export var MASK: ColliderMasks.LAYERS = ColliderMasks.LAYERS.PLAYER_PROJECTILE

func _ready() -> void:
	collision_layer = LAYER
	collision_mask = MASK
