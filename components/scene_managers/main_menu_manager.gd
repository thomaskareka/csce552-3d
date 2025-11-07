extends Node3D

const GAMEPLAY_SCENE = "uid://yhh26tl28cen"
const SETTINGS_SCENE = "uid://omexrlllgk5v"

func _ready() -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(GAMEPLAY_SCENE)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file(SETTINGS_SCENE)
