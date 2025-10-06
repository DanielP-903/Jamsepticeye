class_name AudioSource extends AudioStreamPlayer2D

var active = false
var audio_type: Global.EAudioType

func _ready() -> void:
	finished.connect(_on_stream_finished.bind(self))

func activate() -> void:
	active = true
	#print("Activated: " + name)

func deactivate() -> void:
	if playing:
		stop()
	stream = null
	active = false
	#print("Deactivated: " + name)

func is_active() -> bool:
	return active

func play_audio(new_stream: AudioStream, type, new_volume) -> void:
	stream = new_stream
	audio_type = type
	volume_linear = new_volume
	play()

func _on_stream_finished(_stream: AudioStreamPlayer2D) -> void:
	# When audio is finished, signal this to be deactivated
	deactivate()

func get_audio_type() -> Global.EAudioType:
	return audio_type
