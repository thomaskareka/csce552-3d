extends HealthSystem
class_name PhasedHealthSystem

@export var phase_count = 3;
var current_phase = 1;


func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	
	if current_health == 0:
		current_phase += 1
		current_health = max_health
		
		if current_phase > phase_count:
			died.emit(entity_type)
	
		var boss: EnemyAI = get_parent()
		boss.phase = current_phase
		
		AudioManager.play_sfx(AudioInfo.S_BOSS_TRANSITION)
	
	health_changed.emit(current_health, max_health, entity_type, current_phase)
