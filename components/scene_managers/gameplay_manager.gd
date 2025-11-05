extends Node3D
class_name GameplayManager

@onready var gameplay_gui: GameplayGUI = $GameplayGUI
@export var player_bounds: AABB = AABB(Vector3(-5,-3,0), Vector3(10, 6, 0))
@export var boss_bounds: AABB = AABB(Vector3(-13, -7, 20), Vector3(26, 14, 0))


func _init() -> void:
	pass

func _ready() -> void:
	_start_game()

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
	
func _on_entity_hp_changed(current: int, max: int, type: HealthSystem.EntityType):
	if not (type == HealthSystem.EntityType.ENEMY):
		gameplay_gui.change_hp_bar(current, max, type)

func _on_entity_died(type: HealthSystem.EntityType):
	if type == HealthSystem.EntityType.BOSS:
		_win_game()
	elif type == HealthSystem.EntityType.PLAYER:
		_lose_game()

func _win_game() -> void:
	print("win")

func _lose_game() -> void:
	print("lose")
