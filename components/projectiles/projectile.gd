extends Node
class_name Projectile
@onready var collider: ProjectileCollider = $ProjectileCollider
@onready var collider_shape: CollisionShape3D = $ProjectileCollider/CollisionShape3D
@onready var mesh_instance : MeshInstance3D = $MeshInstance3D

var movement_data: BaseMove

signal despawn(p: Projectile)

func set_collision_data(shape: Shape3D, damage: int, layer: ColliderMasks.LAYERS, mask: ColliderMasks.LAYERS):
	collider.set_targets(layer, mask)
	collider.damage = damage
	collider_shape.shape = shape.duplicate()

func get_aabb() -> AABB:
	if mesh_instance:
		return mesh_instance.get_aabb()
	else: return AABB()

func set_mesh(mesh: Mesh):
	mesh_instance.mesh = mesh.duplicate()

func set_movement_data(script: BaseMove, params: Dictionary = {}):
	movement_data = script.duplicate()
	movement_data.init(self, params)
