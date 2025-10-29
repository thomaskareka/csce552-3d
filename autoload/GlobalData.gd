extends Node

const SAVE_PATH := "user://save.cfg"

var data := {
	"music_volume": 0,
	"sfx_volume": 0,
	"use_relative": true,
	"mouse_sensitivity" : 0.5,
	"joystick_sensitivity" : 5
}

func _ready() -> void:
	load_all()
	
func save_all():
	var cfg := ConfigFile.new()
	
	for key in data.keys():
		cfg.set_value("data", key, data[key])
		
	var err := cfg.save(SAVE_PATH)
	if err != OK:
		push_error("failed to save to %s: %s" % [SAVE_PATH, str(err)])

func load_all() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		for key in data.keys():
			data[key] = cfg.get_value("data", key, data[key])
	else:
		print("using default data")
