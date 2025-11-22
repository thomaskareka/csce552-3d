extends EnemyAI
class_name BlobEnemyAI
const BLOB_SCENE = preload("uid://b578iscp5s8yq")
const CHILD_HEALTH_SCENE = preload("uid://dotxcjf3uwy8b")
const BLOB_COUNT = 10
@onready var health_system: HealthSystem = $HealthSystem

@export var TARGET_Z = 20

var blobs: Array[Node3D] = []

func _ready() -> void:
	for i in range(BLOB_COUNT):
		var new_blob = BLOB_SCENE.instantiate()
		new_blob.position.x += i * 2
		add_child(new_blob)
		blobs.append(new_blob)
		
		var child_health: ChildHealth = CHILD_HEALTH_SCENE.instantiate()
		child_health.init(health_system)
		new_blob.add_child(child_health)
	super._ready()
	
func choose_state(params: Dictionary = {}) -> Array:
	for blob in blobs:
		var blob_visible: bool = false
		
		var notifier = blob.get_node_or_null("VisibleOnScreenNotifier3D")
		if notifier:
			blob_visible = notifier.is_on_screen()
		if not blob_visible:
			blob.linear_velocity = Vector3.ZERO
			blob.global_position = MovementHelper.get_random_point_outside_aabb(boss_bounds, 10)
		
	return super.choose_state(params)
