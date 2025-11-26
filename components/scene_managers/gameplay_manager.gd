extends Node3D
class_name GameplayManager

@onready var gameplay_gui: GameplayGUI = $GameplayGUI
@onready var camera: Camera3D = $GameCamera
@export var player_bounds: AABB = AABB(Vector3(-5,-3,0), Vector3(10, 6, 0.5))
@export var boss_bounds: AABB = AABB(Vector3(-10, -6, 20), Vector3(20, 12, 0))


func _init() -> void:
	pass

func _ready() -> void:
	_init_bounds()
	_start_game()

func _init_bounds() -> void:
	var bounds_max := player_bounds.position + player_bounds.size
	var center := player_bounds.position + (player_bounds.size * 0.5)
	var thickness := 1.0
	
	#left
	_create_wall(
		Vector3(player_bounds.position.x - thickness * 0.5, center.y, center.z),
		Vector3(thickness, player_bounds.size.y + 2.0 * thickness, thickness)
	)
	#right
	_create_wall(
		Vector3(bounds_max.x + thickness * 0.5, center.y, center.z),
		Vector3(thickness, player_bounds.size.y + 2.0 * thickness, thickness)
	)
	#top
	_create_wall(
		Vector3(center.x, bounds_max.y + thickness * 0.5, center.z),
		Vector3(player_bounds.size.x + 2 * thickness, thickness, thickness)
	)
	#bottom
	_create_wall(
		Vector3(center.x, player_bounds.position.y - thickness * 0.5, center.z),
		Vector3(player_bounds.size.x + 2 * thickness, thickness, thickness)
	)

func _create_wall(pos: Vector3, size: Vector3) -> void:
	var wall := StaticBody3D.new()
	add_child(wall)
	wall.transform.origin = pos
	
	var cs = CollisionShape3D.new()
	wall.add_child(cs)
	
	var shape := BoxShape3D.new()
	shape.size = size
	cs.shape = shape


func _start_game() -> void:
	for hs: HealthSystem in get_tree().get_nodes_in_group("health_system"):
		hs.died.connect(_on_entity_died)
		hs.health_changed.connect(_on_entity_hp_changed)
	var player = get_tree().get_first_node_in_group("Player")
	var boss = get_tree().get_first_node_in_group("Boss")
	var entity_tracker: EntityTracker = get_tree().get_first_node_in_group("EntityTracker")
	entity_tracker.reset()
	entity_tracker.init(player, boss)
	
	boss.set_player_bounds(player_bounds)
	boss.set_self_bounds(boss_bounds)
	boss.camera = camera
	
func _on_entity_hp_changed(current: int, max: int, type: HealthSystem.EntityType, phase: int = 0):
	if not (type == HealthSystem.EntityType.ENEMY):
		gameplay_gui.change_hp_bar(current, max, type, phase)

func _on_entity_died(type: HealthSystem.EntityType):
	if type == HealthSystem.EntityType.BOSS:
		_win_game()
	elif type == HealthSystem.EntityType.PLAYER:
		_lose_game()

func _win_game() -> void:
	_change_to_game_over("You win!")

func _lose_game() -> void:
	_change_to_game_over("Try again?")

func _change_to_game_over(status: String) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var scene: GameOverManager = load(MenuManager.GAME_OVER_SCENE).instantiate()
	scene.result_text = status
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
