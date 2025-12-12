extends Node3D
@onready var absolute_toggle: CheckButton = $Control/ScrollContainer/VBoxContainer/CheckButton
@onready var aim_slider: HSlider = $Control/ScrollContainer/VBoxContainer/AimSlider
@onready var music_slider: HSlider = $Control/ScrollContainer/VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $Control/ScrollContainer/VBoxContainer/SFXSlider
@onready var mouse_slider: HSlider = $Control/ScrollContainer/VBoxContainer/MouseSlider

func _ready() -> void:
	absolute_toggle.button_pressed = GlobalData.data["use_relative"]
	aim_slider.value = GlobalData.data["joystick_sensitivity"]
	music_slider.value = GlobalData.data["music_volume"]
	sfx_slider.value = GlobalData.data["sfx_volume"]
	mouse_slider.value = GlobalData.data["mouse_sensitivity"]

func _on_aim_slider_value_changed(value: float) -> void:
	GlobalData.data["joystick_sensitivity"] = value


func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.change_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.change_sfx_volume(value)


func _on_check_button_toggled(toggled_on: bool) -> void:
	GlobalData.data["use_relative"] = !toggled_on


func _on_back_button_pressed() -> void:
	GlobalData.data["music_volume"] = music_slider.value
	GlobalData.data["sfx_volume"] = sfx_slider.value
	GlobalData.save_all()
	get_tree().change_scene_to_file("uid://3046lgay8fu8")


func _on_mouse_slider_value_changed(value: float) -> void:
	GlobalData.data["mouse_sensitivity"] = value
