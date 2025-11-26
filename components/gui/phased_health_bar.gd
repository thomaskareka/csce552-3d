extends Control
class_name PhasedHealthBar
@onready var hp_bar: ProgressBar = $HPBar
@onready var phase_bar: ProgressBar = $PhaseBar

var current_phase = 1;
@export var max_phases = 3;

func change_hp_bar(hp, max, phase):
	hp_bar.max_value = max
	hp_bar.value = hp

	if phase > current_phase:
		current_phase = phase
		phase_bar.max_value = max_phases
		phase_bar.value = max_phases + 1 - current_phase
