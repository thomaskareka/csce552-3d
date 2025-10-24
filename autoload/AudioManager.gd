extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array = []

const MAX_SFX_CHANNELS = 8


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	for i in MAX_SFX_CHANNELS:
		var player = AudioStreamPlayer.new()
		sfx_players.append(player)
		add_child(player)
	
func play_song(id: String, ignore_playing = true):
	music_player.volume_db = GlobalData.data["music_volume"]
	if music_player.playing and not ignore_playing:
		return
	var stream = _load_asset(id)
	if stream:
		music_player.stop()
		music_player.stream = stream
		music_player.play()

func change_music_volume(volume: float):
	music_player.volume_db = volume

func change_sfx_volume(volume: float):
	for player in sfx_players:
		player.volume_db = volume
		

func play_sfx(id: String, random_pitch := false, pitch_mod := 0.0, audio_mod := 0.0):
	var player: AudioStreamPlayer = _get_sfx_player()
	if not player: return
	var stream = _load_asset(id)
	if stream:
		player.volume_db = GlobalData.data["sfx_volume"] + audio_mod
		if random_pitch:
			player.pitch_scale = randf_range(0.9, 1.1)
		elif pitch_mod > 0:
			player.pitch_scale = pitch_mod
		else: 
			player.pitch_scale = 1
		player.stop()
		player.stream = stream
		player.play()

func fade_song():
	var tween = music_player.create_tween()
	tween.tween_property(music_player, "volume_db", -80, 3)

func _get_sfx_player():
	for p in sfx_players:
		if not p.playing:
			return p
	return null

func _load_asset(id: String):
	var stream = load(id)
	if (stream == null):
		push_error(id, "could not be loaded")
	if not (stream is AudioStream):
		push_error(id, " is not an audio stream")
	return stream
