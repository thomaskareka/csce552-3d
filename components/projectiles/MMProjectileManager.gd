extends Node3D

@export var projectile: Projectile
@export var pool_size = 0
var multimesh_instance: MultiMeshInstance3D
var projectile_pool: Array[Node3D]

func _ready() -> void:
	if pool_size > 0:
		multimesh_instance = MultiMeshInstance3D.new()
		
		var mm = MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.instance_count = pool_size
		add_child(multimesh_instance)
	pass
