extends Node2D

func _ready() -> void:
	Global.audio_manager.play_music(Global.EMusicType.music1)
