extends Node3D
class_name ProjectileManager
const PROJECTILE_SCENE = preload("uid://na07nxobd4yp")

@export var PROJECTILE_DATA: ProjectileData
@export var POOL_SIZE = 0
@export var LAYER: ColliderMasks.LAYERS = ColliderMasks.LAYERS.ENEMY_PROJECTILE
@export var MASK: ColliderMasks.LAYERS = ColliderMasks.LAYERS.PLAYER
@export var use_process: bool = true
var projectile_pool: Array[Projectile]
var active_projectiles: Array[Projectile]

func _process(delta: float) -> void:
	for p in active_projectiles:
		p.movement_data.tick(delta)

func _ready() -> void:
	for i in POOL_SIZE:
		_create_projectile()
	if not use_process:
		self.process_mode = Node.PROCESS_MODE_DISABLED

func _create_projectile() -> Projectile:
		var p: Projectile = PROJECTILE_SCENE.instantiate()
		add_child(p)
		p.hide()
		p.set_movement_data(PROJECTILE_DATA.movement_script)
		p.set_collision_data(PROJECTILE_DATA.hitbox, PROJECTILE_DATA.damage, LAYER, MASK)
		p.set_mesh(PROJECTILE_DATA.mesh)
		p.process_mode = Node.PROCESS_MODE_DISABLED
		projectile_pool.append(p)
		p.despawn.connect(_reset_projectile)
		return p

func _reset_projectile(p: Projectile):
	active_projectiles.erase(p)
	projectile_pool.append(p)
	p.hide()
	p.call_deferred("reparent", self)
	p.global_position = self.global_position
	p.set_movement_data(PROJECTILE_DATA.movement_script)
	p.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func _get_projectile() -> Projectile:
	if projectile_pool.is_empty():
		return _create_projectile()
	else:
		return projectile_pool.pop_back()

func spawn_projectile(params: Dictionary):
	var p = _get_projectile()
	active_projectiles.append(p)
	params["base_velocity"] = PROJECTILE_DATA.speed
	params["lifetime"] = PROJECTILE_DATA.lifetime
	
	p.set_movement_data(PROJECTILE_DATA.movement_script, params)
	p.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	p.show()
	p.reparent(get_tree().get_first_node_in_group("ProjectileCollection"))
