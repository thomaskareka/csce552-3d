extends Control
class_name GameplayGUI

@onready var player_hp_bar: ProgressBar = $PlayerHPBar
@onready var boss_hp_bar: PhasedHealthBar = $PhasedHealthBar

func change_hp_bar(hp, max, type: HealthSystem.EntityType, phase: int = 0):
	if type == HealthSystem.EntityType.BOSS:
		boss_hp_bar.change_hp_bar(hp, max, phase)
		return

	var target_bar = player_hp_bar
	target_bar.max_value = max
	target_bar.value = hp
