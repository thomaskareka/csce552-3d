extends EnemyAI
class_name BlobEnemyAI
const BLOB_SCENE = preload("uid://b578iscp5s8yq")
const BLOB_COUNT = 10

@export var TARGET_Z = 20

var blobs: Array[Node3D] = []

func _ready() -> void:
	for i in range(BLOB_COUNT):
		var new_blob = BLOB_SCENE.instantiate()
		new_blob.position.x += i * 4
		add_child(new_blob)
		blobs.append(new_blob)
	super._ready()
