extends Control
class_name GameplayGUI

@onready var player_hp_bar: ProgressBar = $HBoxContainer/PlayerHPBar
@onready var boss_hp_bar: ProgressBar = $HBoxContainer/EnemyHPBar

func change_hp_bar(hp, max, type: HealthSystem.EntityType):
	var target_bar = boss_hp_bar
	if type == HealthSystem.EntityType.PLAYER:
		target_bar = player_hp_bar
	
	target_bar.max_value = max
	target_bar.value = hp
