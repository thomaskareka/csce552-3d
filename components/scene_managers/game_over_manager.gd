extends Node3D
class_name GameOverManager

@onready var status_label = $GUI/CenterContainer/StatusLabel
var result_text := ""

func _ready() -> void:
	status_label.text = result_text

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MenuManager.MENU_SCENE)


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file(MenuManager.GAMEPLAY_SCENE)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
