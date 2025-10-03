class_name AudioManager extends Node

@export var audio_map: Dictionary[Global.EAudioType, AudioStream]
@export var music_map: Dictionary[Global.EMusicType, AudioStream]

var audio_source_scene = preload("res://Scenes/audio_source.tscn")
var audio_pool: Array[AudioSource] = []

var music: AudioStreamPlayer2D
var current_music: Global.EMusicType

const pool_size = 3

func _ready() -> void:
	Global.audio_manager = self
	
	# Create the music object
	_create_music()
	
	for n in range(pool_size):
		_create_audio_source()

func _create_music():
	music = AudioStreamPlayer2D.new()
	music.name = "Music"
	music.bus = "Music"
	add_child(music)

func play_music(music_type: Global.EMusicType):
	if music_map.get(music_type) == null:
		push_error("Couldn't play " + Global.EMusicType.keys()[music_type] + " because it doesn't exist in the music_map!")
		return
	print("Playing: " + Global.EMusicType.keys()[music_type])
	if music.playing:
		music.stop()
	music.stream = music_map[music_type]
	music.play()

func stop_music() -> void:
	if music.playing:
		music.stop()
	music.stream = null

func _get_free_audio_from_pool() -> AudioSource:
	for n in range(audio_pool.size()):
		if !audio_pool[n].is_active():
			audio_pool[n].activate()
			return audio_pool[n]
	
	# No free projectiles, make one
	var instance = _create_audio_source()
	instance.activate()
	return instance

func _create_audio_source() -> AudioSource:
	var instance: AudioSource = audio_source_scene.instantiate()
	instance.name = "Audio" + str(audio_pool.size())
	instance.bus = "Sound"
	instance.deactivate()
	add_child(instance)
	audio_pool.append(instance)
	return instance

func play_audio(audio_type: Global.EAudioType):
	if audio_map.get(audio_type) == null:
		push_error("Couldn't play " + Global.EAudioType.keys()[audio_type] + " because it doesn't exist in the audio_map!")
		return
	print("Playing: " + Global.EAudioType.keys()[audio_type])
	var audio_source = _get_free_audio_from_pool()
	audio_source.play_audio(audio_map[audio_type], audio_type)

func stop_audio(audio_type: Global.EAudioType) -> bool:
	#print("Stopping: " + Global.EAudioType.keys()[audio_type])
	for audio in audio_pool:
		if audio.get_audio_type() == audio_type:
			audio.deactivate()
			return true
	return false

func stop_all_audio(also_stop_music = false) -> void:
	print("Stopping All Audio!")
	for audio in audio_pool:
		if audio.is_active():
			audio.deactivate()
	if also_stop_music:
		print("Also Stopping Music!")
		stop_music()
