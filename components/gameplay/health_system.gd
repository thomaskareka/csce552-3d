extends Node
class_name HealthSystem

enum EntityType {
	PLAYER, BOSS, ENEMY
}

@export var max_health := 100
@export var entity_type := EntityType.ENEMY

var current_health := max_health

signal health_changed(current: int, max: int, type: EntityType)
signal died(type: EntityType)

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	health_changed.emit(current_health, max_health, entity_type)
	if current_health == 0:
		died.emit(entity_type)
