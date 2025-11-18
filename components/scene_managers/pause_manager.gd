extends Control

var is_paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_input"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	self.visible = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if !is_paused else Input.MOUSE_MODE_VISIBLE)

func _on_continue_button_pressed() -> void:
	toggle_pause()


func _on_restart_button_pressed() -> void:
	toggle_pause()
	get_tree().change_scene_to_file(MenuManager.GAMEPLAY_SCENE)



func _on_menu_button_pressed() -> void:
	toggle_pause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file(MenuManager.MENU_SCENE)
