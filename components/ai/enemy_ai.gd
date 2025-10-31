extends Node3D
class_name EnemyAI

@onready var state_machine : StateMachine = $StateMachine

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	state_machine.change_to_start()

func _physics_process(delta: float) -> void:
	state_machine.tick(delta)
